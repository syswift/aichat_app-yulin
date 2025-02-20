import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'chat_message.dart';
import 'teacher.dart';
import '../../../utils/responsive_size.dart';
import 'media_preview_page.dart';

class TeacherChatPage extends StatefulWidget {
  const TeacherChatPage({super.key});

  @override
  State<TeacherChatPage> createState() => _TeacherChatPageState();
}

class _TeacherChatPageState extends State<TeacherChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final AudioRecorder _audioRecorder;
  final AudioPlayer _audioPlayer = AudioPlayer();
  DateTime? _recordingStartTime;
  
  final List<ChatMessage> _messages = [];
  bool _isRecording = false;
  bool _isLoading = false;
  String? _currentAudioPath;
  final Map<String, bool> _playingStates = {};
  Teacher? _currentTeacher;
  final Map<String, VideoPlayerController> _videoControllers = {};

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _initAudioPlayer();
    _loadInitialData();
  }

  Future<void> _initAudioPlayer() async {
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _playingStates.updateAll((key, value) => false);
      });
    });
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      _currentTeacher = Teacher(
        id: 'teacher1',
        name: '王老师',
        isOnline: true,
      );

      _messages.addAll([
        ChatMessage(
          id: '1',
          senderId: 'teacher1',
          receiverId: 'currentUserId',
          content: '你好！有什么我可以帮你的吗？',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
      ]);

      setState(() {});
    } catch (e) {
      _showError('加载数据失败');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String content, MessageType type, {String? mediaPath, String? thumbnailPath}) async {
    if ((content.isEmpty && mediaPath == null) || _isLoading) return;
    
    try {
      final message = ChatMessage(
        id: DateTime.now().toString(),
        senderId: 'currentUserId',
        receiverId: _currentTeacher?.id ?? '',
        content: content,
        type: type,
        timestamp: DateTime.now(),
        mediaUrl: mediaPath,
        thumbnailUrl: thumbnailPath,
      );

      setState(() => _messages.add(message));
      _messageController.clear();
      _scrollToBottom();
      
    } catch (e) {
      _showError('发送失败');
      setState(() => _messages.removeLast());
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      
      if (image != null) {
        await _sendMessage('图片消息', MessageType.image, mediaPath: image.path);
      }
    } catch (e) {
      _showError('选择图片失败');
    }
  }

  Future<void> _pickVideo() async {
    try {
      debugPrint('开始选择视频...');
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 10),
      );
      
      if (video != null) {
        debugPrint('选择视频成功，路径: ${video.path}');
        
        // 检查视频文件是否存在
        final videoFile = File(video.path);
        if (!await videoFile.exists()) {
          throw Exception('视频文件不存在');
        }

        // 直接发送视频消息，使用默认封面
        await _sendMessage(
          '视频消息',
          MessageType.video,
          mediaPath: video.path,
        );
        debugPrint('视频消息发送成功');
        
      } else {
        debugPrint('用户取消选择视频');
      }
    } catch (e, stackTrace) {
      debugPrint('选择视频失败: $e');
      debugPrint('错误堆栈: $stackTrace');
      _showError('选择视频失败: $e');
    }
  }

  Future<void> _startRecording() async {
    try {
      if (_isRecording) {
        await _stopRecording();
      }

      if (await _audioRecorder.hasPermission()) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        _currentAudioPath = '${appDir.path}/$fileName';
        
        _recordingStartTime = DateTime.now();

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
            numChannels: 1,
          ),
          path: _currentAudioPath!,
        );

        setState(() => _isRecording = true);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.mic, color: Colors.white),
                  SizedBox(width: ResponsiveSize.w(10)),
                  const Text('正在录音...松开发送'),
                ],
              ),
              duration: const Duration(days: 1),
              backgroundColor: const Color(0xFF5A2E17),
            ),
          );
        }
      } else {
        _showError('没有录音权限');
      }
    } catch (e) {
      debugPrint('录音错误: $e');
      _showError('开始录音失败: $e');
      setState(() => _isRecording = false);
      _currentAudioPath = null;
      _recordingStartTime = null;
    }
  }

  Future<void> _stopRecording() async {
    try {
      if (!_isRecording) return;

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      final String? audioPath = _currentAudioPath;
      if (audioPath == null) {
        _showError('录音路径无效');
        return;
      }

      final String? path = await _audioRecorder.stop();
      setState(() => _isRecording = false);

      if (path == null) {
        _showError('录音保存失败');
        return;
      }

      if (_recordingStartTime != null) {
        final duration = DateTime.now().difference(_recordingStartTime!);
        final durationInSeconds = duration.inSeconds;
        
        if (durationInSeconds < 1) {
          _showError('录音时间太短');
          return;
        }

        await _sendMessage(
          '语音消息 $durationInSeconds秒',
          MessageType.audio,
          mediaPath: path,
        );
      }

      _recordingStartTime = null;
      _currentAudioPath = null;

    } catch (e) {
      _showError('停止录音失败: $e');
    } finally {
      setState(() => _isRecording = false);
      _recordingStartTime = null;
      _currentAudioPath = null;
    }
  }

  Future<void> _playAudio(String messageId, String audioPath) async {
    try {
      if (_playingStates.containsValue(true)) {
        await _audioPlayer.stop();
        setState(() {
          _playingStates.updateAll((key, value) => false);
        });
      }

      setState(() {
        _playingStates[messageId] = true;
      });

      await _audioPlayer.play(
        audioPath.startsWith('http')
            ? UrlSource(audioPath)
            : DeviceFileSource(audioPath),
      );

    } catch (e) {
      _showError('播放失败: $e');
      setState(() {
        _playingStates[messageId] = false;
      });
    }
  }

  Future<void> _stopAudio(String messageId) async {
    try {
      await _audioPlayer.stop();
      setState(() {
        _playingStates[messageId] = false;
      });
    } catch (e) {
      _showError('停止播放失败: $e');
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(15)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFFFDFA7),
            width: ResponsiveSize.w(1),
          ),
        ),
      ),
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
          SizedBox(width: ResponsiveSize.w(10)),
          CircleAvatar(
            backgroundColor: const Color(0xFF5A2E17),
            radius: ResponsiveSize.w(20),
            child: Text(
              '王',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveSize.sp(16),
              ),
            ),
          ),
          SizedBox(width: ResponsiveSize.w(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentTeacher?.name ?? '王老师',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(18),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF5A2E17),
                  ),
                ),
                Text(
                  _currentTeacher?.isOnline == true ? '在线' : '离线',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(14),
                    color: _currentTeacher?.isOnline == true
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(ResponsiveSize.w(15)),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return _buildMessageBubble(_messages[index]);
      },
    );
  }

  Widget _buildAudioBubble(ChatMessage message, bool isMe) {
    final isPlaying = _playingStates[message.id] ?? false;
    final durationText = message.content.split(' ').last;

    return GestureDetector(
      onTap: () {
        if (isPlaying) {
          _stopAudio(message.id);
        } else {
          _playAudio(message.id, message.mediaUrl!);
        }
      },
      child: Container(
        padding: EdgeInsets.all(ResponsiveSize.w(12)),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFFFDFA7) : Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
          border: Border.all(
            color: const Color(0xFFFFDFA7),
            width: ResponsiveSize.w(1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPlaying ? Icons.stop : Icons.play_arrow,
              color: const Color(0xFF5A2E17),
              size: ResponsiveSize.w(24),
            ),
            SizedBox(width: ResponsiveSize.w(8)),
            if (isPlaying)
              SizedBox(
                width: ResponsiveSize.w(16),
                height: ResponsiveSize.w(16),
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5A2E17)),
                ),
              ),
            SizedBox(width: ResponsiveSize.w(8)),
            Text(
              durationText,
              style: TextStyle(
                fontSize: ResponsiveSize.sp(14),
                color: const Color(0xFF5A2E17),
              ),
            ),
          ],
        ),
      ),
    );
  }

    Widget _buildMessageBubble(ChatMessage message) {
    final isMe = message.senderId == 'currentUserId';

    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveSize.h(10)),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              backgroundColor: const Color(0xFF5A2E17),
              radius: ResponsiveSize.w(20),
              child: Text(
                '王',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveSize.sp(16),
                ),
              ),
            ),
            SizedBox(width: ResponsiveSize.w(10)),
          ],
          Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (message.type == MessageType.video)
                _buildVideoBubble(message)
              else if (message.type == MessageType.audio)
                _buildAudioBubble(message, isMe)
              else if (message.type == MessageType.image)
                _buildImageBubble(message)
              else
                _buildTextBubble(message, isMe),
              SizedBox(height: ResponsiveSize.h(4)),
              Text(
                DateFormat('HH:mm').format(message.timestamp),
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(12),
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          if (isMe) ...[
            SizedBox(width: ResponsiveSize.w(10)),
            CircleAvatar(
              backgroundColor: const Color(0xFFFFDFA7),
              radius: ResponsiveSize.w(20),
              child: Text(
                '我',
                style: TextStyle(
                  color: const Color(0xFF5A2E17),
                  fontSize: ResponsiveSize.sp(16),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 修改视频气泡构建方法
  Widget _buildVideoBubble(ChatMessage message) {
    // 如果这个消息的视频控制器还没有初始化，就初始化它
    if (!_videoControllers.containsKey(message.id)) {
      final controller = VideoPlayerController.file(File(message.mediaUrl!));
      _videoControllers[message.id] = controller;
      controller.initialize().then((_) {
        // 确保组件还在树中
        if (mounted) {
          setState(() {});
        }
      });
    }

    final controller = _videoControllers[message.id]!;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MediaPreviewPage(
              mediaPath: message.mediaUrl!,
              isVideo: true,
            ),
          ),
        );
      },
      child: Container(
        width: ResponsiveSize.w(200),
        height: ResponsiveSize.h(150),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
          border: Border.all(
            color: const Color(0xFFFFDFA7),
            width: ResponsiveSize.w(1),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 视频预览
            ClipRRect(
              borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
              child: controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
            ),
            // 播放/暂停按钮
            GestureDetector(
              onTap: () {
                setState(() {
                  if (controller.value.isPlaying) {
                    controller.pause();
                  } else {
                    // 暂停其他正在播放的视频
                    for (var otherController in _videoControllers.values) {
                      if (otherController != controller && otherController.value.isPlaying) {
                        otherController.pause();
                      }
                    }
                    controller.play();
                  }
                });
                // 阻止事件冒泡到外层的 GestureDetector
                return;
              },
              child: Container(
                width: ResponsiveSize.w(50),
                height: ResponsiveSize.w(50),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: ResponsiveSize.w(30),
                ),
              ),
            ),
            // 视频进度条
            if (controller.value.isInitialized)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: VideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(
                    playedColor: Color(0xFFFFDFA7),
                    bufferedColor: Colors.white24,
                    backgroundColor: Colors.grey,
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveSize.h(8),
                    horizontal: ResponsiveSize.w(8),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextBubble(ChatMessage message, bool isMe) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(12)),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFFFFDFA7) : Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        border: Border.all(
          color: const Color(0xFFFFDFA7),
          width: ResponsiveSize.w(1),
        ),
      ),
      child: Text(
        message.content,
        style: TextStyle(
          fontSize: ResponsiveSize.sp(16),
          color: const Color(0xFF5A2E17),
        ),
      ),
    );
  }

  Widget _buildImageBubble(ChatMessage message) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MediaPreviewPage(
              mediaPath: message.mediaUrl!,
              isVideo: false,
            ),
          ),
        );
      },
      child: Container(
        constraints: BoxConstraints(
          maxWidth: ResponsiveSize.w(200),
          maxHeight: ResponsiveSize.h(200),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFFFDFA7),
            width: ResponsiveSize.w(1),
          ),
          borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
          child: Image.file(
            File(message.mediaUrl!),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(15)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: const Color(0xFFFFDFA7),
            width: ResponsiveSize.w(1),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            color: const Color(0xFF5A2E17),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => Container(
                  padding: EdgeInsets.all(ResponsiveSize.w(20)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(ResponsiveSize.w(20)),
                      topRight: Radius.circular(ResponsiveSize.w(20)),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.image),
                        title: const Text('图片'),
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.videocam),
                        title: const Text('视频'),
                        onTap: () {
                          Navigator.pop(context);
                          _pickVideo();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.w(15),
                vertical: ResponsiveSize.h(8),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E9),
                borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                border: Border.all(
                  color: const Color(0xFFFFDFA7),
                  width: ResponsiveSize.w(1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: '输入消息...',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: ResponsiveSize.sp(16),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(16),
                        color: const Color(0xFF5A2E17),
                      ),
                      maxLines: null,
                    ),
                  ),
                  GestureDetector(
                    onLongPressStart: (_) => _startRecording(),
                    onLongPressEnd: (_) => _stopRecording(),
                    child: Container(
                      padding: EdgeInsets.all(ResponsiveSize.w(8)),
                      decoration: BoxDecoration(
                        color: _isRecording 
                            ? const Color(0xFFFFDFA7) 
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
                      ),
                      child: Icon(
                        Icons.mic,
                        color: const Color(0xFF5A2E17),
                        size: ResponsiveSize.w(24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: ResponsiveSize.w(10)),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFDFA7),
              borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
            ),
            child: IconButton(
              icon: const Icon(Icons.send),
              color: const Color(0xFF5A2E17),
              onPressed: () {
                if (_messageController.text.trim().isNotEmpty) {
                  _sendMessage(_messageController.text.trim(), MessageType.text);
                }
              },
            ),
          ),
        ],
      ),
    );
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
              _buildHeader(),
              Expanded(
                child: _buildMessageList(),
              ),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // 释放所有视频控制器
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
    _messageController.dispose();
    _scrollController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}