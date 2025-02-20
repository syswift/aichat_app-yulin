import 'package:flutter/material.dart';
import 'video_chapters_player.dart';
import '../../../utils/responsive_size.dart';

class VideoChaptersPage extends StatefulWidget {
  final String videoTitle;

  const VideoChaptersPage({
    super.key,
    required this.videoTitle,
  });

  @override
  State<VideoChaptersPage> createState() => _VideoChaptersPageState();
}

class _VideoChaptersPageState extends State<VideoChaptersPage> {
  final int totalChapters = 30;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _searchQuery = '';
  bool _showLocked = false;
  
  // 家长控制密码 - 实际应用中应该从安全存储中获取
  final String _parentPassword = "123456";
  
  // 存储每个章节的锁定状态
  final Map<int, bool> _lockedChapters = {};

  // 初始化章节锁定状态
  @override
  void initState() {
    super.initState();
    for (int i = 1; i <= totalChapters; i++) {
      _lockedChapters[i] = false;
    }
  }
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

  // 显示密码验证对话框
  Future<bool> _showPasswordDialog(String action) async {
    _passwordController.clear();
    bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          '家长验证',
          style: TextStyle(
            color: const Color(0xFF5C3D2E),
            fontSize: ResponsiveSize.sp(24),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              action == 'lock' ? '锁定章节需要家长密码验证' : '解锁章节需要家长密码验证',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(18),
                color: const Color(0xFF5C3D2E),
              ),
            ),
            SizedBox(height: ResponsiveSize.h(20)),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: '请输入家长密码',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
              ),
              style: TextStyle(fontSize: ResponsiveSize.sp(18)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
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
              if (_passwordController.text == _parentPassword) {
                Navigator.pop(context, true);
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      '错误提示',
                      style: TextStyle(
                        color: const Color(0xFF5C3D2E),
                        fontSize: ResponsiveSize.sp(24),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      '密码错误，请重试',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(18),
                        color: const Color(0xFF5C3D2E),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          '确定',
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
                );
              }
            },
            child: Text(
              '确认',
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
    );
    
    return result ?? false;
  }

  // 切换章节锁定状态
  Future<void> _toggleLock(int chapter) async {
    final bool isAuthenticated = await _showPasswordDialog(
      _lockedChapters[chapter]! ? 'unlock' : 'lock'
    );
    
    if (isAuthenticated) {
      setState(() {
        _lockedChapters[chapter] = !_lockedChapters[chapter]!;
      });
    }
  }

  List<int> _getFilteredChapters() {
    List<int> chapters = List.generate(totalChapters, (index) => index + 1);
    
    if (_searchQuery.isNotEmpty) {
      try {
        final chapter = int.parse(_searchQuery);
        if (chapter > 0 && chapter <= totalChapters) {
          return [chapter];
        }
        return [];
      } catch (_) {
        return [];
      }
    }

    if (_showLocked) {
      chapters = chapters.where((chapter) => _lockedChapters[chapter]!).toList();
    }
    
    return chapters;
  }
    @override
  Widget build(BuildContext context) {
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
                                widget.videoTitle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: ResponsiveSize.sp(36),
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF5C3D2E),
                                ),
                              ),
                              SizedBox(height: ResponsiveSize.h(8)),
                              Text(
                                _showLocked ? '已锁定章节' : '视频章节',
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
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          _showLocked ? Icons.lock : Icons.search_off,
                                          size: ResponsiveSize.w(80),
                                          color: const Color(0xFFE6B788).withOpacity(0.5),
                                        ),
                                        SizedBox(height: ResponsiveSize.h(20)),
                                        Text(
                                          _showLocked ? '暂无锁定的章节' : '未找到相关章节',
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
                                    itemCount: filteredChapters.length,
                                    itemBuilder: (context, index) {
                                      final chapter = filteredChapters[index];
                                      return GestureDetector(
                                        onTap: () {
                                          if (_lockedChapters[chapter]!) {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text(
                                                  '访问受限',
                                                  style: TextStyle(
                                                    color: const Color(0xFF5C3D2E),
                                                    fontSize: ResponsiveSize.sp(24),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.lock,
                                                      color: const Color(0xFFE6B788),
                                                      size: ResponsiveSize.w(50),
                                                    ),
                                                    SizedBox(height: ResponsiveSize.h(20)),
                                                    Text(
                                                      '该章节已被家长锁定，暂时无法观看',
                                                      style: TextStyle(
                                                        fontSize: ResponsiveSize.sp(18),
                                                        color: const Color(0xFF5C3D2E),
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    child: Text(
                                                      '确定',
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
                                            );
                                            return;
                                          }
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => VideoPlayerPage(
                                                currentChapter: chapter,
                                                totalChapters: totalChapters,
                                                videoTitle: widget.videoTitle,
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
                                                            'assets/cartoon.png',
                                                            width: double.infinity,
                                                            height: double.infinity,
                                                            fit: BoxFit.cover,
                                                          ),
                                                          if (_lockedChapters[chapter]!)
                                                            Container(
                                                              color: Colors.black.withOpacity(0.5),
                                                              child: Center(
                                                                child: Icon(
                                                                  Icons.lock,
                                                                  color: Colors.white,
                                                                  size: ResponsiveSize.w(50),
                                                                ),
                                                              ),
                                                            ),
                                                          Positioned(
                                                            right: ResponsiveSize.w(20),
                                                            top: ResponsiveSize.h(20),
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () => _toggleLock(chapter),
                                                                  child: Container(
                                                                    padding: EdgeInsets.all(ResponsiveSize.w(8)),
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.white.withOpacity(0.8),
                                                                      shape: BoxShape.circle,
                                                                    ),
                                                                    child: Icon(
                                                                      _lockedChapters[chapter]! ? Icons.lock : Icons.lock_open,
                                                                      color: const Color(0xFFE6B788),
                                                                      size: ResponsiveSize.w(24),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(width: ResponsiveSize.w(8)),
                                                                Container(
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
                                                              ],
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
                                                        '第 $chapter 章',
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
                                              ],
                                            ),
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
              // 搜索和锁定按钮
              Positioned(
                top: ResponsiveSize.h(90),
                right: ResponsiveSize.w(80),
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
                          _showLocked = !_showLocked;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(20)),
                        height: ResponsiveSize.h(60),
                        decoration: BoxDecoration(
                          color: _showLocked ? const Color(0xFF5C3D2E) : const Color(0xFFE6B788),
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
                              Icons.lock,
                              color: Colors.white,
                              size: ResponsiveSize.w(30),
                            ),
                            SizedBox(width: ResponsiveSize.w(8)),
                            Text(
                              '已锁定',
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
    _passwordController.dispose();
    super.dispose();
  }
}