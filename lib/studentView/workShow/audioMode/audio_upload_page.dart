import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import '../../../utils/responsive_size.dart';

class AudioUploadPage extends StatefulWidget {
  final Function(String title, String audioPath, String imagePath)? onSaveWork;

  const AudioUploadPage({
    super.key,
    this.onSaveWork,
  });

  @override
  State<AudioUploadPage> createState() => _AudioUploadPageState();
}

class _AudioUploadPageState extends State<AudioUploadPage> {
  File? _selectedAudioFile;
  final String _defaultCover = 'assets/default_cover.png';
  bool _hasMedia = false;
  bool _isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'm4a', 'aac', 'wma'],
      );

      if (result != null) {
        setState(() {
          _selectedAudioFile = File(result.files.single.path!);
          _hasMedia = true;
          _isPlaying = false;
        });
        await _audioPlayer.setSourceDeviceFile(_selectedAudioFile!.path);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('选择文件失败: $e')),
      );
    }
  }

  Future<void> _playOrPause() async {
    if (_selectedAudioFile == null) return;

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.resume();
      }
      setState(() => _isPlaying = !_isPlaying);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('播放失败: $e')),
      );
    }
  }

  void _handleSave() {
    if (!_hasMedia || _selectedAudioFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先选择音频文件')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '保存作品',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(28),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: ResponsiveSize.w(500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                style: TextStyle(fontSize: ResponsiveSize.sp(24)),
                decoration: InputDecoration(
                  labelText: '作品名称',
                  labelStyle: TextStyle(fontSize: ResponsiveSize.sp(24)),
                  hintText: '请输入作品名称',
                  hintStyle: TextStyle(fontSize: ResponsiveSize.sp(22)),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.w(20),
                    vertical: ResponsiveSize.h(15),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '取消',
              style: TextStyle(fontSize: ResponsiveSize.sp(22)),
            ),
          ),
          TextButton(
            onPressed: () {
              if (_titleController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '请输入作品名称',
                      style: TextStyle(fontSize: ResponsiveSize.sp(20)),
                    ),
                  ),
                );
                return;
              }
              
              widget.onSaveWork?.call(
                _titleController.text,
                _selectedAudioFile!.path,
                _defaultCover,
              );
              
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '作品保存成功',
                    style: TextStyle(fontSize: ResponsiveSize.sp(20)),
                  ),
                ),
              );
            },
            child: Text(
              '保存',
              style: TextStyle(fontSize: ResponsiveSize.sp(22)),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
        ),
        contentPadding: EdgeInsets.fromLTRB(
          ResponsiveSize.w(30),
          ResponsiveSize.h(20),
          ResponsiveSize.w(30),
          ResponsiveSize.h(20),
        ),
      ),
    );
  }
    @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Scaffold(
      body: Container(
        color: const Color(0xFFFFF1D6),
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.w(20),
                  vertical: ResponsiveSize.h(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        'assets/backbutton1.png',
                        width: ResponsiveSize.w(90),
                        height: ResponsiveSize.h(90),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: ResponsiveSize.w(15)),
                          child: _buildStyledButton(
                            '分享',
                            () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '分享功能开发中',
                                    style: TextStyle(fontSize: ResponsiveSize.sp(20)),
                                  ),
                                ),
                              );
                            },
                            fontSize: ResponsiveSize.sp(26),
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveSize.w(30),
                              vertical: ResponsiveSize.h(12),
                            ),
                          ),
                        ),
                        _buildStyledButton(
                          '保存',
                          _handleSave,
                          fontSize: ResponsiveSize.sp(26),
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveSize.w(30),
                            vertical: ResponsiveSize.h(12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: ResponsiveSize.w(500),
                  height: ResponsiveSize.h(500),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9E9),
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                    border: Border.all(
                      color: const Color(0xFFFFDFA7),
                      width: ResponsiveSize.w(2),
                    ),
                  ),
                  child: _selectedAudioFile != null
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.audio_file,
                                  size: ResponsiveSize.w(120),
                                  color: const Color(0xFF5A2E17),
                                ),
                                SizedBox(height: ResponsiveSize.h(20)),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(20)),
                                  child: Text(
                                    _selectedAudioFile!.path.split('/').last,
                                    style: TextStyle(
                                      fontSize: ResponsiveSize.sp(22),
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF5A2E17),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: ResponsiveSize.h(40),
                              child: GestureDetector(
                                onTap: _playOrPause,
                                child: Container(
                                  padding: EdgeInsets.all(ResponsiveSize.w(15)),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFDFA7),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFFFCC80),
                                      width: ResponsiveSize.w(2),
                                    ),
                                  ),
                                  child: Icon(
                                    _isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: const Color(0xFF5A2E17),
                                    size: ResponsiveSize.w(40),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.audio_file,
                              size: ResponsiveSize.w(120),
                              color: const Color(0xFF5A2E17).withOpacity(0.3),
                            ),
                            SizedBox(height: ResponsiveSize.h(40)),
                            _buildStyledButton(
                              '选择音频文件',
                              _pickAudioFile,
                              fontSize: ResponsiveSize.sp(26),
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveSize.w(40),
                                vertical: ResponsiveSize.h(15),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledButton(
    String text, 
    VoidCallback onTap, {
    double fontSize = 26,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 50,
      vertical: 18,
    ),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: const Color(0xFFFFDFA7),
          borderRadius: BorderRadius.circular(ResponsiveSize.w(30)),
          border: Border.all(
            color: const Color(0xFFFFCC80),
            width: ResponsiveSize.w(2),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: const Color(0xFF5A2E17),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}