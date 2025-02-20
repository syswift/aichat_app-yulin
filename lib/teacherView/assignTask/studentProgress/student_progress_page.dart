import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';

class StudentProgressItem {
  final String student;
  final String className;
  final double progress;

  StudentProgressItem({
    required this.student,
    required this.className,
    required this.progress,
  });
}

class StudentProgressPage extends StatelessWidget {
  const StudentProgressPage({super.key});

  static final List<HeaderItem> headers = [
    HeaderItem(title: '排行', flex: 1),
    HeaderItem(title: '学员', flex: 2),
    HeaderItem(title: '所在班级', flex: 2),
    HeaderItem(title: '周期完成度', flex: 2),
  ];

  static final List<StudentProgressItem> progressList = [
    StudentProgressItem(student: '张三', className: '初一A班', progress: 0.95),
    StudentProgressItem(student: '李四', className: '初一B班', progress: 0.88),
    StudentProgressItem(student: '王五', className: '初一A班', progress: 0.85),
    StudentProgressItem(student: '赵六', className: '初一C班', progress: 0.82),
    StudentProgressItem(student: '孙七', className: '初一B班', progress: 0.78),
    StudentProgressItem(student: '周八', className: '初一A班', progress: 0.75),
  ]..sort((a, b) => b.progress.compareTo(a.progress));

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Container(
      padding: EdgeInsets.only(top: ResponsiveSize.h(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: ResponsiveSize.w(24)),
            child: Text(
              '学员完成度',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(28),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
            ),
          ),
          SizedBox(height: ResponsiveSize.h(24)),
          // 内容区域
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: ResponsiveSize.w(10),
                    offset: Offset(0, ResponsiveSize.h(4)),
                  ),
                ],
              ),
                            child: Column(
                children: [
                  // 表头
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.w(24),
                      vertical: ResponsiveSize.h(16),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE4C4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: ResponsiveSize.w(10),
                          offset: Offset(0, ResponsiveSize.h(4)),
                        ),
                      ],
                    ),
                    child: Row(
                      children: headers.map((header) => _buildHeaderItem(header)).toList(),
                    ),
                  ),
                  // 列表内容
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: progressList.length,
                      itemBuilder: (context, index) {
                        final item = progressList[index];
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveSize.w(24),
                            vertical: ResponsiveSize.h(20),
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[200]!,
                                width: ResponsiveSize.w(1),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              // 排行
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: _buildRankWidget(index + 1),
                                ),
                              ),
                              // 学员
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    item.student,
                                    style: TextStyle(
                                      fontSize: ResponsiveSize.sp(22),
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                              ),
                              // 所在班级
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    item.className,
                                    style: TextStyle(
                                      fontSize: ResponsiveSize.sp(22),
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                              ),
                                                            // 完成度
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    '${(item.progress * 100).toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      fontSize: ResponsiveSize.sp(22),
                                      color: const Color(0xFF1976D2),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderItem(HeaderItem header) {
    return Expanded(
      flex: header.flex,
      child: Center(
        child: Text(
          header.title,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(25),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF333333),
          ),
        ),
      ),
    );
  }

  Widget _buildRankWidget(int rank) {
    Color color;
    switch (rank) {
      case 1:
        color = const Color(0xFFFFD700); // 金色
        break;
      case 2:
        color = const Color(0xFFC0C0C0); // 银色
        break;
      case 3:
        color = const Color(0xFFCD7F32); // 铜色
        break;
      default:
        color = Colors.grey[600]!;
    }

    return Container(
      width: ResponsiveSize.w(36),
      height: ResponsiveSize.h(36),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          rank.toString(),
          style: TextStyle(
            fontSize: ResponsiveSize.sp(22),
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}

class HeaderItem {
  final String title;
  final int flex;

  HeaderItem({
    required this.title,
    required this.flex,
  });
}
