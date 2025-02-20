import 'package:flutter/material.dart';
import '../../utils/responsive_size.dart';
import 'schoolTextbooks/school_textbooks_page.dart';
import 'teacherShared/teacher_shared_page.dart';
import 'myTextbooks/my_textbooks_page.dart';

class TextbookManagePage extends StatefulWidget {
  const TextbookManagePage({super.key});

  @override
  State<TextbookManagePage> createState() => _TextbookManagePageState();
}

class _TextbookManagePageState extends State<TextbookManagePage> {
  String selectedMenu = '学校教材';

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          children: [
            // 左侧菜单
            Container(
              width: ResponsiveSize.w(200),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: ResponsiveSize.w(10),
                    offset: Offset(0, ResponsiveSize.h(4)),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 返回按钮
                  SafeArea(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(ResponsiveSize.w(16)),
                        child: Image.asset(
                          'assets/backbutton1.png',
                          width: ResponsiveSize.w(80),
                          height: ResponsiveSize.h(80),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(20)),
                  // 菜单项
                  _buildMenuItem('学校教材'),
                  _buildMenuItem('老师分享'),
                  _buildMenuItem('我的教材'),
                ],
              ),
            ),
                        // 分割线
            Container(
              width: ResponsiveSize.w(1),
              color: Colors.grey[300],
            ),
            // 右侧内容区域
            Expanded(
              child: Container(
                color: const Color(0xFFFDF5E6),
                child: Column(
                  children: [
                    // 顶部标题栏
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.w(32),
                        vertical: ResponsiveSize.h(16),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: ResponsiveSize.w(10),
                            offset: Offset(0, ResponsiveSize.h(4)),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedMenu,
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(24),
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          // 搜索框
                          Container(
                            width: ResponsiveSize.w(300),
                            height: ResponsiveSize.h(40),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                            ),
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              style: TextStyle(
                                fontSize: ResponsiveSize.sp(20),
                              ),
                              decoration: InputDecoration(
                                isCollapsed: true,
                                hintText: '搜索教材',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: ResponsiveSize.sp(20),
                                ),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(
                                    left: ResponsiveSize.w(12),
                                    right: ResponsiveSize.w(8),
                                  ),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.grey[400],
                                    size: ResponsiveSize.w(24),
                                  ),
                                ),
                                prefixIconConstraints: BoxConstraints(
                                  minWidth: ResponsiveSize.w(40),
                                  minHeight: ResponsiveSize.h(40),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                  right: ResponsiveSize.w(16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                                        // 内容区域
                    Expanded(
                      child: _buildContent(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title) {
    bool isSelected = selectedMenu == title;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(8)),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedMenu = title;
          });
        },
        child: Container(
          width: ResponsiveSize.w(160),
          padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(16)),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFE4C4) : Colors.transparent,
            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
            border: Border(
              left: BorderSide(
                color: isSelected ? const Color(0xFFDEB887) : Colors.transparent,
                width: ResponsiveSize.w(4),
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveSize.sp(22),
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFF8B4513) : Colors.grey[800],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(ResponsiveSize.w(32)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 直接显示教材内容展示区域
          Expanded(
            child: _buildContentSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    switch (selectedMenu) {
      case '学校教材':
        return const SchoolTextbooksPage();
      case '老师分享':
        return const TeacherSharedPage();
      case '我的教材':
        return const MyTextbooksPage();
      default:
        return Center(
          child: Text(
            '暂无内容',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(18),
              color: Colors.grey,
            ),
          ),
        );
    }
  }
}