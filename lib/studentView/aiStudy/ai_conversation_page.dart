import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import '../../utils/responsive_size.dart';
import '../../services/livekit_room_service.dart';
import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'dart:convert';

class AIConversationPage extends StatefulWidget {
  final String serverUrl;
  final String token;

  const AIConversationPage({
    super.key,
    required this.serverUrl,
    required this.token,
  });

  @override
  State<AIConversationPage> createState() => _AIConversationPageState();
}

class _AIConversationPageState extends State<AIConversationPage>
    with SingleTickerProviderStateMixin {
  final LiveKitRoomService _roomService = LiveKitRoomService();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  bool _isConnecting = true;
  bool _isListening = false;
  bool _isProcessing = false;
  bool _isAISpeaking = false;
  String? _connectionError;
  String _currentAISpeechText = ''; // New variable to track current AI speech
  Timer? _volumeTimer;
  double _micVolume = 0.0;
  List<double> _waveform = List.filled(20, 0.0);
  EventsListener<RoomEvent>? _roomListener;
  EventsListener<ParticipantEvent>? _trackListener;

  // For animation
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  final List<Color> _gradientColors = [
    const Color(0xFFFDAA58),
    const Color(0xFFFF8A5B),
    const Color(0xFFFFC15C),
  ];

  @override
  void initState() {
    super.initState();
    _connectToRoom();

    // Initialize animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _roomService.disconnect();
    _scrollController.dispose();
    _animationController.dispose();
    _volumeTimer?.cancel();
    _roomListener?.dispose();
    _trackListener?.dispose();
    super.dispose();
  }

  Future<void> _connectToRoom() async {
    setState(() => _isConnecting = true);

    try {
      final success = await _roomService.connectToRoom(
        widget.serverUrl,
        widget.token,
      );

      setState(() {
        _isConnecting = false;
        if (!success) {
          _connectionError = _roomService.connectionError;
        } else {
          // Setup LiveKit audio channel
          _setupLiveKitAudio();
        }
      });
    } catch (e) {
      setState(() {
        _isConnecting = false;
        _connectionError = e.toString();
      });
    }
  }

  void _setupLiveKitAudio() {
    try {
      // Make sure microphone is initially disabled
      _roomService.room.localParticipant?.setMicrophoneEnabled(false);

      // Create a listener for the room
      _roomListener = _roomService.room.createListener();

      // Listen for data messages from LiveKit
      _roomListener?.on<DataReceivedEvent>((event) {
        // Process all data messages - you can add filtering logic if needed
        final message = utf8.decode(event.data);
        _processAgentMessage(message);
      });

      // Listen for tracks (to know when agent audio is playing)
      for (final participant in _roomService.room.remoteParticipants.values) {
        _setupParticipantListeners(participant);
      }

      _roomListener?.on<ParticipantConnectedEvent>((event) {
        _setupParticipantListeners(event.participant);
      });

      // Send a greeting message to trigger the agent
      _sendMessageToAgent("start_conversation");
    } catch (e) {
      print('Error setting up LiveKit audio: $e');
      setState(() {
        _connectionError = 'Error setting up audio: $e';
      });
    }
  }

  void _setupParticipantListeners(RemoteParticipant participant) {
    // Monitor the participant's tracks
    final listener = participant.createListener();

    listener.on<TrackSubscribedEvent>((event) {
      if (event.track is AudioTrack) {
        // Agent audio track was added
        setState(() {
          _isAISpeaking = true;
        });

        // Setup track-specific listener
        final trackListener = event.publication.participant.createListener();
        trackListener.on<TrackUnmutedEvent>((unmutedEvent) {
          setState(() {
            _isAISpeaking = true;
          });
        });

        trackListener.on<TrackMutedEvent>((mutedEvent) {
          setState(() {
            _isAISpeaking = false;
          });
        });

        _trackListener = trackListener;
      }
    });

    listener.on<TrackUnsubscribedEvent>((event) {
      if (event.track is AudioTrack) {
        // Agent finished speaking
        setState(() {
          _isAISpeaking = false;

          // Update message playing status
          for (int i = 0; i < _messages.length; i++) {
            if (!_messages[i].isUser && _messages[i].isPlaying) {
              _messages[i] = ChatMessage(
                text: _messages[i].text,
                isUser: false,
                time: _messages[i].time,
                isPlaying: false,
              );
            }
          }
        });
      }
    });
  }

  void _processAgentMessage(String message) {
    try {
      // Try to parse it as JSON first
      final Map<String, dynamic> data = jsonDecode(message);

      // Check what type of message this is
      if (data.containsKey('type')) {
        switch (data['type']) {
          case 'transcript':
            // This is a transcript of what the user said
            if (data.containsKey('text') &&
                data['text'].toString().isNotEmpty) {
              _addMessage(data['text'], isUser: true);
            }
            break;

          case 'agent_response':
            // This is a response from the agent
            if (data.containsKey('text') &&
                data['text'].toString().isNotEmpty) {
              _addMessage(data['text'], isUser: false, isPlaying: true);
              setState(() {
                _isProcessing = false;
                _currentAISpeechText =
                    data['text']; // Update the current speech text
              });
            }
            break;

          case 'speech_progress':
            // New case to handle speech progress updates
            if (data.containsKey('text')) {
              setState(() {
                _currentAISpeechText = data['text'];
              });
            }
            break;

          case 'processing_status':
            // This indicates the agent is processing
            setState(() {
              _isProcessing = data['processing'] ?? false;
            });
            break;

          case 'error':
            // Handle errors
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error: ${data['message'] ?? "Unknown error"}',
                  style: TextStyle(fontSize: ResponsiveSize.sp(30)),
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
            break;
        }
      } else if (data.containsKey('text')) {
        // Simple text message format
        _addMessage(data['text'], isUser: false, isPlaying: true);
        setState(() {
          _isProcessing = false;
          _currentAISpeechText = data['text']; // Update the current speech text
        });
      }
    } catch (e) {
      // Not JSON, treat as plain text from agent
      if (message.isNotEmpty) {
        _addMessage(message, isUser: false, isPlaying: true);
        setState(() {
          _isProcessing = false;
          _currentAISpeechText = message; // Update the current speech text
        });
      }
    }
  }

  void _toggleListening() {
    if (_isAISpeaking) {
      // Stop AI from speaking if user wants to talk
      _stopAISpeaking();
      return;
    }

    setState(() {
      _isListening = !_isListening;
    });

    HapticFeedback.mediumImpact();

    if (_isListening) {
      _startListening();
    } else {
      _stopListeningAndProcess();
    }
  }

  void _startListening() {
    // Enable microphone via LiveKit
    _roomService.room.localParticipant?.setMicrophoneEnabled(true);

    // Send message to agent that user is speaking
    _sendMessageToAgent("user_speaking_start");

    // Start monitoring microphone volume levels
    _startVolumeMonitoring();

    // Visual confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '我在听，请说话...',
          style: TextStyle(fontSize: ResponsiveSize.sp(30)),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _startVolumeMonitoring() {
    // Start monitoring volume for visualization
    _volumeTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_roomService.room.localParticipant?.hasAudio == true) {
        // In a real implementation, you would get actual microphone levels
        // For now we'll still simulate for the visualization
        setState(() {
          _micVolume = math.Random().nextDouble() * 0.8 + 0.2;

          // Update waveform
          for (int i = 0; i < _waveform.length - 1; i++) {
            _waveform[i] = _waveform[i + 1];
          }
          _waveform[_waveform.length - 1] = _micVolume;
        });
      }
    });
  }

  void _stopListeningAndProcess() {
    // Tell agent user stopped speaking
    _sendMessageToAgent("user_speaking_end");

    // Disable microphone
    _roomService.room.localParticipant?.setMicrophoneEnabled(false);

    // Stop monitoring volume
    _volumeTimer?.cancel();

    // Reset waveform and show processing state
    setState(() {
      _isProcessing = true;
      _waveform = List.filled(20, 0.0);
    });
  }

  void _sendMessageToAgent(
    String messageType, [
    Map<String, dynamic>? additionalData,
  ]) {
    try {
      // Create the message to send
      final Map<String, dynamic> message = {
        'type': messageType,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      // Add any additional data
      if (additionalData != null) {
        message.addAll(additionalData);
      }

      // Convert to JSON and send
      final String jsonMessage = jsonEncode(message);
      final data = utf8.encode(jsonMessage);

      _roomService.room.localParticipant?.publishData(data, reliable: true);
    } catch (e) {
      print('Error sending message to agent: $e');
    }
  }

  void _stopAISpeaking() {
    // Send message to agent to stop speaking
    _sendMessageToAgent("stop_speaking");

    setState(() {
      _isAISpeaking = false;
      _currentAISpeechText = ''; // Clear the current speech text

      // Reset all playing states
      for (int i = 0; i < _messages.length; i++) {
        if (_messages[i].isPlaying) {
          _messages[i] = ChatMessage(
            text: _messages[i].text,
            isUser: _messages[i].isUser,
            time: _messages[i].time,
            isPlaying: false,
          );
        }
      }
    });

    // Visual confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'AI语音已停止',
          style: TextStyle(fontSize: ResponsiveSize.sp(30)),
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _playAIMessageWithTTS(String text) {
    // Set the AI as speaking
    setState(() {
      _isAISpeaking = true;
      _currentAISpeechText = text; // Set the current speech text
    });

    // Send message to agent to play this specific text
    _sendMessageToAgent("play_tts", {"text": text});

    // Visual confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '正在播放语音...',
          style: TextStyle(fontSize: ResponsiveSize.sp(30)),
        ),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addMessage(
    String text, {
    required bool isUser,
    bool isPlaying = false,
  }) {
    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: isUser,
          time: DateTime.now(),
          isPlaying: isPlaying,
        ),
      );

      // Scroll to bottom after message is added
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AI 语音助手",
          style: TextStyle(
            fontSize: ResponsiveSize.sp(45),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFDAA58),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _roomService.disconnect();
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body:
          _isConnecting
              ? _buildLoadingView()
              : _connectionError != null
              ? _buildErrorView()
              : _buildChatView(),
    );
  }

  Widget _buildLoadingView() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade50, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: const Color(0xFFFDAA58),
              strokeWidth: ResponsiveSize.w(8),
            ),
            SizedBox(height: ResponsiveSize.h(25)),
            Text(
              "正在连接...",
              style: TextStyle(
                fontSize: ResponsiveSize.sp(38),
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade50, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveSize.w(40)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: ResponsiveSize.w(100),
                color: Colors.red[400],
              ),
              SizedBox(height: ResponsiveSize.h(25)),
              Text(
                "连接失败",
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(45),
                  fontWeight: FontWeight.bold,
                  color: Colors.red[400],
                ),
              ),
              SizedBox(height: ResponsiveSize.h(15)),
              Text(
                _connectionError ?? "未知错误",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(35),
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: ResponsiveSize.h(50)),
              ElevatedButton(
                onPressed: _connectToRoom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFDAA58),
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.w(50),
                    vertical: ResponsiveSize.h(20),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(30)),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "重试",
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(38),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatView() {
    return Stack(
      children: [
        // Background gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade50, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // Content
        SafeArea(
          child: Column(
            children: [
              // Chat status bar
              _buildStatusBar(),

              // Chat messages
              Expanded(
                child:
                    _messages.isEmpty && !_isProcessing
                        ? _buildEmptyChatView()
                        : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveSize.w(25),
                            vertical: ResponsiveSize.h(15),
                          ),
                          itemCount: _messages.length + (_isProcessing ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _messages.length && _isProcessing) {
                              return _buildProcessingIndicator();
                            }
                            return _buildMessageBubble(_messages[index]);
                          },
                        ),
              ),

              // Audio waveform visualization
              if (_isListening) _buildAudioWaveform(),

              // Bottom padding for floating action button
              SizedBox(height: ResponsiveSize.h(100)),
            ],
          ),
        ),

        // Floating voice button
        Positioned(
          bottom: ResponsiveSize.h(30),
          left: 0,
          right: 0,
          child: Center(child: _buildVoiceButton()),
        ),
      ],
    );
  }

  Widget _buildStatusBar() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.w(20),
            vertical: ResponsiveSize.h(10),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveSize.w(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          margin: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.w(20),
            vertical: ResponsiveSize.h(10),
          ),
          child: Row(
            children: [
              Icon(
                _isAISpeaking
                    ? Icons.volume_up
                    : _isListening
                    ? Icons.mic
                    : Icons.smart_toy,
                color:
                    _isAISpeaking
                        ? Colors.blue
                        : _isListening
                        ? Colors.green
                        : const Color(0xFFFDAA58),
                size: ResponsiveSize.w(30),
              ),
              SizedBox(width: ResponsiveSize.w(10)),
              Text(
                _isAISpeaking
                    ? "AI正在说话..."
                    : _isListening
                    ? "正在聆听..."
                    : _isProcessing
                    ? "正在思考..."
                    : "准备好了，点击麦克风开始",
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(30),
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
              const Spacer(),
              if (_isAISpeaking)
                GestureDetector(
                  onTap: _stopAISpeaking,
                  child: Container(
                    padding: EdgeInsets.all(ResponsiveSize.w(8)),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
                    ),
                    child: Icon(
                      Icons.stop,
                      color: Colors.red,
                      size: ResponsiveSize.w(20),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Add the AI speech display widget when AI is speaking
        if (_isAISpeaking && _currentAISpeechText.isNotEmpty)
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.w(20),
              vertical: ResponsiveSize.h(5),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.w(20),
              vertical: ResponsiveSize.h(10),
            ),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
              border: Border.all(color: Colors.blue.withOpacity(0.2)),
            ),
            child: Text(
              _currentAISpeechText,
              style: TextStyle(
                fontSize: ResponsiveSize.sp(32),
                color: Colors.blue[800],
                height: 1.3,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyChatView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: ResponsiveSize.w(150),
            height: ResponsiveSize.w(150),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mic_none_rounded,
              size: ResponsiveSize.w(80),
              color: const Color(0xFFFDAA58),
            ),
          ),
          SizedBox(height: ResponsiveSize.h(30)),
          Text(
            "点击麦克风按钮开始语音对话",
            style: TextStyle(
              fontSize: ResponsiveSize.sp(38),
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: ResponsiveSize.h(20)),
          Text(
            "我可以帮您解答问题、提供学习资源\n或者进行知识探索",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveSize.sp(32),
              color: Colors.grey[500],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingIndicator() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: ResponsiveSize.h(20)),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(20),
          vertical: ResponsiveSize.h(15),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: ResponsiveSize.w(25),
              height: ResponsiveSize.w(25),
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color(0xFFFDAA58),
                ),
              ),
            ),
            SizedBox(width: ResponsiveSize.w(15)),
            Text(
              "AI正在思考...",
              style: TextStyle(
                fontSize: ResponsiveSize.sp(32),
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioWaveform() {
    return Container(
      height: ResponsiveSize.h(60),
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(30),
        vertical: ResponsiveSize.h(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(20, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            width: ResponsiveSize.w(8),
            height: _waveform[index] * ResponsiveSize.h(60),
            decoration: BoxDecoration(
              color: Color.lerp(
                Colors.orange.shade300,
                const Color(0xFFFDAA58),
                _waveform[index],
              ),
              borderRadius: BorderRadius.circular(ResponsiveSize.w(3)),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    final isPlaying = message.isPlaying;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: ResponsiveSize.w(600),
          minWidth: ResponsiveSize.w(100),
        ),
        margin: EdgeInsets.only(
          top: ResponsiveSize.h(15),
          bottom: ResponsiveSize.h(15),
          left: isUser ? ResponsiveSize.w(80) : 0,
          right: isUser ? 0 : ResponsiveSize.w(80),
        ),
        padding: EdgeInsets.all(ResponsiveSize.w(20)),
        decoration: BoxDecoration(
          color:
              isUser ? const Color(0xFFFDAA58).withOpacity(0.9) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isUser ? ResponsiveSize.w(20) : 0),
            topRight: Radius.circular(isUser ? 0 : ResponsiveSize.w(20)),
            bottomLeft: Radius.circular(ResponsiveSize.w(20)),
            bottomRight: Radius.circular(ResponsiveSize.w(20)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border:
              !isUser && !isPlaying
                  ? Border.all(color: Colors.grey.withOpacity(0.2))
                  : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Speaker identification
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isUser ? Icons.person : Icons.smart_toy,
                  size: ResponsiveSize.w(24),
                  color:
                      isUser
                          ? Colors.white.withOpacity(0.7)
                          : const Color(0xFFFDAA58),
                ),
                SizedBox(width: ResponsiveSize.w(10)),
                Text(
                  isUser ? "我" : "AI助手",
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(28),
                    fontWeight: FontWeight.bold,
                    color: isUser ? Colors.white : const Color(0xFFFDAA58),
                  ),
                ),
                if (!isUser)
                  Padding(
                    padding: EdgeInsets.only(left: ResponsiveSize.w(10)),
                    child:
                        isPlaying
                            ? Icon(
                              Icons.volume_up,
                              size: ResponsiveSize.w(24),
                              color: Colors.blue,
                            )
                            : GestureDetector(
                              onTap: () {
                                if (!_isAISpeaking) {
                                  setState(() {
                                    // Mark this message as playing
                                    for (int i = 0; i < _messages.length; i++) {
                                      if (_messages[i] == message) {
                                        _messages[i] = ChatMessage(
                                          text: message.text,
                                          isUser: false,
                                          time: message.time,
                                          isPlaying: true,
                                        );
                                        break;
                                      }
                                    }
                                  });
                                  // Play this message
                                  _playAIMessageWithTTS(message.text);
                                }
                              },
                              child: Icon(
                                Icons.volume_up_outlined,
                                size: ResponsiveSize.w(24),
                                color: Colors.grey,
                              ),
                            ),
                  ),
              ],
            ),

            SizedBox(height: ResponsiveSize.h(10)),

            // Message text
            Text(
              message.text,
              style: TextStyle(
                fontSize: ResponsiveSize.sp(34),
                color: isUser ? Colors.white : Colors.black87,
                height: 1.4,
              ),
            ),

            SizedBox(height: ResponsiveSize.h(5)),

            // Message time
            Text(
              _formatTime(message.time),
              style: TextStyle(
                fontSize: ResponsiveSize.sp(24),
                color: isUser ? Colors.white.withOpacity(0.7) : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildVoiceButton() {
    return AvatarGlow(
      // For circular glow, don't specify glowBorderRadius
      animate: _isListening,
      glowColor: const Color(0xFFFDAA58),
      child: FloatingActionButton(
        onPressed: _toggleListening,
        backgroundColor: const Color(0xFFFDAA58),
        child: Icon(
          _isListening ? Icons.mic : Icons.mic_none,
          size: ResponsiveSize.w(40),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;
  final bool isPlaying;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.isPlaying = false,
  });
}
