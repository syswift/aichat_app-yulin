import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';
import '../../../utils/responsive_size.dart';

class AudioPlayerPage extends StatefulWidget {
  final String title;
  final String audioPath;
  final String? imagePath;
  final DateTime? createTime;    
  final String? teacherComment;  
  final DateTime? commentTime;   

  const AudioPlayerPage({
    super.key,
    required this.title,
    required this.audioPath,
    this.imagePath,
    this.createTime,            
    this.teacherComment,        
    this.commentTime,           
  });

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isDisposed = false;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _showInfo = true;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
  }

  String _getWeeksInApp() {
    if (widget.createTime == null) return '0周';
    final now = DateTime.now();
    final difference = now.difference(widget.createTime!);
    final weeks = (difference.inDays / 7).ceil();
    return '$weeks周';
  }

  String _getFormattedDate() {
    if (widget.createTime == null) return '未知时间';
    return DateFormat('yyyy年MM月dd日').format(widget.createTime!);
  }

  Future<void> _setupAudioPlayer() async {
    try {
      debugPrint('开始初始化音频播放器...');
      debugPrint('音频路径: ${widget.audioPath}');

      // 先获取时长
      if (widget.audioPath.startsWith('assets/')) {
        await _audioPlayer.setSource(AssetSource(widget.audioPath.replaceFirst('assets/', '')));
      } else {
        await _audioPlayer.setSourceDeviceFile(widget.audioPath);
      }
      
      // 立即获取时长
      final duration = await _audioPlayer.getDuration();
      if (duration != null && mounted && !_isDisposed) {
        setState(() => _duration = duration);
      }
      
      debugPrint('音频源设置完成，时长: $_duration');

      _audioPlayer.onDurationChanged.listen((duration) {
        if (!mounted || _isDisposed) return;
        setState(() => _duration = duration);
      }, onError: (error) {
        debugPrint('Duration changed error: $error');
      });

      _audioPlayer.onPositionChanged.listen((position) {
        if (!mounted || _isDisposed) return;
        setState(() => _position = position);
      }, onError: (error) {
        debugPrint('Position changed error: $error');
      });

      _audioPlayer.onPlayerComplete.listen((event) {
        if (!mounted || _isDisposed) return;
        setState(() => _isPlaying = false);
      }, onError: (error) {
        debugPrint('Player complete error: $error');
      });

      _audioPlayer.onPlayerStateChanged.listen((state) {
        if (!mounted || _isDisposed) return;
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }, onError: (error) {
        debugPrint('Player state changed error: $error');
      });

      debugPrint('音频播放器初始化完成');
    } catch (e, stackTrace) {
      debugPrint('音频播放器初始化错误: $e');
      debugPrint('错误堆栈: $stackTrace');
      if (mounted && !_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('音频初始化失败: $e')),
        );
      }
    }
  }

  Future<void> _playOrPause() async {
    if (_isDisposed) return;
    
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        setState(() => _isPlaying = false);
      } else {
        if (_position.inSeconds == _duration.inSeconds) {
          // 如果已经播放到结尾，重新开始
          await _audioPlayer.seek(Duration.zero);
        }
        await _audioPlayer.resume();
        setState(() => _isPlaying = true);
      }
    } catch (e) {
      debugPrint('播放控制错误: $e');
      if (mounted && !_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('播放控制失败: $e')),
        );
      }
    }
  }
    Future<void> _seekTo(Duration position) async {
    if (_isDisposed) return;
    
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      debugPrint('进度调整错误: $e');
      if (mounted && !_isDisposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('进度调整失败: $e')),
        );
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  

  Widget _buildInfoPanel() {
    final displayComment = widget.teacherComment?.isNotEmpty == true 
        ? widget.teacherComment! 
        : '测试点评内容：这是一个非常棒的朗读作品！发音准确，语调自然，感情充沛。特别是在重音和停顿的处理上非常到位，让整个朗读更有感染力。继续保持这样的水平，相信会有更好的进步！';
    
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
              Text(
                content,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5A2E17),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    debugPrint('正在销毁音频播放器...');
    _isDisposed = true;
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Scaffold(
      body: Container(
        color: const Color(0xFFFFF1D6),
        child: SafeArea(
          child: Stack(
            children: [
              if (widget.imagePath != null && widget.imagePath!.isNotEmpty)
                Positioned.fill(
                  child: Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                        maxHeight: MediaQuery.of(context).size.height * 0.8,
                      ),
                      child: widget.imagePath!.startsWith('assets/')
                          ? Image.asset(
                              widget.imagePath!,
                              fit: BoxFit.contain,
                            )
                          : Image.file(
                              File(widget.imagePath!),
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          child: Center(
                            child: Container(
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
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveSize.w(90)),
                      ],
                    ),
                  ),
                  // 在 build 方法中的播放按钮部分
Expanded(
  child: Container(
    alignment: Alignment.center,
    child: Container(
      width: ResponsiveSize.w(120),
      height: ResponsiveSize.h(120),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDFA7),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFFFCC80),
          width: ResponsiveSize.w(1),
        ),
      ),
      child: IconButton(
        icon: Icon(
          _isPlaying ? Icons.pause : Icons.play_arrow,  // 改回原来的图标
          size: ResponsiveSize.w(60),
          color: const Color(0xFF5A2E17),
        ),
        onPressed: _playOrPause,
      ),
    ),
  ),
),
                  Container(
                    margin: EdgeInsets.only(
                      left: ResponsiveSize.w(20),
                      right: ResponsiveSize.w(20),
                      bottom: ResponsiveSize.h(20),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.w(15),
                      vertical: ResponsiveSize.h(10),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDFA7),
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                      border: Border.all(
                        color: const Color(0xFFFFCC80),
                        width: ResponsiveSize.w(1),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SliderTheme(
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
                            value: _position.inSeconds.toDouble(),
                            min: 0,
                            max: _duration.inSeconds.toDouble(),
                            onChanged: (value) {
                              _seekTo(Duration(seconds: value.toInt()));
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveSize.w(16)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(_position),
                                style: TextStyle(
                                  color: const Color(0xFF5A2E17),
                                  fontSize: ResponsiveSize.sp(18),
                                ),
                              ),
                              Text(
                                _formatDuration(_duration),
                                style: TextStyle(
                                  color: const Color(0xFF5A2E17),
                                  fontSize: ResponsiveSize.sp(18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              _buildInfoPanel(),
              _buildInfoToggle(),
            ],
          ),
        ),
      ),
    );
  }
}