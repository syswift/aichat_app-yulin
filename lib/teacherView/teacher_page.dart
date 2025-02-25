import 'package:flutter/material.dart';
import '../studentView/student_page.dart';
import '../adminView/admin_page.dart';
import './assignTask/assign_task_page.dart';
import './textbookManage/textbook_manage_page.dart';
import './questionBankManage/question_bank_manage.dart';
import './classManage/class_manage_page.dart';
import './messages/message_page.dart';
import './schoolNews/school_news_page.dart';
import './pointsManage/points_manage_page.dart';
import '../studentView/workShow/show_room.dart';
import '../../../utils/responsive_size.dart';

class TeacherPage extends StatelessWidget {
  const TeacherPage({super.key});

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
              Expanded(child: _buildMainContent(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(20),
        vertical: ResponsiveSize.h(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildTeacherInfo(),
              SizedBox(width: ResponsiveSize.w(20)),
              _buildRoleSwitch(context),
            ],
          ),
          Row(
            children: [
              _buildActionButton(context, 'assets/message.png', '消息'),
              SizedBox(width: ResponsiveSize.w(30)),
              _buildActionButton(context, 'assets/school.png', '学校动态'),
              SizedBox(width: ResponsiveSize.w(30)),
              _buildActionButton(context, 'assets/setting.png', '设置'),
              SizedBox(width: ResponsiveSize.w(30)),
              _buildActionButton(context, 'assets/tv.png', '投屏功能'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherInfo() {
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
                          '王老师',
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
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.w(10),
                            ),
                          ),
                          child: Text(
                            '教师',
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
          horizontal: ResponsiveSize.w(16),
          vertical: ResponsiveSize.h(10),
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4A6FA5), Color(0xFF2B4C80)],
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
              MaterialPageRoute(builder: (context) => const StudentPage()),
            );
            break;
          case 'admin':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminPage()),
            );
            break;
        }
      },
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<String>>[
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
              value: 'admin',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(8)),
                child: Text(
                  '管理端',
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

  Widget _buildActionButton(
    BuildContext context,
    String imageAsset,
    String label,
  ) {
    return GestureDetector(
      onTap: () {
        if (label == '消息') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MessagePage()),
          );
        } else if (label == '学校动态') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SchoolNewsPage()),
          );
        }
      },
      child: Column(
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
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveSize.h(30),
            horizontal: ResponsiveSize.w(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildContentCard(
                    context,
                    '布置作业',
                    'assets/homework_assign.png',
                  ),
                  SizedBox(width: ResponsiveSize.w(60)),
                  _buildContentCard(
                    context,
                    '积分管理',
                    'assets/points_manage.png',
                  ),
                  SizedBox(width: ResponsiveSize.w(60)),
                  _buildContentCard(
                    context,
                    '题库管理',
                    'assets/question_bank.png',
                  ),
                ],
              ),
              SizedBox(height: ResponsiveSize.h(30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildContentCard(context, '管理班级', 'assets/class_manage.png'),
                  SizedBox(width: ResponsiveSize.w(60)),
                  _buildContentCard(context, '作品秀场', 'assets/show_manage.png'),
                  SizedBox(width: ResponsiveSize.w(60)),
                  _buildContentCard(
                    context,
                    '教材管理',
                    'assets/textbook_manage.png',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentCard(
    BuildContext context,
    String title,
    String imageAsset,
  ) {
    return GestureDetector(
      onTap: () {
        if (title == '布置作业') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AssignTaskPage()),
          );
        } else if (title == '教材管理') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TextbookManagePage()),
          );
        } else if (title == '题库管理') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const QuestionBankManagePage(),
            ),
          );
        } else if (title == '管理班级') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ClassManagePage()),
          );
        } else if (title == '积分管理') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PointsManagePage()),
          );
        } else if (title == '作品秀场') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ShowRoom(isTeacherView: true),
            ),
          );
        }
      },
      child: Container(
        width: ResponsiveSize.w(180),
        height: ResponsiveSize.h(220),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
        ),
        child: Center(
          child: Container(
            width: ResponsiveSize.w(160),
            height: ResponsiveSize.h(200),
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
