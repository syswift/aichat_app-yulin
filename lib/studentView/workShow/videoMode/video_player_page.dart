import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../../../utils/responsive_size.dart';

class VideoPlayerPage extends StatefulWidget {
  final String title;
  final String videoPath;
  final String? imagePath;
  final DateTime? createTime;    
  final String? teacherComment;  
  final DateTime? commentTime;   

  const VideoPlayerPage({
    super.key,
    required this.title,
    required this.videoPath,
    this.imagePath,
    this.createTime,            
    this.teacherComment,        
    this.commentTime,           
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isDisposed = false;
  bool _hasError = false;
  bool _isLoading = true;  
  bool _showInfo = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
  try {
    debugPrint('开始初始化视频播放器...');
    debugPrint('视频路径: ${widget.videoPath}');

    // 区分资源文件和本地文件
    if (widget.videoPath.startsWith('assets/')) {
      debugPrint('使用资源文件初始化视频播放器');
      _videoPlayerController = VideoPlayerController.asset(widget.videoPath);
    } else {
      debugPrint('使用本地文件初始化视频播放器');
      final file = File(widget.videoPath);
      final exists = await file.exists();
      debugPrint('文件是否存在: $exists');
      if (!exists) {
        throw Exception('视频文件不存在: ${widget.videoPath}');
      }
      _videoPlayerController = VideoPlayerController.file(file);
    }
    
    debugPrint('视频控制器已创建');

    await _videoPlayerController!.initialize();
    debugPrint('视频初始化完成');

    if (!_isDisposed) {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: false,
        looping: false,
        showControls: true,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              '视频加载失败: $errorMessage',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(24),
                color: const Color(0xFF5A2E17),
              ),
            ),
          );
        },
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFF5A2E17),
          handleColor: const Color(0xFF5A2E17),
          backgroundColor: const Color(0xFFFFDFA7),
          bufferedColor: const Color(0xFF5A2E17).withOpacity(0.3),
        ),
      );

      setState(() {
        _isLoading = false;
      });
    }
  } catch (e, stackTrace) {
    debugPrint('视频播放器初始化错误: $e');
    debugPrint('错误堆栈: $stackTrace');
    
    if (!_isDisposed) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }
}
    @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Scaffold(
      body: Container(
        color: const Color(0xFFFFF1D6),
        child: Stack(
          children: [
            Column(
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
                            widget.title,
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(25),
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF5A2E17),
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveSize.w(90)),
                      ],
                    ),
                  ),
                ),
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
                        child: _buildVideoPlayer(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _buildInfoPanel(),
            _buildInfoToggle(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF5A2E17)),
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: ResponsiveSize.w(40),
              color: const Color(0xFF5A2E17),
            ),
            SizedBox(height: ResponsiveSize.h(10)),
            Text(
              '视频加载失败',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(24),
                color: const Color(0xFF5A2E17),
              ),
            ),
          ],
        ),
      );
    }

    if (_chewieController != null && _videoPlayerController != null) {
      return Chewie(controller: _chewieController!);
    }

    return const SizedBox.shrink();
  }

      Widget _buildInfoPanel() {
    final displayComment = widget.teacherComment?.isNotEmpty == true 
        ? widget.teacherComment! 
        : '测试点评内容：这是一个非常棒的创作视频！画面构图合理，故事情节完整，创意十足。特别是在细节的处理上非常用心，让整个作品更有感染力。继续保持这样的创作热情，相信会有更好的作品！';
    
    final displayCommentTime = widget.commentTime ?? DateTime.now().subtract(const Duration(days: 2));

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      right: _showInfo ? ResponsiveSize.w(20) : -ResponsiveSize.w(300),
      top: ResponsiveSize.h(20),
      child: Container(
        width: ResponsiveSize.w(300),
        padding: EdgeInsets.all(ResponsiveSize.w(15)),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
          border: Border.all(
            color: const Color(0xFFFFDFA7),
            width: ResponsiveSize.w(2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: ResponsiveSize.w(10),
              offset: Offset(0, ResponsiveSize.h(5)),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '作品信息',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(24),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF5A2E17),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showInfo = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(ResponsiveSize.w(5)),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDFA7),
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                    ),
                    child: Icon(
                      Icons.close,
                      size: ResponsiveSize.w(20),
                      color: const Color(0xFF5A2E17),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveSize.h(15)),
            _buildInfoItem(
              icon: Icons.calendar_today,
              title: '完成日期',
              content: _getFormattedDate(),
            ),
            SizedBox(height: ResponsiveSize.h(10)),
            _buildInfoItem(
              icon: Icons.timer,
              title: '鹅爸爸陪伴',
              content: _getWeeksInApp(),
            ),
            SizedBox(height: ResponsiveSize.h(10)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveSize.w(8)),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1D6),
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                  ),
                  child: Icon(
                    Icons.rate_review,
                    size: ResponsiveSize.w(20),
                    color: const Color(0xFF5A2E17),
                  ),
                ),
                SizedBox(width: ResponsiveSize.w(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '老师点评',
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(18),
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            DateFormat('MM-dd').format(displayCommentTime),
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(16),
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveSize.h(4)),
                      Text(
                        displayComment,
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(20),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5A2E17),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildInfoToggle() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      right: _showInfo ? -ResponsiveSize.w(50) : ResponsiveSize.w(20),
      top: ResponsiveSize.h(20),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showInfo = true;
          });
        },
        child: Container(
          padding: EdgeInsets.all(ResponsiveSize.w(12)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
            border: Border.all(
              color: const Color(0xFFFFDFA7),
              width: ResponsiveSize.w(2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: ResponsiveSize.w(5),
                offset: Offset(0, ResponsiveSize.h(2)),
              ),
            ],
          ),
          child: Icon(
            Icons.info_outline,
            size: ResponsiveSize.w(24),
            color: const Color(0xFF5A2E17),
          ),
        ),
      ),
    );
  }
  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,  // 让图标和文字顶部对齐
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveSize.w(8)),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1D6),
            borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
          ),
          child: Icon(
            icon,
            size: ResponsiveSize.w(20),
            color: const Color(0xFF5A2E17),
          ),
        ),
        SizedBox(width: ResponsiveSize.w(10)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(18),
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: ResponsiveSize.h(4)),
              Padding(
                padding: EdgeInsets.only(left: ResponsiveSize.w(0)),  // 确保内容和图标纵向对齐
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(20),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF5A2E17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  String _getFormattedDate() {
    if (widget.createTime == null) return '未知时间';
    return DateFormat('yyyy年MM月dd日').format(widget.createTime!);
  }

  String _getWeeksInApp() {
    if (widget.createTime == null) return '0周';
    final now = DateTime.now();
    final difference = now.difference(widget.createTime!);
    final weeks = (difference.inDays / 7).ceil();
    return '$weeks周';
  }

  @override
  void dispose() {
    _isDisposed = true;
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}