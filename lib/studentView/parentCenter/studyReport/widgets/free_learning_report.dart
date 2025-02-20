import 'package:flutter/material.dart';
import '../../../../utils/responsive_size.dart';
import '../models/free_learning_data.dart';
import '../utils/color_utils.dart';

class FreeLearningReport extends StatelessWidget {
  final List<FreeLearningData> freeLearningData;

  const FreeLearningReport({
    super.key,
    required this.freeLearningData,
  });

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
            '自由学习概况',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(24),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveSize.h(20)),
          _buildCategorySummary(),
          SizedBox(height: ResponsiveSize.h(30)),
          _buildFreeLearningDetails(),
        ],
      ),
    );
  }

  Widget _buildCategorySummary() {
    Map<String, int> categoryDurations = {};
    for (var item in freeLearningData) {
      categoryDurations[item.category] = (categoryDurations[item.category] ?? 0) + item.duration;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '学习分类统计',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(18),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: ResponsiveSize.h(15)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCategoryCard('视频', categoryDurations['视频'] ?? 0),
            _buildCategoryCard('音频', categoryDurations['音频'] ?? 0),
            _buildCategoryCard('绘本', categoryDurations['绘本'] ?? 0),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String category, int duration) {
    final color = ColorUtils.getCategoryColor(category);
    return Container(
      width: ResponsiveSize.w(200),
      padding: EdgeInsets.all(ResponsiveSize.w(15)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            category,
            style: TextStyle(
              fontSize: ResponsiveSize.sp(16),
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          SizedBox(height: ResponsiveSize.h(8)),
          Text(
            '$duration分钟',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(20),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFreeLearningDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '学习详情',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(18),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: ResponsiveSize.h(15)),
        ...freeLearningData.map((item) => _buildFreeLearningItem(item)),
      ],
    );
  }

  Widget _buildFreeLearningItem(FreeLearningData item) {
    final color = ColorUtils.getCategoryColor(item.category);
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveSize.h(15),
        horizontal: ResponsiveSize.w(15),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: ResponsiveSize.w(1),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveSize.w(8)),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
            ),
            child: Icon(
              _getCategoryIcon(item.category),
              color: color,
              size: ResponsiveSize.w(24),
            ),
          ),
          SizedBox(width: ResponsiveSize.w(15)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(8)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '学习时长：${item.duration}分钟',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(14),
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '完成度：${(item.progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(14),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case '视频':
        return Icons.play_circle_outline;
      case '音频':
        return Icons.headphones;
      case '绘本':
        return Icons.book;
      default:
        return Icons.help_outline;
    }
  }
} 