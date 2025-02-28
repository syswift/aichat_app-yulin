import 'package:flutter/material.dart';
import './schoolQuestion/school_question_bank.dart';
import './myQuestion/my_question_bank.dart';
import './singleQuestion/single_question.dart';
import '../../utils/responsive_size.dart';
import '../../services/background_service.dart';

class QuestionBankManagePage extends StatefulWidget {
  const QuestionBankManagePage({super.key});

  @override
  State<QuestionBankManagePage> createState() => _QuestionBankManagePageState();
}

class _QuestionBankManagePageState extends State<QuestionBankManagePage> {
  String selectedMenu = '学校题库';
  final TextEditingController _searchController = TextEditingController();
  final BackgroundService _backgroundService = BackgroundService();

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);

    return Scaffold(
      body: FutureBuilder<ImageProvider>(
        future: _backgroundService.getBackgroundImage(),
        builder: (context, snapshot) {
          final backgroundImage =
              snapshot.data ?? const AssetImage('assets/background.jpg');

          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: backgroundImage, fit: BoxFit.cover),
            ),
            child: Row(
              children: [
                // 左侧菜单栏部分
                Container(
                  width: ResponsiveSize.w(280),
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
                      _buildMenuItem('学校题库'),
                      _buildMenuItem('我的题库'),
                      _buildMenuItem('单项习题'),
                    ],
                  ),
                ),
                // 分割线
                Container(width: ResponsiveSize.w(1), color: Colors.grey[300]),
                // 右侧内容区域
                Expanded(
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
                              color: Colors.black.withOpacity(0.15),
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
                                borderRadius: BorderRadius.circular(
                                  ResponsiveSize.w(20),
                                ),
                              ),
                              child: TextField(
                                controller: _searchController,
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                  fontSize: ResponsiveSize.sp(20),
                                ),
                                decoration: InputDecoration(
                                  isCollapsed: true,
                                  hintText: '搜索题库',
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
                        child: Container(
                          color: const Color(0xFFFDF5E6),
                          child: _buildContent(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(String title) {
    bool isSelected = selectedMenu == title;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveSize.h(8),
        horizontal: ResponsiveSize.w(12),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedMenu = title;
          });
        },
        child: Container(
          width: ResponsiveSize.w(240),
          padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(16)),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFE4C4) : Colors.transparent,
            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
            border: Border(
              left: BorderSide(
                color:
                    isSelected ? const Color(0xFFDEB887) : Colors.transparent,
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
    switch (selectedMenu) {
      case '学校题库':
        return const SchoolQuestionBankPage();
      case '我的题库':
        return const MyQuestionBankPage();
      case '单项习题':
        return const SingleQuestionPage();
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
