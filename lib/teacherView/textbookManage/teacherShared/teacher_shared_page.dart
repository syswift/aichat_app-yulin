import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';

class TextbookItem {
  final String title;
  final String grade;
  final String teacher;
  final String shareDate;
  final int downloads;
  final String coverImage;

  TextbookItem({
    required this.title,
    required this.grade,
    required this.teacher,
    required this.shareDate,
    required this.downloads,
    required this.coverImage,
  });
}

class TeacherSharedPage extends StatefulWidget {
  const TeacherSharedPage({super.key});

  @override
  State<TeacherSharedPage> createState() => _TeacherSharedPageState();
}

class _TeacherSharedPageState extends State<TeacherSharedPage> {
  String _selectedGrade = '全部年级';
  
  final List<TextbookItem> _allTextbooks = [
    TextbookItem(
      title: '分享教材 1',
      grade: '一年级',
      teacher: '张老师',
      shareDate: '2024-03-20',
      downloads: 128,
      coverImage: 'assets/cartoon.png',
    ),
    TextbookItem(
      title: '分享教材 2',
      grade: '二年级',
      teacher: '李老师',
      shareDate: '2024-03-19',
      downloads: 256,
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
              return _buildSharedTextbookCard(
                title: textbook.title,
                grade: textbook.grade,
                teacher: textbook.teacher,
                shareDate: textbook.shareDate,
                downloads: textbook.downloads,
                coverImage: textbook.coverImage,
              );
            },
          ),
        ),
              ],
    );
  }

  Widget _buildSharedTextbookCard({
    required String title,
    required String grade,
    required String teacher,
    required String shareDate,
    required int downloads,
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
                        '分享者: $teacher',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(14),
                          color: Colors.grey[600],
                        ),
                      ),
                                            Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            shareDate,
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(14),
                              color: Colors.grey[600],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveSize.w(8),
                              vertical: ResponsiveSize.h(4),
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6F3FF),
                              borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.download_rounded,
                                  size: ResponsiveSize.w(16),
                                  color: const Color(0xFF1E88E5),
                                ),
                                SizedBox(width: ResponsiveSize.w(4)),
                                Text(
                                  downloads.toString(),
                                  style: TextStyle(
                                    fontSize: ResponsiveSize.sp(14),
                                    color: const Color(0xFF1E88E5),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: ResponsiveSize.h(8),
            right: ResponsiveSize.w(8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // TODO: 实现下载功能
                },
                borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                child: Container(
                  padding: EdgeInsets.all(ResponsiveSize.w(8)),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: ResponsiveSize.w(4),
                        offset: Offset(0, ResponsiveSize.h(2)),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.download_rounded,
                    color: const Color(0xFF1E88E5),
                    size: ResponsiveSize.w(24),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}