import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';

class SchoolNewsPage extends StatefulWidget {
  const SchoolNewsPage({super.key});

  @override
  State<SchoolNewsPage> createState() => _SchoolNewsPageState();
}

class _SchoolNewsPageState extends State<SchoolNewsPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<SchoolNews> _newsList = [
    SchoolNews(
      title: '2024年春季开学通知',
      content: '亲爱的老师们，新学期即将开始，请做好开学准备工作...',
      date: '2024-02-25',
      type: NewsType.notice,
      isImportant: true,
    ),
    SchoolNews(
      title: '教师节表彰大会',
      content: '在第40个教师节来临之际，学校将举办教师表彰大会...',
      date: '2024-02-20',
      type: NewsType.activity,
      isImportant: false,
    ),
    SchoolNews(
      title: '期末考试安排',
      content: '2023-2024学年第二学期期末考试将于7月1日开始...',
      date: '2024-02-15',
      type: NewsType.exam,
      isImportant: true,
    ),
  ];

  NewsType? _selectedType;

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
            _buildTopBar(),
            SizedBox(height: ResponsiveSize.h(32)),
            _buildFilterBar(),
            SizedBox(height: ResponsiveSize.h(24)),
            _buildNewsList(),
          ],
        ),
      ),
    );
  }
    Widget _buildTopBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            'assets/backbutton1.png',
            width: ResponsiveSize.w(80),
            height: ResponsiveSize.h(80),
          ),
        ),
        SizedBox(width: ResponsiveSize.w(20)),
        Text(
          '学校动态',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(28),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8B4513),
          ),
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
          child: TextField(
            controller: _searchController,
            style: TextStyle(fontSize: ResponsiveSize.sp(20)),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: '搜索通知',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: ResponsiveSize.sp(20),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(12)),
                child: Icon(
                  Icons.search,
                  color: Colors.grey[400],
                  size: ResponsiveSize.w(24),
                ),
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: ResponsiveSize.w(46),
                minHeight: ResponsiveSize.h(46),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(16)),
              isCollapsed: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Row(
      children: [
        _buildFilterChip(NewsType.notice, '通知公告'),
        SizedBox(width: ResponsiveSize.w(16)),
        _buildFilterChip(NewsType.activity, '活动安排'),
        SizedBox(width: ResponsiveSize.w(16)),
        _buildFilterChip(NewsType.exam, '考试相关'),
      ],
    );
  }

  Widget _buildFilterChip(NewsType type, String label) {
    return FilterChip(
      selected: _selectedType == type,
      onSelected: (bool selected) {
        setState(() {
          _selectedType = selected ? type : null;
        });
      },
      label: Text(
        label,
        style: TextStyle(
          fontSize: ResponsiveSize.sp(18),
          color: _selectedType == type ? const Color(0xFF8B4513) : Colors.grey[700],
        ),
      ),
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFFFFE4C4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
        side: BorderSide(
          color: _selectedType == type ? const Color(0xFFDEB887) : Colors.grey[300]!,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(16),
        vertical: ResponsiveSize.h(8),
      ),
    );
  }
    Widget _buildNewsList() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(ResponsiveSize.w(24)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
          border: Border.all(color: const Color(0xFFDEB887)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: ResponsiveSize.w(10),
              offset: Offset(0, ResponsiveSize.h(4)),
            ),
          ],
        ),
        child: ListView.separated(
          itemCount: _filteredNews.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            return _buildNewsItem(_filteredNews[index]);
          },
        ),
      ),
    );
  }

  Widget _buildNewsItem(SchoolNews news) {
    return InkWell(
      onTap: () {
        // TODO: 显示详细内容
      },
      child: Container(
        padding: EdgeInsets.all(ResponsiveSize.w(20)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveSize.w(12)),
              decoration: BoxDecoration(
                color: news.type.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
              ),
              child: Icon(
                news.type.icon,
                color: news.type.color,
                size: ResponsiveSize.w(24),
              ),
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
                      Text(
                        news.title,
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(20),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveSize.h(8)),
                  Text(
                    news.content,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(16),
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: ResponsiveSize.w(20)),
            Text(
              news.date,
              style: TextStyle(
                fontSize: ResponsiveSize.sp(14),
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
    List<SchoolNews> get _filteredNews {
    if (_selectedType == null) {
      return _newsList;
    }
    return _newsList.where((news) => news.type == _selectedType).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class SchoolNews {
  final String title;
  final String content;
  final String date;
  final NewsType type;
  final bool isImportant;

  SchoolNews({
    required this.title,
    required this.content,
    required this.date,
    required this.type,
    required this.isImportant,
  });
}

enum NewsType {
  notice(
    icon: Icons.announcement,
    color: Color(0xFF1976D2),
  ),
  activity(
    icon: Icons.event,
    color: Color(0xFF43A047),
  ),
  exam(
    icon: Icons.assignment,
    color: Color(0xFFEF6C00),
  );

  final IconData icon;
  final Color color;

  const NewsType({
    required this.icon,
    required this.color,
  });
}