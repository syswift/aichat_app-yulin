import 'package:flutter/material.dart';
import './quick_review_page.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import '../../../utils/responsive_size.dart';
import 'components/ai_review_panel.dart';
import 'components/manual_review_panel.dart';
import 'components/voice_review_panel.dart';

enum ReviewType {
  ai('AI点评'),
  manual('普通点评'),
  voice('语音点评');

  final String label;
  const ReviewType(this.label);
}

enum ContentType {
  video('视频'),
  audio('录音'),
  book('绘本阅读');

  final String label;
  const ContentType(this.label);
}

class ReviewDetailPage extends StatefulWidget {
  final ReviewItem reviewItem;
  final VoidCallback? onReviewSubmitted;

  const ReviewDetailPage({
    super.key,
    required this.reviewItem,
    this.onReviewSubmitted,
  });

  @override
  State<ReviewDetailPage> createState() => _ReviewDetailPageState();
}

class _ReviewDetailPageState extends State<ReviewDetailPage> {
  ReviewType selectedReviewType = ReviewType.manual;
  String systemScore = '0.0';
  String aiEvaluation = '';
  String manualEvaluation = '';
  bool isEvaluating = false;
  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _evaluationController = TextEditingController();

  late VideoPlayerController _videoController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration audioDuration = Duration.zero;
  Duration audioPosition = Duration.zero;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;

  bool _showVideoControls = false;
  Timer? _hideControlsTimer;

  static const Color primaryColor = Color(0xFFFF9E9E);
  static const Color primaryYellow = Color(0xFFFFE4B5);
  static const Color secondaryYellow = Color(0xFFFFF3D6);
  static const Color textColor = Color(0xFF333333);

  bool isRecording = false;
  String recordDuration = '00:00';
  Timer? _recordingTimer;
  int _recordingSeconds = 0;
  String? recordedAudioPath;
  String? voiceEvaluation;


  final AudioPlayer _resultAudioPlayer = AudioPlayer();
  bool _isResultPlaying = false;

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
    _initAudioPlayer();
    _scoreController.text = systemScore;
    
    _videoController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _scoreController.dispose();
    _evaluationController.dispose();
    _hideControlsTimer?.cancel();
    _recordingTimer?.cancel();
    _resultAudioPlayer.dispose();
    super.dispose();
  }

  void _initVideoPlayer() {
    _videoController = VideoPlayerController.asset('assets/test_video.mp4')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
  }

  void _initAudioPlayer() {
    _durationSubscription = _audioPlayer.onDurationChanged.listen((Duration d) {
      if (mounted) {
        setState(() => audioDuration = d);
      }
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((Duration p) {
      if (mounted) {
        setState(() => audioPosition = p);
      }
    });

    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => isPlaying = false);
      }
    });
  }


  void _showControls() {
    if (mounted) {
      setState(() {
        _showVideoControls = true;
      });
      _hideControlsTimer?.cancel();
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showVideoControls = false;
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
    return duration.inHours > 0 
        ? '$hours:$minutes:$seconds' 
        : '$minutes:$seconds';
  }

  Future<void> _playResultVoice() async {
    try {
      if (_isResultPlaying) {
        await _resultAudioPlayer.pause();
        setState(() => _isResultPlaying = false);
      } else {
        await _resultAudioPlayer.play(DeviceFileSource(voiceEvaluation!));
        setState(() => _isResultPlaying = true);
      }
    } catch (e) {
      print('播放评价语音失败: $e');
    }
  }

  void _initResultAudioPlayer() {
    _resultAudioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _isResultPlaying = false);
      }
    });
  }

  void _showEvaluationResult() {
    _initResultAudioPlayer();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              '测评结果',
              style: TextStyle(
                color: textColor,
                fontSize: ResponsiveSize.sp(26),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: ResponsiveSize.w(400),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 评分显示
                    Text(
                      '得分：$systemScore',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: ResponsiveSize.sp(24),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(24)),
                    
                    // AI点评内容（如果有）
                    if (aiEvaluation.isNotEmpty) ...[
                      Text(
                        'AI点评：',
                        style: TextStyle(
                          color: textColor,
                          fontSize: ResponsiveSize.sp(22),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(8)),
                      Container(
                        padding: EdgeInsets.all(ResponsiveSize.w(12)),
                        decoration: BoxDecoration(
                          color: secondaryYellow,
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                        ),
                        child: Text(
                          aiEvaluation,
                          style: TextStyle(
                            color: textColor.withOpacity(0.8),
                            fontSize: ResponsiveSize.sp(20),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(16)),
                    ],
                    
                    // 普通点评内容（如果有）
                    if (manualEvaluation.isNotEmpty) ...[
                      Text(
                        '普通点评：',
                        style: TextStyle(
                          color: textColor,
                          fontSize: ResponsiveSize.sp(22),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(8)),
                      Container(
                        padding: EdgeInsets.all(ResponsiveSize.w(12)),
                        decoration: BoxDecoration(
                          color: secondaryYellow,
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                        ),
                        child: Text(
                          manualEvaluation,
                          style: TextStyle(
                            color: textColor.withOpacity(0.8),
                            fontSize: ResponsiveSize.sp(20),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(16)),
                    ],
                    
                    // 语音点评（如果有）
                    if (voiceEvaluation != null) ...[
                      Text(
                        '语音点评：',
                        style: TextStyle(
                          color: textColor,
                          fontSize: ResponsiveSize.sp(22),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(8)),
                      Container(
                        padding: EdgeInsets.all(ResponsiveSize.w(12)),
                        decoration: BoxDecoration(
                          color: secondaryYellow,
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.mic, color: primaryColor),
                            SizedBox(width: ResponsiveSize.w(8)),
                            Text(
                              '语音点评',
                              style: TextStyle(
                                color: textColor,
                                fontSize: ResponsiveSize.sp(18),
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                _isResultPlaying ? Icons.pause : Icons.play_arrow,
                                color: primaryColor,
                              ),
                              onPressed: () {
                                _playResultVoice().then((_) {
                                  setDialogState(() {});
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    widget.reviewItem.status = ReviewStatus.reviewed;
                  });
                  widget.onReviewSubmitted?.call();
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.check_circle,
                  color: Colors.green[600],
                  size: ResponsiveSize.w(24),
                ),
                label: Text(
                  '提交点评',
                  style: TextStyle(
                    color: Colors.green[600],
                    fontSize: ResponsiveSize.sp(22),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  _resultAudioPlayer.stop();
                  _isResultPlaying = false;
                  Navigator.pop(context);
                },
                child: Text(
                  '关闭',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: ResponsiveSize.sp(22),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }


  void _shareContent() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '分享功能开发中...',
          style: TextStyle(fontSize: ResponsiveSize.sp(18)),
        ),
        backgroundColor: primaryColor,
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (!_videoController.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
        child: GestureDetector(
          onTap: _showControls,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: VideoPlayer(_videoController),
              ),
              if (_showVideoControls || !_videoController.value.isPlaying)
                AnimatedOpacity(
                  opacity: _showVideoControls ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    color: Colors.black26,
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                          _videoController.value.isPlaying 
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline,
                          size: ResponsiveSize.w(64),
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              _videoController.value.isPlaying
                                  ? _videoController.pause()
                                  : _videoController.play();
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                              if (_showVideoControls)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.all(ResponsiveSize.w(16)),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        VideoProgressIndicator(
                          _videoController,
                          allowScrubbing: true,
                          padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(8)),
                          colors: VideoProgressColors(
                            playedColor: primaryColor,
                            bufferedColor: Colors.white.withOpacity(0.5),
                            backgroundColor: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        SizedBox(height: ResponsiveSize.h(8)),
                        Row(
                          children: [
                            Text(
                              _formatDuration(_videoController.value.position),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ResponsiveSize.sp(14),
                              ),
                            ),
                            SizedBox(width: ResponsiveSize.w(8)),
                            Text(
                              '/ ${_formatDuration(_videoController.value.duration)}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: ResponsiveSize.sp(14),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.replay_10,
                                color: Colors.white,
                                size: ResponsiveSize.w(28),
                              ),
                              onPressed: () {
                                final newPosition = _videoController.value.position - 
                                    const Duration(seconds: 10);
                                _videoController.seekTo(newPosition);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                _videoController.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                                size: ResponsiveSize.w(28),
                              ),
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    _videoController.value.isPlaying
                                        ? _videoController.pause()
                                        : _videoController.play();
                                  });
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.forward_10,
                                color: Colors.white,
                                size: ResponsiveSize.w(28),
                              ),
                              onPressed: () {
                                final newPosition = _videoController.value.position + 
                                    const Duration(seconds: 10);
                                _videoController.seekTo(newPosition);
                              },
                            ),
                          ],
                        ),
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
    Widget _buildAudioPlayer() {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(24)),
      decoration: BoxDecoration(
        color: secondaryYellow,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.audiotrack,
            size: ResponsiveSize.w(48),
            color: primaryColor,
          ),
          SizedBox(height: ResponsiveSize.h(16)),
          Slider(
            value: audioPosition.inSeconds.toDouble(),
            min: 0,
            max: audioDuration.inSeconds.toDouble(),
            activeColor: primaryColor,
            inactiveColor: Colors.white,
            onChanged: (value) {
              _audioPlayer.seek(Duration(seconds: value.toInt()));
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(audioPosition),
                  style: TextStyle(
                    color: textColor.withOpacity(0.8),
                    fontSize: ResponsiveSize.sp(18),
                  ),
                ),
                Text(
                  _formatDuration(audioDuration),
                  style: TextStyle(
                    color: textColor.withOpacity(0.8),
                    fontSize: ResponsiveSize.sp(18),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ResponsiveSize.h(16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.skip_previous,
                  color: primaryColor,
                  size: ResponsiveSize.w(32),
                ),
                onPressed: () {
                  _audioPlayer.seek(Duration.zero);
                },
              ),
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: primaryColor,
                  size: ResponsiveSize.w(48),
                ),
                onPressed: () async {
                  if (isPlaying) {
                    await _audioPlayer.pause();
                  } else {
                    await _audioPlayer.play(AssetSource('test_audio.mp3'));
                  }
                  if (mounted) {
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                  }
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.skip_next,
                  color: primaryColor,
                  size: ResponsiveSize.w(32),
                ),
                onPressed: () {
                  _audioPlayer.seek(audioDuration);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookReader() {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
        border: Border.all(color: primaryYellow),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: secondaryYellow,
               borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
              ),
              child: Center(
                child: Text(
                  '绘本内容预览区域',
                  style: TextStyle(
                    color: textColor,
                    fontSize: ResponsiveSize.sp(22),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: ResponsiveSize.h(16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: primaryColor,
                  size: ResponsiveSize.w(24),
                ),
                onPressed: () {},
              ),
              Text(
                '第 1 页 / 共 10 页',
                style: TextStyle(
                  color: textColor.withOpacity(0.8),
                  fontSize: ResponsiveSize.sp(18),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: primaryColor,
                  size: ResponsiveSize.w(24),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
    Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: primaryColor, size: ResponsiveSize.w(24)),
      label: Text(
        label,
        style: TextStyle(
          color: primaryColor,
          fontSize: ResponsiveSize.sp(22),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryYellow,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(16),
          vertical: ResponsiveSize.h(12),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
        ),
      ),
    );
  }

  Widget _buildContentView() {
    switch (_getContentType()) {
      case ContentType.video:
        return _buildVideoPlayer();
      case ContentType.audio:
        return _buildAudioPlayer();
      case ContentType.book:
        return _buildBookReader();
      default:
        return const Center(child: Text('暂不支持的内容类型'));
    }
  }

  ContentType _getContentType() {
    return ContentType.video;
  }

  void _startRecording() async {
    try {
      if (mounted) {
        setState(() {
          isRecording = true;
          _recordingSeconds = 0;
          recordDuration = '00:00';
        });
      }
      
      // 开始计时
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          _recordingSeconds++;
          setState(() {
            recordDuration = _formatDuration(Duration(seconds: _recordingSeconds));
          });
        }
      });
      
      // TODO: 实现实际录音功能
    } catch (e) {
      print('录音失败: $e');
    }
  }

  void _stopRecording() async {
    try {
      _recordingTimer?.cancel();
      if (mounted) {
        setState(() {
          isRecording = false;
          // TODO: 保存录音文件路径到 recordedAudioPath
        });
      }
    } catch (e) {
      print('停止录音失败: $e');
    }
  }


  Future<void> _handleAIReview() async {
    setState(() {
    });
    
    try {
      // TODO: 调用 AI 点评 API
      // 模拟 API 调用
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        aiEvaluation = "这是AI生成的点评内容..."; // 这里替换为实际的 API 返回内容
        systemScore = "95"; // 更新系统评分
      });
    } catch (e) {
      // 错误处理
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('AI点评生成失败：$e')),
      );
    } finally {
      setState(() {
      });
    }
  }

  Widget _buildReviewContent() {
    switch (selectedReviewType) {
      case ReviewType.ai:
        return AIReviewPanel(
          aiEvaluation: aiEvaluation,
          onEvaluationChanged: (value) {
            setState(() {
              aiEvaluation = value;
            });
          },
          onAIReview: _handleAIReview,
        );
      case ReviewType.manual:
        return ManualReviewPanel(
          manualEvaluation: manualEvaluation,
          onEvaluationChanged: (value) {
            setState(() {
              manualEvaluation = value;
            });
          },
          score: systemScore,
          onScoreChanged: (value) {
            setState(() {
              systemScore = value;
            });
          },
        );
      case ReviewType.voice:
        return VoiceReviewPanel(
          voiceEvaluation: voiceEvaluation,
          onVoiceRecorded: (path) {
            setState(() {
              voiceEvaluation = path;
            });
          },
          onVoiceDeleted: () {
            setState(() {
              voiceEvaluation = null;
            });
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fsbg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 左侧信息面板
            SizedBox(
              width: ResponsiveSize.w(300),
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                color: Colors.white.withOpacity(0.95),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                child: Column(
                  children: [
                    // 返回按钮
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: EdgeInsets.all(ResponsiveSize.w(16)),
                          child: Image.asset(
                            'assets/backbutton1.png',
                            width: ResponsiveSize.w(60),
                            height: ResponsiveSize.h(60),
                          ),
                        ),
                      ),
                    ),
                                        // 学生信息
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(ResponsiveSize.w(16)),
                      margin: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(20)),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: ResponsiveSize.w(40),
                            backgroundColor: Colors.grey[100],
                            child: Icon(
                              Icons.person,
                              size: ResponsiveSize.w(50),
                              color: primaryColor.withOpacity(0.8),
                            ),
                          ),
                          SizedBox(height: ResponsiveSize.h(12)),
                          Text(
                            widget.reviewItem.student,
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(25),
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: ResponsiveSize.h(4)),
                          Text(
                            widget.reviewItem.task,
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(22),
                              color: textColor.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 评分内容区域
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(20)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: ResponsiveSize.h(32)),
                              // 评分类型选择
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // AI点评按钮
                                  InkWell(
                                    onTap: () {
                                      if (mounted) {
                                        setState(() {
                                          selectedReviewType = ReviewType.ai;
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ResponsiveSize.w(20),
                                        vertical: ResponsiveSize.h(10),
                                      ),
                                      decoration: BoxDecoration(
                                        color: selectedReviewType == ReviewType.ai 
                                            ? primaryYellow
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                                        border: Border.all(
                                          color: selectedReviewType == ReviewType.ai 
                                              ? primaryColor
                                              : Colors.grey[300]!,
                                        ),
                                      ),
                                      child: Text(
                                        ReviewType.ai.label,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: ResponsiveSize.sp(22),
                                          fontWeight: FontWeight.w500,
                                          color: selectedReviewType == ReviewType.ai 
                                              ? primaryColor
                                              : textColor.withOpacity(0.6),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveSize.h(12)),
                                  // 普通点评和语音点评按钮
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            if (mounted) {
                                              setState(() {
                                                selectedReviewType = ReviewType.manual;
                                              });
                                            }
                                          },
                                          child: Container(
                                            height: ResponsiveSize.h(44),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: ResponsiveSize.w(12),
                                              vertical: ResponsiveSize.h(8),
                                            ),
                                            decoration: BoxDecoration(
                                              color: selectedReviewType == ReviewType.manual 
                                                  ? primaryYellow
                                                  : Colors.transparent,
                                              borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                                              border: Border.all(
                                                color: selectedReviewType == ReviewType.manual 
                                                    ? primaryColor
                                                    : Colors.grey[300]!,
                                              ),
                                            ),
                                            child: Text(
                                              ReviewType.manual.label,
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: ResponsiveSize.sp(20),
                                                fontWeight: FontWeight.w500,
                                                color: selectedReviewType == ReviewType.manual 
                                                    ? primaryColor
                                                    : textColor.withOpacity(0.6),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: ResponsiveSize.w(12)),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            if (mounted) {
                                              setState(() {
                                                selectedReviewType = ReviewType.voice;
                                              });
                                            }
                                          },
                                          child: Container(
                                            height: ResponsiveSize.h(44),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: ResponsiveSize.w(12),
                                              vertical: ResponsiveSize.h(8),
                                            ),
                                            decoration: BoxDecoration(
                                              color: selectedReviewType == ReviewType.voice 
                                                  ? primaryYellow
                                                  : Colors.transparent,
                                              borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                                              border: Border.all(
                                                color: selectedReviewType == ReviewType.voice 
                                                    ? primaryColor
                                                    : Colors.grey[300]!,
                                              ),
                                            ),
                                            child: Text(
                                              ReviewType.voice.label,
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: ResponsiveSize.sp(20),
                                                fontWeight: FontWeight.w500,
                                                color: selectedReviewType == ReviewType.voice 
                                                    ? primaryColor
                                                    : textColor.withOpacity(0.6),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: ResponsiveSize.h(32)),
                              // 系统评分
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '系统评分',
                                    style: TextStyle(
                                      fontSize: ResponsiveSize.sp(22),
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveSize.h(16)),
                                  Container(
                                    padding: EdgeInsets.all(ResponsiveSize.w(16)),
                                    decoration: BoxDecoration(
                                      color: secondaryYellow,
                                      borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          systemScore,
                                          style: TextStyle(
                                            fontSize: ResponsiveSize.sp(36),
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                        ),
                                        Text(
                                          ' / 100',
                                          style: TextStyle(
                                            fontSize: ResponsiveSize.sp(22),
                                            color: textColor.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: ResponsiveSize.h(32)),
                              _buildReviewContent(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 分割线
            Container(
              width: ResponsiveSize.w(1),
              color: Colors.grey[300],
            ),
            // 右侧内容区域
            Expanded(
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                color: Colors.white.withOpacity(0.95),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(ResponsiveSize.w(24)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _buildActionButton(
                                '测评结果',
                                Icons.assessment,
                                () => _showEvaluationResult(),
                              ),
                              SizedBox(width: ResponsiveSize.w(12)),
                              _buildActionButton(
                                '分享',
                                Icons.share,
                                () => _shareContent(),
                              ),
                            ],
                          ),
                          SizedBox(height: ResponsiveSize.h(16)),
                          Expanded(
                            child: _buildContentView(),
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
    );
  }
}