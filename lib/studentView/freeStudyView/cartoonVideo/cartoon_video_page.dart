import 'package:flutter/material.dart';
import 'video_chapters.dart';
import '../../../utils/responsive_size.dart';

class CartoonVideoPage extends StatefulWidget {
  const CartoonVideoPage({super.key});

  @override
  State<CartoonVideoPage> createState() => _CartoonVideoPageState();
}

class _CartoonVideoPageState extends State<CartoonVideoPage> {
  bool _showFavorites = false;
  bool _showLocked = false; // 新增：显示锁定视频
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _searchQuery = '';
  
  // 家长控制密码 - 实际应用中应该从安全存储中获取
  final String _parentPassword = "123456";
  
  final List<Map<String, dynamic>> videos = [
    {
      'title': 'Hlecang', 
      'cover': 'assets/cartoon.png', 
      'isFavorite': false,
      'isLocked': false,
    },
    {
      'title': 'Colrcotics', 
      'cover': 'assets/cartoon.png', 
      'isFavorite': false,
      'isLocked': false,
    },
    {
      'title': 'Meiregttlacs', 
      'cover': 'assets/cartoon.png', 
      'isFavorite': false,
      'isLocked': false,
    },
    {
      'title': 'Memes', 
      'cover': 'assets/cartoon.png', 
      'isFavorite': false,
      'isLocked': false,
    },
    {
      'title': 'Video 5', 
      'cover': 'assets/cartoon.png', 
      'isFavorite': false,
      'isLocked': false,
    },
    {
      'title': 'Video 6', 
      'cover': 'assets/cartoon.png', 
      'isFavorite': false,
      'isLocked': false,
    },
    {
      'title': 'Video 7', 
      'cover': 'assets/cartoon.png', 
      'isFavorite': false,
      'isLocked': false,
    },
    {
      'title': 'Video 8', 
      'cover': 'assets/cartoon.png', 
      'isFavorite': false,
      'isLocked': false,
    },
    {
      'title': 'Video 9', 
      'cover': 'assets/cartoon.png', 
      'isFavorite': false,
      'isLocked': false,
    },
  ];

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            title: Text(
              '搜索视频',
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
      videos[index]['isFavorite'] = !videos[index]['isFavorite'];
    });
  }
    List<Map<String, dynamic>> _getFilteredVideos() {
    List<Map<String, dynamic>> filteredVideos = videos;
    
    if (_searchQuery.isNotEmpty) {
      filteredVideos = videos.where((video) => 
        video['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    if (_showFavorites) {
      filteredVideos = filteredVideos.where((video) => video['isFavorite']).toList();
    }

    // 新增：显示锁定视频
    if (_showLocked) {
      filteredVideos = filteredVideos.where((video) => video['isLocked']).toList();
    }
    
    return filteredVideos;
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
              action == 'lock' ? '锁定视频需要家长密码验证' : '解锁视频需要家长密码验证',
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

  // 切换视频锁定状态
  Future<void> _toggleLock(int index) async {
    final video = videos[index];
    final bool isAuthenticated = await _showPasswordDialog(
      video['isLocked'] ? 'unlock' : 'lock'
    );
    
    if (isAuthenticated) {
      setState(() {
        video['isLocked'] = !video['isLocked'];
      });
    }
  }
    @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    final displayedVideos = _getFilteredVideos();

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
                                'CARTOON VIDEO',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: ResponsiveSize.sp(28),
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF5C3D2E),
                                ),
                              ),
                              SizedBox(height: ResponsiveSize.h(8)),
                              Text(
                                _showLocked ? '已锁定视频' : '动画视频',
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
                                    // 主内容区
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: ResponsiveSize.h(40)),
                      child: Center(
                        child: Container(
                          width: ResponsiveSize.w(1300),
                          height: ResponsiveSize.h(900),
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
                                  child: displayedVideos.isEmpty
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
                                                _showLocked 
                                                    ? '暂无锁定的视频'
                                                    : (_showFavorites 
                                                        ? '暂无收藏的视频' 
                                                        : '未找到相关视频'),
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
                                          itemCount: displayedVideos.length,
                                          itemBuilder: (context, index) {
                                            final video = displayedVideos[index];
                                            return GestureDetector(
                                              onTap: () {
                                                if (video['isLocked']) {
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
                                                            '该视频已被家长锁定，暂时无法观看',
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
                                                    builder: (context) => VideoChaptersPage(
                                                      videoTitle: video['title']!,
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
                                                                  video['cover']!,
                                                                  width: double.infinity,
                                                                  height: double.infinity,
                                                                  fit: BoxFit.cover,
                                                                ),
                                                                if (video['isLocked'])
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
                                                                      '视频',
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
                                                            decoration: BoxDecoration(
                                                              color: const Color(0xFFFBE4D8),
                                                              borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius.circular(ResponsiveSize.w(30)),
                                                                bottomRight: Radius.circular(ResponsiveSize.w(30)),
                                                              ),
                                                            ),
                                                            child: Text(
                                                              video['title']!,
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
                                                        child: Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () => _toggleLock(videos.indexOf(video)),
                                                              child: Container(
                                                                padding: EdgeInsets.all(ResponsiveSize.w(8)),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white.withOpacity(0.8),
                                                                  shape: BoxShape.circle,
                                                                ),
                                                                child: Icon(
                                                                  video['isLocked'] ? Icons.lock : Icons.lock_open,
                                                                  color: const Color(0xFFE6B788),
                                                                  size: ResponsiveSize.w(24),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: ResponsiveSize.w(8)),
                                                            GestureDetector(
                                                              onTap: () => _toggleFavorite(videos.indexOf(video)),
                                                              child: Container(
                                                                padding: EdgeInsets.all(ResponsiveSize.w(8)),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white.withOpacity(0.8),
                                                                  shape: BoxShape.circle,
                                                                ),
                                                                child: Icon(
                                                                  video['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                                                                  color: const Color(0xFFE6B788),
                                                                  size: ResponsiveSize.w(24),
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
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(40)),
                ],
              ),
              // 搜索、收藏和锁定按钮
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
                          _showFavorites = !_showFavorites;
                          if (_showFavorites) _showLocked = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(20)),
                        height: ResponsiveSize.h(60),
                        decoration: BoxDecoration(
                          color: _showFavorites ? const Color(0xFF5C3D2E) : const Color(0xFFE6B788),
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
                    SizedBox(width: ResponsiveSize.w(20)),
                    // 新增：锁定视频按钮
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showLocked = !_showLocked;
                          if (_showLocked) _showFavorites = false;
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