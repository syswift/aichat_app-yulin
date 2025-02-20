import 'package:flutter/material.dart';

class ColorUtils {
  static Color getTaskTypeColor(String taskType) {
    switch (taskType) {
      case '韵律启蒙':
        return const Color(0xFFE57373);
      case '听力理解':
        return const Color(0xFF81C784);
      case '口语表达':
        return const Color(0xFF64B5F6);
      case '自读闯关':
        return const Color(0xFFFFB74D);
      case '书写听写':
        return const Color(0xFF9575CD);
      default:
        return Colors.grey;
    }
  }

  static Color getCategoryColor(String category) {
    switch (category) {
      case '视频':
        return const Color(0xFF88c5fd);
      case '音频':
        return const Color(0xFFFFB74D);
      case '绘本':
        return const Color(0xFF81C784);
      default:
        return Colors.grey;
    }
  }

  static Color getScoreColor(double score) {
    if (score >= 90) {
      return const Color(0xFF4CAF50);
    } else if (score >= 80) {
      return const Color(0xFF2196F3);
    } else if (score >= 60) {
      return const Color(0xFFFFA726);
    } else {
      return const Color(0xFFE57373);
    }
  }
} 