import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';
import '../../../utils/responsive_size.dart';

typedef OnSaveWorkCallback = void Function(String title, String audioPath, String imagePath, String? videoPath);

class AudioRecordPage extends StatefulWidget {
  final OnSaveWorkCallback? onSaveWork;
  
  const AudioRecordPage({
    super.key, 
    this.onSaveWork,
  });

  @override
  State<AudioRecordPage> createState() => _AudioRecordPageState();
}

class _AudioRecordPageState extends State<AudioRecordPage> {
  // 基本控制器和状态
  final _audioRecorder = AudioRecorder();
  final _audioPlayer = AudioPlayer();
  final TextEditingController _titleController = TextEditingController();
  
  // 音频相关状态
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _recordPath;
  
  // 媒体相关状态
  bool _hasMedia = false;
  String _selectedImage = 'assets/cartoon.png';
  
  // 摄像头相关状态
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  String? _videoPath;
  VideoPlayerController? _videoController;
  bool _isVideoWindowExpanded = false;
  bool _isVideoWindowVisible = true;

  // 响应式尺寸
  late final double _previewImageSize;
  late final double _previewTitleSize;
  late final double _dialogWidth;
  late final double _dialogHeight;
  late final double _headerHeight;
  late final double _contentPadding;


  @override
  void initState() {
    super.initState();
    _initializeCamera();
    
    // 初始化响应式尺寸
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ResponsiveSize.init(context);
      _previewImageSize = ResponsiveSize.w(60);
      _previewTitleSize = ResponsiveSize.sp(25);
      _dialogWidth = ResponsiveSize.w(600);
      _dialogHeight = ResponsiveSize.h(400);
      _headerHeight = ResponsiveSize.h(100);
      _contentPadding = ResponsiveSize.w(30);
    });
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      ),
      ResolutionPreset.medium,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }
    // 开始录制
  Future<void> _start() async {
    try {
      if (!_hasMedia) return;
      
      final directory = await getApplicationDocumentsDirectory();
      final audioPath = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
      
      // 开始录音
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: audioPath,
      );
      
      // 开始录像
      if (_isCameraInitialized) {
        await _cameraController!.startVideoRecording();
      }
      
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      debugPrint('Error starting recording: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('录制启动失败: $e')),
      );
    }
  }

  // 停止录制
  Future<void> _stop() async {
    try {
      // 停止录音
      final audioPath = await _audioRecorder.stop();
      
      // 停止录像
      if (_isCameraInitialized) {
        final videoFile = await _cameraController!.stopVideoRecording();
        _videoPath = videoFile.path;
        
        // 初始化视频播放器
        _videoController?.dispose();
        _videoController = VideoPlayerController.file(File(_videoPath!))
          ..initialize().then((_) {
            if (mounted) setState(() {});
          });
      }
      
      if (audioPath != null) {
        setState(() {
          _isRecording = false;
          _recordPath = audioPath;
        });
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
  }

  // 播放或暂停音频
  Future<void> _playOrPause() async {
    if (_recordPath == null) return;

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        _videoController?.pause();
        setState(() {
          _isPlaying = false;
        });
      } else {
        await _audioPlayer.play(DeviceFileSource(_recordPath!));
        _videoController?.play();
        setState(() {
          _isPlaying = true;
        });

        _audioPlayer.onPlayerComplete.listen((event) {
          if (mounted) {
            setState(() {
              _isPlaying = false;
            });
            _videoController?.pause();
            _videoController?.seekTo(Duration.zero);
          }
        });
      }
    } catch (e) {
      debugPrint('Error playing media: $e');
    }
  }

  // 请求权限
  Future<void> _requestPermissions() async {
    if (!_hasMedia) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先添加媒体文件')),
      );
      return;
    }

    try {
      final micStatus = await Permission.microphone.status;
      final cameraStatus = await Permission.camera.status;
      
      if (micStatus.isGranted && cameraStatus.isGranted) {
        await _start();
      } else {
        final micResult = await Permission.microphone.request();
        final cameraResult = await Permission.camera.request();
        
        if (micResult.isGranted && cameraResult.isGranted) {
          if (!mounted) return;
          await _start();
        } else {
          if (!mounted) return;
          _showPermissionDeniedDialog();
        }
      }
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
    }
  }
    // 视频预览窗口
  Widget _buildVideoPreviewWindow() {
    if (!_isVideoWindowVisible || _videoPath == null || _videoController == null) {
      return const SizedBox();
    }

    return Positioned(
      right: ResponsiveSize.w(20),
      top: ResponsiveSize.h(20),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isVideoWindowExpanded = !_isVideoWindowExpanded;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _isVideoWindowExpanded 
            ? ResponsiveSize.w(400) 
            : ResponsiveSize.w(200),
          height: _isVideoWindowExpanded 
            ? ResponsiveSize.h(300) 
            : ResponsiveSize.h(150),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFFFDFA7),
              width: ResponsiveSize.w(2),
            ),
            borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                child: VideoPlayer(_videoController!),
              ),
              Positioned(
                right: ResponsiveSize.w(5),
                top: ResponsiveSize.h(5),
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: ResponsiveSize.w(24),
                  ),
                  onPressed: () {
                    setState(() {
                      _isVideoWindowVisible = false;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 保存对话框
  void _handleSave() {
    if (!_hasMedia || _recordPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先录制音频')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '保存作品',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(28),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: ResponsiveSize.w(500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                style: TextStyle(fontSize: ResponsiveSize.sp(24)),
                decoration: InputDecoration(
                  labelText: '作品名称',
                  labelStyle: TextStyle(fontSize: ResponsiveSize.sp(24)),
                  hintText: '请输入作品名称',
                  hintStyle: TextStyle(fontSize: ResponsiveSize.sp(22)),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.w(20),
                    vertical: ResponsiveSize.h(15),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '取消',
              style: TextStyle(fontSize: ResponsiveSize.sp(22)),
            ),
          ),
          TextButton(
            onPressed: () {
              if (_titleController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请输入作品名称')),
                );
                return;
              }
              widget.onSaveWork?.call(
                _titleController.text,
                _recordPath!,
                _selectedImage,
                _videoPath,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('作品保存成功')),
              );
            },
            child: Text(
              '保存',
              style: TextStyle(fontSize: ResponsiveSize.sp(22)),
            ),
          ),
        ],
      ),
    );
  }

  // 权限拒绝对话框
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          '需要录音和摄像头权限',
          style: TextStyle(fontSize: ResponsiveSize.sp(24)),
        ),
        content: Text(
          '我们需要录音和摄像头权限来录制内容，请允许访问。',
          style: TextStyle(fontSize: ResponsiveSize.sp(18)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '取消',
              style: TextStyle(fontSize: ResponsiveSize.sp(20)),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            child: Text(
              '去设置',
              style: TextStyle(fontSize: ResponsiveSize.sp(20)),
            ),
          ),
        ],
      ),
    );
  }
    @override
  Widget build(BuildContext context) {
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
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: ResponsiveSize.w(15)),
                              child: _buildStyledButton(
                                '分享',
                                () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('分享功能开发中')),
                                  );
                                },
                              ),
                            ),
                            _buildStyledButton('保存', _handleSave),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      ResponsiveSize.w(20),
                      0,
                      ResponsiveSize.w(20),
                      ResponsiveSize.h(20)
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: ResponsiveSize.w(200),
                          margin: EdgeInsets.only(right: ResponsiveSize.w(20)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                            border: Border.all(
                              color: const Color(0xFFFFDFA7),
                              width: ResponsiveSize.w(2),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // 媒体预览区域
                              Padding(
                                padding: EdgeInsets.all(ResponsiveSize.w(20)),
                                child: Container(
                                  width: ResponsiveSize.w(160),
                                  height: ResponsiveSize.h(120),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFFFFDFA7),
                                      width: ResponsiveSize.w(2),
                                    ),
                                    borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                                        child: _hasMedia 
                                          ? Image.asset(
                                              _selectedImage,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            )
                                          : Container(
                                              color: const Color(0xFFFFF9E9),
                                              child: Icon(
                                                Icons.add_photo_alternate,
                                                size: ResponsiveSize.w(40),
                                                color: const Color(0xFF5A2E17),
                                              ),
                                            ),
                                      ),
                                      if (_hasMedia && _recordPath != null)
                                        Positioned(
                                          left: ResponsiveSize.w(5),
                                          top: ResponsiveSize.h(5),
                                          child: GestureDetector(
                                            onTap: _playOrPause,
                                            child: Container(
                                              padding: EdgeInsets.all(ResponsiveSize.w(4)),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFFDFA7),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: const Color(0xFFFFCC80),
                                                  width: ResponsiveSize.w(2),
                                                ),
                                              ),
                                              child: Icon(
                                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                                color: const Color(0xFF5A2E17),
                                                size: ResponsiveSize.w(20),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              // 添加媒体按钮
                              GestureDetector(
                                onTap: _addMedia,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: ResponsiveSize.h(20)),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveSize.w(40),
                                    vertical: ResponsiveSize.h(15),
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFDFA7),
                                    borderRadius: BorderRadius.circular(ResponsiveSize.w(30)),
                                    border: Border.all(
                                      color: const Color(0xFFFFCC80),
                                      width: ResponsiveSize.w(2),
                                    ),
                                  ),
                                  child: Text(
                                    '添加媒体',
                                    style: TextStyle(
                                      fontSize: ResponsiveSize.sp(24),
                                      color: const Color(0xFF5A2E17),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 主要内容区域
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                              border: Border.all(
                                color: const Color(0xFFFFDFA7),
                                width: ResponsiveSize.w(2),
                              ),
                            ),
                            child: Stack(
                              children: [
                                // 媒体显示
                                if (_hasMedia)
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(ResponsiveSize.w(18)),
                                      child: Image.asset(
                                        _selectedImage,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                // 录制按钮
                                Positioned(
                                  bottom: ResponsiveSize.h(20),
                                  left: ResponsiveSize.w(20),
                                  child: Container(
                                    padding: EdgeInsets.all(ResponsiveSize.w(16)),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                                      border: Border.all(
                                        color: const Color(0xFFFFDFA7),
                                        width: ResponsiveSize.w(2),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            if (!_isRecording) {
                                              await _requestPermissions();
                                            } else {
                                              await _stop();
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(ResponsiveSize.w(15)),
                                            decoration: BoxDecoration(
                                              color: _isRecording
                                                ? const Color(0xFFFF6B6B)
                                                : const Color(0xFFFFDFA7),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: _isRecording
                                                  ? const Color(0xFFFF8A8A)
                                                  : const Color(0xFFFFCC80),
                                                width: ResponsiveSize.w(2),
                                              ),
                                            ),
                                            child: Icon(
                                              _isRecording ? Icons.stop : Icons.mic,
                                              color: const Color(0xFF5A2E17),
                                              size: ResponsiveSize.w(40),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: ResponsiveSize.h(8)),
                                        Text(
                                          _isRecording ? '停止' : '录音',
                                          style: TextStyle(
                                            fontSize: ResponsiveSize.sp(20),
                                            color: const Color(0xFF5A2E17),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // 录制时的摄像头预览
            if (_isRecording && _isCameraInitialized)
              Positioned(
                right: ResponsiveSize.w(20),
                top: ResponsiveSize.h(100),
                child: Container(
                  width: ResponsiveSize.w(200),
                  height: ResponsiveSize.h(150),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFFFDFA7),
                      width: ResponsiveSize.w(2),
                    ),
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                    child: CameraPreview(_cameraController!),
                  ),
                ),
              ),
            // 播放时的视频预览
            if (!_isRecording)
              _buildVideoPreviewWindow(),
          ],
        ),
      ),
    );
  }
  void _addMedia() {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: _dialogWidth,
        height: _dialogHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
        ),
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(ResponsiveSize.w(20))
                ),
                image: const DecorationImage(
                  image: AssetImage('assets/addbackground.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  '选择媒体文件',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(30),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(_contentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMediaOption(
                    title: '三只小猪',
                    image: 'assets/cartoon.png',
                  ),
                  SizedBox(height: ResponsiveSize.h(20)),
                  _buildMediaOption(
                    title: '云朵',
                    image: 'assets/cloud.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildMediaOption({
  required String title,
  required String image,
}) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    onTap: () {
      setState(() {
        _selectedImage = image;
        _hasMedia = true;
      });
      Navigator.pop(context);
    },
    leading: Container(
      width: _previewImageSize,
      height: _previewImageSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
    ),
    title: Text(
      title,
      style: TextStyle(
        fontSize: _previewTitleSize,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

  Widget _buildStyledButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(30),
          vertical: ResponsiveSize.h(12),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFDFA7),
          borderRadius: BorderRadius.circular(ResponsiveSize.w(30)),
          border: Border.all(
            color: const Color(0xFFFFCC80),
            width: ResponsiveSize.w(2),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(26),
            color: const Color(0xFF5A2E17),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _titleController.dispose();
    _cameraController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }
}