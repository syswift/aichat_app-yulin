import 'package:flutter/material.dart';
import '../../../../utils/responsive_size.dart';

class HomeworkStatus extends StatelessWidget {
  const HomeworkStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(30)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: ResponsiveSize.w(15),
            spreadRadius: ResponsiveSize.w(5),
            offset: Offset(0, ResponsiveSize.h(5)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '作业完成情况',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(24),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveSize.h(30)),
          _buildHomeworkItem('每日听力', 0.8),
          _buildHomeworkItem('阅读理解', 0.9),
          _buildHomeworkItem('口语练习', 0.7),
          _buildHomeworkItem('写作练习', 0.85),
        ],
      ),
    );
  }

  Widget _buildHomeworkItem(String title, double progress) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: ResponsiveSize.sp(16),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: ResponsiveSize.h(8)),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF88c5fd)),
            minHeight: ResponsiveSize.h(8),
          ),
          SizedBox(height: ResponsiveSize.h(8)),
          Text(
            '${(progress * 100).toInt()}% 完成',
            style: TextStyle(
              color: const Color(0xFF666666),
              fontSize: ResponsiveSize.sp(14),
            ),
          ),
        ],
      ),
    );
  }
} 