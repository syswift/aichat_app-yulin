import 'package:flutter/material.dart';
import '../../utils/responsive_size.dart';
import 'class_manage_page.dart';
import 'student_detail_page.dart';
import '../../adminView/models/student_model.dart';

class ClassMembersPage extends StatefulWidget {
  final ClassInfo classInfo;

  const ClassMembersPage({super.key, required this.classInfo});

  @override
  State<ClassMembersPage> createState() => _ClassMembersPageState();
}

class _ClassMembersPageState extends State<ClassMembersPage> {
  final TextEditingController _searchController = TextEditingController();

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
                SizedBox(width: ResponsiveSize.w(20)),
                Text(
                  widget.classInfo.name,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(24),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8B4513),
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
                        hintText: '搜索学生',
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
            // 学生列表
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
                    crossAxisCount: 6,
                    crossAxisSpacing: ResponsiveSize.w(24),
                    mainAxisSpacing: ResponsiveSize.h(24),
                    childAspectRatio: 0.8,
                  ),
                  itemCount: widget.classInfo.studentCount,
                  itemBuilder: (context, index) {
                    return _buildStudentCard(index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentDetailPage(
              student: Student(
                id: 'student_$index',
                name: '学生${index + 1}',
                contact: '家长${index + 1}',
                phone: '1380013800$index',
                classNames: [widget.classInfo.name],
                level: 'Level 1',
                planner: '王老师',
                joinDate: DateTime.now(),
              ),
            ),
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
            CircleAvatar(
              radius: ResponsiveSize.w(40),
              backgroundColor: Colors.white,
              child: Text(
                '学生${index + 1}',
                style: TextStyle(
                  color: const Color(0xFF8B4513),
                  fontSize: ResponsiveSize.sp(14),
                ),
              ),
            ),
            SizedBox(height: ResponsiveSize.h(8)),
            Text(
              '学生${index + 1}',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(16),
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