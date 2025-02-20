import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import '../../../../utils/responsive_size.dart';

class VoiceReviewPanel extends StatefulWidget {
  final String? voiceEvaluation;
  final Function(String) onVoiceRecorded;
  final VoidCallback? onVoiceDeleted;

  const VoiceReviewPanel({
    super.key,
    this.voiceEvaluation,
    required this.onVoiceRecorded,
    this.onVoiceDeleted,
  });

  @override
  State<VoiceReviewPanel> createState() => _VoiceReviewPanelState();
}

class _VoiceReviewPanelState extends State<VoiceReviewPanel> {
  final _audioRecorder = AudioRecorder();
  final _audioPlayer = AudioPlayer();
  String? _recordedPath;
  
  bool isRecording = false;
  bool isPlaying = false;
  String recordDuration = '00:00';
  Timer? _recordingTimer;
  int _recordingSeconds = 0;
  
  Duration audioDuration = Duration.zero;
  Duration audioPosition = Duration.zero;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    super.dispose();
  }

  void _initAudioPlayer() {
    _durationSubscription = _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => audioDuration = d);
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() => audioPosition = p);
    });

    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        isPlaying = false;
        audioPosition = Duration.zero;
      });
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        // 获取应用文档目录
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/voice_recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
        _recordedPath = path;  // 保存路径到成员变量
        
        // 开始录音，使用非空的 path
        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: path,  // 使用本地变量而不是可空的成员变量
        );
        
        setState(() {
          isRecording = true;
          _recordingSeconds = 0;
          recordDuration = '00:00';
        });
        
        _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (mounted) {
            _recordingSeconds++;
            setState(() {
              recordDuration = _formatDuration(Duration(seconds: _recordingSeconds));
            });
          }
        });
      }
    } catch (e) {
      print('录音失败: $e');
    }
  }

  Future<void> _stopRecording() async {
    _recordingTimer?.cancel();
    
    try {
      if (isRecording) {
        await _audioRecorder.stop();
        setState(() {
          isRecording = false;
        });
        
        if (_recordedPath != null) {
          widget.onVoiceRecorded(_recordedPath!);
        }
      }
    } catch (e) {
      print('停止录音失败: $e');
    }
  }

  Future<void> _playRecording() async {
    if (widget.voiceEvaluation == null) return;
    
    try {
      if (isPlaying) {
        await _audioPlayer.pause();
        setState(() => isPlaying = false);
      } else {
        // 播放实际录制的音频文件
        await _audioPlayer.play(DeviceFileSource(widget.voiceEvaluation!));
        setState(() => isPlaying = true);
      }
    } catch (e) {
      print('播放录音失败: $e');
    }
  }

  void _deleteRecording() {
    if (widget.voiceEvaluation != null) {
      // 删除录音文件
      File(widget.voiceEvaluation!).delete().then((_) {
        setState(() {
          widget.onVoiceRecorded('');
          if (widget.onVoiceDeleted != null) {
            widget.onVoiceDeleted!();
          }
        });
      }).catchError((e) {
        print('删除录音失败: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '语音点评',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(22),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: ResponsiveSize.h(16)),
        Container(
          padding: EdgeInsets.all(ResponsiveSize.w(16)),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7E6),
            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.voiceEvaluation != null && widget.voiceEvaluation!.isNotEmpty) ...[
                Container(
                  padding: EdgeInsets.all(ResponsiveSize.w(12)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.mic, color: Colors.orange[700]),
                          SizedBox(width: ResponsiveSize.w(8)),
                          Expanded(
                            child: Text(
                              '已录制语音点评',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: ResponsiveSize.sp(18),
                              ),
                            ),
                          ),
                          Text(
                            _formatDuration(audioDuration),
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: ResponsiveSize.sp(14),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveSize.h(8)),
                      // 进度条
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: ResponsiveSize.h(4),
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: ResponsiveSize.w(6),
                          ),
                        ),
                        child: Slider(
                          value: audioPosition.inSeconds.toDouble(),
                          max: audioDuration.inSeconds.toDouble(),
                          activeColor: Colors.orange[700],
                          inactiveColor: Colors.grey[300],
                          onChanged: (value) {
                            _audioPlayer.seek(Duration(seconds: value.toInt()));
                          },
                        ),
                      ),
                      // 控制按钮
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.orange[700],
                            ),
                            onPressed: _playRecording,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.orange[700],
                            ),
                            onPressed: _deleteRecording,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else ...[
                GestureDetector(
                  onTapDown: (_) => _startRecording(),
                  onTapUp: (_) => _stopRecording(),
                  onTapCancel: () => _stopRecording(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveSize.h(16),
                      horizontal: ResponsiveSize.w(20),
                    ),
                    decoration: BoxDecoration(
                      color: isRecording ? Colors.orange[700]?.withOpacity(0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                      border: Border.all(
                        color: isRecording ? Colors.orange[700]! : Colors.grey[300]!,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isRecording ? Icons.stop : Icons.mic,
                          color: Colors.orange[700],
                          size: ResponsiveSize.w(24),
                        ),
                        SizedBox(width: ResponsiveSize.w(8)),
                        Text(
                          isRecording ? recordDuration : '按住开始录音',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: ResponsiveSize.sp(18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(8)),
                Text(
                  '提示：按住按钮开始录音，松开结束录音',
                  style: TextStyle(
                    color: Colors.black87.withOpacity(0.6),
                    fontSize: ResponsiveSize.sp(14),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
} 