import 'package:flutter/material.dart';
import './rhythm/rhythm_page.dart';
import './listening/listening_page.dart';
import './speaking/speaking_page.dart';
import './reading/reading_page.dart';
import './writing/writing_page.dart';
import '../../utils/responsive_size.dart';

class FixedStudyPage extends StatefulWidget {
  const FixedStudyPage({super.key});

  @override
  State<FixedStudyPage> createState() => _FixedStudyPageState();
}

class _FixedStudyPageState extends State<FixedStudyPage> {
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
              Expanded(child: _buildMainContent()),
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(20)),
        child: Row(
          children: [
            GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RhythmPage()),
                  ),
              child: _buildContentCard(
                '韵律启蒙',
                'assets/rhythm.png',
                'RHYTHM',
                'nullyellow.png',
              ),
            ),
            SizedBox(width: ResponsiveSize.w(40)),
            GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListeningPage(),
                    ),
                  ),
              child: _buildContentCard(
                '听力理解',
                'assets/listening1.png',
                'LISTENING',
                'nullsilver.png',
              ),
            ),
            SizedBox(width: ResponsiveSize.w(40)),
            GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SpeakingPage(),
                    ),
                  ),
              child: _buildContentCard(
                '口语表达',
                'assets/speaking.png',
                'SPEAKING',
                'nullyellow.png',
              ),
            ),
            SizedBox(width: ResponsiveSize.w(40)),
            GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReadingPage(),
                    ),
                  ),
              child: _buildContentCard(
                '自读闯关',
                'assets/reading_level.png',
                'READING',
                'nullsilver.png',
              ),
            ),
            SizedBox(width: ResponsiveSize.w(40)),
            GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WritingPage(),
                    ),
                  ),
              child: _buildContentCard(
                '书写听写',
                'assets/writing1.png',
                'WRITING',
                'nullyellow.png',
              ),
            ),
            SizedBox(width: ResponsiveSize.w(20)),
          ],
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
    // 获取方块颜色
    Color getBoxColor() {
      switch (title) {
        case '口语表达':
          return const Color(0xFF81d5ca); // 口语表达的浅绿色
        case '自读闯关':
          return const Color(0xFFeaa3cd); // 自读闯关的粉色
        case '书写听写':
          return const Color(0xFF8bb3f5); // 书写听写的蓝色
        default:
          return backgroundImage == 'nullyellow.png'
              ? const Color(0xFFa1cdaa)
              : const Color(0xFF88c5fd);
      }
    }

    // 获取边框颜色
    Color getBorderColor() {
      switch (title) {
        case '口语表达':
          return const Color(0xFF9de2d9); // 口语表达的浅绿色边框
        case '自读闯关':
          return const Color(0xFFf4b9dd); // 自读闯关的浅粉色边框
        case '书写听写':
          return const Color(0xFFa7c6f7); // 书写听写的浅蓝色边框
        default:
          return backgroundImage == 'nullyellow.png'
              ? const Color.fromARGB(255, 167, 204, 189)
              : const Color.fromARGB(255, 192, 223, 252);
      }
    }

    return Container(
      width: ResponsiveSize.w(300),
      height: ResponsiveSize.h(600),
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
              height: ResponsiveSize.h(600),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: ResponsiveSize.h(30),
            left: ResponsiveSize.w(100),
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  englishTitle.split('\n').map((text) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: ResponsiveSize.h(5)),
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(32),
                          fontWeight:
                              text == englishTitle.split('\n').first
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
              imageAsset,
              width: ResponsiveSize.w(170),
              height: ResponsiveSize.w(170),
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
                height: ResponsiveSize.h(100),
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
