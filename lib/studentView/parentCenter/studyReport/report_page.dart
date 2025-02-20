import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';
import 'widgets/widgets.dart';
import 'models/time_data.dart';

class StudyReportPage extends StatefulWidget {
  const StudyReportPage({super.key});

  @override
  State<StudyReportPage> createState() => _StudyReportPageState();
}

class _StudyReportPageState extends State<StudyReportPage> {
  String _selectedPeriod = '日报';
  final List<String> _periods = ['日报', '周报', '月报', '年报'];


  final List<VideoWatchData> _videoWatchData = [
    VideoWatchData(
      title: '小猪佩奇第1章',
      totalDuration: 1200,
      watchedDuration: 1080,
      skipCount: 2,
      fastForwardCount: 1,
      lastWatchTime: '2024-03-20 10:30',
    ),
    VideoWatchData(
      title: '大灰狼第2章',
      totalDuration: 1200,
      watchedDuration: 1200,
      skipCount: 0,
      fastForwardCount: 0,
      lastWatchTime: '2024-03-20 14:20',
    ),
    VideoWatchData(
      title: '英语故事会第1期',
      totalDuration: 900,
      watchedDuration: 720,
      skipCount: 3,
      fastForwardCount: 2,
      lastWatchTime: '2024-03-20 16:45',
    ),
  ];

  final List<FreeLearningData> _freeLearningData = [
    FreeLearningData(
      category: '视频',
      title: '小猪佩奇',
      duration: 45,
      lastWatchTime: '2024-03-20 15:30',
      progress: 0.8,
    ),
    FreeLearningData(
      category: '音频', 
      title: '睡前故事',
      duration: 30,
      lastWatchTime: '2024-03-20 19:30',
      progress: 1.0,
    ),
    FreeLearningData(
      category: '绘本',
      title: '三只小猪',
      duration: 25,
      lastWatchTime: '2024-03-20 16:30', 
      progress: 0.6,
    ),
  ];

  final List<StagedLearningData> _stagedLearningData = [
    StagedLearningData(
      level: 'Level 1',
      week: 'Week 1',
      taskType: '韵律启蒙',
      taskName: '基础节奏练习',
      duration: 30,
      completionTime: '2024-03-20 14:30',
      score: 95,
    ),
    StagedLearningData(
      level: 'Level 1',
      week: 'Week 1', 
      taskType: '听力理解',
      taskName: '动物单词听力',
      duration: 25,
      completionTime: '2024-03-20 15:30',
      score: 88,
    ),
  ];
     @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/parentbg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              SizedBox(height: ResponsiveSize.h(20)),
              _buildPeriodSelector(),
              SizedBox(height: ResponsiveSize.h(30)),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.w(40),
                    vertical: ResponsiveSize.h(20),
                  ),
                  child: Column(
                    children: [
                      _buildTimeStatistics(),
                      SizedBox(height: ResponsiveSize.h(30)),
                      _buildVideoWatchDetails(),
                      SizedBox(height: ResponsiveSize.h(30)),
                      _buildLearningTrack(),
                      SizedBox(height: ResponsiveSize.h(30)),
                      _buildHomeworkStatus(),
                      SizedBox(height: ResponsiveSize.h(20)),
                      _buildFreeLearningReport(),
                      SizedBox(height: ResponsiveSize.h(30)),
                      _buildStagedLearningReport(),
                    ],
                  ),
                ),
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

  Widget _buildPeriodSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(40)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _periods.map((period) {
          return GestureDetector(
            onTap: () => setState(() => _selectedPeriod = period),
            child: Container(
              width: ResponsiveSize.w(200),
              height: ResponsiveSize.h(80),
              decoration: BoxDecoration(
                color: _selectedPeriod == period
                    ? const Color(0xFF88c5fd)
                    : Colors.white,
                borderRadius: BorderRadius.circular(ResponsiveSize.w(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: ResponsiveSize.w(8),
                    spreadRadius: ResponsiveSize.w(2),
                    offset: Offset(0, ResponsiveSize.h(4)),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  period,
                  style: TextStyle(
                    color: _selectedPeriod == period
                        ? Colors.white
                        : Colors.black87,
                    fontSize: ResponsiveSize.sp(32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
    Widget _buildTimeStatistics() {
    // 根据选中的时期获取对应的时间数据
    final timeData = _getTimeDataByPeriod(_selectedPeriod);
    
    return TimeStatistics(
      timeData: timeData,
      reportType: _getReportType(_selectedPeriod),
    );
  }

  String _getReportType(String period) {
    switch (period) {
      case '日报':
        return 'daily';
      case '周报':
        return 'weekly';
      case '月报':
        return 'monthly';
      case '年报':
        return 'yearly';
      default:
        return 'daily';
    }
  }

  // 根据报告类型获取对应的时间数据
  List<TimeData> _getTimeDataByPeriod(String period) {
    switch (period) {
      case '日报':
        return [
          TimeData(day: '08:00', minutes: 30),
          TimeData(day: '10:00', minutes: 45),
          TimeData(day: '14:00', minutes: 60),
          TimeData(day: '16:00', minutes: 40),
          TimeData(day: '19:00', minutes: 35),
        ];
      case '周报':
        return [
          TimeData(day: '周一', minutes: 125),
          TimeData(day: '周二', minutes: 180),
          TimeData(day: '周三', minutes: 240),
          TimeData(day: '周四', minutes: 210),
          TimeData(day: '周五', minutes: 195),
          TimeData(day: '周六', minutes: 260),
          TimeData(day: '周日', minutes: 150),
        ];
      case '月报':
        return [
          TimeData(day: '第1周', minutes: 1200),
          TimeData(day: '第2周', minutes: 1350),
          TimeData(day: '第3周', minutes: 1100),
          TimeData(day: '第4周', minutes: 1400),
        ];
      case '年报':
        return [
          TimeData(day: '1月', minutes: 4800),
          TimeData(day: '2月', minutes: 5200),
          TimeData(day: '3月', minutes: 4900),
          TimeData(day: '4月', minutes: 5100),
          TimeData(day: '5月', minutes: 4700),
          TimeData(day: '6月', minutes: 5300),
        ];
      default:
        return [];
    }
  }

  // 获取不同报告类型的最大时长基准

  // 获取对应的时期文本

  // 计算总时长
    Widget _buildVideoWatchDetails() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '视频观看详情',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(24),
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                  '今日数据',
                  style: TextStyle(
                    color: const Color(0xFF88c5fd),
                    fontSize: ResponsiveSize.sp(14),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.h(30)),
          ..._videoWatchData.map((video) => _buildVideoWatchItem(video)),
        ],
      ),
    );
  }

  Widget _buildVideoWatchItem(VideoWatchData video) {
    final watchedPercentage = (video.watchedDuration / video.totalDuration * 100).toInt();
    final hasAbnormalBehavior = video.skipCount > 0 || video.fastForwardCount > 0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(20)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: ResponsiveSize.w(1),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  video.title,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(18),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (hasAbnormalBehavior)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.w(8),
                    vertical: ResponsiveSize.h(4),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9E9E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
                  ),
                  child: Text(
                    '异常',
                    style: TextStyle(
                      color: const Color(0xFFFF9E9E),
                      fontSize: ResponsiveSize.sp(12),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: ResponsiveSize.h(15)),
          LinearProgressIndicator(
            value: video.watchedDuration / video.totalDuration,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF88c5fd)),
            minHeight: ResponsiveSize.h(8),
          ),
          SizedBox(height: ResponsiveSize.h(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '观看进度：$watchedPercentage%',
                style: TextStyle(
                  color: const Color(0xFF666666),
                  fontSize: ResponsiveSize.sp(14),
                ),
              ),
              Text(
                '最后观看：${video.lastWatchTime}',
                style: TextStyle(
                  color: const Color(0xFF666666),
                  fontSize: ResponsiveSize.sp(14),
                ),
              ),
            ],
          ),
          if (hasAbnormalBehavior) ...[
            SizedBox(height: ResponsiveSize.h(10)),
            Row(
              children: [
                if (video.skipCount > 0)
                  _buildAbnormalBehaviorTag(
                    '跳过 ${video.skipCount} 次',
                    const Color(0xFFFF9E9E),
                  ),
                if (video.skipCount > 0 && video.fastForwardCount > 0)
                  SizedBox(width: ResponsiveSize.w(10)),
                if (video.fastForwardCount > 0)
                  _buildAbnormalBehaviorTag(
                    '快进 ${video.fastForwardCount} 次',
                    const Color(0xFFFFB74D),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
    Widget _buildAbnormalBehaviorTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(8),
        vertical: ResponsiveSize.h(4),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: ResponsiveSize.w(14),
            color: color,
          ),
          SizedBox(width: ResponsiveSize.w(4)),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: ResponsiveSize.sp(12),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningTrack() {
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
            '学习轨迹',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(24),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveSize.h(30)),
          _buildTrackItem('观看视频', '《英语动片1》 10:00-10:30'),
          _buildTrackItem('听力练习', '《听力训练》 11:00-11:30'),
          _buildTrackItem('阅读练习', '《阅读理解》 14:00-14:30'),
          _buildTrackItem('作业完成', '《每日作业》 16:00-16:30'),
        ],
      ),
    );
  }

  Widget _buildTrackItem(String title, String detail) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(15)),
      child: Row(
        children: [
          Container(
            width: ResponsiveSize.w(12),
            height: ResponsiveSize.h(12),
            decoration: const BoxDecoration(
              color: Color(0xFF88c5fd),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: ResponsiveSize.w(15)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ResponsiveSize.h(5)),
              Text(
                detail,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: ResponsiveSize.sp(14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHomeworkStatus() {
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

  Widget _buildFreeLearningReport() {
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

  Widget _buildStagedLearningReport() {
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

  Widget _buildCategorySummary() {
    // 计算每个类别的总时长
    Map<String, int> categoryDurations = {};
    for (var item in _freeLearningData) {
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
            _buildCategoryCard('视频', categoryDurations['视频'] ?? 0, const Color(0xFF88c5fd)),
            _buildCategoryCard('音频', categoryDurations['音频'] ?? 0, const Color(0xFFFFB74D)),
            _buildCategoryCard('绘本', categoryDurations['绘本'] ?? 0, const Color(0xFF81C784)),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String category, int duration, Color color) {
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
        ..._freeLearningData.map((item) => _buildFreeLearningItem(item)),
      ],
    );
  }

  Widget _buildFreeLearningItem(FreeLearningData item) {
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
              color: _getCategoryColor(item.category).withOpacity(0.1),
              borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
            ),
            child: Icon(
              _getCategoryIcon(item.category),
              color: _getCategoryColor(item.category),
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

  Color _getCategoryColor(String category) {
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

  Widget _buildLevelProgress() {
    // 获取当前进行的关卡和周数
    final currentLevel = _stagedLearningData.isNotEmpty ? _stagedLearningData[0].level : 'Level 1';
    final currentWeek = _stagedLearningData.isNotEmpty ? _stagedLearningData[0].week : 'Week 1';

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
              Column(
                children: [
                  Text(
                    '当前关卡',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(14),
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(8)),
                  Text(
                    currentLevel,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(20),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF88c5fd),
                    ),
                  ),
                ],
              ),
              Container(
                width: ResponsiveSize.w(1),
                height: ResponsiveSize.h(40),
                color: Colors.grey.withOpacity(0.3),
              ),
              Column(
                children: [
                  Text(
                    '当前周数',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(14),
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(8)),
                  Text(
                    currentWeek,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(20),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF88c5fd),
                    ),
                  ),
                ],
              ),
            ],
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
        ..._stagedLearningData.map((item) => _buildStagedLearningItem(item)),
      ],
    );
  }

  Widget _buildStagedLearningItem(StagedLearningData item) {
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
                      color: _getTaskTypeColor(item.taskType).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                    ),
                    child: Icon(
                      _getTaskTypeIcon(item.taskType),
                      color: _getTaskTypeColor(item.taskType),
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
                  color: _getScoreColor(item.score).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
                ),
                child: Text(
                  '${item.score.toInt()}分',
                  style: TextStyle(
                    color: _getScoreColor(item.score),
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

  Color _getTaskTypeColor(String taskType) {
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

  IconData _getTaskTypeIcon(String taskType) {
    switch (taskType) {
      case '韵律启蒙':
        return Icons.music_note;
      case '听力理解':
        return Icons.headset;
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

  Color _getScoreColor(double score) {
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

class VideoWatchData {
  final String title;
  final int totalDuration;
  final int watchedDuration;
  final int skipCount;
  final int fastForwardCount;
  final String lastWatchTime;

  VideoWatchData({
    required this.title,
    required this.totalDuration,
    required this.watchedDuration,
    required this.skipCount,
    required this.fastForwardCount,
    required this.lastWatchTime,
  });
}

class FreeLearningData {
  final String category; // 视频/音频/绘本
  final String title;
  final int duration; // 观看时长(分钟)
  final String lastWatchTime;
  final double progress; // 完成进度

  FreeLearningData({
    required this.category,
    required this.title, 
    required this.duration,
    required this.lastWatchTime,
    required this.progress,
  });
}

class StagedLearningData {
  final String level;
  final String week;
  final String taskType; // 韵律/听力/口语/阅读/书写
  final String taskName;
  final int duration;
  final String completionTime;
  final double score;

  StagedLearningData({
    required this.level,
    required this.week,
    required this.taskType,
    required this.taskName, 
    required this.duration,
    required this.completionTime,
    required this.score,
  });
}