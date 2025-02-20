import 'package:flutter/material.dart';

class HuibenManagePage extends StatefulWidget {
  const HuibenManagePage({super.key});

  @override
  _HuibenManagePageState createState() => _HuibenManagePageState();
}

class _HuibenManagePageState extends State<HuibenManagePage> {
  int _currentPage = 0;
  final List<String> _pages = [
    'assets/huiben.jpg',
    'assets/settings.jpg',
    'assets/theme.png',
  ];
  final List<List<Map<String, dynamic>>> _customContent = [
    [],
    [],
    [],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('绘本编辑'),
      ),
      body: GestureDetector(
        onTapUp: (details) {
          _showAddContentDialog(context, details.localPosition);
        },
        child: Stack(
          children: [
            Image.asset(
              _pages[_currentPage],
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            ..._customContent[_currentPage].map((content) {
              return Positioned(
                left: content['position'].dx,
                top: content['position'].dy,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(content['text']),
                ),
              );
            }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _currentPage > 0
                ? () {
                    setState(() {
                      _currentPage--;
                    });
                  }
                : null,
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: _currentPage < _pages.length - 1
                ? () {
                    setState(() {
                      _currentPage++;
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }

  void _showAddContentDialog(BuildContext context, Offset position) {
    final TextEditingController _textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('添加自定义内容'),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(hintText: '输入内容'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _customContent[_currentPage].add({
                    'position': position,
                    'text': _textController.text,
                  });
                });
                Navigator.of(context).pop();
              },
              child: const Text('添加'),
            ),
          ],
        );
      },
    );
  }
}
