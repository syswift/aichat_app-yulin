import 'package:flutter/material.dart';
import '../studentView/student_page.dart';
import '../teacherView/teacher_page.dart';
import 'studentManage/student_manage_page.dart';
import 'classesManage/classes_manage.dart';
import 'staffManage/staff_manage_page.dart';
import 'pointsShop/points_shop_manage_page.dart';
import '../../../utils/responsive_size.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

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
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              Expanded(
                child: _buildMainContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(20), vertical: ResponsiveSize.h(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildAdminInfo(),
              SizedBox(width: ResponsiveSize.w(20)),
              _buildRoleSwitch(context),
            ],
          ),
          _buildActionButton('assets/tv.png', '投屏功能'),
        ],
      ),
    );
  }

  Widget _buildAdminInfo() {
    return SizedBox(
      width: ResponsiveSize.w(300),
      height: ResponsiveSize.h(200),
      child: Stack(
        children: [
          Positioned(
            bottom: ResponsiveSize.h(40),
            left: ResponsiveSize.w(20),
            child: Container(
              width: ResponsiveSize.w(280),
              height: ResponsiveSize.h(120),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                border: Border.all(
                  color: Colors.white,
                  width: ResponsiveSize.w(1.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: ResponsiveSize.w(8),
                    offset: Offset(0, ResponsiveSize.h(4)),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: ResponsiveSize.w(30)),
                    child: Container(
                      width: ResponsiveSize.w(90),
                      height: ResponsiveSize.h(90),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: ResponsiveSize.w(3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: ResponsiveSize.w(8),
                            offset: Offset(0, ResponsiveSize.h(4)),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/teacher.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: ResponsiveSize.w(50)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '管理员',
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(24),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2B4C80),
                          ),
                        ),
                        SizedBox(height: ResponsiveSize.h(6)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveSize.w(10),
                            vertical: ResponsiveSize.h(3),
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A6FA5).withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(ResponsiveSize.w(10)),
                          ),
                          child: Text(
                            '系统管理员',
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(16),
                              color: const Color(0xFF4A6FA5),
                              fontWeight: FontWeight.w500,
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
        ],
      ),
    );
  }

  Widget _buildRoleSwitch(BuildContext context) {
    return PopupMenuButton<String>(
      offset: Offset(0, ResponsiveSize.h(40)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.w(16), vertical: ResponsiveSize.h(10)),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A6FA5),
              Color(0xFF2B4C80),
            ],
          ),
          borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2B4C80).withOpacity(0.4),
              offset: Offset(0, ResponsiveSize.h(2)),
              blurRadius: ResponsiveSize.w(6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.switch_account,
              color: Colors.white,
              size: ResponsiveSize.w(24),
            ),
            SizedBox(width: ResponsiveSize.w(8)),
            Text(
              '切换身份',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveSize.sp(18),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: ResponsiveSize.w(8)),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
              size: ResponsiveSize.w(24),
            ),
          ],
        ),
      ),
      onSelected: (String value) {
        switch (value) {
          case 'student':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const StudentPage(),
              ),
            );
            break;
          case 'teacher':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TeacherPage(),
              ),
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'student',
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(8)),
            child: Text(
              '学生端',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(16),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'teacher',
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(8)),
            child: Text(
              '教师端',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(16),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String imageAsset, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imageAsset,
          width: ResponsiveSize.w(80),
          height: ResponsiveSize.h(80),
        ),
        SizedBox(height: ResponsiveSize.h(8)),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(20),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ResponsiveSize.w(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContentCard(context, '学员管理', 'assets/student_manage.png'),
          SizedBox(width: ResponsiveSize.w(20)),
          _buildContentCard(context, '班级管理', 'assets/class2.png'),
          SizedBox(width: ResponsiveSize.w(20)),
          _buildContentCard(context, '员工管理', 'assets/staff_manage.png'),
          SizedBox(width: ResponsiveSize.w(20)),
          _buildContentCard(context, '积分商城', 'assets/points_shop.png'),
        ],
      ),
    );
  }

  Widget _buildContentCard(
      BuildContext context, String title, String imageAsset) {
    return GestureDetector(
      onTap: () {
        switch (title) {
          case '学员管理':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StudentManagePage(),
              ),
            );
            break;
          case '班级管理':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ClassManagePage(),
              ),
            );
            break;
          case '员工管理':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StaffManagePage(),
              ),
            );
            break;
          case '积分商城':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PointsShopManagePage(),
              ),
            );
            break;
        }
      },
      child: Container(
        width: ResponsiveSize.w(240),
        height: ResponsiveSize.h(280),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
        ),
        child: Center(
          child: Container(
            width: ResponsiveSize.w(200),
            height: ResponsiveSize.h(240),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: ResponsiveSize.w(10),
                  offset: Offset(0, ResponsiveSize.h(5)),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(ResponsiveSize.w(15)),
                      topRight: Radius.circular(ResponsiveSize.w(15)),
                    ),
                    child: Image.asset(
                      imageAsset,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(28),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
