import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:async';

// Picture Book model
class PictureBook {
  final String id;
  final String title;
  final String coverImage;
  final List<String> pages;
  final List<List<Map<String, dynamic>>> customContent;

  PictureBook({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.pages,
    required this.customContent,
  });
}

class HuibenManagePage extends StatefulWidget {
  const HuibenManagePage({super.key});

  @override
  _HuibenManagePageState createState() => _HuibenManagePageState();
}

class _HuibenManagePageState extends State<HuibenManagePage> {
  bool _isEditingBook = false;
  PictureBook? _selectedBook;
  int _currentPage = 0;

  // Audio recording and playback
  FlutterSoundPlayer? _player;
  FlutterSoundRecorder? _recorder;
  bool _isRecorderInitialized = false;
  bool _isPlayerInitialized = false;
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _currentAudioPath;
  String? _currentPlayingAudioId;

  // Sample books data
  final List<PictureBook> _books = [
    PictureBook(
      id: '1',
      title: '小猫咪的冒险',
      coverImage: 'assets/huiben.jpg',
      pages: ['assets/huiben.jpg', 'assets/settings.jpg', 'assets/theme.png'],
      customContent: [[], [], []],
    ),
    PictureBook(
      id: '2',
      title: '海底世界',
      coverImage: 'assets/settings.jpg',
      pages: ['assets/settings.jpg', 'assets/huiben.jpg', 'assets/theme.png'],
      customContent: [[], [], []],
    ),
    PictureBook(
      id: '3',
      title: '太空探险',
      coverImage: 'assets/theme.png',
      pages: ['assets/theme.png', 'assets/settings.jpg', 'assets/huiben.jpg'],
      customContent: [[], [], []],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    // Initialize the recorder
    _recorder = FlutterSoundRecorder();

    // Initialize the player
    _player = FlutterSoundPlayer();

    try {
      await _initRecorder();
      await _initPlayer();
    } catch (e) {
      print('Error initializing audio: $e');
      // Show an error message to the user
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('音频功能初始化失败: $e')));
    }
  }

  @override
  void dispose() {
    _disposeAudio();
    super.dispose();
  }

  Future<void> _disposeAudio() async {
    try {
      if (_recorder != null) {
        if (_isRecording) {
          await _recorder!.stopRecorder();
        }
        await _recorder!.closeRecorder();
        _recorder = null;
      }

      if (_player != null) {
        if (_isPlaying) {
          await _player!.stopPlayer();
        }
        await _player!.closePlayer();
        _player = null;
      }
    } catch (e) {
      print('Error disposing audio: $e');
    }
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    try {
      await _recorder!.openRecorder();
      _isRecorderInitialized = true;
    } catch (e) {
      print('Error initializing recorder: $e');
      _isRecorderInitialized = false;
      rethrow;
    }
  }

  Future<void> _initPlayer() async {
    try {
      await _player!.openPlayer();
      _isPlayerInitialized = true;
    } catch (e) {
      print('Error initializing player: $e');
      _isPlayerInitialized = false;
      rethrow;
    }
  }

  Future<void> _startRecording() async {
    if (!_isRecorderInitialized || _recorder == null) {
      print('Recorder not initialized');
      return;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      _currentAudioPath = '${directory.path}/audio_$timestamp.aac';

      await _recorder!.startRecorder(
        toFile: _currentAudioPath,
        codec: Codec.aacADTS,
      );

      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      print('Error starting recording: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('录音失败: $e')));
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecorderInitialized || !_isRecording || _recorder == null) return;

    try {
      await _recorder!.stopRecorder();
      setState(() {
        _isRecording = false;
      });
    } catch (e) {
      print('Error stopping recording: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('停止录音失败: $e')));
    }
  }

  Future<void> _playAudio(String audioPath, String contentId) async {
    if (!_isPlayerInitialized || _player == null) {
      print('Player not initialized');
      return;
    }

    try {
      if (_isPlaying && _currentPlayingAudioId == contentId) {
        await _player!.stopPlayer();
        setState(() {
          _isPlaying = false;
          _currentPlayingAudioId = null;
        });
        return;
      }

      if (_isPlaying) {
        await _player!.stopPlayer();
      }

      await _player!.startPlayer(
        fromURI: audioPath,
        whenFinished: () {
          setState(() {
            _isPlaying = false;
            _currentPlayingAudioId = null;
          });
        },
      );

      setState(() {
        _isPlaying = true;
        _currentPlayingAudioId = contentId;
      });
    } catch (e) {
      print('Error playing audio: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('播放录音失败: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditingBook ? '编辑绘本：${_selectedBook?.title}' : '绘本管理'),
        elevation: 0,
        actions:
            _isEditingBook
                ? [
                  IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: () {
                      // Save logic here
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('绘本保存成功！')));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _isEditingBook = false;
                        _currentPage = 0;
                      });
                    },
                  ),
                ]
                : [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // Add new book logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('创建新绘本功能即将上线')),
                      );
                    },
                  ),
                ],
      ),
      body: _isEditingBook ? _buildEditView() : _buildBooksGridView(),
    );
  }

  Widget _buildBooksGridView() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade50, Colors.white],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '我的绘本',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _books.length,
              itemBuilder: (context, index) {
                return _buildBookCard(_books[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(PictureBook book) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBook = book;
          _isEditingBook = true;
          _currentPage = 0;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: 'book_${book.id}',
                child: Image.asset(book.coverImage, fit: BoxFit.cover),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Text(
                  book.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditView() {
    if (_selectedBook == null) return const SizedBox.shrink();

    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SingleChildScrollView(
                child: GestureDetector(
                  onTapUp: (details) {
                    // Calculate the position relative to the scrollable area
                    final RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    final offset = renderBox.globalToLocal(
                      details.globalPosition,
                    );
                    _showAddContentDialog(context, offset);
                  },
                  child: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Hero(
                            tag: 'book_${_selectedBook!.id}',
                            child: Image.asset(
                              _selectedBook!.pages[_currentPage],
                              width: double.infinity,
                              fit:
                                  BoxFit
                                      .fitWidth, // Changed from cover to fitWidth
                            ),
                          ),
                        ],
                      ),
                      ..._selectedBook!.customContent[_currentPage].map((
                        content,
                      ) {
                        final contentId = content['id'] ?? 'unknown';
                        return Positioned(
                          left: content['position'].dx,
                          top: content['position'].dy,
                          child: GestureDetector(
                            onTap: () => _editContentDialog(context, content),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.85),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child:
                                  content['type'] == 'audio'
                                      ? Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              _isPlaying &&
                                                      _currentPlayingAudioId ==
                                                          contentId
                                                  ? Icons.stop
                                                  : Icons.play_arrow,
                                            ),
                                            onPressed:
                                                () => _playAudio(
                                                  content['audioPath'],
                                                  contentId,
                                                ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '音频内容',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )
                                      : Text(
                                        content['text'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        _buildPageControls(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPageControls() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.arrow_back),
            label: const Text('上一页'),
            onPressed:
                _currentPage > 0 ? () => setState(() => _currentPage--) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade100,
              foregroundColor: Colors.blue.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Text(
            '${_currentPage + 1}/${_selectedBook?.pages.length}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.arrow_forward),
            label: const Text('下一页'),
            onPressed:
                _selectedBook != null &&
                        _currentPage < _selectedBook!.pages.length - 1
                    ? () => setState(() => _currentPage++)
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade100,
              foregroundColor: Colors.blue.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddContentDialog(BuildContext context, Offset position) {
    final textController = TextEditingController();
    bool isAudioMode = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isAudioMode ? '添加音频内容' : '添加自定义内容'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: Text('文字'),
                        selected: !isAudioMode,
                        onSelected: (selected) {
                          if (selected) {
                            setDialogState(() {
                              isAudioMode = false;
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      ChoiceChip(
                        label: Text('录音'),
                        selected: isAudioMode,
                        onSelected: (selected) {
                          if (selected) {
                            if (!_isRecorderInitialized) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('录音功能未初始化，请检查麦克风权限'),
                                ),
                              );
                              return;
                            }
                            setDialogState(() {
                              isAudioMode = true;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  isAudioMode
                      ? Column(
                        children: [
                          ElevatedButton(
                            onPressed:
                                _isRecording
                                    ? () {
                                      _stopRecording().then((_) {
                                        setDialogState(() {});
                                      });
                                    }
                                    : () {
                                      _startRecording().then((_) {
                                        setDialogState(() {});
                                      });
                                    },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(16),
                              backgroundColor:
                                  _isRecording ? Colors.red : Colors.blue,
                            ),
                            child: Icon(
                              _isRecording ? Icons.stop : Icons.mic,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isRecording
                                ? '正在录音...'
                                : _currentAudioPath != null
                                ? '录音完成'
                                : '点击开始录音',
                            style: TextStyle(
                              color: _isRecording ? Colors.red : Colors.black54,
                            ),
                          ),
                          if (_currentAudioPath != null && !_isRecording)
                            TextButton.icon(
                              icon: Icon(
                                _isPlaying ? Icons.stop : Icons.play_arrow,
                              ),
                              label: Text(_isPlaying ? '停止播放' : '预览录音'),
                              onPressed: () {
                                if (_isPlaying) {
                                  _player?.stopPlayer().then((_) {
                                    setDialogState(() {
                                      _isPlaying = false;
                                    });
                                  });
                                } else {
                                  final uniqueId =
                                      DateTime.now().millisecondsSinceEpoch
                                          .toString();
                                  _playAudio(_currentAudioPath!, uniqueId).then(
                                    (_) {
                                      setDialogState(() {});
                                    },
                                  );
                                }
                              },
                            ),
                        ],
                      )
                      : TextField(
                        controller: textController,
                        decoration: const InputDecoration(
                          hintText: '输入内容',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (_isRecording) {
                      _stopRecording();
                    }
                    if (_isPlaying) {
                      _player?.stopPlayer();
                    }
                    _currentAudioPath = null;
                    Navigator.of(context).pop();
                  },
                  child: const Text('取消'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (isAudioMode && _currentAudioPath == null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('请先录制音频')));
                      return;
                    }

                    if (!isAudioMode && textController.text.isEmpty) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('请输入文字内容')));
                      return;
                    }

                    final timestamp =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    setState(() {
                      _selectedBook!.customContent[_currentPage].add(
                        isAudioMode
                            ? {
                              'id': timestamp,
                              'position': position,
                              'type': 'audio',
                              'audioPath': _currentAudioPath,
                            }
                            : {
                              'id': timestamp,
                              'position': position,
                              'type': 'text',
                              'text': textController.text,
                            },
                      );
                    });
                    _currentAudioPath = null;
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('添加'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _editContentDialog(BuildContext context, Map<String, dynamic> content) {
    final textController = TextEditingController(
      text: content['type'] == 'text' ? content['text'] : '',
    );
    final contentType = content['type'] ?? 'text';
    final audioPath = contentType == 'audio' ? content['audioPath'] : null;
    final contentId = content['id'] ?? 'unknown';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(contentType == 'audio' ? '编辑音频内容' : '编辑内容'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  contentType == 'audio'
                      ? Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_isPlaying &&
                                  _currentPlayingAudioId == contentId) {
                                _player?.stopPlayer().then((_) {
                                  setDialogState(() {
                                    _isPlaying = false;
                                    _currentPlayingAudioId = null;
                                  });
                                });
                              } else {
                                _playAudio(audioPath!, contentId).then((_) {
                                  setDialogState(() {});
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(16),
                              backgroundColor: Colors.blue,
                            ),
                            child: Icon(
                              _isPlaying && _currentPlayingAudioId == contentId
                                  ? Icons.stop
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isPlaying && _currentPlayingAudioId == contentId
                                ? '正在播放...'
                                : '点击播放录音',
                          ),
                        ],
                      )
                      : TextField(
                        controller: textController,
                        decoration: const InputDecoration(
                          hintText: '输入内容',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (_isPlaying) {
                      _player?.stopPlayer();
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedBook!.customContent[_currentPage].remove(
                        content,
                      );
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('删除', style: TextStyle(color: Colors.red)),
                ),
                if (contentType == 'text')
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        content['text'] = textController.text;
                      });
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('更新'),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
