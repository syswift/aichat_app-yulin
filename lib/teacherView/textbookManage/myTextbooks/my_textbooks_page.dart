import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';
import 'create_textbook_page.dart';

class TextbookItem {
  final String title;
  final String grade;
  final String lastUsed;
  final String coverImage;

  TextbookItem({
    required this.title,
    required this.grade,
    required this.lastUsed,
    required this.coverImage,
  });
}

class MyTextbooksPage extends StatefulWidget {
  const MyTextbooksPage({super.key});

  @override
  State<MyTextbooksPage> createState() => _MyTextbooksPageState();
}

class _MyTextbooksPageState extends State<MyTextbooksPage> {
  String _selectedGrade = '全部年级';

  final List<TextbookItem> _allTextbooks = [
    TextbookItem(
      title: '我的教材 1',
      grade: '一年级',
      lastUsed: '2024-03-20',
      coverImage: 'assets/cartoon.png',
    ),
    TextbookItem(
      title: '我的教材 2',
      grade: '二年级',
      lastUsed: '2024-03-19',
      coverImage: 'assets/cartoon.png',
    ),
  ];

  late List<TextbookItem> _filteredTextbooks;
    @override
  void initState() {
    super.initState();
    _filteredTextbooks = List.from(_allTextbooks);
  }

  void _filterByGrade(String grade) {
    setState(() {
      _selectedGrade = grade;
      if (grade == '全部年级') {
        _filteredTextbooks = List.from(_allTextbooks);
      } else {
        _filteredTextbooks = _allTextbooks
            .where((textbook) => textbook.grade == grade)
            .toList();
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
        Padding(
          padding: EdgeInsets.all(ResponsiveSize.w(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PopupMenuButton<String>(
                onSelected: _filterByGrade,
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
              Row(
                children: [
                  SizedBox(
                    width: ResponsiveSize.w(160),
                    height: ResponsiveSize.h(56),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateTextbookPage(),
                          ),
                        );
                      },
                                            icon: Icon(
                        Icons.add_circle_outline,
                        size: ResponsiveSize.w(28),
                      ),
                      label: Text(
                        '创建',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(22),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFE4C4),
                        foregroundColor: const Color(0xFF8B4513),
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(20)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                          side: const BorderSide(
                            color: Color(0xFFDEB887),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.w(16)),
                  SizedBox(
                    width: ResponsiveSize.w(160),
                    height: ResponsiveSize.h(56),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: 实现添加功能
                      },
                      icon: Icon(
                        Icons.file_upload_outlined,
                        size: ResponsiveSize.w(28),
                      ),
                      label: Text(
                        '添加',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(22),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFE4C4),
                        foregroundColor: const Color(0xFF8B4513),
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(20)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                          side: const BorderSide(
                            color: Color(0xFFDEB887),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.w(16)),
                  SizedBox(
                    width: ResponsiveSize.w(160),
                    height: ResponsiveSize.h(56),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: 实现编辑功能
                      },
                                            icon: Icon(
                        Icons.edit_note,
                        size: ResponsiveSize.w(28),
                      ),
                      label: Text(
                        '编辑',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(22),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFE4C4),
                        foregroundColor: const Color(0xFF8B4513),
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(20)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                          side: const BorderSide(
                            color: Color(0xFFDEB887),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
              return _buildMyTextbookCard(
                title: textbook.title,
                grade: textbook.grade,
                lastUsed: textbook.lastUsed,
                coverImage: textbook.coverImage,
              );
            },
          ),
        ),
      ],
    );
  }
    Widget _buildMyTextbookCard({
    required String title,
    required String grade,
    required String lastUsed,
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
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(ResponsiveSize.w(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Text(
                        grade,
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(14),
                          color: const Color(0xFF1E88E5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '最近使用: $lastUsed',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(14),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // 自制标签
          Positioned(
            top: ResponsiveSize.h(16),
            left: ResponsiveSize.w(16),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.w(12),
                vertical: ResponsiveSize.h(6),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3),
                borderRadius: BorderRadius.circular(ResponsiveSize.w(6)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: ResponsiveSize.w(4),
                    offset: Offset(0, ResponsiveSize.h(2)),
                  ),
                ],
              ),
              child: Text(
                '自制',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(14),
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          // 编辑和删除按钮
          Positioned(
            top: ResponsiveSize.h(8),
            right: ResponsiveSize.w(8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: ResponsiveSize.w(24),
                  ),
                  onPressed: () {
                    // TODO: 实现编辑功能
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: ResponsiveSize.w(24),
                  ),
                  onPressed: () {
                    // TODO: 实现删除功能
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}