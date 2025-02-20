import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';

class CreatePictureBookPage extends StatefulWidget {
  const CreatePictureBookPage({super.key});

  @override
  State<CreatePictureBookPage> createState() => _CreatePictureBookPageState();
}

class _CreatePictureBookPageState extends State<CreatePictureBookPage> {
  int? _selectedPageIndex;
  final List<Map<String, dynamic>> _bookPages = [];
  int _currentPage = 0;
  final int _totalPages = 5;

  @override
  void initState() {
    super.initState();
    _initializePages();
  }

  void _initializePages() {
    setState(() {
      _bookPages.clear();
      for (int i = 0; i < _totalPages; i++) {
        _bookPages.add({
          'pageNumber': '第${i + 1}页',
          'imagePath': 'assets/cartoon_${i + 1}.jpg',
          'attachments': [],
        });
      }
    });
  }
    void _addAttachment(String type) {
    if (_selectedPageIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先选择一个页面')),
      );
      return;
    }

    setState(() {
      _bookPages[_selectedPageIndex!]['attachments'].add({
        'type': type,
        'name': '$type${_bookPages[_selectedPageIndex!]['attachments'].length + 1}',
      });
    });
  }

  void _removeAttachment(int pageIndex, int attachmentIndex) {
    setState(() {
      _bookPages[pageIndex]['attachments'].removeAt(attachmentIndex);
    });
  }

  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '保存绘本',
          style: TextStyle(
            color: const Color(0xFF8B4513),
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveSize.sp(24),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: '绘本名称',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                ),
                labelStyle: TextStyle(
                  color: const Color(0xFF8B4513),
                  fontSize: ResponsiveSize.sp(16),
                ),
              ),
            ),
            SizedBox(height: ResponsiveSize.h(16)),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: '备注',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                ),
                labelStyle: TextStyle(
                  color: const Color(0xFF8B4513),
                  fontSize: ResponsiveSize.sp(16),
                ),
              ),
            ),
            SizedBox(height: ResponsiveSize.h(16)),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: '适用年级',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                ),
                labelStyle: TextStyle(
                  color: const Color(0xFF8B4513),
                  fontSize: ResponsiveSize.sp(16),
                ),
              ),
              items: ['一年级', '二年级', '三年级']
                  .map((grade) => DropdownMenuItem(
                        value: grade,
                        child: Text(
                          grade,
                          style: TextStyle(
                            color: const Color(0xFF8B4513),
                            fontSize: ResponsiveSize.sp(16),
                          ),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
          ],
        ),
                actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '取消',
              style: TextStyle(
                color: const Color(0xFF8B4513),
                fontSize: ResponsiveSize.sp(16),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: 实现保存功能
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFE4C4),
              foregroundColor: const Color(0xFF8B4513),
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.w(20),
                vertical: ResponsiveSize.h(10),
              ),
            ),
            child: Text(
              '保存',
              style: TextStyle(fontSize: ResponsiveSize.sp(16)),
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
      backgroundColor: const Color(0xFFFDF5E6),
      body: Padding(
        padding: EdgeInsets.all(ResponsiveSize.w(32)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    'assets/backbutton1.png',
                    width: ResponsiveSize.w(80),
                    height: ResponsiveSize.h(80),
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.book,
                    size: ResponsiveSize.w(20),
                  ),
                  label: Text(
                    '当前页面: ${_currentPage + 1}',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(20),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                                    style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFE4C4),
                    foregroundColor: const Color(0xFF8B4513),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.w(20),
                      vertical: ResponsiveSize.h(12),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                      side: const BorderSide(
                        color: Color(0xFFDEB887),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveSize.w(16)),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: 实现添加绘本功能
                  },
                  icon: Icon(
                    Icons.add,
                    size: ResponsiveSize.w(20),
                  ),
                  label: Text(
                    '添加绘本',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(20),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFE4C4),
                    foregroundColor: const Color(0xFF8B4513),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.w(20),
                      vertical: ResponsiveSize.h(12),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                      side: const BorderSide(
                        color: Color(0xFFDEB887),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveSize.w(16)),
                ElevatedButton.icon(
                  onPressed: _showSaveDialog,
                  icon: Icon(
                    Icons.save,
                    size: ResponsiveSize.w(20),
                  ),
                  label: Text(
                    '保存',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(20),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                                    style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFE4C4),
                    foregroundColor: const Color(0xFF8B4513),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.w(20),
                      vertical: ResponsiveSize.h(12),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                      side: const BorderSide(
                        color: Color(0xFFDEB887),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveSize.h(20)),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                              border: Border.all(
                                color: const Color(0xFFDEB887),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Image.asset(
                                    _bookPages[_currentPage]['imagePath'],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Positioned(
                                  left: ResponsiveSize.w(10),
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.chevron_left,
                                        size: ResponsiveSize.w(40),
                                      ),
                                      onPressed: _currentPage > 0
                                          ? () {
                                              setState(() {
                                                _currentPage--;
                                              });
                                            }
                                          : null,
                                      color: _currentPage > 0
                                          ? const Color(0xFF8B4513)
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                                                                Positioned(
                                  right: ResponsiveSize.w(10),
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.chevron_right,
                                        size: ResponsiveSize.w(40),
                                      ),
                                      onPressed: _currentPage < _totalPages - 1
                                          ? () {
                                              setState(() {
                                                _currentPage++;
                                              });
                                            }
                                          : null,
                                      color: _currentPage < _totalPages - 1
                                          ? const Color(0xFF8B4513)
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: ResponsiveSize.h(20)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildActionButton('图片', 'assets/star.png', () => _addAttachment('图片')),
                            _buildActionButton('音频', 'assets/star.png', () => _addAttachment('音频')),
                            _buildActionButton('视频', 'assets/star.png', () => _addAttachment('视频')),
                            _buildActionButton('习题', 'assets/star.png', () => _addAttachment('习题')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    margin: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(16)),
                    color: const Color(0xFFDEB887),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                        border: Border.all(
                          color: const Color(0xFFDEB887),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(ResponsiveSize.w(16)),
                            child: Row(
                              children: [
                                Text(
                                  '页面列表',
                                  style: TextStyle(
                                    fontSize: ResponsiveSize.sp(20),
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF8B4513),
                                  ),
                                ),
                              ],
                            ),
                          ),
                                                    Expanded(
                            child: ListView.builder(
                              itemCount: _bookPages.length,
                              itemBuilder: (context, index) {
                                return _buildPageItem(_bookPages[index], index);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, String iconPath, VoidCallback onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: ResponsiveSize.w(120),
          height: ResponsiveSize.h(48),
          margin: EdgeInsets.only(bottom: ResponsiveSize.h(8)),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFE4C4),
              foregroundColor: const Color(0xFF8B4513),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                side: const BorderSide(
                  color: Color(0xFFDEB887),
                  width: 1,
                ),
              ),
            ),
            child: Image.asset(
              iconPath,
              width: ResponsiveSize.w(24),
              height: ResponsiveSize.h(24),
            ),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(16),
            color: const Color(0xFF8B4513),
          ),
        ),
      ],
    );
  }

  Widget _buildPageItem(Map<String, dynamic> page, int index) {
    final isSelected = _selectedPageIndex == index;
    final isCurrentPage = _currentPage == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPageIndex = index;
          _currentPage = index;
        });
      },
            child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(16),
          vertical: ResponsiveSize.h(8),
        ),
        padding: EdgeInsets.all(ResponsiveSize.w(16)),
        decoration: BoxDecoration(
          color: isSelected || isCurrentPage 
              ? const Color(0xFFFFE4C4) 
              : const Color(0xFFFFF8DC),
          borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
          border: Border.all(
            color: const Color(0xFFDEB887),
            width: isSelected || isCurrentPage ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  page['pageNumber'],
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8B4513),
                  ),
                ),
                if (isCurrentPage) ...[
                  SizedBox(width: ResponsiveSize.w(8)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.w(8),
                      vertical: ResponsiveSize.h(4),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B4513),
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                    ),
                    child: Text(
                      '当前页面',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(12),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (page['attachments'].isNotEmpty) ...[
              SizedBox(height: ResponsiveSize.h(8)),
              Wrap(
                spacing: ResponsiveSize.w(8),
                runSpacing: ResponsiveSize.h(8),
                children: List<Widget>.generate(
                  page['attachments'].length,
                  (attachmentIndex) => _buildAttachmentChip(
                    page['attachments'][attachmentIndex],
                    () => _removeAttachment(index, attachmentIndex),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentChip(Map<String, dynamic> attachment, VoidCallback onDelete) {
    return Chip(
      label: Text(
        attachment['name'],
        style: TextStyle(
          color: const Color(0xFF8B4513),
          fontSize: ResponsiveSize.sp(14),
        ),
      ),
      backgroundColor: const Color(0xFFFFE4C4),
      deleteIcon: Icon(
        Icons.close,
        size: ResponsiveSize.w(16),
        color: const Color(0xFF8B4513),
      ),
      onDeleted: onDelete,
    );
  }
}