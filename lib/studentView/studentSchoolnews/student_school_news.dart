import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';

class StudentSchoolNewsPage extends StatefulWidget {
  const StudentSchoolNewsPage({super.key});

  @override
  State<StudentSchoolNewsPage> createState() => _StudentSchoolNewsPageState();
}

class _StudentSchoolNewsPageState extends State<StudentSchoolNewsPage> {
  final TextEditingController _searchController = TextEditingController();

  // 模拟学校动态数据
  final List<SchoolNews> _newsList = [
    SchoolNews(
      title: '2024年春季开学通知',
      content: '亲爱的同学们，新学期即将开始，请做好开学准备工作...',
      date: '2024-02-25',
      type: NewsType.notice,
      isImportant: true,
      isUnread: true,
    ),
    SchoolNews(
      title: '校园文化节活动',
      content: '本周五下午将在操场举行校园文化节开幕式，欢迎同学们踊跃参加...',
      date: '2024-02-20',
      type: NewsType.activity,
      isImportant: false,
      isUnread: true,
    ),
    SchoolNews(
      title: '期末考试安排',
      content: '2023-2024学年第二学期期末考试将于7月1日开始...',
      date: '2024-02-15',
      type: NewsType.exam,
      isImportant: true,
      isUnread: true,
    ),
  ];

  NewsType? _selectedType;

  // 添加未读消息计数getter
  int get unreadCount => _newsList.where((news) => news.isUnread).length;
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
                    width: ResponsiveSize.w(100),
                    height: ResponsiveSize.h(100),
                  ),
                ),
                SizedBox(width: ResponsiveSize.w(30)),
                Row(
                  children: [
                    Text(
                      '学校动态',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(28),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF8B4513),
                      ),
                    ),
                    if (unreadCount > 0)
                      Container(
                        margin: EdgeInsets.only(left: ResponsiveSize.w(12)),
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(8),
                          vertical: ResponsiveSize.h(3),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
                        ),
                        child: Text(
                          '$unreadCount条',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveSize.sp(12),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: ResponsiveSize.w(300),
                  height: ResponsiveSize.h(46),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(23)),
                    border: Border.all(color: const Color(0xFFDEB887)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: ResponsiveSize.w(10),
                        offset: Offset(0, ResponsiveSize.h(4)),
                      ),
                    ],
                  ),
                  child: Center(
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(fontSize: ResponsiveSize.sp(16)),
                      decoration: InputDecoration(
                        hintText: '搜索动态...',
                        hintStyle: TextStyle(fontSize: ResponsiveSize.sp(16)),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFFDEB887)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        isDense: true,
                      ),
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveSize.h(30)),
                        Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: NewsType.values.map((type) => _buildTypeFilter(type)).toList(),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      for (var news in _newsList) {
                        news.isUnread = false;
                      }
                    });
                  },
                  child: Text(
                    '全部已读',
                    style: TextStyle(
                      color: const Color(0xFF8B4513),
                      fontSize: ResponsiveSize.sp(16),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveSize.h(20)),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B4513).withOpacity(0.1),
                      blurRadius: ResponsiveSize.w(10),
                      offset: Offset(0, ResponsiveSize.h(5)),
                    ),
                  ],
                ),
                child: ListView.separated(
                  padding: EdgeInsets.all(ResponsiveSize.w(20)),
                  itemCount: _newsList.length,
                  separatorBuilder: (context, index) => SizedBox(height: ResponsiveSize.h(40)),
                  itemBuilder: (context, index) => _buildNewsItem(_newsList[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeFilter(NewsType type) {
    final bool isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = isSelected ? null : type;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: ResponsiveSize.w(16)),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(20),
          vertical: ResponsiveSize.h(10),
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF6BA66).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
          border: Border.all(
            color: isSelected ? const Color(0xFFF6BA66) : Colors.grey[300]!,
            width: ResponsiveSize.w(2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              type.icon,
              color: isSelected ? const Color(0xFF8B4513) : Colors.grey[600],
              size: ResponsiveSize.w(20),
            ),
            SizedBox(width: ResponsiveSize.w(8)),
            Text(
              type.label,
              style: TextStyle(
                fontSize: ResponsiveSize.sp(16),
                color: isSelected ? const Color(0xFF8B4513) : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
    Widget _buildNewsItem(SchoolNews news) {
    return GestureDetector(
      onTap: () {
        if (news.isUnread) {
          setState(() {
            news.isUnread = false;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.all(ResponsiveSize.w(20)),
        decoration: BoxDecoration(
          color: const Color(0xFFF6BA66).withOpacity(0.1),
          borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
          border: Border.all(
            color: const Color(0xFFF6BA66).withOpacity(0.3),
            width: ResponsiveSize.w(2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveSize.w(12)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
                    boxShadow: [
                      BoxShadow(
                        color: news.type.color.withOpacity(0.2),
                        blurRadius: ResponsiveSize.w(8),
                        offset: Offset(0, ResponsiveSize.h(2)),
                      ),
                    ],
                  ),
                  child: Icon(
                    news.type.icon,
                    color: news.type.color,
                    size: ResponsiveSize.w(24),
                  ),
                ),
                if (news.isUnread)
                  Positioned(
                    right: ResponsiveSize.w(-5),
                    top: ResponsiveSize.h(-5),
                    child: Container(
                      width: ResponsiveSize.w(10),
                      height: ResponsiveSize.h(10),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: ResponsiveSize.w(20)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (news.isImportant)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveSize.w(8),
                            vertical: ResponsiveSize.h(2),
                          ),
                          margin: EdgeInsets.only(right: ResponsiveSize.w(8)),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(ResponsiveSize.w(4)),
                          ),
                          child: Text(
                            '重要',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: ResponsiveSize.sp(14),
                            ),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          news.title,
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(20),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF5C3D2E),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveSize.h(12)),
                  Text(
                    news.content,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(16),
                      color: const Color(0xFF5C3D2E),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(12)),
                  Text(
                    news.date,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(14),
                      color: Colors.grey[600],
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
}

enum NewsType {
  notice(Icons.notifications_outlined, '通知公告', Color(0xFFF6BA66)),
  activity(Icons.celebration_outlined, '活动消息', Color(0xFF8B4513)),
  exam(Icons.assignment_outlined, '考试相关', Color(0xFFDEB887));

  final IconData icon;
  final String label;
  final Color color;

  const NewsType(this.icon, this.label, this.color);
}

class SchoolNews {
  final String title;
  final String content;
  final String date;
  final NewsType type;
  final bool isImportant;
  bool isUnread;

  SchoolNews({
    required this.title,
    required this.content,
    required this.date,
    required this.type,
    required this.isImportant,
    this.isUnread = false,
  });
}