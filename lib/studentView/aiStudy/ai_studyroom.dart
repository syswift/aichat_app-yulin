import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';
import '../../services/livekit_service.dart';
import '../../services/ai_agent_service.dart';
import '../../models/ai_agent_config.dart';

class AIStudyRoom extends StatefulWidget {
  const AIStudyRoom({super.key});

  @override
  State<AIStudyRoom> createState() => _AIStudyRoomState();
}

class _AIStudyRoomState extends State<AIStudyRoom> {
  final LiveKitService _livekitService = LiveKitService();
  final AIAgentService _aiAgentService = AIAgentService(
    baseUrl: 'http://198.13.49.35:5050', // 替换为您的SDK服务器URL
  );

  TextbookConfig? _selectedTextbook;
  List<TextbookConfig> _availableTextbooks = [];
  bool _isConnecting = false;
  bool _isChatActive = false;
  String _aiResponse = '';

  @override
  void initState() {
    super.initState();
    _loadTextbooks();

    // Listen for AI messages
    _livekitService.aiMessages.listen((message) {
      setState(() {
        _aiResponse = message;
      });
    });
  }

  @override
  void dispose() {
    _livekitService.dispose();
    _livekitService.disconnect();
    super.dispose();
  }

  Future<void> _loadTextbooks() async {
    try {
      final textbooks = await _aiAgentService.getAvailableTextbooks();
      setState(() {
        _availableTextbooks = textbooks;
        if (textbooks.isNotEmpty) {
          _selectedTextbook = textbooks.first;
        }
      });
    } catch (e) {
      _showError('无法加载教材列表');
    }
  }

  Future<void> _startChat() async {
    if (_selectedTextbook == null) {
      _showError('请先选择教材');
      return;
    }

    setState(() => _isConnecting = true);

    try {
      // 获取LiveKit连接信息
      final token = await _aiAgentService.getLiveKitToken(
        userName: 'student',
        textbookId: _selectedTextbook!.id,
      );

      final liveKitUrl = await _aiAgentService.getLiveKitUrl();

      // 连接到LiveKit房间
      await _livekitService.connect(
        url: liveKitUrl,
        token: token,
        userName: 'student',
        agentName: 'aiagent',
      );

      setState(() {
        _isChatActive = true;
        _isConnecting = false;
      });
    } catch (e) {
      setState(() => _isConnecting = false);
      _showError('连接失败: ${e.toString()}');
    }
  }

  void _toggleMicrophone() async {
    if (_livekitService.isSpeaking.value) {
      await _livekitService.disableMicrophone();
    } else {
      await _livekitService.enableMicrophone();
    }
    setState(() {});
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showTextbookDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('选择教材'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _availableTextbooks.length,
                itemBuilder: (context, index) {
                  final textbook = _availableTextbooks[index];
                  return ListTile(
                    title: Text(textbook.title),
                    subtitle: Text(textbook.description),
                    selected: _selectedTextbook?.id == textbook.id,
                    onTap: () {
                      setState(() => _selectedTextbook = textbook);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('取消'),
              ),
            ],
          ),
    );
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
                image: AssetImage('assets/AIStudyRoom.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 返回按钮
          Positioned(
            top: ResponsiveSize.h(60),
            left: ResponsiveSize.w(40),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Image.asset(
                'assets/backbutton1.png',
                width: ResponsiveSize.w(100),
                height: ResponsiveSize.h(100),
              ),
            ),
          ),
          // 切换教材按钮
          Positioned(
            top: ResponsiveSize.h(60),
            right: ResponsiveSize.w(90),
            child: _buildCustomButton(
              label: '切换教材',
              onTap: _showTextbookDialog,
            ),
          ),

          // 显示当前教材
          if (_selectedTextbook != null)
            Positioned(
              top: ResponsiveSize.h(150),
              right: ResponsiveSize.w(90),
              child: Container(
                padding: EdgeInsets.all(ResponsiveSize.w(15)),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
                ),
                child: Text(
                  '当前教材: ${_selectedTextbook!.title}',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(24),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // AI回复显示
          if (_aiResponse.isNotEmpty)
            Positioned(
              top: ResponsiveSize.h(200),
              left: ResponsiveSize.w(100),
              right: ResponsiveSize.w(100),
              child: Container(
                padding: EdgeInsets.all(ResponsiveSize.w(20)),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                  border: Border.all(
                    color: const Color.fromARGB(255, 253, 170, 88),
                    width: 2,
                  ),
                ),
                child: Text(
                  _aiResponse,
                  style: TextStyle(fontSize: ResponsiveSize.sp(28)),
                ),
              ),
            ),

          // 麦克风按钮（当聊天开始时显示）
          if (_isChatActive)
            Positioned(
              bottom: ResponsiveSize.h(100),
              left:
                  MediaQuery.of(context).size.width / 2 - ResponsiveSize.w(50),
              child: GestureDetector(
                onTap: _toggleMicrophone,
                child: Container(
                  width: ResponsiveSize.w(100),
                  height: ResponsiveSize.w(100),
                  decoration: BoxDecoration(
                    color:
                        _livekitService.isSpeaking.value
                            ? Colors.red
                            : const Color.fromARGB(255, 253, 170, 88),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, ResponsiveSize.h(4)),
                        blurRadius: ResponsiveSize.w(4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _livekitService.isSpeaking.value
                        ? Icons.mic
                        : Icons.mic_none,
                    color: Colors.white,
                    size: ResponsiveSize.w(50),
                  ),
                ),
              ),
            ),

          // 开始聊天按钮（未开始聊天时显示）
          if (!_isChatActive)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.55,
              left:
                  MediaQuery.of(context).size.width / 2 - ResponsiveSize.w(75),
              child:
                  _isConnecting
                      ? CircularProgressIndicator(
                        color: const Color.fromARGB(255, 253, 170, 88),
                      )
                      : _buildCustomButton(label: '开始对话', onTap: _startChat),
            ),
        ],
      ),
    );
  }

  Widget _buildCustomButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.w(25),
            vertical: ResponsiveSize.h(15),
          ),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 253, 170, 88),
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
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveSize.sp(35),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
