import 'package:flutter/material.dart';
import '../../../../utils/responsive_size.dart';
import '../models/staged_learning_data.dart';
import '../utils/color_utils.dart';

class StagedLearningReport extends StatelessWidget {
  final List<StagedLearningData> stagedLearningData;

  const StagedLearningReport({
    super.key,
    required this.stagedLearningData,
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
            '阶段闯关进度',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(24),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveSize.h(20)),
          _buildLevelProgress(),
          SizedBox(height: ResponsiveSize.h(30)),
          _buildStagedLearningDetails(),
        ],
      ),
    );
  }

  Widget _buildLevelProgress() {
    final currentLevel = stagedLearningData.isNotEmpty ? stagedLearningData[0].level : 'Level 1';
    final currentWeek = stagedLearningData.isNotEmpty ? stagedLearningData[0].week : 'Week 1';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '当前进度',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(18),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: ResponsiveSize.h(15)),
        Container(
          padding: EdgeInsets.all(ResponsiveSize.w(20)),
          decoration: BoxDecoration(
            color: const Color(0xFF88c5fd).withOpacity(0.1),
            borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
            border: Border.all(
              color: const Color(0xFF88c5fd).withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProgressItem('当前关卡', currentLevel),
              Container(
                width: ResponsiveSize.w(1),
                height: ResponsiveSize.h(40),
                color: Colors.grey.withOpacity(0.3),
              ),
              _buildProgressItem('当前周数', currentWeek),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(14),
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: ResponsiveSize.h(8)),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(20),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF88c5fd),
          ),
        ),
      ],
    );
  }

  Widget _buildStagedLearningDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '闯关详情',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(18),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: ResponsiveSize.h(15)),
        ...stagedLearningData.map((item) => _buildStagedLearningItem(item)),
      ],
    );
  }

  Widget _buildStagedLearningItem(StagedLearningData item) {
    final color = ColorUtils.getTaskTypeColor(item.taskType);
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveSize.h(15),
        horizontal: ResponsiveSize.w(15),
      ),
      margin: EdgeInsets.only(bottom: ResponsiveSize.h(15)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(ResponsiveSize.w(8)),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                    ),
                    child: Icon(
                      _getTaskTypeIcon(item.taskType),
                      color: color,
                      size: ResponsiveSize.w(24),
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.w(10)),
                  Text(
                    item.taskType,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(16),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.w(10),
                  vertical: ResponsiveSize.h(4),
                ),
                decoration: BoxDecoration(
                  color: ColorUtils.getScoreColor(item.score).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
                ),
                child: Text(
                  '${item.score.toInt()}分',
                  style: TextStyle(
                    color: ColorUtils.getScoreColor(item.score),
                    fontSize: ResponsiveSize.sp(14),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.h(10)),
          Text(
            item.taskName,
            style: TextStyle(
              fontSize: ResponsiveSize.sp(14),
              color: Colors.grey[600],
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
                '完成时间：${item.completionTime}',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(14),
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getTaskTypeIcon(String taskType) {
    switch (taskType) {
      case '韵律启蒙':
        return Icons.music_note;
      case '听力理解':
        return Icons.headphones;
      case '口语表达':
        return Icons.record_voice_over;
      case '自读闯关':
        return Icons.menu_book;
      case '书写听写':
        return Icons.edit;
      default:
        return Icons.help_outline;
    }
  }
} 