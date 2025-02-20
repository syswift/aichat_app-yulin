import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../utils/responsive_size.dart';

class VideoUploadPage extends StatefulWidget {
  final Function(String title, String videoPath, String imagePath)? onSaveWork;

  const VideoUploadPage({
    super.key,
    this.onSaveWork,
  });

  @override
  State<VideoUploadPage> createState() => _VideoUploadPageState();
}

class _VideoUploadPageState extends State<VideoUploadPage> {
  VideoPlayerController? _videoController;
  final TextEditingController _titleController = TextEditingController();
  String? _videoPath;
  bool _hasVideo = false;
  bool _isPlaying = false;
  final String _selectedImage = 'assets/universe.png';

  @override
  void dispose() {
    _videoController?.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result != null) {
        String originalPath = result.files.single.path!;
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String videoName = 'video_${DateTime.now().millisecondsSinceEpoch}.mp4';
        final String savedPath = '${appDir.path}/$videoName';

        await File(originalPath).copy(savedPath);
        await _initializeVideo(savedPath);
        setState(() {
          _videoPath = savedPath;
          _hasVideo = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('选择视频失败')),
        );
      }
    }
  }
    Future<void> _initializeVideo(String path) async {
    try {
      if (_videoController != null) {
        await _videoController!.dispose();
      }
      _videoController = VideoPlayerController.file(File(path));
      await _videoController!.initialize();
      _videoController!.addListener(_videoListener);
      setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('初始化视频失败')),
        );
      }
    }
  }

  void _videoListener() {
    if (_videoController!.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _videoController!.value.isPlaying;
      });
    }
  }

  void _togglePlayPause() {
    if (_videoController == null) return;
    
    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
        _videoController!.setLooping(true);
      }
    });
  }

  void _handleSave() {
    if (!_hasVideo || _videoPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先选择视频')),
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
              style: TextStyle(
                fontSize: ResponsiveSize.sp(22),
                color: const Color(0xFF5A2E17),
              ),
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
                _videoPath!,
                _selectedImage,
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
              style: TextStyle(
                fontSize: ResponsiveSize.sp(22),
                color: const Color(0xFF5A2E17),
              ),
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
                  child: _hasVideo && _videoController != null
                      ? GestureDetector(
                          onTap: _togglePlayPause,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(ResponsiveSize.w(18)),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: ResponsiveSize.w(500),
                                      maxHeight: ResponsiveSize.h(500),
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: SizedBox(
                                        width: _videoController!.value.size.width,
                                        height: _videoController!.value.size.height,
                                        child: VideoPlayer(_videoController!),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (!_isPlaying)
                                Container(
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
                                    Icons.play_arrow,
                                    size: ResponsiveSize.w(40),
                                    color: const Color(0xFF5A2E17),
                                  ),
                                ),
                            ],
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.video_library,
                              size: ResponsiveSize.w(120),
                              color: const Color(0xFF5A2E17).withOpacity(0.3),
                            ),
                            SizedBox(height: ResponsiveSize.h(40)),
                            _buildStyledButton(
                              '选择视频文件',
                              _pickVideo,
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