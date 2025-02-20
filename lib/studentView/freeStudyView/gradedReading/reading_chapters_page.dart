import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';

class ReadingChaptersPage extends StatefulWidget {
  final String readingTitle;

  const ReadingChaptersPage({
    super.key,
    required this.readingTitle,
  });

  @override
  State<ReadingChaptersPage> createState() => _ReadingChaptersPageState();
}

class _ReadingChaptersPageState extends State<ReadingChaptersPage> {
  final int totalChapters = 30;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            title: Text(
              '搜索章节',
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
                  hintText: '请输入章节号...',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search),
                ),
                style: TextStyle(fontSize: ResponsiveSize.sp(18)),
                keyboardType: TextInputType.number,
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
    List<int> _getFilteredChapters() {
    if (_searchQuery.isEmpty) {
      return List.generate(totalChapters, (index) => index + 1);
    }
    try {
      final chapter = int.parse(_searchQuery);
      if (chapter > 0 && chapter <= totalChapters) {
        return [chapter];
      }
    } catch (_) {}
    return [];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    final filteredChapters = _getFilteredChapters();

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
                  // 顶部标题栏
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
                                widget.readingTitle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: ResponsiveSize.sp(36),
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF5C3D2E),
                                ),
                              ),
                              SizedBox(height: ResponsiveSize.h(8)),
                              Text(
                                '绘本章节',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: ResponsiveSize.sp(24),
                                  fontWeight: FontWeight.w500,
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
                                    // 章节列表
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
                          child: Padding(
                            padding: EdgeInsets.all(ResponsiveSize.w(40)),
                            child: filteredChapters.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: ResponsiveSize.w(80),
                                        color: const Color(0xFFE6B788).withOpacity(0.5),
                                      ),
                                      SizedBox(height: ResponsiveSize.h(20)),
                                      Text(
                                        '未找到相关章节',
                                        style: TextStyle(
                                          fontSize: ResponsiveSize.sp(24),
                                          color: const Color(0xFF5C3D2E).withOpacity(0.5),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                : GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: ResponsiveSize.w(40),
                                      mainAxisSpacing: ResponsiveSize.h(40),
                                      childAspectRatio: 1.1,
                                    ),
                                    itemCount: filteredChapters.length,
                                    itemBuilder: (context, index) {
                                      final chapter = filteredChapters[index];
                                      
                                      return Container(
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
                                          child: Column(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Stack(
                                                  children: [
                                                    Image.asset(
                                                      'assets/cartoon.png',
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Positioned(
                                                      right: ResponsiveSize.w(20),
                                                      top: ResponsiveSize.h(20),
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: ResponsiveSize.w(15),
                                                          vertical: ResponsiveSize.h(8),
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: const Color(0xFFE6B788),
                                                          borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
                                                        ),
                                                        child: Text(
                                                          '$chapter/$totalChapters',
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
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      '第 $chapter 章',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: const Color(0xFF5C3D2E),
                                                        fontSize: ResponsiveSize.sp(24),
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: ResponsiveSize.h(15)),
                                                                                                        Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            // TODO: 添加阅读功能
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets.symmetric(
                                                              horizontal: ResponsiveSize.w(25),
                                                              vertical: ResponsiveSize.h(10),
                                                            ),
                                                            decoration: BoxDecoration(
                                                              color: const Color(0xFFE6B788),
                                                              borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                                                            ),
                                                            child: Text(
                                                              '阅读',
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: ResponsiveSize.sp(20),
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: ResponsiveSize.w(15)),
                                                        GestureDetector(
                                                          onTap: () {
                                                            // TODO: 添加录音功能
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets.symmetric(
                                                              horizontal: ResponsiveSize.w(25),
                                                              vertical: ResponsiveSize.h(10),
                                                            ),
                                                            decoration: BoxDecoration(
                                                              color: const Color(0xFFE6B788),
                                                              borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                                                            ),
                                                            child: Text(
                                                              '录音',
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: ResponsiveSize.sp(20),
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: ResponsiveSize.h(10)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(40)),
                ],
              ),
              // 搜索按钮
              Positioned(
                top: ResponsiveSize.h(90),
                right: ResponsiveSize.w(200),
                child: GestureDetector(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}