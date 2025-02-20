import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../../utils/responsive_size.dart';

class MediaPreviewPage extends StatefulWidget {
  final String mediaPath;
  final bool isVideo;

  const MediaPreviewPage({
    super.key,
    required this.mediaPath,
    required this.isVideo,
  });

  @override
  State<MediaPreviewPage> createState() => _MediaPreviewPageState();
}

class _MediaPreviewPageState extends State<MediaPreviewPage> {
  VideoPlayerController? _videoController;
  double? _videoAspectRatio;
  bool _isInitialized = false;
  String? _thumbnailPath;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (widget.isVideo) {
      _initVideoPlayer();
    }
  }

  Future<void> _initVideoPlayer() async {
    try {
      _videoController = VideoPlayerController.file(File(widget.mediaPath));
      await _videoController!.initialize();
      
      // 获取视频的原始尺寸
      final videoSize = _videoController!.value.size;
      // 获取屏幕尺寸
      final screenSize = MediaQuery.of(context).size;
      
      // 计算视频的原始宽高比
      final videoAspectRatio = videoSize.width / videoSize.height;
      // 计算屏幕的宽高比
      final screenAspectRatio = screenSize.width / screenSize.height;
      
      // 如果视频比例超过屏幕，需要调整
      if (videoSize.width > screenSize.width || videoSize.height > screenSize.height) {
        if (videoAspectRatio > screenAspectRatio) {
          // 如果视频更宽，以屏幕宽度为准
          _videoAspectRatio = screenSize.width / (screenSize.width / videoAspectRatio);
        } else {
          // 如果视频更高，以屏幕高度为准
          _videoAspectRatio = (screenSize.height * videoAspectRatio) / screenSize.height;
        }
      } else {
        // 如果视频尺寸小于屏幕，保持原始比例
        _videoAspectRatio = videoAspectRatio;
      }
      
      // 自动开始播放
      await _videoController!.play();
      setState(() {
        _isInitialized = true;
      });

      // 监听视频播放完成事件
      _videoController!.addListener(() {
        if (_videoController!.value.position >= _videoController!.value.duration) {
          setState(() {});
        }
      });
    } catch (e) {
      debugPrint('视频初始化错误: $e');
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: widget.isVideo ? [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () {
              // 返回视频路径和缩略图路径
              Navigator.pop(context, {
                'videoPath': widget.mediaPath,
                'thumbnailPath': _thumbnailPath,
              });
            },
          ),
        ] : null,
      ),
      body: SafeArea(
        child: Center(
          child: widget.isVideo
              ? _buildVideoPreview()
              : _buildImagePreview(),
        ),
      ),
    );
  }

  Widget _buildVideoPreview() {
    if (!_isInitialized || _videoController == null) {
      return const CircularProgressIndicator(
        color: Colors.white,
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: _videoAspectRatio ?? _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.w(20),
            vertical: ResponsiveSize.h(10),
          ),
          color: Colors.black.withOpacity(0.5),
          child: Column(
            children: [
              VideoProgressIndicator(
                _videoController!,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: Colors.white,
                  bufferedColor: Colors.white24,
                  backgroundColor: Colors.grey,
                ),
                padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(8)),
              ),
              SizedBox(height: ResponsiveSize.h(8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      _videoController!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: ResponsiveSize.w(30),
                    ),
                    onPressed: () {
                      setState(() {
                        if (_videoController!.value.isPlaying) {
                          _videoController!.pause();
                        } else {
                          _videoController!.play();
                        }
                      });
                    },
                  ),
                  Text(
                    '${_formatDuration(_videoController!.value.position)} / ${_formatDuration(_videoController!.value.duration)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveSize.sp(14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final File imageFile = File(widget.mediaPath);
        final Image image = Image.file(imageFile);
        final Completer<Size> completer = Completer<Size>();
        
        image.image.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener((ImageInfo info, bool _) {
            if (!completer.isCompleted) {
              completer.complete(Size(
                info.image.width.toDouble(),
                info.image.height.toDouble(),
              ));
            }
          }),
        );

        return FutureBuilder<Size>(
          future: completer.future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            final Size imageSize = snapshot.data!;
            final Size screenSize = MediaQuery.of(context).size;
            
            double scale = 1.0;
            if (imageSize.width > screenSize.width || 
                imageSize.height > screenSize.height) {
              final double widthScale = screenSize.width / imageSize.width;
              final double heightScale = screenSize.height / imageSize.height;
              scale = widthScale < heightScale ? widthScale : heightScale;
            }

            final double displayWidth = imageSize.width * scale;
            final double displayHeight = imageSize.height * scale;

            return Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                child: Container(
                  width: displayWidth,
                  height: displayHeight,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                      image: FileImage(imageFile),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _videoController?.dispose();
    super.dispose();
  }
}