import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';

class TextbookItem {
  final String title;
  final String grade;
  final String publisher;
  final String coverImage;

  TextbookItem({
    required this.title,
    required this.grade,
    required this.publisher,
    required this.coverImage,
  });
}

class SchoolTextbooksPage extends StatefulWidget {
  const SchoolTextbooksPage({super.key});

  @override
  State<SchoolTextbooksPage> createState() => SchoolTextbooksPageState();
}

class SchoolTextbooksPageState extends State<SchoolTextbooksPage> {
  String _selectedGrade = '全部年级';
  bool _isSelectMode = false;
  
  // 模拟教材数据
  final List<TextbookItem> _allTextbooks = [
    TextbookItem(
      title: '语文教材 1',
      grade: '一年级上册',
      publisher: '人民教育出版社',
      coverImage: 'assets/cartoon.png',
    ),
    TextbookItem(
      title: '语文教材 2',
      grade: '二年级上册',
      publisher: '人民教育出版社',
      coverImage: 'assets/cartoon.png',
    ),
    TextbookItem(
      title: '语文教材 3',
      grade: '三年级上册',
      publisher: '人民教育出版社',
      coverImage: 'assets/cartoon.png',
    ),
  ];

  late List<bool> _selectedItems;
  late List<TextbookItem> _filteredTextbooks;

    @override
  void initState() {
    super.initState();
    _filteredTextbooks = _allTextbooks;
    _selectedItems = List.generate(_filteredTextbooks.length, (index) => false);
  }

  void _filterTextbooks(String grade) {
    setState(() {
      _selectedGrade = grade;
      if (grade == '全部年级') {
        _filteredTextbooks = _allTextbooks;
      } else {
        _filteredTextbooks = _allTextbooks
            .where((textbook) => textbook.grade.contains(grade))
            .toList();
      }
      _selectedItems = List.generate(_filteredTextbooks.length, (index) => false);
    });
  }

  void _toggleSelectMode() {
    setState(() {
      _isSelectMode = !_isSelectMode;
      if (!_isSelectMode) {
        _selectedItems = List.generate(_filteredTextbooks.length, (index) => false);
      }
    });
  }

  PopupMenuItem<String> _buildPopupMenuItem(String value) {
    return PopupMenuItem<String>(
      value: value,
      height: ResponsiveSize.h(48),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(16),
            color: const Color(0xFF8B4513),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Column(
      children: [
        // 顶部按钮容器
        Padding(
          padding: EdgeInsets.all(ResponsiveSize.w(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 年级选择按钮
              PopupMenuButton<String>(
                onSelected: _filterTextbooks,
                offset: Offset(0, ResponsiveSize.h(60)),
                constraints: BoxConstraints(
                  minWidth: ResponsiveSize.w(200),
                  maxWidth: ResponsiveSize.w(200),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                  side: const BorderSide(
                    color: Color(0xFFDEB887),
                    width: 1,
                  ),
                ),
                color: Colors.white,
                elevation: 4,
                                child: Container(
                  width: ResponsiveSize.w(200),
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.w(20), 
                    vertical: ResponsiveSize.h(12)
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE4C4),
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                    border: Border.all(
                      color: const Color(0xFFDEB887),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: ResponsiveSize.w(4),
                        offset: Offset(0, ResponsiveSize.h(2)),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedGrade,
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(22),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF8B4513),
                        ),
                      ),
                      SizedBox(width: ResponsiveSize.w(8)),
                      Icon(
                        Icons.arrow_drop_down,
                        color: const Color(0xFF8B4513),
                        size: ResponsiveSize.w(28),
                      ),
                    ],
                  ),
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  _buildPopupMenuItem('全部年级'),
                  const PopupMenuDivider(height: 1),
                  _buildPopupMenuItem('一年级'),
                  const PopupMenuDivider(height: 1),
                  _buildPopupMenuItem('二年级'),
                  const PopupMenuDivider(height: 1),
                  _buildPopupMenuItem('三年级'),
                ],
              ),
              // 右侧按钮组
              Row(
                children: [
                  if (_isSelectMode) ...[
                    // 确认下载按钮
                    ElevatedButton.icon(
                      onPressed: _selectedItems.contains(true)
                          ? () {
                              // TODO: 实现下载功能
                            }
                          : null,
                      icon: Icon(
                        Icons.download_done,
                        size: ResponsiveSize.w(24),
                      ),
                      label: Text(
                        '确认下载',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(22),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                                            style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFE4C4),
                        foregroundColor: const Color(0xFF8B4513),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(40), 
                          vertical: ResponsiveSize.h(12)
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                          side: const BorderSide(
                            color: Color(0xFFDEB887),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: ResponsiveSize.w(16)),
                    // 取消按钮
                    ElevatedButton.icon(
                      onPressed: _toggleSelectMode,
                      icon: Icon(
                        Icons.close,
                        size: ResponsiveSize.w(24),
                      ),
                      label: Text(
                        '取消',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(22),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFE4C4),
                        foregroundColor: const Color(0xFF8B4513),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(40), 
                          vertical: ResponsiveSize.h(12)
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                          side: const BorderSide(
                            color: Color(0xFFDEB887),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    // 下载按钮
                    ElevatedButton.icon(
                      onPressed: _toggleSelectMode,
                      icon: Icon(
                        Icons.download,
                        size: ResponsiveSize.w(24),
                      ),
                      label: Text(
                        '下载教材',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(22),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFE4C4),
                        foregroundColor: const Color(0xFF8B4513),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(40), 
                          vertical: ResponsiveSize.h(12)
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                          side: const BorderSide(
                            color: Color(0xFFDEB887),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                                        SizedBox(width: ResponsiveSize.w(16)),
                    // 导入教材按钮
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: 实现导入教材功能
                      },
                      icon: Icon(
                        Icons.upload_file,
                        size: ResponsiveSize.w(24),
                      ),
                      label: Text(
                        '导入教材',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(22),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFE4C4),
                        foregroundColor: const Color(0xFF8B4513),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(40), 
                          vertical: ResponsiveSize.h(12)
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                          side: const BorderSide(
                            color: Color(0xFFDEB887),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        // 教材网格列表
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(ResponsiveSize.w(20)),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.75,
              crossAxisSpacing: ResponsiveSize.w(20),
              mainAxisSpacing: ResponsiveSize.h(20),
            ),
            itemCount: _filteredTextbooks.length,
            itemBuilder: (context, index) {
              final textbook = _filteredTextbooks[index];
              return Stack(
                children: [
                  _buildTextbookCard(
                    title: textbook.title,
                    grade: textbook.grade,
                    publisher: textbook.publisher,
                    coverImage: textbook.coverImage,
                  ),
                  if (_isSelectMode)
                    Positioned(
                      top: ResponsiveSize.h(8),
                      right: ResponsiveSize.w(8),
                      child: Checkbox(
                        value: _selectedItems[index],
                        onChanged: (bool? value) {
                          setState(() {
                            _selectedItems[index] = value ?? false;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(4)),
                        ),
                        activeColor: const Color(0xFF8B4513),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
    Widget _buildTextbookCard({
    required String title,
    required String grade,
    required String publisher,
    required String coverImage,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: ResponsiveSize.w(8),
            offset: Offset(0, ResponsiveSize.h(4)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 教材封面
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(ResponsiveSize.w(12)),
                ),
                image: DecorationImage(
                  image: AssetImage(coverImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // 教材信息
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(ResponsiveSize.w(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(16),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ResponsiveSize.h(4)),
                  Text(
                    grade,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(14),
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(4)),
                  Text(
                    publisher,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(14),
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}