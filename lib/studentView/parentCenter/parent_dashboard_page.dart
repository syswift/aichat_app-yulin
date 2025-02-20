import 'package:flutter/material.dart';
import 'studyReport/report_page.dart';
import 'eye_protection_page.dart';
import 'feature_settings_page.dart';
import 'parent_guidance_page.dart';
import 'platform_notification_page.dart';
import '../../utils/responsive_size.dart';

class ParentDashboardPage extends StatelessWidget {
  const ParentDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fsbg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              Expanded(
                child: _buildMainContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ResponsiveSize.w(20)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Image.asset(
              'assets/backbutton1.png',
              width: ResponsiveSize.w(100),
              height: ResponsiveSize.h(100),
            ),
          ),
        ],
      ),
    );
  }
    Widget _buildMainContent() {
    return Builder(
      builder: (context) => Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 家长指导课
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ParentGuidancePage(),
                      ),
                    );
                  },
                  child: _buildContentCard(
                    '家长指导课',
                    'assets/parentguide.png',
                    'PARENT\nGUIDANCE',
                    'nullyellow.png',
                  ),
                ),
                SizedBox(width: ResponsiveSize.w(40)),
                // 学习报告
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StudyReportPage(),
                      ),
                    );
                  },
                  child: _buildContentCard(
                    '学习报告',
                    'assets/report_icon.png',
                    'STUDY\nREPORT',
                    'nullsilver.png',
                  ),
                ),
                SizedBox(width: ResponsiveSize.w(40)),
                // 平台通知
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlatformNotificationPage(),
                      ),
                    );
                  },
                  child: _buildContentCard(
                    '平台通知',
                    'assets/notification.png',
                    'SYSTEM\nALERTS',
                    'nullyellow.png',
                  ),
                ),
                SizedBox(width: ResponsiveSize.w(40)),
                // 护眼设置
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EyeProtectionPage(),
                      ),
                    );
                  },
                  child: _buildContentCard(
                    '护眼设置',
                    'assets/eye_icon.png',
                    'EYE\nPROTECTION',
                    'nullsilver.png',
                  ),
                ),
                SizedBox(width: ResponsiveSize.w(40)),
                // 功能设置
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FeatureSettingsPage(),
                      ),
                    );
                  },
                  child: _buildContentCard(
                    '功能设置',
                    'assets/setting_icon.png',
                    'FEATURE\nSETTINGS',
                    'nullyellow.png',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
    Widget _buildContentCard(
    String title,
    String imageAsset,
    String englishTitle,
    String backgroundImage,
  ) {
    Color getBoxColor() {
      switch (title) {
        case '家长指导课':
          return const Color(0xFFFF995D);
        case '平台通知':
          return const Color(0xFFFFCA28);
        case '功能设置':
          return const Color(0xFFb89dda);
        case '学习报告':
          return const Color(0xFFa1cdaa);
        case '护眼设置':
          return const Color(0xFF88c5fd);
        default:
          return backgroundImage == 'nullyellow.png'
              ? const Color(0xFFa1cdaa)
              : const Color(0xFF88c5fd);
      }
    }

    Color getBorderColor() {
      switch (title) {
        case '家长指导课':
          return const Color(0xFFFFAD7D);
        case '平台通知':
          return const Color(0xFFFFD54F);
        case '功能设置':
          return const Color(0xFFcbb7e5);
        case '学习报告':
          return const Color.fromARGB(255, 192, 223, 208);
        case '护眼设置':
          return const Color.fromARGB(255, 192, 223, 252);
        default:
          return backgroundImage == 'nullyellow.png'
              ? const Color.fromARGB(255, 167, 204, 189)
              : const Color.fromARGB(255, 192, 223, 252);
      }
    }

    return Container(
      width: ResponsiveSize.w(300),
      height: ResponsiveSize.h(655),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: Offset(0, ResponsiveSize.h(8)),
            blurRadius: ResponsiveSize.w(15),
            spreadRadius: ResponsiveSize.w(1),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
            child: Image.asset(
              'assets/$backgroundImage',
              width: ResponsiveSize.w(300),
              height: ResponsiveSize.h(655),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: ResponsiveSize.h(30),
            left: ResponsiveSize.w(100),
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: englishTitle.split('\n').map((text) {
                bool isSecondLine = text != englishTitle.split('\n').first;
                double fontSize = isSecondLine ? ResponsiveSize.sp(26) : ResponsiveSize.sp(32);
                double letterSpacing = isSecondLine ? 0.5 : 1.2;
                
                return Padding(
                  padding: EdgeInsets.only(bottom: ResponsiveSize.h(5)),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: text == englishTitle.split('\n').first
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: const Color(0xFF333333),
                      letterSpacing: letterSpacing,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Positioned(
            top: ResponsiveSize.h(250),
            left: 0,
            right: 0,
            child: Image.asset(
              imageAsset,
              width: ResponsiveSize.w(170),
              height: ResponsiveSize.h(170),
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: ResponsiveSize.h(480),
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: ResponsiveSize.w(220),
                height: ResponsiveSize.h(150),
                decoration: BoxDecoration(
                  color: getBoxColor(),
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                  border: Border.all(
                    color: getBorderColor(),
                    width: ResponsiveSize.w(2),
                  ),
                ),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(36),
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 255, 254, 254),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}