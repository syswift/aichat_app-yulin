import 'package:flutter/material.dart';
import '../../../../utils/responsive_size.dart';
import '../models/time_data.dart';
import '../utils/time_display_helper.dart';
import 'package:share_plus/share_plus.dart';

class TimeStatistics extends StatelessWidget {
  final List<TimeData> timeData;
  final String reportType;

  const TimeStatistics({
    super.key,
    required this.timeData,
    required this.reportType,
  });

  String get _periodTitle => TimeDisplayHelper.getPeriodTitle(reportType);

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes分钟';
    } else {
      final hours = minutes / 60;
      return '${hours.toStringAsFixed(1)}小时';
    }
  }

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
          _buildHeader(),
          SizedBox(height: ResponsiveSize.h(30)),
          _buildChart(),
          SizedBox(height: ResponsiveSize.h(20)),
          _buildTotal(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Builder(
      builder: (context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '观看时长统计',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(24),
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.w(12),
                  vertical: ResponsiveSize.h(6),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF88c5fd).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
                ),
                child: Text(
                  '$_periodTitle数据',
                  style: TextStyle(
                    color: const Color(0xFF88c5fd),
                    fontSize: ResponsiveSize.sp(14),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: ResponsiveSize.w(10)),
              IconButton(
                onPressed: () => _shareReport(context),
                icon: Icon(
                  Icons.share,
                  color: const Color(0xFF88c5fd),
                  size: ResponsiveSize.w(24),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _shareReport(BuildContext context) async {
    try {
      String shareText = _generateShareText();
      await Share.share(
        shareText,
        subject: '$_periodTitle学习报告',
      ).then((result) {
        if (result.status == ShareResultStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('分享成功！')),
          );
        }
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('分享失败：$error')),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('分享出错：$e')),
      );
    }
  }

  String _generateShareText() {
    final totalMinutes = timeData.fold(0, (sum, item) => sum + item.minutes);
    final targetMinutes = TimeDisplayHelper.getBaseValue(reportType);
    final completion = (totalMinutes / targetMinutes * 100).toInt();
    
    return '''
【$_periodTitle学习报告】

$_periodTitle总学习时长：${_formatDuration(totalMinutes)}

详细学习记录：
${timeData.map((data) => '${data.getDisplayTime(reportType)}: ${_formatDuration(data.minutes)}').join('\n')}

目标完成度：$completion%
${_getEncouragement(completion)}

来自AI伙伴学习助手
''';
  }

  String _getEncouragement(int completion) {
    if (completion >= 100) {
      return '太棒了！完美达成目标，继续保持！👏';
    } else if (completion >= 80) {
      return '表现很好，即将达成目标，加油！💪';
    } else if (completion >= 50) {
      return '已经完成一半了，继续努力！🎯';
    } else {
      return '开始是成功的一半，让我们一起加油！✨';
    }
  }

  Widget _buildChart() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: timeData.length,
      itemBuilder: (context, index) {
        final data = timeData[index];
        
        return Padding(
          padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data.day,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(16),
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    _formatDuration(data.minutes),
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(16),
                      color: const Color(0xFF88c5fd),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveSize.h(8)),
              Container(
                height: ResponsiveSize.h(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF88c5fd), Color(0xFF6eb6ff)],
                  ),
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(4)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTotal() {
    final totalMinutes = timeData.fold(0, (sum, item) => sum + item.minutes);
    String periodText;
    switch (reportType) {
      case 'daily':
        periodText = '今日';
        break;
      case 'weekly':
        periodText = '本周';
        break;
      case 'monthly':
        periodText = '本月';
        break;
      case 'yearly':
        periodText = '今年';
        break;
      default:
        periodText = '总';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$periodText总学习时长：${_formatDuration(totalMinutes)}',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(16),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF666666),
          ),
        ),
      ],
    );
  }
}