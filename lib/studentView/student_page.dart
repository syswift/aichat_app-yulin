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
//import 'personalInfo/personal_info_page.dart';
import 'workShow/show_room.dart';
import 'messageReceive/message_receive_page.dart';
import './studentSchoolnews/student_school_news.dart';
import '../utils/responsive_size.dart';
import './freeStudyView/happyListen/happy_listen_chapters.dart';
import '../common/widgets/logout_button.dart';
import '../common/widgets/profile_username_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/background_service.dart';

// Get Supabase client instance
final supabase = Supabase.instance.client;

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final int unreadCount = 2;
  final int unreadNewsCount = 3;
  final BackgroundService _backgroundService = BackgroundService();

  @override
  void initState() {
    super.initState();
    // Removed _loadUserProfile() call as ProfileUsernameWidget handles it
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<ImageProvider>(
            future: _backgroundService.getBackgroundImage(),
            builder: (context, snapshot) {
              final backgroundImage =
                  snapshot.data ?? const AssetImage('assets/background.jpg');

              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: backgroundImage,
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
              );
            },
          ),
          // Logout button in bottom-right corner
          Positioned(right: 20, bottom: 20, child: const LogoutButton()),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(20),
        vertical: ResponsiveSize.h(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the entire row
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //_buildRoleSwitch(context),
              SizedBox(
                width: ResponsiveSize.w(40),
              ), // Add spacing between elements
              _buildTopRightButtons(context),
            ],
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
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
          case 'teacher':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TeacherPage()),
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
              MaterialPageRoute(builder: (context) => const ShowRoom()),
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
              MaterialPageRoute(builder: (context) => const ParentAuthPage()),
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
    double screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
      left: (screenWidth - ResponsiveSize.w(920)) / 2, // Center horizontally
      bottom: ResponsiveSize.py(120), // Changed from top to bottom
      child: Container(
        width: ResponsiveSize.w(920), // Increased width
        height: ResponsiveSize.h(120), // Reduced height
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
        ),
        child: Center(
          child: Container(
            width: ResponsiveSize.w(900), // Adjusted width
            height: ResponsiveSize.h(100), // Adjusted height
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
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center row contents
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center vertically
              children: [
                Container(
                  width: ResponsiveSize.w(200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: ResponsiveSize.w(25),
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(
                          Icons.person,
                          size: ResponsiveSize.w(30),
                          color: Colors.blue.shade800,
                        ),
                      ),
                      SizedBox(width: ResponsiveSize.w(10)),
                      const ProfileUsernameWidget(
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B4C80),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: ResponsiveSize.w(280), // Reduced from 300
                  height: double.infinity, // Take full height of parent
                  alignment: Alignment.center, // Center content
                  child: _buildInfoRow(Icons.star, '20', '0', '0'),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.w(15), // Reduced from 20
                    ),
                    child: Row(
                      // Changed from Column to Row
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const StudentSchoolNewsPage(),
                              ),
                            );
                          },
                          child: _buildActionButton(
                            'assets/school.png',
                            '学校动态',
                          ),
                        ),
                        _buildActionButton('assets/setting.png', '设置'),
                      ],
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

  // Modify the action button to be more compact
  Widget _buildActionButton(String imageAsset, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imageAsset,
          width: ResponsiveSize.w(28),
          height: ResponsiveSize.w(28),
        ),
        SizedBox(width: ResponsiveSize.w(10)),
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveSize.sp(18),
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            if ((label == '消息' && unreadCount > 0) ||
                (label == '学校动态' && unreadNewsCount > 0))
              Container(
                margin: EdgeInsets.only(left: ResponsiveSize.w(8)),
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.w(6),
                  vertical: ResponsiveSize.h(2),
                ),
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
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String stars,
    String medals,
    String cups,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min, // Added to take only necessary space
      crossAxisAlignment: CrossAxisAlignment.center, // Center items vertically
      children: [
        _buildInfoItem('assets/star.png', stars),
        _buildInfoItem('assets/flower.png', medals),
        _buildInfoItem('assets/medal.png', cups),
      ],
    );
  }

  Widget _buildInfoItem(String imageAsset, String count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(10)),
      child: Row(
        // Changed to Row for horizontal layout
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imageAsset,
            width: ResponsiveSize.w(30),
            height: ResponsiveSize.w(30),
          ),
          SizedBox(width: ResponsiveSize.w(5)),
          Text(
            count,
            style: TextStyle(
              fontSize: ResponsiveSize.sp(20),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double contentWidth = ResponsiveSize.w(
      180 * 3 + 35 * 2,
    ); // Calculate total width of content

    return Positioned(
      left: (screenWidth - contentWidth) / 2, // Center horizontally
      top: ResponsiveSize.py(120),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center the cards
            children: [
              GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FixedStudyPage(),
                      ),
                    ),
                child: _buildContentCard('阶段闯关', 'assets/fixstudy.png'),
              ),
              SizedBox(width: ResponsiveSize.w(35)),
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
              SizedBox(width: ResponsiveSize.w(35)), // Reduced from 40
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
          SizedBox(height: ResponsiveSize.h(8)), // Reduced from 10
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center the cards
            children: [
              GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReadingHistoryPage(),
                      ),
                    ),
                child: _buildContentCard('最近学习', 'assets/readinghistory.png'),
              ),
              SizedBox(width: ResponsiveSize.w(35)),
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
              SizedBox(width: ResponsiveSize.w(35)), // Reduced from 40
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
      width: ResponsiveSize.w(180), // Reduced from 200
      height: ResponsiveSize.h(220), // Reduced from 240
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
      ),
      child: Center(
        child: Container(
          width: ResponsiveSize.w(160), // Reduced from 180
          height: ResponsiveSize.h(200), // Reduced from 220
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
                      fontSize: ResponsiveSize.sp(22), // Reduced from 24
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
