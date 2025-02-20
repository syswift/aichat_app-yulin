import 'package:flutter/material.dart';
import '../teacherView/teacher_page.dart';
import '../adminView/admin_page.dart';
import 'aiStudy/ai_studyroom.dart';
import 'todayHomework/today_homework_page.dart';
import './freeStudyView/free_study_page.dart';
import './fixedStudyView/fixed_study_page.dart';
import 'pointsExchange/points_exchange_page.dart';
import 'historyRecord/reading_history.dart';
import './parentCenter/parent_auth_page.dart';
import 'personalInfo/personal_info_page.dart';
import 'workShow/show_room.dart';
import 'messageReceive/message_receive_page.dart';
import './studentSchoolnews/student_school_news.dart';
import '../utils/responsive_size.dart';
import './freeStudyView/happyListen/happy_listen_chapters.dart';

class StudentPage extends StatelessWidget {
  const StudentPage({super.key});
  final int unreadCount = 2;
  final int unreadNewsCount = 3;

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
                child: Stack(
                  children: [
                    _buildStudentInfo(context),
                    _buildMainContent(context),
                  ],
                ),
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
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PersonalInfoPage(),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/rabbit.png',
                      width: ResponsiveSize.w(300),
                      height: ResponsiveSize.h(200),
                    ),
                  ),
                  Positioned(
                    bottom: ResponsiveSize.h(60),
                    left: ResponsiveSize.w(120),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PersonalInfoPage(),
                          ),
                        );
                      },
                      child: Text(
                        '陈超学员',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(28),
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: ResponsiveSize.w(20)),
              _buildRoleSwitch(context),
            ],
          ),
          _buildTopRightButtons(context),
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
          case 'teacher':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TeacherPage(),
              ),
            );
            break;
          case 'admin':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminPage(),
              ),
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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

  Widget _buildTopRightButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFeatureButton(
          icon: 'assets/happylistenicon.png',
          label: '磨耳朵',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HappyListenPage(), // 直接跳转到快乐听页面
              ),
            );
          },
        ),
        SizedBox(width: ResponsiveSize.w(30)),
        _buildFeatureButton(
          icon: 'assets/show.png',
          label: '作品秀场',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ShowRoom(),
              ),
            );
          },
        ),
        SizedBox(width: ResponsiveSize.w(30)),
        _buildFeatureButton(
          icon: 'assets/tv.png',
          label: '投屏功能',
          onTap: () {
            // TODO: 处理投屏功能点击事件
          },
        ),
        SizedBox(width: ResponsiveSize.w(30)),
        _buildFeatureButton(
          icon: 'assets/parent.png',
          label: '家长管理',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ParentAuthPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeatureButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            width: ResponsiveSize.w(80),
            height: ResponsiveSize.w(80),
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

  Widget _buildStudentInfo(BuildContext context) {
    return Positioned(
      left: ResponsiveSize.px(20),
      top: ResponsiveSize.py(20),
      child: Container(
        width: ResponsiveSize.w(280),
        height: ResponsiveSize.h(580),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
        ),
        child: Center(
          child: Container(
            width: ResponsiveSize.w(240),
            height: ResponsiveSize.h(550),
            margin: EdgeInsets.all(ResponsiveSize.w(10)),
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
                Container(
                  width: double.infinity,
                  height: ResponsiveSize.h(200),
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/container.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(ResponsiveSize.w(15)),
                      topRight: Radius.circular(ResponsiveSize.w(15)),
                    ),
                  ),
                  padding: EdgeInsets.all(ResponsiveSize.w(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: ResponsiveSize.w(45),
                        backgroundImage: const AssetImage('assets/AIStudy.png'),
                      ),
                      SizedBox(height: ResponsiveSize.h(15)),
                      Text(
                        '示例学生',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(24),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(30)),
                _buildInfoRow(Icons.star, '20', '0', '0'),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.all(ResponsiveSize.w(20)),
                  child: _buildActionButtons(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String stars, String medals, String cups) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Image.asset(
              'assets/star.png',
              width: ResponsiveSize.w(35),
              height: ResponsiveSize.w(35),
            ),
            SizedBox(height: ResponsiveSize.h(8)),
            Text(
              stars,
              style: TextStyle(
                fontSize: ResponsiveSize.sp(22),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Image.asset(
              'assets/flower.png',
              width: ResponsiveSize.w(35),
              height: ResponsiveSize.w(35),
            ),
            SizedBox(height: ResponsiveSize.h(8)),
            Text(
              medals,
              style: TextStyle(
                fontSize: ResponsiveSize.sp(22),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Image.asset(
              'assets/medal.png',
              width: ResponsiveSize.w(35),
              height: ResponsiveSize.w(35),
            ),
            SizedBox(height: ResponsiveSize.h(8)),
            Text(
              cups,
              style: TextStyle(
                fontSize: ResponsiveSize.sp(22),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MessagePage(),
              ),
            );
          },
          child: _buildActionButton('assets/message.png', '消息'),
        ),
        SizedBox(height: ResponsiveSize.h(20)),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StudentSchoolNewsPage(),
              ),
            );
          },
          child: _buildActionButton('assets/school.png', '学校动态'),
        ),
        SizedBox(height: ResponsiveSize.h(20)),
        _buildActionButton('assets/setting.png', '设置'),
      ],
    );
  }

  Widget _buildActionButton(String imageAsset, String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(10)),
      child: Row(
        children: [
          Image.asset(
            imageAsset,
            width: ResponsiveSize.w(32),
            height: ResponsiveSize.w(32),
          ),
          SizedBox(width: ResponsiveSize.w(20)),
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if ((label == '消息' && unreadCount > 0) ||
                  (label == '学校动态' && unreadNewsCount > 0))
                Container(
                  margin: EdgeInsets.only(left: ResponsiveSize.w(8)),
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.w(8),
                      vertical: ResponsiveSize.h(3)),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
                  ),
                  child: Text(
                    '${label == '消息' ? unreadCount : unreadNewsCount}条',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveSize.sp(12),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Positioned(
      left: ResponsiveSize.px(320),
      top: ResponsiveSize.py(20),
      right: ResponsiveSize.px(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // 阶段闯关（原固定学）
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FixedStudyPage(),
                    ),
                  );
                },
                child: _buildContentCard('阶段闯关', 'assets/fixstudy.png'),
              ),
              SizedBox(width: ResponsiveSize.w(20)),
              // 自由学
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FreeStudyPage(),
                    ),
                  );
                },
                child: _buildContentCard('自由学', 'assets/freestudy.png'),
              ),
              SizedBox(width: ResponsiveSize.w(20)),

              // 每日作业
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TodayHomeworkPage(),
                    ),
                  );
                },
                child: _buildContentCard('每日作业', 'assets/homework.png'),
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.h(20)),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReadingHistoryPage(),
                    ),
                  );
                },
                child: _buildContentCard('最近学习', 'assets/readinghistory.png'),
              ),
              SizedBox(width: ResponsiveSize.w(20)),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AIStudyRoom(),
                    ),
                  );
                },
                child: _buildContentCard('AI对练', 'assets/AIStudy.png'),
              ),
              SizedBox(width: ResponsiveSize.w(20)),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PointsExchangePage(),
                    ),
                  );
                },
                child: _buildContentCard('积分兑换', 'assets/points.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(String title, String imageAsset) {
    return Container(
      width: ResponsiveSize.w(240),
      height: ResponsiveSize.h(280),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
      ),
      child: Center(
        child: Container(
          width: ResponsiveSize.w(210),
          height: ResponsiveSize.h(250),
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
                flex: 7,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(ResponsiveSize.w(15)),
                      topRight: Radius.circular(ResponsiveSize.w(15)),
                    ),
                    image: DecorationImage(
                      image: AssetImage(imageAsset),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
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
    );
  }
}
