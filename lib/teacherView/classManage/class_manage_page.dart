import 'package:flutter/material.dart';
import '../../utils/responsive_size.dart';
import 'class_members_page.dart';

class ClassManagePage extends StatefulWidget {
  const ClassManagePage({super.key});

  @override
  State<ClassManagePage> createState() => _ClassManagePageState();
}

class _ClassManagePageState extends State<ClassManagePage> {
  final TextEditingController _searchController = TextEditingController();
  
  // 模拟班级数据
  final List<ClassInfo> _classes = [
    ClassInfo(name: '一年级一班', studentCount: 45),
    ClassInfo(name: '一年级二班', studentCount: 42),
    ClassInfo(name: '二年级一班', studentCount: 48),
    ClassInfo(name: '二年级二班', studentCount: 46),
  ];

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      body: Padding(
        padding: EdgeInsets.all(ResponsiveSize.w(32)),
        child: Column(
          children: [
            // 顶部栏
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    'assets/backbutton1.png',
                    width: ResponsiveSize.w(80),
                    height: ResponsiveSize.h(80),
                  ),
                ),
                const Spacer(),
                // 搜索框
                Container(
                  width: ResponsiveSize.w(300),
                  height: ResponsiveSize.h(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                    border: Border.all(color: const Color(0xFFDEB887)),
                  ),
                  child: Center(
                    child: TextField(
                      controller: _searchController,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(20),
                        height: 1.0,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: '搜索班级',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: ResponsiveSize.sp(20),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[400],
                          size: ResponsiveSize.w(24),
                        ),
                        prefixIconConstraints: BoxConstraints(
                          minWidth: ResponsiveSize.w(40),
                          minHeight: ResponsiveSize.h(40),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: ResponsiveSize.h(10),
                          horizontal: ResponsiveSize.w(16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveSize.h(32)),
            // 班级列表
            Expanded(
              child: Container(
                padding: EdgeInsets.all(ResponsiveSize.w(24)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
                  border: Border.all(color: const Color(0xFFDEB887)),
                ),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: ResponsiveSize.w(24),
                    mainAxisSpacing: ResponsiveSize.h(24),
                    childAspectRatio: 1.2,
                  ),
                  itemCount: _classes.length,
                  itemBuilder: (context, index) {
                    return _buildClassCard(_classes[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassCard(ClassInfo classInfo) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClassMembersPage(classInfo: classInfo),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFE4C4),
          borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
          border: Border.all(color: const Color(0xFFDEB887)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: ResponsiveSize.w(10),
              offset: Offset(0, ResponsiveSize.h(4)),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              classInfo.name,
              style: TextStyle(
                fontSize: ResponsiveSize.sp(24),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8B4513),
              ),
            ),
            SizedBox(height: ResponsiveSize.h(8)),
            Text(
              '${classInfo.studentCount}名学生',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(18),
                color: const Color(0xFF8B4513),
              ),
            ),
          ],
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

class ClassInfo {
  final String name;
  final int studentCount;

  ClassInfo({
    required this.name,
    required this.studentCount,
  });
}