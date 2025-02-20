import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';

class ReadingHistoryPage extends StatelessWidget {
  const ReadingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/historyrecord.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(  // 使用Stack来保持标题的位置
            children: [
              Column(
                children: [
                  _buildTopBar(context),
                  SizedBox(height: ResponsiveSize.h(20)),
                  // 标题部分移到Stack中单独定位
                  SizedBox(height: ResponsiveSize.h(100)),  // 为标题预留空间
                  Expanded(
                    child: _buildHistoryContainer(),
                  ),
                ],
              ),
              // 单独定位标题
              Positioned(
                top: ResponsiveSize.py(140),  // 调整标题位置
                left: 0,
                right: 0,
                child: _buildTitle(),
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

  Widget _buildTitle() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '学习历史记录',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(40),
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 3, 3, 3),
            ),
          ),
          SizedBox(height: ResponsiveSize.h(5)),
          Text(
            'Learning History Records',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(20),
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 6, 6, 6).withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryContainer() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveSize.h(30),
        right: ResponsiveSize.w(20),
      ),
      child: Center(
        child: Container(
          width: ResponsiveSize.w(970),
          height: ResponsiveSize.h(550),
          margin: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(40)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveSize.w(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: ResponsiveSize.w(10),
                offset: Offset(0, ResponsiveSize.h(5)),
              ),
            ],
          ),
          child: ListView.builder(
            padding: EdgeInsets.all(ResponsiveSize.w(20)),
            itemCount: 10,
            itemBuilder: (context, index) {
              return _buildHistoryItem(
                bookTitle: '小王子',
                chapter: '第${index + 1}章',
                content: '王子与玫瑰的故事',
                dateTime: DateTime.now().subtract(Duration(days: index)),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem({
    required String bookTitle,
    required String chapter,
    required String content,
    required DateTime dateTime,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveSize.h(15)),
      padding: EdgeInsets.all(ResponsiveSize.w(15)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: ResponsiveSize.w(1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: ResponsiveSize.w(5),
            offset: Offset(0, ResponsiveSize.h(2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bookTitle,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(24),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
              ),
              Text(
                '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
                '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(24),
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.h(10)),
          Text(
            chapter,
            style: TextStyle(
              fontSize: ResponsiveSize.sp(24),
              color: const Color(0xFF666666),
            ),
          ),
          SizedBox(height: ResponsiveSize.h(5)),
          Text(
            content,
            style: TextStyle(
              fontSize: ResponsiveSize.sp(24),
              color: const Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }
}