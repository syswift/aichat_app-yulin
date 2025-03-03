import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'attachment_model.dart';
import 'image_attachments_manager.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/responsive_size.dart';

class CreateTextbookPage extends StatefulWidget {
  const CreateTextbookPage({super.key});

  @override
  State<CreateTextbookPage> createState() => _CreateTextbookPageState();
}

class _CreateTextbookPageState extends State<CreateTextbookPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  int? _selectedSectionIndex;
  final List<Map<String, dynamic>> _videoSections = [];
  Duration _currentPosition = Duration.zero;
  Duration _videoDuration = Duration.zero;
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _videoPlayerController = VideoPlayerController.asset(
        'assets/test_video.mp4',
      )
      ..initialize().then((_) {
        _videoDuration = _videoPlayerController.value.duration;

        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          aspectRatio: 16 / 9,
          autoPlay: false,
          looping: false,
          showControls: true,
          materialProgressColors: ChewieProgressColors(
            playedColor: const Color(0xFF8B4513),
            handleColor: const Color(0xFF8B4513),
            backgroundColor: const Color(0xFFDEB887),
            bufferedColor: const Color(0xFFFFE4C4),
          ),
        );

        _videoPlayerController.addListener(() {
          setState(() {
            _currentPosition = _videoPlayerController.value.position;
          });
        });

        setState(() {});
      });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Duration _parseDuration(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return Duration.zero;
    try {
      final minutes = int.parse(parts[0]);
      final seconds = int.parse(parts[1]);
      return Duration(minutes: minutes, seconds: seconds);
    } catch (e) {
      return Duration.zero;
    }
  }

  void _showAddSectionDialog() {
    _startTimeController.text = _formatDuration(_currentPosition);
    _endTimeController.text = _formatDuration(_videoDuration);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              '添加时间段',
              style: TextStyle(
                color: const Color(0xFF8B4513),
                fontSize: ResponsiveSize.sp(32),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: ResponsiveSize.w(600),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _startTimeController,
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(24),
                        color: const Color(0xFF8B4513),
                      ),
                      decoration: InputDecoration(
                        labelText: '开始时间 (分:秒)',
                        labelStyle: TextStyle(
                          color: const Color(0xFF8B4513),
                          fontSize: ResponsiveSize.sp(22),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(16),
                          ),
                          borderSide: const BorderSide(width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(16),
                          ),
                          borderSide: const BorderSide(
                            color: Color(0xFF8B4513),
                            width: 3,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(24),
                          vertical: ResponsiveSize.h(28),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(32)),
                    TextField(
                      controller: _endTimeController,
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(24),
                        color: const Color(0xFF8B4513),
                      ),
                      decoration: InputDecoration(
                        labelText: '结束时间 (分:秒)',
                        labelStyle: TextStyle(
                          color: const Color(0xFF8B4513),
                          fontSize: ResponsiveSize.sp(22),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(16),
                          ),
                          borderSide: const BorderSide(width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(16),
                          ),
                          borderSide: const BorderSide(
                            color: Color(0xFF8B4513),
                            width: 3,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(24),
                          vertical: ResponsiveSize.h(28),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            contentPadding: EdgeInsets.fromLTRB(
              ResponsiveSize.w(32),
              ResponsiveSize.h(24),
              ResponsiveSize.w(32),
              ResponsiveSize.h(32),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveSize.w(24)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.w(32),
                    vertical: ResponsiveSize.h(20),
                  ),
                ),
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: const Color(0xFF8B4513),
                    fontSize: ResponsiveSize.sp(22),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final startTime = _parseDuration(_startTimeController.text);
                  final endTime = _parseDuration(_endTimeController.text);

                  if (endTime > startTime && endTime <= _videoDuration) {
                    setState(() {
                      _videoSections.add({
                        'timeRange':
                            '${_formatDuration(startTime)} - ${_formatDuration(endTime)}',
                        'startTime': startTime,
                        'endTime': endTime,
                        'attachments': [],
                      });
                    });
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '请输入有效的时间范围',
                          style: TextStyle(fontSize: ResponsiveSize.sp(18)),
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFE4C4),
                  foregroundColor: const Color(0xFF8B4513),
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.w(32),
                    vertical: ResponsiveSize.h(20),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
                  ),
                ),
                child: Text(
                  '添加',
                  style: TextStyle(fontSize: ResponsiveSize.sp(22)),
                ),
              ),
            ],
            actionsPadding: EdgeInsets.fromLTRB(
              ResponsiveSize.w(32),
              0,
              ResponsiveSize.w(32),
              ResponsiveSize.h(24),
            ),
          ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  void _deleteSection(int index) {
    setState(() {
      _videoSections.removeAt(index);
      if (_selectedSectionIndex == index) {
        _selectedSectionIndex = null;
      }
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (!mounted) return;

      if (image != null && _selectedSectionIndex != null) {
        final section = _videoSections[_selectedSectionIndex!];
        setState(() {
          section['attachments'].add({
            'type': '图片',
            'name': '图片${section['attachments'].length + 1}',
            'file': image.path,
            'position': const Offset(100, 100),
            'scale': 1.0,
            'startTime': section['startTime'],
            'endTime': section['endTime'],
          });
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('选择图片失败: $e')));
    }
  }

  void _addAttachment(String type) {
    if (_selectedSectionIndex == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先选择一个时间段')));
      return;
    }

    if (type == '图片') {
      _pickImage();
    } else {
      final section = _videoSections[_selectedSectionIndex!];
      setState(() {
        section['attachments'].add({
          'type': type,
          'name': '$type${section['attachments'].length + 1}',
          'startTime': section['startTime'],
          'endTime': section['endTime'],
        });
      });
    }
  }

  void _removeAttachment(int sectionIndex, int attachmentIndex) {
    setState(() {
      _videoSections[sectionIndex]['attachments'].removeAt(attachmentIndex);
    });
  }

  void _showSaveDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.save_outlined,
                  color: const Color(0xFF8B4513),
                  size: ResponsiveSize.w(28),
                ),
                SizedBox(width: ResponsiveSize.w(12)),
                Text(
                  '保存教材',
                  style: TextStyle(
                    color: const Color(0xFF8B4513),
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveSize.sp(24),
                  ),
                ),
              ],
            ),
            contentPadding: EdgeInsets.fromLTRB(
              ResponsiveSize.w(24),
              ResponsiveSize.h(20),
              ResponsiveSize.w(24),
              ResponsiveSize.h(24),
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: ResponsiveSize.w(500),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: '教材名称',
                        labelStyle: const TextStyle(color: Color(0xFF8B4513)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(12),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(12),
                          ),
                          borderSide: const BorderSide(
                            color: Color(0xFF8B4513),
                            width: 2,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.book_outlined,
                          color: Color(0xFF8B4513),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(20)),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: '备注',
                        labelStyle: const TextStyle(color: Color(0xFF8B4513)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(12),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(12),
                          ),
                          borderSide: const BorderSide(
                            color: Color(0xFF8B4513),
                            width: 2,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.note_outlined,
                          color: Color(0xFF8B4513),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(20)),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: '适用年级',
                        labelStyle: const TextStyle(color: Color(0xFF8B4513)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(12),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(12),
                          ),
                          borderSide: const BorderSide(
                            color: Color(0xFF8B4513),
                            width: 2,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.school_outlined,
                          color: Color(0xFF8B4513),
                        ),
                      ),
                      items:
                          ['一年级', '二年级', '三年级']
                              .map(
                                (grade) => DropdownMenuItem(
                                  value: grade,
                                  child: Text(
                                    grade,
                                    style: const TextStyle(
                                      color: Color(0xFF8B4513),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: const Color(0xFF8B4513),
                    fontSize: ResponsiveSize.sp(16),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: 实现保存功能
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFE4C4),
                  foregroundColor: const Color(0xFF8B4513),
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.w(24),
                    vertical: ResponsiveSize.h(12),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                  ),
                ),
                child: Text(
                  '保存',
                  style: TextStyle(fontSize: ResponsiveSize.sp(16)),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(ResponsiveSize.w(32)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          'assets/backbutton1.png',
                          width: ResponsiveSize.w(80),
                          height: ResponsiveSize.h(80),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.access_time,
                          size: ResponsiveSize.w(20),
                        ),
                        label: Text(
                          '当前时间: ${_formatDuration(_currentPosition)}',
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(20),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFE4C4),
                          foregroundColor: const Color(0xFF8B4513),
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveSize.w(20),
                            vertical: ResponsiveSize.h(12),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.w(8),
                            ),
                            side: const BorderSide(
                              color: Color(0xFFDEB887),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: ResponsiveSize.w(16)),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: 实现添加教材功能
                        },
                        icon: Icon(Icons.add, size: ResponsiveSize.w(20)),
                        label: Text(
                          '添加教材',
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(20),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFE4C4),
                          foregroundColor: const Color(0xFF8B4513),
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveSize.w(20),
                            vertical: ResponsiveSize.h(12),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.w(8),
                            ),
                            side: const BorderSide(
                              color: Color(0xFFDEB887),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: ResponsiveSize.w(16)),
                      ElevatedButton.icon(
                        onPressed: _showSaveDialog,
                        icon: Icon(Icons.save, size: ResponsiveSize.w(20)),
                        label: Text(
                          '保存',
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(20),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFE4C4),
                          foregroundColor: const Color(0xFF8B4513),
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveSize.w(20),
                            vertical: ResponsiveSize.h(12),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.w(8),
                            ),
                            side: const BorderSide(
                              color: Color(0xFFDEB887),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveSize.h(20)),
                  SizedBox(
                    height:
                        MediaQuery.of(context).size.height -
                        ResponsiveSize.h(150),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveSize.w(12),
                                        ),
                                        border: Border.all(
                                          color: const Color(0xFFDEB887),
                                        ),
                                      ),
                                      child:
                                          _chewieController != null
                                              ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      ResponsiveSize.w(12),
                                                    ),
                                                child: Chewie(
                                                  controller:
                                                      _chewieController!,
                                                ),
                                              )
                                              : const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Color(0xFF8B4513),
                                                    ),
                                              ),
                                    ),
                                    if (_selectedSectionIndex != null)
                                      ImageAttachmentsManager(
                                        attachments:
                                            _videoSections[_selectedSectionIndex!]['attachments']
                                                .map<AttachmentModel>(
                                                  (
                                                    attachment,
                                                  ) => AttachmentModel(
                                                    type: attachment['type'],
                                                    name: attachment['name'],
                                                    filePath:
                                                        attachment['file'],
                                                    position:
                                                        attachment['position'] ??
                                                        const Offset(100, 100),
                                                    scale:
                                                        attachment['scale'] ??
                                                        1.0,
                                                  ),
                                                )
                                                .toList(),
                                        onPositionChanged: (index, position) {
                                          setState(() {
                                            _videoSections[_selectedSectionIndex!]['attachments'][index]['position'] =
                                                position;
                                          });
                                        },
                                        onScaleChanged: (index, scale) {
                                          setState(() {
                                            _videoSections[_selectedSectionIndex!]['attachments'][index]['scale'] =
                                                scale;
                                          });
                                        },
                                        onDelete: (index) {
                                          setState(() {
                                            _videoSections[_selectedSectionIndex!]['attachments']
                                                .removeAt(index);
                                          });
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(height: ResponsiveSize.h(20)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildActionButton(
                                    '图片',
                                    'assets/image_icon.png',
                                    () => _addAttachment('图片'),
                                  ),
                                  _buildActionButton(
                                    '音频',
                                    'assets/audio_icon.png',
                                    () => _addAttachment('音频'),
                                  ),
                                  _buildActionButton(
                                    '视频',
                                    'assets/video_icon.png',
                                    () => _addAttachment('视频'),
                                  ),
                                  _buildActionButton(
                                    '习题',
                                    'assets/checklist_icon.png',
                                    () => _addAttachment('习题'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          margin: EdgeInsets.symmetric(
                            horizontal: ResponsiveSize.w(16),
                          ),
                          color: const Color(0xFFDEB887),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.w(12),
                              ),
                              border: Border.all(
                                color: const Color(0xFFDEB887),
                              ),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(ResponsiveSize.w(16)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '时间段列表',
                                        style: TextStyle(
                                          fontSize: ResponsiveSize.sp(20),
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF8B4513),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          _buildListActionButton(
                                            '添加',
                                            Icons.add,
                                          ),
                                          SizedBox(width: ResponsiveSize.w(8)),
                                          _buildListActionButton(
                                            '删除',
                                            Icons.delete,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _videoSections.length,
                                    itemBuilder: (context, index) {
                                      return _buildVideoSection(
                                        _videoSections[index],
                                        index,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Make sure the keyboard doesn't resize the UI
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildActionButton(
    String label,
    String iconPath,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            width: ResponsiveSize.w(60),
            height: ResponsiveSize.h(60),
          ),
          SizedBox(height: ResponsiveSize.h(8)),
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveSize.sp(18),
              color: const Color(0xFF8B4513),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListActionButton(String label, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        if (label == '添加') {
          _showAddSectionDialog();
        } else if (label == '删除' && _selectedSectionIndex != null) {
          _deleteSection(_selectedSectionIndex!);
        } else if (label == '删除') {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('请先选择一个时间段')));
        }
      },
      icon: Icon(icon, size: ResponsiveSize.w(20)),
      label: Text(label, style: TextStyle(fontSize: ResponsiveSize.sp(16))),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFE4C4),
        foregroundColor: const Color(0xFF8B4513),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(16),
          vertical: ResponsiveSize.h(8),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
          side: const BorderSide(color: Color(0xFFDEB887), width: 1),
        ),
      ),
    );
  }

  Widget _buildVideoSection(Map<String, dynamic> section, int index) {
    final isSelected = _selectedSectionIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSectionIndex = index;
          _videoPlayerController.seekTo(section['startTime']);
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(16),
          vertical: ResponsiveSize.h(8),
        ),
        padding: EdgeInsets.all(ResponsiveSize.w(16)),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFE4C4) : const Color(0xFFFFF8DC),
          borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
          border: Border.all(
            color: const Color(0xFFDEB887),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section['timeRange'],
              style: TextStyle(
                fontSize: ResponsiveSize.sp(16),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8B4513),
              ),
            ),
            if (section['attachments'].isNotEmpty) ...[
              SizedBox(height: ResponsiveSize.h(8)),
              Wrap(
                spacing: ResponsiveSize.w(8),
                runSpacing: ResponsiveSize.h(8),
                children: List<Widget>.generate(
                  section['attachments'].length,
                  (attachmentIndex) => _buildAttachmentChip(
                    section['attachments'][attachmentIndex],
                    () => _removeAttachment(index, attachmentIndex),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentChip(
    Map<String, dynamic> attachment,
    VoidCallback onDelete,
  ) {
    return Chip(
      label: Text(
        attachment['name'],
        style: TextStyle(
          color: const Color(0xFF8B4513),
          fontSize: ResponsiveSize.sp(14),
        ),
      ),
      backgroundColor: const Color(0xFFFFE4C4),
      deleteIcon: Icon(
        Icons.close,
        size: ResponsiveSize.w(16),
        color: const Color(0xFF8B4513),
      ),
      onDeleted: onDelete,
    );
  }
}
