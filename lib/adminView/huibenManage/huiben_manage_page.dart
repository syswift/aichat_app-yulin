import 'package:flutter/material.dart';

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
                              child: Text(
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

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('添加自定义内容'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: '输入内容',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedBook!.customContent[_currentPage].add({
                    'position': position,
                    'text': textController.text,
                  });
                });
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
  }

  void _editContentDialog(BuildContext context, Map<String, dynamic> content) {
    final textController = TextEditingController(text: content['text']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('编辑内容'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: '输入内容',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedBook!.customContent[_currentPage].remove(content);
                });
                Navigator.of(context).pop();
              },
              child: const Text('删除', style: TextStyle(color: Colors.red)),
            ),
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
  }
}
