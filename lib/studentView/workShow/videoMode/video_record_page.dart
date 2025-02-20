import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../utils/responsive_size.dart';

class VideoRecordPage extends StatefulWidget {
  final Function(String title, String videoPath, String imagePath)? onSaveWork;

  const VideoRecordPage({
    super.key,
    this.onSaveWork,
  });

  @override
  State<VideoRecordPage> createState() => _VideoRecordPageState();
}

class _VideoRecordPageState extends State<VideoRecordPage> {
  VideoPlayerController? _videoController;
  final TextEditingController _titleController = TextEditingController();
  String? _videoPath;
  bool _isPreview = false;
  bool _isPlaying = false;
  bool _isDisposed = false;
  bool _showControls = false;

  @override
  void initState() {
    super.initState();
    _recordVideo();
  }

  Future<void> _recordVideo() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 10),
      );

      if (video != null) {
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String videoName = 'video_${DateTime.now().millisecondsSinceEpoch}.mp4';
        final String savedPath = '${appDir.path}/$videoName';
        
        await File(video.path).copy(savedPath);
        
        if (_videoController != null) {
          await _videoController!.dispose();
        }
        
        final videoController = VideoPlayerController.file(File(savedPath));
        await videoController.initialize();
        videoController.addListener(_videoListener);
        
        if (!_isDisposed) {
          setState(() {
            _isPreview = true;
            _videoPath = savedPath;
            _videoController = videoController;
          });
        }
      } else {
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('视频录制失败，请重试')),
        );
        Navigator.pop(context);
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

  void _handleTap() {
    setState(() {
      _showControls = !_showControls;
    });

    if (_showControls) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _showControls) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  void _handleSave() {
    if (_videoPath == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '保存作品',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(28),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5A2E17),
          ),
        ),
        content: SizedBox(
          width: ResponsiveSize.w(500),
          child: TextField(
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
                'assets/default_cover.png',
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '保存成功',
                    style: TextStyle(fontSize: ResponsiveSize.sp(20)),
                  ),
                ),
              );
              _titleController.clear();
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
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.w(25),
                        vertical: ResponsiveSize.h(12),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFDFA7),
                        borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                        border: Border.all(
                          color: const Color(0xFFFFCC80),
                          width: ResponsiveSize.w(2),
                        ),
                      ),
                      child: Text(
                        '视频预览',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(25),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5A2E17),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        if (_isPreview) ...[
                          _buildActionButton('重录', () {
                            _videoController?.dispose();
                            _recordVideo();
                          }),
                          SizedBox(width: ResponsiveSize.w(15)),
                          _buildActionButton('保存', _handleSave),
                        ] else ...[
                          SizedBox(width: ResponsiveSize.w(90)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_isPreview && _videoController != null)
              Expanded(
                child: Center(
                  child: Container(
                    width: ResponsiveSize.w(800),
                    height: ResponsiveSize.h(450),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF9E9),
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                      border: Border.all(
                        color: const Color(0xFFFFDFA7),
                        width: ResponsiveSize.w(2),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(18)),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: VideoPlayer(_videoController!),
                          ),
                          GestureDetector(
                            onTap: () {
                              _handleTap();
                              _togglePlayPause();
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Stack(
                                children: [
                                  if (!_isPlaying || _showControls)
                                    Center(
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
                                          size: ResponsiveSize.w(40),
                                          color: const Color(0xFF5A2E17),
                                        ),
                                      ),
                                    ),
                                                                      if (_showControls)
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(10)),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFDFA7).withOpacity(0.9),
                                        ),
                                        child: ValueListenableBuilder(
                                          valueListenable: _videoController!,
                                          builder: (context, VideoPlayerValue value, child) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(20)),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    _formatDuration(value.position),
                                                    style: TextStyle(
                                                      color: const Color(0xFF5A2E17),
                                                      fontSize: ResponsiveSize.sp(16),
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: SliderTheme(
                                                      data: SliderThemeData(
                                                        activeTrackColor: const Color(0xFF5A2E17),
                                                        inactiveTrackColor: const Color(0xFF5A2E17).withOpacity(0.3),
                                                        thumbColor: const Color(0xFF5A2E17),
                                                        trackHeight: ResponsiveSize.h(4),
                                                        thumbShape: RoundSliderThumbShape(
                                                          enabledThumbRadius: ResponsiveSize.w(8),
                                                        ),
                                                      ),
                                                      child: Slider(
                                                        value: value.position.inMilliseconds.toDouble(),
                                                        min: 0,
                                                        max: value.duration.inMilliseconds.toDouble(),
                                                        onChanged: (newValue) {
                                                          final Duration position = Duration(milliseconds: newValue.round());
                                                          _videoController!.seekTo(position);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    _formatDuration(value.duration),
                                                    style: TextStyle(
                                                      color: const Color(0xFF5A2E17),
                                                      fontSize: ResponsiveSize.sp(16),
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(30),
          vertical: ResponsiveSize.h(12),
        ),
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
            fontSize: ResponsiveSize.sp(25),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5A2E17),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    _titleController.dispose();
    super.dispose();
  }
}