import 'package:flutter/material.dart';
import './points_rule_dialog.dart';
import '../../../utils/responsive_size.dart';

class StudentPointsPage extends StatelessWidget {
  const StudentPointsPage({super.key});

  int _calculateTotalPoints(int stars, int flowers, int medals) {
    return (stars / 100).floor() + (flowers / 50).floor() + (medals / 50).floor();
  }

  void _showPointsRuleDialog(BuildContext context) {
    const int totalStars = 1000;
    const int totalFlowers = 70;
    const int totalMedals = 130;
    
    final int totalPoints = _calculateTotalPoints(totalStars, totalFlowers, totalMedals);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
          ),
          child: Container(
            width: ResponsiveSize.w(400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(ResponsiveSize.w(20))),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(10)),
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/addbackground.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(ResponsiveSize.w(20)),
                      topRight: Radius.circular(ResponsiveSize.w(20)),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '已获得奖励统计',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(24),
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                                Padding(
                  padding: EdgeInsets.all(ResponsiveSize.w(20)),
                  child: Column(
                    children: [
                      _buildStatItem('assets/star.png', totalStars, '100个 = 1积分'),
                      SizedBox(height: ResponsiveSize.h(15)),
                      _buildStatItem('assets/flower.png', totalFlowers, '50个 = 1积分'),
                      SizedBox(height: ResponsiveSize.h(15)),
                      _buildStatItem('assets/medal.png', totalMedals, '50个 = 1积分'),
                      SizedBox(height: ResponsiveSize.h(20)),
                      Text(
                        '可兑换积分：$totalPoints',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(22),
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(20)),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          '确定',
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(20),
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String iconPath, int count, String rule) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          iconPath,
          width: ResponsiveSize.w(30),
          height: ResponsiveSize.h(30),
        ),
        SizedBox(width: ResponsiveSize.w(10)),
        Text(
          '已获得：$count个',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(20),
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        Text(
          '($rule)',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(16),
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    const int totalStars = 1000;
    const int totalFlowers = 70;
    const int totalMedals = 130;
    final int totalPoints = _calculateTotalPoints(totalStars, totalFlowers, totalMedals);
        return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 顶部标题和积分显示
        Padding(
          padding: EdgeInsets.only(
            left: ResponsiveSize.w(40),
            right: ResponsiveSize.w(40),
            top: ResponsiveSize.h(30)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '学员积分',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(30),
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  Text(
                    '可兑总积分: ',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(24),
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '$totalPoints',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(24),
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.w(10)),
                  GestureDetector(
                    onTap: () => _showPointsRuleDialog(context),
                    child: Image.asset(
                      'assets/questionmark.png',
                      width: ResponsiveSize.w(24),
                      height: ResponsiveSize.h(24),
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.w(40)),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const PointsRuleDialog(),
                      );
                    },
                    child: Text(
                      '积分规则',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(24),
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 表格标题
        Container(
          margin: EdgeInsets.all(ResponsiveSize.w(20)),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE4B5),
            borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: ResponsiveSize.h(15),
              horizontal: ResponsiveSize.w(20)
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
            ),
                        child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      '排名',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(20),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5C3D2E),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      '学员',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(20),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5C3D2E),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      '所在班级',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(20),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5C3D2E),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      '可兑/总积分',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(20),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5C3D2E),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 表格内容
        Container(
          margin: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(20)),
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveSize.h(15),
            horizontal: ResponsiveSize.w(20)
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    '1',
                    style: TextStyle(fontSize: ResponsiveSize.sp(20)),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/star.png',
                        width: ResponsiveSize.w(40),
                        height: ResponsiveSize.h(40),
                      ),
                      SizedBox(width: ResponsiveSize.w(10)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '示例学生',
                            style: TextStyle(fontSize: ResponsiveSize.sp(20)),
                          ),
                          Text(
                            'studentedk',
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(16),
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    '三年二班',
                    style: TextStyle(fontSize: ResponsiveSize.sp(20)),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    '13/13',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(20),
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}