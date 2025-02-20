import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../../utils/responsive_size.dart';
import 'dart:async';

class CustomVideoControls extends StatefulWidget {
  final VideoPlayerController controller;
  final bool isFullScreen;
  final bool isPlaylistVisible;
  final VoidCallback onPlaylistTap;
  final VoidCallback onToggleFullScreen;
  final bool isNightAudioModeEnabled;  // 新增

  const CustomVideoControls({
    super.key,
    required this.controller,
    required this.isFullScreen,
    required this.isPlaylistVisible,
    required this.onPlaylistTap,
    required this.onToggleFullScreen,
    this.isNightAudioModeEnabled = false,  // 新增
  });

  @override
  State<CustomVideoControls> createState() => _CustomVideoControlsState();
}

class _CustomVideoControlsState extends State<CustomVideoControls> {
  bool _hideControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _hideControls = true;
        });
      }
    });
  }

  void _onTapVideo() {
    setState(() {
      _hideControls = !_hideControls;
      if (!_hideControls) {
        _startHideTimer();
      }
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTapVideo,
      child: Stack(
        children: [
          // 视频播放器
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            child: Center(
              child: AspectRatio(
                aspectRatio: widget.controller.value.aspectRatio,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  child: VideoPlayer(widget.controller),
                ),
              ),
            ),
          ),

          // 控制器界面
          AnimatedOpacity(
            opacity: _hideControls ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: Stack(
              children: [
                // 顶部控制栏
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // 播放列表按钮
                        if (widget.isFullScreen)
                          IconButton(
                            icon: Icon(
                              widget.isPlaylistVisible 
                                  ? Icons.chevron_right 
                                  : Icons.playlist_play,
                              color: Colors.white,
                              size: 32,
                            ),
                            onPressed: widget.onPlaylistTap,
                          ),
                        // 全屏按钮
                        IconButton(
                          icon: Icon(
                            widget.isFullScreen
                                ? Icons.fullscreen_exit
                                : Icons.fullscreen,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: widget.onToggleFullScreen,
                        ),
                      ],
                    ),
                  ),
                ),

                // 底部控制栏
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 进度条
                        _ProgressBar(controller: widget.controller),
                        
                        // 播放控制和时间
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              // 播放/暂停按钮
                              IconButton(
                                icon: Icon(
                                  widget.controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (widget.controller.value.isPlaying) {
                                      widget.controller.pause();
                                    } else {
                                      widget.controller.play();
                                    }
                                  });
                                },
                              ),
                              // 当前时间
                              Text(
                                _formatDuration(widget.controller.value.position),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const Text(
                                ' / ',
                                style: TextStyle(color: Colors.white),
                              ),
                              // 总时长
                              Text(
                                _formatDuration(widget.controller.value.duration),
                                style: const TextStyle(color: Colors.white),
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
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
// 自定义进度条组件
class _ProgressBar extends StatelessWidget {
  final VideoPlayerController controller;

  const _ProgressBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, VideoPlayerValue value, child) {
        return SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.3),
            thumbColor: Colors.white,
            trackHeight: 2.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
          ),
          child: Slider(
            value: value.position.inMilliseconds.toDouble(),
            max: value.duration.inMilliseconds.toDouble(),
            onChanged: (newValue) {
              final Duration newPosition = Duration(milliseconds: newValue.toInt());
              controller.seekTo(newPosition);
            },
          ),
        );
      },
    );
  }
}

class VideoPlayerPage extends StatefulWidget {
  final int currentChapter;
  final int totalChapters;
  final String videoTitle;
  final bool isNightAudioModeEnabled;  // 新增

  const VideoPlayerPage({
    super.key,
    required this.currentChapter,
    required this.totalChapters,
    required this.videoTitle,
    this.isNightAudioModeEnabled = false,  // 新增
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}
class _VideoPlayerPageState extends State<VideoPlayerPage> with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoPlayerController;
  bool isAudioMode = false;
  bool isLooping = false;
  bool isAutoPlay = false;
  bool isPlaylistVisible = false;
  bool isFullScreen = false;
  late AnimationController _animationController;
  late Animation<Offset> _playlistAnimation;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _initializeAnimations();
    
    // 如果开启了晚间音频模式，强制使用音频模式
    if (widget.isNightAudioModeEnabled) {
      isAudioMode = true;
    }
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _playlistAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.asset(
      'assets/test_video.mp4',
    );
    await _videoPlayerController.initialize();
    setState(() {});
  }

  void _togglePlaylist() {
    setState(() {
      isPlaylistVisible = !isPlaylistVisible;
      if (isPlaylistVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;
      if (isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        if (isPlaylistVisible) {
          isPlaylistVisible = false;
          _animationController.reverse();
        }
      }
    });
  }

  void _toggleAudioMode() {
    // 如果晚间音频模式开启且当前是音频模式，禁止切换
    if (widget.isNightAudioModeEnabled && isAudioMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('晚间音频模式已开启，无法切换到视频模式'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    setState(() {
      isAudioMode = !isAudioMode;
    });
  }

  void _toggleLoop() {
    setState(() {
      isLooping = !isLooping;
      _videoPlayerController.setLooping(isLooping);
    });
  }

  void _toggleAutoPlay() {
    setState(() {
      isAutoPlay = !isAutoPlay;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _animationController.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }
    @override
  Widget build(BuildContext context) {
    if (isFullScreen) {
      return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (!didPop && isFullScreen) {
            _toggleFullScreen();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Center(
                child: CustomVideoControls(
                  controller: _videoPlayerController,
                  isFullScreen: isFullScreen,
                  isPlaylistVisible: isPlaylistVisible,
                  onPlaylistTap: _togglePlaylist,
                  onToggleFullScreen: _toggleFullScreen,
                  isNightAudioModeEnabled: widget.isNightAudioModeEnabled,
                ),
              ),
              if (isPlaylistVisible)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: SlideTransition(
                    position: _playlistAnimation,
                    child: Container(
                      width: 300,
                      color: Colors.black.withOpacity(0.8),
                      child: _buildPlaylist(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/cartoon_videobg1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 顶部标题栏
              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveSize.w(50),
                  top: ResponsiveSize.h(20),
                  bottom: ResponsiveSize.h(20)
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        'assets/backbutton1.png',
                        width: ResponsiveSize.w(100),
                        height: ResponsiveSize.w(100),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.videoTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(36),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5C3D2E),
                        ),
                      ),
                    ),
                    SizedBox(width: ResponsiveSize.w(100)),
                  ],
                ),
              ),
              // 主内容区
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(ResponsiveSize.w(20)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(30)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE6B788).withOpacity(0.3),
                        offset: Offset(0, ResponsiveSize.h(4)),
                        blurRadius: ResponsiveSize.w(15),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(ResponsiveSize.w(30)),
                          ),
                          child: Stack(
                            children: [
                              CustomVideoControls(
                                controller: _videoPlayerController,
                                isFullScreen: isFullScreen,
                                isPlaylistVisible: isPlaylistVisible,
                                onPlaylistTap: _togglePlaylist,
                                onToggleFullScreen: _toggleFullScreen,
                                isNightAudioModeEnabled: widget.isNightAudioModeEnabled,
                              ),
                              if (isAudioMode)
                                Container(
                                  color: Colors.white,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.audio_file,
                                          size: ResponsiveSize.w(100),
                                          color: const Color(0xFFE6B788),
                                        ),
                                        SizedBox(height: ResponsiveSize.h(20)),
                                        _buildAudioControls(),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      _buildControlPanel(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaylist() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.black.withOpacity(0.6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '播放列表',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveSize.sp(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${widget.currentChapter}/${widget.totalChapters}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveSize.sp(16),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: _togglePlaylist,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: widget.totalChapters,
            itemBuilder: (context, index) {
              final chapter = index + 1;
              final isCurrentChapter = chapter == widget.currentChapter;
              
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isCurrentChapter
                      ? Colors.white.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  dense: true,
                  leading: Text(
                    '$chapter',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveSize.sp(16),
                      fontWeight: isCurrentChapter
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  title: Text(
                    '第 $chapter 章',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveSize.sp(16),
                      fontWeight: isCurrentChapter
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: isCurrentChapter
                      ? const Icon(
                          Icons.play_circle_filled,
                          color: Colors.white,
                          size: 24,
                        )
                      : null,
                  onTap: () {
                    // TODO: 实现切换章节的逻辑
                    setState(() {
                      // 这里添加切换章节的代码
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(20)),
      decoration: BoxDecoration(
        color: const Color(0xFFFBE4D8),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(ResponsiveSize.w(30)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: isAudioMode ? Icons.videocam : Icons.audio_file,
            label: isAudioMode ? '视频模式' : '音频模式',
            onPressed: _toggleAudioMode,
          ),
          _buildControlButton(
            icon: isLooping ? Icons.repeat_one : Icons.repeat,
            label: isLooping ? '单个循环' : '循环播放',
            onPressed: _toggleLoop,
          ),
          _buildControlButton(
            icon: isAutoPlay ? Icons.playlist_play : Icons.featured_play_list,
            label: isAutoPlay ? '连续播放' : '单集播放',
            onPressed: _toggleAutoPlay,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
          iconSize: ResponsiveSize.w(35),
          color: const Color(0xFF5C3D2E),
        ),
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF5C3D2E),
            fontSize: ResponsiveSize.sp(16),
          ),
        ),
      ],
    );
  }

  Widget _buildAudioControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder(
          valueListenable: _videoPlayerController,
          builder: (context, VideoPlayerValue value, child) {
            return IconButton(
              icon: Icon(
                value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                size: ResponsiveSize.w(60),
                color: const Color(0xFFE6B788),
              ),
              onPressed: () {
                value.isPlaying ? _videoPlayerController.pause() : _videoPlayerController.play();
              },
            );
          },
        ),
        SizedBox(height: ResponsiveSize.h(20)),
        _buildProgressBar(),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(40)),
      child: ValueListenableBuilder(
        valueListenable: _videoPlayerController,
        builder: (context, VideoPlayerValue value, child) {
          return Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFFE6B788),
                  inactiveTrackColor: const Color(0xFFE6B788).withOpacity(0.3),
                  thumbColor: const Color(0xFFE6B788),
                  overlayColor: const Color(0xFFE6B788).withOpacity(0.3),
                  trackHeight: ResponsiveSize.h(4),
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: ResponsiveSize.w(8),
                  ),
                  overlayShape: RoundSliderOverlayShape(
                    overlayRadius: ResponsiveSize.w(16),
                  ),
                ),
                child: Slider(
                  value: value.position.inMilliseconds.toDouble(),
                  max: value.duration.inMilliseconds.toDouble(),
                  onChanged: (newValue) {
                    final Duration newPosition = Duration(
                      milliseconds: newValue.toInt(),
                    );
                    _videoPlayerController.seekTo(newPosition);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(value.position),
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(16),
                        color: const Color(0xFF5C3D2E),
                      ),
                    ),
                    Text(
                      _formatDuration(value.duration),
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(16),
                        color: const Color(0xFF5C3D2E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}