import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';
import 'chatWindow/teacher_chat_page.dart';

class PlatformNotificationPage extends StatefulWidget {
  const PlatformNotificationPage({super.key});

  @override
  State<PlatformNotificationPage> createState() => _PlatformNotificationPageState();
}

class _PlatformNotificationPageState extends State<PlatformNotificationPage> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: '系统更新通知',
      content: '亲爱的家长，鹅爸爸平台将于本周六凌晨2:00-4:00进行系统维护升级，届时服务将暂时中断，请您提前做好安排。',
      date: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
    ),
    NotificationItem(
      title: '新功能上线',
      content: '鹅爸爸平台新增"亲子互动"功能，快来和孩子一起体验吧！',
      date: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
    NotificationItem(
      title: '课程更新提醒',
      content: '您关注的课程已更新最新内容，点击查看详情。',
      date: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
    NotificationItem(
      title: '节日活动预告',
      content: '六一儿童节特别活动即将开始，敬请期待精彩内容！',
      date: DateTime.now().subtract(const Duration(days: 4)),
      isRead: true,
    ),
    NotificationItem(
      title: '学习报告生成提醒',
      content: '您的孩子本周学习报告已生成，点击查看学习情况分析。',
      date: DateTime.now().subtract(const Duration(days: 5)),
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Scaffold(
      body: Container(
        color: const Color(0xFFFFF1D6),
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(20)),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  return _buildNotificationCard(_notifications[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TeacherChatPage(),
            ),
          );
        },
        backgroundColor: const Color(0xFFFFDFA7),
        child: const Icon(
          Icons.message,
          color: Color(0xFF5A2E17),
        ),
      ),
    );
  }

    Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(20),
          vertical: ResponsiveSize.h(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Image.asset(
                'assets/backbutton1.png',
                width: ResponsiveSize.w(90),
                height: ResponsiveSize.h(90),
              ),
            ),
            Text(
              '平台通知',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(32),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5A2E17),
              ),
            ),
            SizedBox(width: ResponsiveSize.w(90)),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveSize.h(20)),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9E9),
          borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
          border: Border.all(
            color: const Color(0xFFFFCA28),
            width: ResponsiveSize.w(2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: ResponsiveSize.w(8),
              offset: Offset(0, ResponsiveSize.h(4)),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (!notification.isRead)
              Positioned(
                top: ResponsiveSize.h(15),
                right: ResponsiveSize.w(15),
                child: Container(
                  width: ResponsiveSize.w(10),
                  height: ResponsiveSize.h(10),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(ResponsiveSize.w(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(20),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5A2E17),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDate(notification.date),
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(14),
                          color: const Color(0xFF5A2E17).withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveSize.h(15)),
                  Text(
                    notification.content,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(16),
                      color: const Color(0xFF5A2E17),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '今天';
    } else if (difference.inDays == 1) {
      return '昨天';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${date.month}月${date.day}日';
    }
  }
}

class NotificationItem {
  final String title;
  final String content;
  final DateTime date;
  bool isRead;

  NotificationItem({
    required this.title,
    required this.content,
    required this.date,
    this.isRead = false,
  });
}