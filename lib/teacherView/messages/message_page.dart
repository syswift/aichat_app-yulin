import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../utils/responsive_size.dart';

// 接收者类型枚举
enum ReceiverType {
  student('学生'),
  parent('家长');

  final String label;
  const ReceiverType(this.label);
}

// 家长信息数据模型
class ParentInfo {
  final String studentName;
  final String parentName;
  final String parentId;

  const ParentInfo({
    required this.studentName,
    required this.parentName,
    required this.parentId,
  });
}

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  
  List<String> selectedClasses = [];
  List<String> selectedStudents = [];
  List<String> selectedParentIds = [];
  final List<File> _selectedImages = [];
  final List<String> _audioRecordings = [];
  bool _isRecording = false;
  int? _playingIndex;
  File? _previewImage;
  final _audioRecorder = AudioRecorder();
  final _audioPlayer = AudioPlayer();
  ReceiverType _receiverType = ReceiverType.student;

  final List<String> classes = ['一年级一班', '一年级二班', '二年级一班', '二年级二班'];
  
  final Map<String, List<String>> studentsByClass = {
    '一年级一班': ['张三', '李四', '王五'],
    '一年级二班': ['赵六', '钱七', '孙八'],
    '二年级一班': ['周九', '吴十', '郑十一'],
    '二年级二班': ['王十二', '李十三', '赵十四'],
  };

  final Map<String, List<ParentInfo>> parentsByClass = {
    '一年级一班': [
      ParentInfo(studentName: '张三', parentName: '张父', parentId: 'p001'),
      ParentInfo(studentName: '李四', parentName: '李母', parentId: 'p002'),
      ParentInfo(studentName: '王五', parentName: '王父', parentId: 'p003'),
    ],
    '一年级二班': [
      ParentInfo(studentName: '赵六', parentName: '赵母', parentId: 'p004'),
      ParentInfo(studentName: '钱七', parentName: '钱父', parentId: 'p005'),
      ParentInfo(studentName: '孙八', parentName: '孙母', parentId: 'p006'),
    ],
    '二年级一班': [
      ParentInfo(studentName: '周九', parentName: '周父', parentId: 'p007'),
      ParentInfo(studentName: '吴十', parentName: '吴母', parentId: 'p008'),
      ParentInfo(studentName: '郑十一', parentName: '郑父', parentId: 'p009'),
    ],
    '二年级二班': [
      ParentInfo(studentName: '王十二', parentName: '王母', parentId: 'p010'),
      ParentInfo(studentName: '李十三', parentName: '李父', parentId: 'p011'),
      ParentInfo(studentName: '赵十四', parentName: '赵母', parentId: 'p012'),
    ],
  };
    @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    final status = await _audioRecorder.hasPermission();
    if (!status) {
      _showError('请授予录音权限');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
        ),
        child: Container(
          width: ResponsiveSize.w(300),
          padding: EdgeInsets.all(ResponsiveSize.w(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveSize.w(16)),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: ResponsiveSize.w(40),
                ),
              ),
              SizedBox(height: ResponsiveSize.h(20)),
              Text(
                '提示',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(24),
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: ResponsiveSize.h(10)),
              Text(
                message,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(16),
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveSize.h(20)),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  '确定',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(18),
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
        ),
        child: Container(
          width: ResponsiveSize.w(300),
          padding: EdgeInsets.all(ResponsiveSize.w(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveSize.w(16)),
                decoration: const BoxDecoration(
                  color: Color(0xFF2E7D32),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: ResponsiveSize.w(40),
                ),
              ),
              SizedBox(height: ResponsiveSize.h(20)),
              Text(
                '发送成功',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(24),
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: ResponsiveSize.h(10)),
              Text(
                message,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(16),
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: ResponsiveSize.h(20)),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _clearAll();
                },
                child: Text(
                  '确定',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(18),
                    color: const Color(0xFF2E7D32),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clearAll() {
    _messageController.clear();
    selectedClasses.clear();
    selectedStudents.clear();
    selectedParentIds.clear();
    setState(() {
      _selectedImages.clear();
      _audioRecordings.clear();
    });
  }
    Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
    }
  }

  Future<void> _startRecording() async {
    try {
      final hasPermission = await _audioRecorder.hasPermission();
      if (hasPermission) {
        final voicePath = await _getVoiceFilePath();
        final recordConfig = RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        );
        await _audioRecorder.start(recordConfig, path: voicePath);
        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      print('Error recording audio: $e');
    }
  }

  Future<String> _getVoiceFilePath() async {
    final dir = await getTemporaryDirectory();
    final filename = 'voice_message_${DateTime.now().millisecondsSinceEpoch}.m4a';
    return path.join(dir.path, filename);
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      if (path != null) {
        setState(() {
          _audioRecordings.add(path);
          _isRecording = false;
        });
      }
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  Future<void> _playRecording(int index) async {
    try {
      if (_playingIndex == index) {
        await _audioPlayer.stop();
        setState(() {
          _playingIndex = null;
        });
      } else {
        final file = File(_audioRecordings[index]);
        if (await file.exists()) {
          setState(() {
            _playingIndex = index;
          });
          await _audioPlayer.play(DeviceFileSource(_audioRecordings[index]));
          _audioPlayer.onPlayerComplete.listen((_) {
            setState(() {
              _playingIndex = null;
            });
          });
        } else {
          _showError('录音文件不存在');
        }
      }
    } catch (e) {
      _showError('播放失败: $e');
    }
  }

  void _showImagePreview() {
    if (_previewImage == null) return;
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 3.0,
              child: Image.file(_previewImage!),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(ResponsiveSize.w(8)),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: ResponsiveSize.w(24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
    @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      body: Padding(
        padding: EdgeInsets.all(ResponsiveSize.w(32)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(),
            SizedBox(height: ResponsiveSize.h(32)),
            _buildMainContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            'assets/backbutton1.png',
            width: ResponsiveSize.w(80),
            height: ResponsiveSize.h(80),
          ),
        ),
        SizedBox(width: ResponsiveSize.w(20)),
        Text(
          '发送消息',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(28),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8B4513),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(ResponsiveSize.w(24)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
                border: Border.all(color: const Color(0xFFDEB887)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '选择接收者',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(22),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8B4513),
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(16)),
                  _buildReceiverTypeSelector(),
                  SizedBox(height: ResponsiveSize.h(16)),
                  Container(
  height: ResponsiveSize.h(40),
  decoration: BoxDecoration(
    color: const Color(0xFFFDF5E6),
    borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
    border: Border.all(color: const Color(0xFFDEB887)),
  ),
  child: TextField(
    controller: _searchController,
    textAlignVertical: TextAlignVertical.center, // 添加此行
    style: TextStyle(fontSize: ResponsiveSize.sp(16)),
    decoration: InputDecoration(
      hintText: '搜索${_receiverType.label}...',
      hintStyle: TextStyle(fontSize: ResponsiveSize.sp(16)),
      prefixIcon: Icon(Icons.search, size: ResponsiveSize.w(20)),
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(16),
      ),
      isCollapsed: true, // 添加此行
    ),
  ),
),
                  SizedBox(height: ResponsiveSize.h(16)),
                  Expanded(
                    child: _receiverType == ReceiverType.student
                        ? _buildClassList()
                        : _buildParentList(),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: ResponsiveSize.w(24)),
          _buildMessageEditor(),
        ],
      ),
    );
  }

  Widget _buildReceiverTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFDF5E6),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
        border: Border.all(color: const Color(0xFFDEB887)),
      ),
      child: Row(
        children: ReceiverType.values.map((type) {
          final isSelected = type == _receiverType;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _receiverType = type;
                  selectedClasses.clear();
                  selectedStudents.clear();
                  selectedParentIds.clear();
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveSize.h(8),
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFFE4C4) : Colors.transparent,
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(6)),
                ),
                child: Text(
                  type.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: const Color(0xFF8B4513),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
    Widget _buildClassList() {
    return ListView.builder(
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final className = classes[index];
        return ExpansionTile(
          title: Row(
            children: [
              Checkbox(
                value: selectedClasses.contains(className),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      selectedClasses.add(className);
                      selectedStudents.addAll(
                        studentsByClass[className] ?? []
                      );
                    } else {
                      selectedClasses.remove(className);
                      selectedStudents.removeWhere(
                        (student) => studentsByClass[className]?.contains(student) ?? false
                      );
                    }
                  });
                },
              ),
              Text(
                className,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  color: const Color(0xFF8B4513),
                ),
              ),
            ],
          ),
          children: [
            ...studentsByClass[className]?.map(
              (student) => Padding(
                padding: EdgeInsets.only(left: ResponsiveSize.w(32)),
                child: Row(
                  children: [
                    Checkbox(
                      value: selectedStudents.contains(student),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedStudents.add(student);
                          } else {
                            selectedStudents.remove(student);
                          }
                        });
                      },
                    ),
                    Text(
                      student,
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(18),
                        color: const Color(0xFF8B4513),
                      ),
                    ),
                  ],
                ),
              ),
            ) ?? [],
          ],
        );
      },
    );
  }

  Widget _buildParentList() {
    return ListView.builder(
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final className = classes[index];
        final parents = parentsByClass[className] ?? [];
        return ExpansionTile(
          title: Row(
            children: [
              Checkbox(
                value: parents.every((p) => selectedParentIds.contains(p.parentId)),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      selectedParentIds.addAll(parents.map((p) => p.parentId));
                    } else {
                      selectedParentIds.removeWhere(
                        (id) => parents.any((p) => p.parentId == id)
                      );
                    }
                  });
                },
              ),
              Text(
                className,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  color: const Color(0xFF8B4513),
                ),
              ),
            ],
          ),
          children: [
            ...parents.map(
              (parent) => Padding(
                padding: EdgeInsets.only(left: ResponsiveSize.w(32)),
                child: Row(
                  children: [
                    Checkbox(
                      value: selectedParentIds.contains(parent.parentId),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedParentIds.add(parent.parentId);
                          } else {
                            selectedParentIds.remove(parent.parentId);
                          }
                        });
                      },
                    ),
                    Text(
                      '${parent.studentName}的${parent.parentName}',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(18),
                        color: const Color(0xFF8B4513),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
    Widget _buildMessageEditor() {
    return Expanded(
      flex: 2,
      child: Container(
        padding: EdgeInsets.all(ResponsiveSize.w(24)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
          border: Border.all(color: const Color(0xFFDEB887)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '编辑消息',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(22),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8B4513),
              ),
            ),
            SizedBox(height: ResponsiveSize.h(16)),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                  border: Border.all(color: const Color(0xFFDEB887)),
                ),
                child: Column(
                  children: [
                    if (_selectedImages.isNotEmpty || _audioRecordings.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(ResponsiveSize.w(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_selectedImages.isNotEmpty) ...[
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                    _selectedImages.length,
                                    (index) => Padding(
                                      padding: EdgeInsets.only(right: ResponsiveSize.w(10)),
                                      child: _buildImagePreview(index),
                                    ),
                                  ),
                                ),
                              ),
                              if (_audioRecordings.isNotEmpty)
                                Divider(height: ResponsiveSize.h(20), color: const Color(0xFFDEB887)),
                            ],
                            if (_audioRecordings.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  _audioRecordings.length,
                                  (index) => Padding(
                                    padding: EdgeInsets.only(bottom: ResponsiveSize.h(8)),
                                    child: _buildAudioPreview(index),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    if (_selectedImages.isNotEmpty || _audioRecordings.isNotEmpty)
                      Divider(height: 1, color: const Color(0xFFDEB887)),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        maxLines: null,
                        style: TextStyle(fontSize: ResponsiveSize.sp(16)),
                        decoration: InputDecoration(
                          hintText: '请输入消息内容...',
                          hintStyle: TextStyle(fontSize: ResponsiveSize.sp(16)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(ResponsiveSize.w(16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: ResponsiveSize.h(16)),
            _buildMediaControls(),
            SizedBox(height: ResponsiveSize.h(16)),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _previewImage = _selectedImages[index];
        });
        _showImagePreview();
      },
      child: Container(
        width: ResponsiveSize.w(100),
        height: ResponsiveSize.h(100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
          border: Border.all(color: const Color(0xFFDEB887)),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
              child: Image.file(
                _selectedImages[index],
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedImages.removeAt(index);
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(ResponsiveSize.w(4)),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: ResponsiveSize.w(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
    Widget _buildAudioPreview(int index) {
    final isPlaying = _playingIndex == index;
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(8)),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
        border: Border.all(color: const Color(0xFFDEB887)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _playRecording(index),
            child: Icon(
              isPlaying ? Icons.stop_circle : Icons.play_circle_filled,
              color: const Color(0xFFF5A623),
              size: ResponsiveSize.w(30),
            ),
          ),
          SizedBox(width: ResponsiveSize.w(8)),
          Text(
            '录音 ${index + 1}',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(16),
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: ResponsiveSize.w(8)),
          GestureDetector(
            onTap: () {
              setState(() {
                _audioRecordings.removeAt(index);
                if (_playingIndex == index) {
                  _audioPlayer.stop();
                  _playingIndex = null;
                }
              });
            },
            child: Icon(
              Icons.cancel,
              color: Colors.red,
              size: ResponsiveSize.w(24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaControls() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFDF5E6),
            borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
            border: Border.all(color: const Color(0xFFDEB887)),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: _pickImage,
                icon: Icon(
                  Icons.image,
                  color: const Color(0xFF8B4513),
                  size: ResponsiveSize.w(24),
                ),
              ),
              Container(
                width: ResponsiveSize.w(1),
                height: ResponsiveSize.h(24),
                color: const Color(0xFFDEB887),
              ),
              IconButton(
                onPressed: _isRecording ? _stopRecording : _startRecording,
                icon: Icon(
                  _isRecording ? Icons.stop : Icons.mic,
                  color: _isRecording ? Colors.red : const Color(0xFF8B4513),
                  size: ResponsiveSize.w(24),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildSendButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: () {
          final bool hasReceivers = _receiverType == ReceiverType.student 
              ? selectedStudents.isNotEmpty 
              : selectedParentIds.isNotEmpty;
              
          if (!hasReceivers) {
            _showError('请选择至少一个${_receiverType.label}');
            return;
          }
          if (_messageController.text.isEmpty && 
              _selectedImages.isEmpty && 
              _audioRecordings.isEmpty) {
            _showError('请输入消息内容或添加媒体文件');
            return;
          }
          
          _showSuccessDialog('消息已成功发送');
        },
        icon: Icon(
          Icons.send,
          size: ResponsiveSize.w(20),
        ),
        label: Text(
          '发送',
          style: TextStyle(fontSize: ResponsiveSize.sp(20)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFE4C4),
          foregroundColor: const Color(0xFF8B4513),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.w(32),
            vertical: ResponsiveSize.h(16),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
            side: BorderSide(
              color: const Color(0xFFDEB887),
              width: ResponsiveSize.w(1),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _messageController.dispose();
    _audioPlayer.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }
}