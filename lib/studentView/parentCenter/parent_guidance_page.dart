import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../../../utils/responsive_size.dart';

class ParentGuidancePage extends StatefulWidget {
  const ParentGuidancePage({super.key});

  @override
  State<ParentGuidancePage> createState() => _ParentGuidancePageState();
}

class _ParentGuidancePageState extends State<ParentGuidancePage> {
  List<VideoItem>? _videos;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    try {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 500));
      
      final List<VideoItem> videos = [
        VideoItem(
          id: '1',
          title: '如何与孩子有效沟通',
          category: '亲子教育指导',
          videoUrl: 'assets/video1.mp4',
        ),
        VideoItem(
          id: '2',
          title: '培养孩子的学习兴趣',
          category: '亲子教育指导',
          videoUrl: 'assets/video2.mp4',
        ),
        VideoItem(
          id: '3',
          title: '如何制定合理的学习计划',
          category: '学习方法指导',
          videoUrl: 'assets/video1.mp4',
        ),
        VideoItem(
          id: '4',
          title: '提高孩子的学习效率',
          category: '学习方法指导',
          videoUrl: 'assets/video2.mp4',
        ),
      ];

      for (var video in videos) {
        await video.initializeDuration();
      }

      if (mounted) {
        setState(() {
          _videos = videos;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '加载视频失败，请稍后重试';
          _isLoading = false;
        });
      }
    }
  }

  Map<String, List<VideoItem>> _groupVideosByCategory() {
    if (_videos == null) return {};
    final Map<String, List<VideoItem>> grouped = {};
    for (var video in _videos!) {
      if (!grouped.containsKey(video.category)) {
        grouped[video.category] = [];
      }
      grouped[video.category]!.add(video);
    }
    return grouped;
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
                    Text(
                      '家长指导课',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(32),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5A2E17),
                      ),
                    ),
                    SizedBox(width: ResponsiveSize.w(90)),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5A2E17)),
                  ),
                ),
              )
            else if (_error != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _error!,
                        style: TextStyle(
                          color: const Color(0xFF5A2E17),
                          fontSize: ResponsiveSize.sp(18),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(20)),
                      ElevatedButton(
                        onPressed: _loadVideos,
                        child: const Text('重试'),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadVideos,
                  color: const Color(0xFF5A2E17),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(20)),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: _groupVideosByCategory()
                          .entries
                          .map(
                            (entry) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildCategoryHeader(entry.key),
                                SizedBox(height: ResponsiveSize.h(20)),
                                _buildVideoGrid(entry.value),
                                SizedBox(height: ResponsiveSize.h(30)),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(String category) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(20),
        vertical: ResponsiveSize.h(10),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFF995D),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
        border: Border.all(
          color: const Color(0xFFFFAD7D),
          width: ResponsiveSize.w(2),
        ),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: ResponsiveSize.sp(22),
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
    Widget _buildVideoGrid(List<VideoItem> videos) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: ResponsiveSize.w(20),
        mainAxisSpacing: ResponsiveSize.h(20),
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) => VideoCard(
        video: videos[index],
        onTap: () => _openVideoPlayer(videos[index]),
      ),
    );
  }

  void _openVideoPlayer(VideoItem video) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerPage(video: video),
      ),
    );
  }
}

class VideoItem {
  final String id;
  final String title;
  final String category;
  final String videoUrl;
  String? duration;

  VideoItem({
    required this.id,
    required this.title,
    required this.category,
    required this.videoUrl,
  });

  Future<void> initializeDuration() async {
    final controller = VideoPlayerController.asset(videoUrl);
    await controller.initialize();
    duration = _formatDuration(controller.value.duration);
    await controller.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

class VideoCard extends StatelessWidget {
  final VideoItem video;
  final VoidCallback onTap;

  const VideoCard({
    super.key,
    required this.video,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9E9),
          borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
          border: Border.all(
            color: const Color(0xFFFFDFA7),
            width: ResponsiveSize.w(2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: ResponsiveSize.w(8),
              offset: Offset(0, ResponsiveSize.h(4)),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(ResponsiveSize.w(13)),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/cartoon.png',
                      fit: BoxFit.cover,
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(ResponsiveSize.w(12)),
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
                          color: const Color(0xFF5A2E17),
                          size: ResponsiveSize.w(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ResponsiveSize.w(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(18),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5A2E17),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ResponsiveSize.h(5)),
                  Text(
                    video.duration ?? '加载中...',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(14),
                      color: const Color(0xFF5A2E17).withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class VideoPlayerPage extends StatefulWidget {
  final VideoItem video;

  const VideoPlayerPage({
    super.key,
    required this.video,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.asset(widget.video.videoUrl);
      await _videoPlayerController.initialize();
      
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: false,
        looping: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFF5A2E17),
          handleColor: const Color(0xFF5A2E17),
          backgroundColor: const Color(0xFFFFDFA7),
          bufferedColor: const Color(0xFF5A2E17).withOpacity(0.3),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(
                color: const Color(0xFF5A2E17),
                fontSize: ResponsiveSize.sp(16),
              ),
            ),
          );
        },
      );

      setState(() => _isInitialized = true);
    } catch (e) {
      setState(() => _error = '视频加载失败，请稍后重试');
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Scaffold(
      body: Container(
        color: const Color(0xFFFFF1D6),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(ResponsiveSize.w(20)),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        'assets/backbutton1.png',
                        width: ResponsiveSize.w(90),
                        height: ResponsiveSize.h(90),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.video.title,
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(24),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5A2E17),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: ResponsiveSize.w(90)),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: _error != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _error!,
                              style: TextStyle(
                                color: const Color(0xFF5A2E17),
                                fontSize: ResponsiveSize.sp(18),
                              ),
                            ),
                            SizedBox(height: ResponsiveSize.h(20)),
                            ElevatedButton(
                              onPressed: _initializePlayer,
                              child: Text(
                                '重试',
                                style: TextStyle(fontSize: ResponsiveSize.sp(16)),
                              ),
                            ),
                          ],
                        )
                      : !_isInitialized
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF5A2E17),
                              ),
                            )
                          : Container(
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
                                child: Chewie(
                                  controller: _chewieController!,
                                ),
                              ),
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}