import 'package:flutter/material.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';
import '../../../utils/responsive_size.dart';
import 'alarm_dialog.dart';
import 'audio_item.dart';

class HappyListenPage extends StatefulWidget {
  const HappyListenPage({super.key});

  @override
  State<HappyListenPage> createState() => _HappyListenPageState();
}

class _HappyListenPageState extends State<HappyListenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AudioPlayer _audioPlayer;
  late List<StreamSubscription> _subscriptions;
  bool isPlaying = false;
  bool isLooping = false;
  String? currentCover;
  Duration currentDuration = Duration.zero;
  Duration totalDuration = const Duration(minutes: 3);
  Timer? timer;
  Timer? shutdownTimer;
  Timer? countdownTimer;
  Duration? timerDuration;
  Timer? alarmTimer;
  DateTime? alarmTime;
  String? alarmAudioPath;

  // 音频列表
  final List<AudioItem> audioList = [
    AudioItem(path: 'assets/test_audio.mp3', title: '测试音频1'),
    AudioItem(path: 'assets/test_audio2.mp3', title: '测试音频2'),
    AudioItem(path: 'assets/test_audio3.mp3', title: '测试音频3'),
  ];
  int currentAudioIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _subscriptions = [];
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    _audioPlayer = AudioPlayer();
    await _loadCurrentAudio();
  }

  Future<void> _loadCurrentAudio() async {
    if (!mounted) return;
    if (audioList.isEmpty) return;

    await _audioPlayer.setAsset(audioList[currentAudioIndex].path);

    _subscriptions.add(
      _audioPlayer.durationStream.listen((duration) {
        if (mounted) {
          setState(() {
            totalDuration = duration ?? const Duration(minutes: 3);
          });
        }
      }),
    );

    _subscriptions.add(
      _audioPlayer.positionStream.listen((position) {
        if (mounted) {
          setState(() {
            currentDuration = position;
          });
        }
      }),
    );

    _subscriptions.add(
      _audioPlayer.playerStateStream.listen((state) {
        if (!mounted) return;
        if (state.processingState == ProcessingState.completed) {
          if (isLooping) {
            _audioPlayer.seek(Duration.zero);
            _audioPlayer.play();
          } else if (audioList.length > 1 &&
              currentAudioIndex < audioList.length - 1) {
            // 只有在不是最后一首歌时才自动播放下一首
            _playNext();
          } else {
            // 最后一首歌或只有一首歌时，停止播放并重置状态
            setState(() {
              isPlaying = false;
              _controller.stop();
              currentDuration = Duration.zero;
              _audioPlayer.seek(Duration.zero);
              _audioPlayer.stop();
            });
          }
        }
      }),
    );
  }

  void _playNext() {
    if (!mounted) return;
    if (currentAudioIndex < audioList.length - 1) {
      setState(() {
        currentAudioIndex++;
        _loadCurrentAudio();
        if (isPlaying) {
          _audioPlayer.play();
        }
      });
    }
  }

  void _playPrevious() {
    if (!mounted) return;
    if (currentAudioIndex > 0) {
      setState(() {
        currentAudioIndex--;
        _loadCurrentAudio();
        if (isPlaying) {
          _audioPlayer.play();
        }
      });
    }
  }

  void _togglePlay() async {
    if (!mounted) return;
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _controller.repeat();
        _audioPlayer.play();
      } else {
        _controller.stop();
        _audioPlayer.pause();
      }
    });
  }

  void _toggleLoop() {
    if (!mounted) return;
    setState(() {
      isLooping = !isLooping;
      _audioPlayer.setLoopMode(isLooping ? LoopMode.one : LoopMode.off);
    });
    // 不再重置播放位置，继续播放
  }

  void _deleteCurrentAudio() {
    if (!mounted) return;
    setState(() {
      audioList.removeAt(currentAudioIndex);
      if (audioList.isEmpty) {
        // 如果删除后列表为空，重置播放器状态
        isPlaying = false;
        _controller.stop();
        _audioPlayer.stop();
        currentDuration = Duration.zero;
        totalDuration = const Duration(minutes: 3);
      } else {
        // 如果删除的是最后一个音频，将索引调整到新的最后一个
        if (currentAudioIndex >= audioList.length) {
          currentAudioIndex = audioList.length - 1;
        }
        _loadCurrentAudio();
      }
    });
  }

  String _formatTimerDuration() {
    if (timerDuration == null) return '定时';
    final hours = timerDuration!.inHours;
    final minutes = timerDuration!.inMinutes.remainder(60);
    final seconds = timerDuration!.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _showTimerDialog() {
    if (!mounted) return;
    int hours = 0;
    int minutes = 0;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              '设置定时',
              style: TextStyle(
                color: const Color(0xFFE6B788),
                fontSize: ResponsiveSize.sp(35),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: StatefulBuilder(
              builder:
                  (context, setState) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 小时选择
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_drop_up,
                                  color: const Color(0xFFE6B788),
                                  size: ResponsiveSize.w(40),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (hours < 12) hours++;
                                  });
                                },
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveSize.w(30),
                                  vertical: ResponsiveSize.h(15),
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFFE6B788),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveSize.w(12),
                                  ),
                                ),
                                child: Text(
                                  hours.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    fontSize: ResponsiveSize.sp(35),
                                    color: const Color(0xFFE6B788),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: const Color(0xFFE6B788),
                                  size: ResponsiveSize.w(40),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (hours > 0) hours--;
                                  });
                                },
                              ),
                              Text(
                                '小时',
                                style: TextStyle(
                                  color: const Color(0xFFE6B788),
                                  fontSize: ResponsiveSize.sp(24),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: ResponsiveSize.w(40)),
                          // 分钟选择
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_drop_up,
                                  color: const Color(0xFFE6B788),
                                  size: ResponsiveSize.w(40),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (minutes < 59) minutes++;
                                  });
                                },
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveSize.w(30),
                                  vertical: ResponsiveSize.h(15),
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFFE6B788),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveSize.w(12),
                                  ),
                                ),
                                child: Text(
                                  minutes.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    fontSize: ResponsiveSize.sp(35),
                                    color: const Color(0xFFE6B788),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: const Color(0xFFE6B788),
                                  size: ResponsiveSize.w(40),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (minutes > 0) minutes--;
                                  });
                                },
                              ),
                              Text(
                                '分钟',
                                style: TextStyle(
                                  color: const Color(0xFFE6B788),
                                  fontSize: ResponsiveSize.sp(24),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveSize.h(30)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              shutdownTimer?.cancel();
                              countdownTimer?.cancel();
                              timerDuration = null;
                              Navigator.pop(context);
                            },
                            child: Text(
                              '取消',
                              style: TextStyle(
                                color: const Color(0xFFE6B788),
                                fontSize: ResponsiveSize.sp(24),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, hours * 60 + minutes);
                            },
                            child: Text(
                              '确定',
                              style: TextStyle(
                                color: const Color(0xFFE6B788),
                                fontSize: ResponsiveSize.sp(24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            ),
          ),
    ).then((value) {
      if (value != null && mounted) {
        shutdownTimer?.cancel();
        countdownTimer?.cancel();

        final totalMinutes = value;
        timerDuration = Duration(minutes: totalMinutes);

        shutdownTimer = Timer(Duration(minutes: totalMinutes), () {
          if (!mounted) return;
          setState(() {
            isPlaying = false;
            _controller.stop();
            _audioPlayer.pause();
            timerDuration = null;
          });
        });

        // 启动倒计时
        countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (!mounted) return;
          setState(() {
            if (timerDuration != null && timerDuration!.inSeconds > 0) {
              timerDuration = Duration(seconds: timerDuration!.inSeconds - 1);
            } else {
              countdownTimer?.cancel();
              timerDuration = null;
            }
          });
        });
      }
    });
  }

  void _showAddContentDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              '添加内容',
              style: TextStyle(
                color: const Color(0xFFE6B788),
                fontSize: ResponsiveSize.sp(35),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              '该功能正在开发中...',
              style: TextStyle(
                color: const Color(0xFFE6B788),
                fontSize: ResponsiveSize.sp(24),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  '确定',
                  style: TextStyle(
                    color: const Color(0xFFE6B788),
                    fontSize: ResponsiveSize.sp(24),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _showAlarmDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlarmDialog(audioList: audioList),
    ).then((result) {
      if (result != null) {
        _setAlarm(result['time'], result['audioPath']);
      }
    });
  }

  void _setAlarm(DateTime time, String? audioPath) {
    // 取消之前的闹钟
    alarmTimer?.cancel();

    if (audioPath == null) return;

    alarmTime = time;
    alarmAudioPath = audioPath;

    // 计算延迟时间
    final now = DateTime.now();
    final delay = time.difference(now);

    // 设置新闹钟
    alarmTimer = Timer(delay, () async {
      if (!mounted) return;

      // 保存当前播放状态
      final wasPlaying = isPlaying;
      final currentAudioPath = audioList[currentAudioIndex].path;
      final currentPosition = _audioPlayer.position;

      // 播放闹钟音频
      await _audioPlayer.setAsset(alarmAudioPath!);
      await _audioPlayer.play();

      // 显示闹钟提醒对话框
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              title: Text(
                '闹钟',
                style: TextStyle(
                  color: const Color(0xFFE6B788),
                  fontSize: ResponsiveSize.sp(35),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                '时间到了！',
                style: TextStyle(
                  color: const Color(0xFFE6B788),
                  fontSize: ResponsiveSize.sp(24),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    // 停止闹钟音频
                    await _audioPlayer.stop();

                    // 恢复之前的播放状态
                    await _audioPlayer.setAsset(currentAudioPath);
                    await _audioPlayer.seek(currentPosition);
                    if (wasPlaying) {
                      await _audioPlayer.play();
                    }

                    Navigator.pop(context);
                  },
                  child: Text(
                    '关闭',
                    style: TextStyle(
                      color: const Color(0xFFE6B788),
                      fontSize: ResponsiveSize.sp(24),
                    ),
                  ),
                ),
              ],
            ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    timer?.cancel();
    shutdownTimer?.cancel();
    countdownTimer?.cancel();
    alarmTimer?.cancel();
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    return Scaffold(
      body: Stack(
        children: [
          // 背景图片
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/happylistenbg1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 左侧内容区
          Positioned(
            top: ResponsiveSize.h(180),
            left: ResponsiveSize.w(100),
            bottom: ResponsiveSize.h(100),
            child: Container(
              width: ResponsiveSize.w(500),
              height: ResponsiveSize.h(700),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(ResponsiveSize.w(30)),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 214, 214, 213),
                    offset: Offset(ResponsiveSize.w(4), ResponsiveSize.h(4)),
                    blurRadius: ResponsiveSize.w(2),
                    spreadRadius: ResponsiveSize.w(4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(ResponsiveSize.w(20)),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 247, 237),
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 旋转的磁带图标
                    RotationTransition(
                      turns: _controller,
                      child: Container(
                        width: ResponsiveSize.w(200),
                        height: ResponsiveSize.w(200),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFE6B788),
                          image:
                              currentCover != null
                                  ? DecorationImage(
                                    image: AssetImage(currentCover!),
                                    fit: BoxFit.cover,
                                  )
                                  : null,
                        ),
                        child:
                            currentCover == null
                                ? Icon(
                                  Icons.music_note,
                                  size: ResponsiveSize.w(100),
                                  color: Colors.white,
                                )
                                : null,
                      ),
                    ),
                    // 播放控制按钮
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.skip_previous),
                          onPressed:
                              currentAudioIndex > 0 ? _playPrevious : null,
                          iconSize: ResponsiveSize.w(40),
                          color:
                              currentAudioIndex > 0
                                  ? const Color(0xFFE6B788)
                                  : const Color(0xFFE6B788).withOpacity(0.3),
                        ),
                        SizedBox(width: ResponsiveSize.w(20)),
                        IconButton(
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                          ),
                          onPressed: audioList.isNotEmpty ? _togglePlay : null,
                          iconSize: ResponsiveSize.w(60),
                          color:
                              audioList.isNotEmpty
                                  ? const Color(0xFFE6B788)
                                  : const Color(0xFFE6B788).withOpacity(0.3),
                        ),
                        SizedBox(width: ResponsiveSize.w(20)),
                        IconButton(
                          icon: const Icon(Icons.skip_next),
                          onPressed:
                              currentAudioIndex < audioList.length - 1
                                  ? _playNext
                                  : null,
                          iconSize: ResponsiveSize.w(40),
                          color:
                              currentAudioIndex < audioList.length - 1
                                  ? const Color(0xFFE6B788)
                                  : const Color(0xFFE6B788).withOpacity(0.3),
                        ),
                        SizedBox(width: ResponsiveSize.w(20)),
                        IconButton(
                          icon: Icon(
                            isLooping ? Icons.repeat_one : Icons.repeat,
                          ),
                          onPressed: audioList.isNotEmpty ? _toggleLoop : null,
                          iconSize: ResponsiveSize.w(40),
                          color:
                              audioList.isNotEmpty
                                  ? const Color(0xFFE6B788)
                                  : const Color(0xFFE6B788).withOpacity(0.3),
                        ),
                      ],
                    ),
                    // 进度条
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.w(30),
                      ),
                      child: Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: const Color(0xFFE6B788),
                              inactiveTrackColor: const Color(
                                0xFFE6B788,
                              ).withOpacity(0.3),
                              thumbColor: const Color(0xFFE6B788),
                              overlayColor: const Color(
                                0xFFE6B788,
                              ).withOpacity(0.3),
                            ),
                            child: Slider(
                              value: currentDuration.inSeconds.toDouble(),
                              max: totalDuration.inSeconds.toDouble(),
                              onChanged:
                                  audioList.isNotEmpty
                                      ? (value) async {
                                        if (!mounted) return;
                                        final newPosition = Duration(
                                          seconds: value.toInt(),
                                        );
                                        setState(() {
                                          currentDuration = newPosition;
                                        });
                                        await _audioPlayer.seek(newPosition);
                                      }
                                      : null,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveSize.w(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(currentDuration),
                                  style: TextStyle(
                                    color: const Color(0xFFE6B788),
                                    fontSize: ResponsiveSize.sp(18),
                                  ),
                                ),
                                Text(
                                  _formatDuration(totalDuration),
                                  style: TextStyle(
                                    color: const Color(0xFFE6B788),
                                    fontSize: ResponsiveSize.sp(18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 功能按钮
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFunctionButton(
                          Icons.timer,
                          '定时',
                          audioList.isNotEmpty ? _showTimerDialog : null,
                        ),
                        _buildFunctionButton(
                          Icons.alarm, // 添加闹钟图标
                          '闹钟',
                          _showAlarmDialog, // 添加闹钟对话框
                        ),
                        _buildFunctionButton(
                          Icons.add_circle_outline,
                          '添加',
                          _showAddContentDialog,
                        ),
                        _buildFunctionButton(
                          Icons.delete_outline,
                          '删除',
                          _deleteCurrentAudio,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 返回按钮
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: ResponsiveSize.w(50),
                top: ResponsiveSize.h(20),
              ),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Image.asset(
                  'assets/backbutton1.png',
                  width: ResponsiveSize.w(100),
                  height: ResponsiveSize.w(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunctionButton(
    IconData icon,
    String label,
    VoidCallback? onPressed,
  ) {
    final buttonLabel = label == '定时' ? _formatTimerDuration() : label;
    final isEnabled = onPressed != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
          iconSize: ResponsiveSize.w(35),
          color:
              isEnabled
                  ? const Color(0xFFE6B788)
                  : const Color(0xFFE6B788).withOpacity(0.3),
        ),
        Text(
          buttonLabel,
          style: TextStyle(
            color:
                isEnabled
                    ? const Color(0xFFE6B788)
                    : const Color(0xFFE6B788).withOpacity(0.3),
            fontSize: ResponsiveSize.sp(18),
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
