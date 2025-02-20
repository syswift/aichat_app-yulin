import 'package:flutter/material.dart';
import 'reading_chapters_page.dart';
import '../../../utils/responsive_size.dart';

class GradedReadingPage extends StatefulWidget {
  const GradedReadingPage({super.key});

  @override
  State<GradedReadingPage> createState() => _GradedReadingPageState();
}

class _GradedReadingPageState extends State<GradedReadingPage> {
  bool _showFavorites = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  final List<Map<String, dynamic>> readings = [
    {'title': '小红帽', 'cover': 'assets/cartoon.png', 'isFavorite': false},
    {'title': '三只小猪', 'cover': 'assets/cartoon.png', 'isFavorite': false},
    {'title': '白雪公主', 'cover': 'assets/cartoon.png', 'isFavorite': false},
    {'title': '灰姑娘', 'cover': 'assets/cartoon.png', 'isFavorite': false},
    {'title': '睡美人', 'cover': 'assets/cartoon.png', 'isFavorite': false},
    {'title': '青蛙王子', 'cover': 'assets/cartoon.png', 'isFavorite': false},
    {'title': '匹诺曹', 'cover': 'assets/cartoon.png', 'isFavorite': false},
    {'title': '美人鱼', 'cover': 'assets/cartoon.png', 'isFavorite': false},
    {'title': '阿拉丁', 'cover': 'assets/cartoon.png', 'isFavorite': false},
  ];

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            title: Text(
              '搜索阅读',
              style: TextStyle(
                color: const Color(0xFF5C3D2E),
                fontSize: ResponsiveSize.sp(24),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '请输入关键字',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search),
                ),
                style: TextStyle(fontSize: ResponsiveSize.sp(18)),
                onSubmitted: (value) {
                  setState(() {
                    _searchQuery = value.trim();
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: const Color(0xFF5C3D2E),
                    fontSize: ResponsiveSize.sp(18),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _searchQuery = _searchController.text.trim();
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  '搜索',
                  style: TextStyle(
                    color: const Color(0xFFE6B788),
                    fontSize: ResponsiveSize.sp(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
            ),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
    void _toggleFavorite(int index) {
    setState(() {
      readings[index]['isFavorite'] = !readings[index]['isFavorite'];
    });
  }

  List<Map<String, dynamic>> _getFilteredReadings() {
    List<Map<String, dynamic>> filteredReadings = readings;
    
    if (_searchQuery.isNotEmpty) {
      filteredReadings = readings.where((reading) => 
        reading['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    if (_showFavorites) {
      filteredReadings = filteredReadings.where((reading) => reading['isFavorite']).toList();
    }
    
    return filteredReadings;
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    final displayedReadings = _getFilteredReadings();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/cartoon_videobg1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: ResponsiveSize.w(50),
                      top: ResponsiveSize.h(20),
                      bottom: ResponsiveSize.h(20)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Image.asset(
                            'assets/backbutton1.png',
                            width: ResponsiveSize.w(100),
                            height: ResponsiveSize.w(100),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'GRADED READING',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: ResponsiveSize.sp(28),
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF5C3D2E),
                                ),
                              ),
                              SizedBox(height: ResponsiveSize.h(8)),
                              Text(
                                '分级阅读',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: ResponsiveSize.sp(36),
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF5C3D2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: ResponsiveSize.w(200)),
                      ],
                    ),
                  ),
                                    Expanded(
                    child: Center(
                      child: Container(
                        width: ResponsiveSize.w(1300),
                        height: ResponsiveSize.h(900),
                        margin: EdgeInsets.only(top: ResponsiveSize.h(40)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(90)),
                          border: Border.all(
                            color: const Color(0xFFE6B788).withOpacity(0.5),
                            width: ResponsiveSize.w(7),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE6B788).withOpacity(0.3),
                              offset: Offset(0, ResponsiveSize.h(4)),
                              blurRadius: ResponsiveSize.w(15),
                              spreadRadius: ResponsiveSize.w(10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(90)),
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(ResponsiveSize.w(40)),
                                child: displayedReadings.isEmpty
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.search_off,
                                              size: ResponsiveSize.w(80),
                                              color: const Color(0xFFE6B788).withOpacity(0.5),
                                            ),
                                            SizedBox(height: ResponsiveSize.h(20)),
                                            Text(
                                              _showFavorites 
                                                  ? '暂无收藏的阅读' 
                                                  : '未找到相关阅读',
                                              style: TextStyle(
                                                fontSize: ResponsiveSize.sp(24),
                                                color: const Color(0xFF5C3D2E).withOpacity(0.5),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : GridView.builder(
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: ResponsiveSize.w(40),
                                          mainAxisSpacing: ResponsiveSize.h(40),
                                          childAspectRatio: 1.3,
                                        ),
                                        itemCount: displayedReadings.length,
                                        itemBuilder: (context, index) {
                                          final reading = displayedReadings[index];
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ReadingChaptersPage(
                                                    readingTitle: reading['title']!,
                                                  ),
                                                ),
                                              );
                                            },
                                                                                        child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(ResponsiveSize.w(30)),
                                                border: Border.all(
                                                  color: const Color(0xFFE6B788).withOpacity(0.5),
                                                  width: ResponsiveSize.w(3),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color(0xFFE6B788).withOpacity(0.3),
                                                    offset: Offset(0, ResponsiveSize.h(4)),
                                                    blurRadius: ResponsiveSize.w(8),
                                                    spreadRadius: ResponsiveSize.w(2),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(ResponsiveSize.w(30)),
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Expanded(
                                                          child: Stack(
                                                            children: [
                                                              Image.asset(
                                                                reading['cover']!,
                                                                width: double.infinity,
                                                                height: double.infinity,
                                                                fit: BoxFit.cover,
                                                              ),
                                                              Positioned(
                                                                left: ResponsiveSize.w(20),
                                                                top: ResponsiveSize.h(20),
                                                                child: Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                    horizontal: ResponsiveSize.w(20),
                                                                    vertical: ResponsiveSize.h(8),
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                    color: const Color(0xFFE6B788),
                                                                    borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                                                                  ),
                                                                  child: Text(
                                                                    '阅读',
                                                                    style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: ResponsiveSize.sp(16),
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          width: double.infinity,
                                                          padding: EdgeInsets.symmetric(
                                                            vertical: ResponsiveSize.h(15),
                                                            horizontal: ResponsiveSize.w(20),
                                                          ),
                                                          decoration: const BoxDecoration(
                                                            color: Color(0xFFFBE4D8),
                                                          ),
                                                          child: Text(
                                                            reading['title']!,
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              color: const Color(0xFF5C3D2E),
                                                              fontSize: ResponsiveSize.sp(24),
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                                                                        Positioned(
                                                      right: ResponsiveSize.w(20),
                                                      top: ResponsiveSize.h(20),
                                                      child: GestureDetector(
                                                        onTap: () => _toggleFavorite(readings.indexOf(reading)),
                                                        child: Icon(
                                                          reading['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                                                          color: const Color(0xFFE6B788),
                                                          size: ResponsiveSize.w(30),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(40)),
                ],
              ),
              // 搜索和收藏按钮
              Positioned(
                top: ResponsiveSize.h(90),
                right: ResponsiveSize.w(200),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _showSearchDialog,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(20)),
                        height: ResponsiveSize.h(60),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6B788),
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(30)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE6B788).withOpacity(0.3),
                              offset: Offset(0, ResponsiveSize.h(4)),
                              blurRadius: ResponsiveSize.w(8),
                              spreadRadius: ResponsiveSize.w(2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.white,
                              size: ResponsiveSize.w(30),
                            ),
                            SizedBox(width: ResponsiveSize.w(8)),
                            Text(
                              '搜索',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ResponsiveSize.sp(24),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: ResponsiveSize.w(20)),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showFavorites = !_showFavorites;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(20)),
                        height: ResponsiveSize.h(60),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6B788),
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(30)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE6B788).withOpacity(0.3),
                              offset: Offset(0, ResponsiveSize.h(4)),
                              blurRadius: ResponsiveSize.w(8),
                              spreadRadius: ResponsiveSize.w(2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _showFavorites ? Icons.favorite : Icons.favorite_border,
                              color: Colors.white,
                              size: ResponsiveSize.w(30),
                            ),
                            SizedBox(width: ResponsiveSize.w(8)),
                            Text(
                              '收藏',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ResponsiveSize.sp(24),
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}