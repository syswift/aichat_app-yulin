import 'package:flutter/material.dart';
import 'cartoonVideo/cartoon_video_page.dart';
import 'gradedReading/graded_reading_page.dart';
import 'happyListen/happy_listen_chapters.dart';
import '../../utils/responsive_size.dart';

class FreeStudyPage extends StatelessWidget {
  const FreeStudyPage({super.key});

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
              height: ResponsiveSize.w(100),
            ),
          ),
        ],
      ),
    );
  }
    Widget _buildMainContent() {
    return Builder(
      builder: (context) => Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartoonVideoPage(),
                  ),
                );
              },
              child: _buildEmptyCard(),
            ),
            SizedBox(width: ResponsiveSize.w(40)),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GradedReadingPage(),
                  ),
                );
              },
              child: _buildContentCard('分级阅读', 'assets/reading.png', isIcon: false),
            ),
            SizedBox(width: ResponsiveSize.w(40)),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HappyListenPage(),
                  ),
                );
              },
              child: _buildContentCard('快乐听', 'assets/happylisten.png', isIcon: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(String title, String imageAsset, {
    bool isIcon = false,
  }) {
    String englishTitle = '';
    String logoAsset = '';
    String backgroundImage = '';
    Color boxColor = Colors.transparent;
    Color borderColor = Colors.transparent;
    
    if (title == '分级阅读') {
      englishTitle = 'GRADED\nREADING';
      logoAsset = 'assets/gradedreadinglogo.png';
      backgroundImage = 'assets/nullsilver.png';
      boxColor = const Color(0xFF88c5fd);
      borderColor = const Color.fromARGB(255, 192, 223, 252);
    } else if (title == '快乐听') {
      englishTitle = 'HAPPY\nLISTENING';
      logoAsset = 'assets/happylistenlogo.png';
      backgroundImage = 'assets/nullyellow.png';
      boxColor = const Color(0xFFa1cdaa);
      borderColor = const Color.fromARGB(255, 167, 204, 189);
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
              backgroundImage,
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
                return Padding(
                  padding: EdgeInsets.only(bottom: ResponsiveSize.h(5)),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(32),
                      fontWeight: text == englishTitle.split('\n').first 
                          ? FontWeight.bold 
                          : FontWeight.normal,
                      color: const Color(0xFF333333),
                      letterSpacing: 1.2,
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
              logoAsset,
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
                  color: boxColor,
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                  border: Border.all(
                    color: borderColor,
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
    Widget _buildEmptyCard() {
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
              'assets/nullyellow.png',
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
              children: [
                Text(
                  'CARTOON',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(32),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF333333),
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(5)),
                Text(
                  'VIDEO',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(32),
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF333333),
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: ResponsiveSize.h(250),
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/cartoonvideologo.png',
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
                  color: const Color.fromARGB(255, 207, 93, 67),
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                  border: Border.all(
                    color: const Color.fromARGB(255, 242, 162, 144),
                    width: ResponsiveSize.w(2),
                  ),
                ),
                child: Center(
                  child: Text(
                    '动画视频',
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