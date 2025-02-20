import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                ResponsiveSize.w(40),
                ResponsiveSize.h(20),
                ResponsiveSize.w(40),
                0,
              ),
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
                  SizedBox(width: ResponsiveSize.w(30)),
                  Row(
                    children: [
                      Icon(
                        Icons.mail_outline,
                        color: const Color(0xFF8B4513),
                        size: ResponsiveSize.w(32),
                      ),
                      SizedBox(width: ResponsiveSize.w(15)),
                      Text(
                        '消息中心',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(28),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF8B4513),
                        ),
                      ),
                      SizedBox(width: ResponsiveSize.w(10)),
                      const UnreadBadge(count: 2),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveSize.h(40)),
                        Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(40)),
                padding: EdgeInsets.all(ResponsiveSize.w(30)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(25)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B4513).withOpacity(0.1),
                      blurRadius: ResponsiveSize.w(15),
                      offset: Offset(0, ResponsiveSize.h(5)),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMessageHeader(),
                    SizedBox(height: ResponsiveSize.h(20)),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildMessageItem(
                            title: '作业提醒',
                            content: '您有一个新的口语作业待完成',
                            time: '10分钟前',
                            type: 'homework',
                            isUnread: true,
                          ),
                          SizedBox(height: ResponsiveSize.h(20)),
                          _buildMessageItem(
                            title: '任务通知',
                            content: '恭喜你完成了今天的阅读任务！',
                            time: '1小时前',
                            type: 'task',
                            isUnread: true,
                          ),
                          SizedBox(height: ResponsiveSize.h(20)),
                          _buildMessageItem(
                            title: '系统通知',
                            content: '系统将于今晚22:00进行维护更新',
                            time: '2小时前',
                            type: 'system',
                            isUnread: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: ResponsiveSize.h(40)),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(20),
        vertical: ResponsiveSize.h(15),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF6BA66).withOpacity(0.1),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
        border: Border.all(
          color: const Color(0xFFF6BA66).withOpacity(0.3),
          width: ResponsiveSize.w(2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '最新消息',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(22),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF8B4513),
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: const Color(0xFF8B4513),
                size: ResponsiveSize.w(24),
              ),
              SizedBox(width: ResponsiveSize.w(8)),
              Text(
                '全部已读',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(16),
                  color: const Color(0xFF8B4513),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
    Widget _buildMessageItem({
    required String title,
    required String content,
    required String time,
    required String type,
    required bool isUnread,
  }) {
    String imagePath;
    const Color iconColor = Color(0xFFF6BA66);

    switch (type) {
      case 'homework':
        imagePath = 'assets/homework.png';
        break;
      case 'task':
        imagePath = 'assets/taskicon.png';
        break;
      default:
        imagePath = 'assets/notification.png';
    }

    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(20)),
      decoration: BoxDecoration(
        color: const Color(0xFFF6BA66).withOpacity(0.1),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
        border: Border.all(
          color: const Color(0xFFF6BA66).withOpacity(0.3),
          width: ResponsiveSize.w(2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveSize.w(12)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withOpacity(0.2),
                      blurRadius: ResponsiveSize.w(8),
                      offset: Offset(0, ResponsiveSize.h(2)),
                    ),
                  ],
                ),
                child: Image.asset(
                  imagePath,
                  width: ResponsiveSize.w(32),
                  height: ResponsiveSize.h(32),
                ),
              ),
              if (isUnread)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: ResponsiveSize.w(12),
                    height: ResponsiveSize.h(12),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: ResponsiveSize.w(20)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(20),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5C3D2E),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.w(12),
                        vertical: ResponsiveSize.h(6),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                      ),
                      child: Text(
                        time,
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(14),
                          color: const Color(0xFFF6BA66),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveSize.h(12)),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    color: const Color(0xFF5C3D2E),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UnreadBadge extends StatelessWidget {
  final int count;

  const UnreadBadge({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox();
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(8),
        vertical: ResponsiveSize.h(4),
      ),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
      ),
      child: Text(
        count.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: ResponsiveSize.sp(14),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}