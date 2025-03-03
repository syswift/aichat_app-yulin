import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart'; // 添加响应式工具类

// 数据模型部分保持不变，只需添加到文件顶部
class StudentPoints {
  final String name;
  final String className;
  int points;
  final List<PointActivity> recentActivity;

  StudentPoints({
    required this.name,
    required this.className,
    required this.points,
    required this.recentActivity,
  });
}

class PointActivity {
  final ActivityType type;
  final int points;
  final String reason;
  final String date;

  PointActivity({
    required this.type,
    required this.points,
    required this.reason,
    required this.date,
  });
}

enum ActivityType { reward, exchange }

class Prize {
  final String name;
  final int points;
  final String image;
  final String description;
  int stock;

  Prize({
    required this.name,
    required this.points,
    required this.image,
    required this.stock,
    required this.description,
  });
}

class ExchangeRecord {
  final String studentName;
  final String className;
  final String prizeName;
  final int points;
  final ExchangeStatus status;
  final String date;

  ExchangeRecord({
    required this.studentName,
    required this.className,
    required this.prizeName,
    required this.points,
    required this.status,
    required this.date,
  });
}

enum ExchangeStatus { pending, shipping, delivered }

class PointsManagePage extends StatefulWidget {
  const PointsManagePage({super.key});

  @override
  State<PointsManagePage> createState() => _PointsManagePageState();
}

class _PointsManagePageState extends State<PointsManagePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTab = '积分奖励';
  String _selectedClass = '全部班级';
  final Set<Prize> _selectedPrizes = {};
  final bool _isDeleteMode = false;

  // 模拟班级数据
  final List<String> _classes = ['全部班级', '一年级一班', '一年级二班', '二年级一班', '二年级二班'];

  // 模拟学生积分数据
  final List<StudentPoints> _students = [
    StudentPoints(
      name: '张三',
      className: '一年级一班',
      points: 850,
      recentActivity: [
        PointActivity(
          type: ActivityType.reward,
          points: 50,
          reason: '课堂表现优秀',
          date: '2024-02-25',
        ),
        PointActivity(
          type: ActivityType.exchange,
          points: 200,
          reason: '兑换文具套装',
          date: '2024-02-20',
        ),
      ],
    ),
    StudentPoints(
      name: '李四',
      className: '一年级一班',
      points: 720,
      recentActivity: [
        PointActivity(
          type: ActivityType.reward,
          points: 30,
          reason: '作业完成认真',
          date: '2024-02-24',
        ),
      ],
    ),
    StudentPoints(
      name: '王五',
      className: '一年级二班',
      points: 920,
      recentActivity: [
        PointActivity(
          type: ActivityType.reward,
          points: 100,
          reason: '获得数学竞赛一等奖',
          date: '2024-02-23',
        ),
      ],
    ),
    StudentPoints(
      name: '赵六',
      className: '二年级一班',
      points: 680,
      recentActivity: [
        PointActivity(
          type: ActivityType.exchange,
          points: 150,
          reason: '兑换精美笔记本',
          date: '2024-02-22',
        ),
      ],
    ),
    StudentPoints(
      name: '钱七',
      className: '二年级二班',
      points: 800,
      recentActivity: [
        PointActivity(
          type: ActivityType.reward,
          points: 80,
          reason: '帮助同学解决问题',
          date: '2024-02-21',
        ),
      ],
    ),
  ];

  // 模拟奖品数据
  final List<Prize> _prizes = [
    Prize(
      name: '文具套装',
      points: 200,
      image: 'assets/prize1.png',
      stock: 50,
      description: '优质文具套装，包含铅笔、橡皮、尺子等',
    ),
    Prize(
      name: '精美笔记本',
      points: 150,
      image: 'assets/prize2.png',
      stock: 30,
      description: 'A5大小，优质纸张，适合日常记录',
    ),
    Prize(
      name: '儿童故事书',
      points: 180,
      image: 'assets/prize2.png',
      stock: 25,
      description: '精选儿童文学作品，图文并茂',
    ),
    Prize(
      name: '运动水杯',
      points: 120,
      image: 'assets/prize2.png',
      stock: 40,
      description: '便携运动水杯，防漏耐用',
    ),
  ];

  // 模拟兑换记录
  final List<ExchangeRecord> _exchangeRecords = [
    ExchangeRecord(
      studentName: '张三',
      className: '一年级一班',
      prizeName: '文具套装',
      points: 200,
      status: ExchangeStatus.delivered,
      date: '2024-02-20',
    ),
    ExchangeRecord(
      studentName: '赵六',
      className: '二年级一班',
      prizeName: '精美笔记本',
      points: 150,
      status: ExchangeStatus.shipping,
      date: '2024-02-22',
    ),
    ExchangeRecord(
      studentName: '李四',
      className: '一年级一班',
      prizeName: '儿童故事书',
      points: 180,
      status: ExchangeStatus.pending,
      date: '2024-02-24',
    ),
    ExchangeRecord(
      studentName: '王五',
      className: '一年级二班',
      prizeName: '运动水杯',
      points: 120,
      status: ExchangeStatus.delivered,
      date: '2024-02-21',
    ),
    ExchangeRecord(
      studentName: '钱七',
      className: '二年级二班',
      prizeName: '文具套装',
      points: 200,
      status: ExchangeStatus.shipping,
      date: '2024-02-23',
    ),
  ];

  List<StudentPoints> get _filteredStudents {
    if (_selectedClass == '全部班级') {
      return _students;
    }
    return _students
        .where((student) => student.className == _selectedClass)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      body: Padding(
        padding: EdgeInsets.all(ResponsiveSize.w(32)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: ResponsiveSize.h(32)),
            _buildTabs(),
            SizedBox(height: ResponsiveSize.h(24)),
            Expanded(child: _buildMainContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            'assets/backbutton1.png',
            width: ResponsiveSize.w(80),
            height: ResponsiveSize.h(80),
          ),
        ),
        SizedBox(width: ResponsiveSize.w(20)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '积分管理',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(28),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8B4513),
              ),
            ),
            SizedBox(height: ResponsiveSize.h(4)),
            Text(
              '管理学生积分和奖品兑换',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(16),
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const Spacer(),
        _buildSearchBar(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: ResponsiveSize.w(300),
      height: ResponsiveSize.h(46),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(23)),
        border: Border.all(color: const Color(0xFFDEB887)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: ResponsiveSize.w(10),
            offset: Offset(0, ResponsiveSize.h(4)),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(fontSize: ResponsiveSize.sp(16)),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: '搜索学生或奖品',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: ResponsiveSize.sp(16),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[400],
            size: ResponsiveSize.w(20),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.w(16),
          ),
          isCollapsed: true,
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      height: ResponsiveSize.h(60),
      margin: EdgeInsets.only(left: ResponsiveSize.w(32)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(30)),
        border: Border.all(color: const Color(0xFFDEB887)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTab('积分奖励', Icons.star),
          SizedBox(width: ResponsiveSize.w(16)),
          _buildTab('兑换记录', Icons.history),
        ],
      ),
    );
  }

  Widget _buildTab(String title, IconData icon) {
    bool isSelected = _selectedTab == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = title),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(32),
          vertical: ResponsiveSize.h(12),
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFE4C4) : Colors.transparent,
          borderRadius: BorderRadius.circular(ResponsiveSize.w(30)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: ResponsiveSize.w(24),
              color: isSelected ? const Color(0xFF8B4513) : Colors.grey[600],
            ),
            SizedBox(width: ResponsiveSize.w(12)),
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveSize.sp(20),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFF8B4513) : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_selectedTab) {
      case '积分奖励':
        return _buildRewardContent();
      case '兑换记录':
        return _buildRecordsContent();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRewardContent() {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(32)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        border: Border.all(color: const Color(0xFFDEB887)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterDropdown(),
          SizedBox(height: ResponsiveSize.h(32)),
          _buildListHeader(),
          SizedBox(height: ResponsiveSize.h(16)),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredStudents.length,
              itemBuilder:
                  (context, index) => _buildStudentListItem(
                    _filteredStudents[index],
                    index + 1,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(24),
        vertical: ResponsiveSize.h(12),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        border: Border.all(color: const Color(0xFFDEB887)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: ResponsiveSize.w(10),
            offset: Offset(0, ResponsiveSize.h(4)),
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: _selectedClass,
        icon: Icon(
          Icons.arrow_drop_down,
          color: const Color(0xFF8B4513),
          size: ResponsiveSize.w(30),
        ),
        elevation: 16,
        style: TextStyle(
          fontSize: ResponsiveSize.sp(20),
          color: const Color(0xFF8B4513),
        ),
        underline: Container(height: 0),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedClass = newValue;
            });
          }
        },
        items:
            _classes.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(20),
                    color: const Color(0xFF8B4513),
                  ),
                ),
              );
            }).toList(),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        isExpanded: false,
        hint: Text(
          '选择班级',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(20),
            color: const Color(0xFF8B4513),
          ),
        ),
      ),
    );
  }

  Widget _buildListHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(24),
        vertical: ResponsiveSize.h(16),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8DC),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                '序号',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8B4513),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                '学生姓名',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8B4513),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                '班级',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8B4513),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                '当前积分',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8B4513),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                '操作',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8B4513),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showActivityHistory(StudentPoints student) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
            ),
            child: Container(
              width: ResponsiveSize.w(600),
              padding: EdgeInsets.all(ResponsiveSize.w(24)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${student.name}的积分记录',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(24),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF8B4513),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveSize.h(24)),
                  Container(
                    padding: EdgeInsets.all(ResponsiveSize.w(16)),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8DC),
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '当前积分：${student.points}',
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(18),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF8B4513),
                          ),
                        ),
                        Text(
                          '班级：${student.className}',
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(18),
                            color: const Color(0xFF8B4513),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(24)),
                  Text(
                    '积分变动记录',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(18),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8B4513),
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(16)),
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: ResponsiveSize.h(300),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: student.recentActivity.length,
                      itemBuilder: (context, index) {
                        final activity = student.recentActivity[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: ResponsiveSize.h(12)),
                          padding: EdgeInsets.all(ResponsiveSize.w(16)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.w(12),
                            ),
                            border: Border.all(color: const Color(0xFFDEB887)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(ResponsiveSize.w(8)),
                                decoration: BoxDecoration(
                                  color:
                                      activity.type == ActivityType.reward
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  activity.type == ActivityType.reward
                                      ? Icons.add_circle_outline
                                      : Icons.remove_circle_outline,
                                  color:
                                      activity.type == ActivityType.reward
                                          ? Colors.green
                                          : Colors.red,
                                  size: ResponsiveSize.w(24),
                                ),
                              ),
                              SizedBox(width: ResponsiveSize.w(16)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      activity.reason,
                                      style: TextStyle(
                                        fontSize: ResponsiveSize.sp(16),
                                        color: const Color(0xFF8B4513),
                                      ),
                                    ),
                                    SizedBox(height: ResponsiveSize.h(4)),
                                    Text(
                                      activity.date,
                                      style: TextStyle(
                                        fontSize: ResponsiveSize.sp(14),
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                activity.type == ActivityType.reward
                                    ? '+${activity.points}'
                                    : '-${activity.points}',
                                style: TextStyle(
                                  fontSize: ResponsiveSize.sp(18),
                                  fontWeight: FontWeight.bold,
                                  color:
                                      activity.type == ActivityType.reward
                                          ? Colors.green
                                          : Colors.red,
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
    );
  }

  Widget _buildStudentListItem(StudentPoints student, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveSize.h(16)),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(24),
        vertical: ResponsiveSize.h(20),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        border: Border.all(color: const Color(0xFFDEB887)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: ResponsiveSize.w(10),
            offset: Offset(0, ResponsiveSize.h(4)),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                index.toString(),
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  color: const Color(0xFF8B4513),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                student.name,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8B4513),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                student.className,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  color: const Color(0xFF8B4513),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                '${student.points}分',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  color: const Color(0xFF8B4513),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _showRewardDialog(student),
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: ResponsiveSize.w(28),
                    color: const Color(0xFF8B4513),
                  ),
                  tooltip: '积分奖励',
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFFFE4C4),
                    padding: EdgeInsets.all(ResponsiveSize.w(12)),
                  ),
                ),
                SizedBox(width: ResponsiveSize.w(16)),
                IconButton(
                  onPressed: () => _showActivityHistory(student),
                  icon: Icon(
                    Icons.history,
                    size: ResponsiveSize.w(28),
                    color: const Color(0xFF8B4513),
                  ),
                  tooltip: '积分记录',
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFFFE4C4),
                    padding: EdgeInsets.all(ResponsiveSize.w(12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRewardDialog(StudentPoints student) {
    final TextEditingController pointsController = TextEditingController();
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              '积分奖励 - ${student.name}',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(24),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8B4513),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: pointsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '奖励积分',
                      labelStyle: TextStyle(
                        fontSize: ResponsiveSize.sp(18),
                        color: const Color(0xFF8B4513),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveSize.w(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(16)),
                  TextField(
                    controller: reasonController,
                    decoration: InputDecoration(
                      labelText: '奖励原因',
                      labelStyle: TextStyle(
                        fontSize: ResponsiveSize.sp(18),
                        color: const Color(0xFF8B4513),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveSize.w(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  '取消',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(18),
                    color: const Color(0xFF8B4513),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  final points = int.tryParse(pointsController.text);
                  final reason = reasonController.text;

                  if (points != null && points > 0 && reason.isNotEmpty) {
                    setState(() {
                      student.points += points;
                      student.recentActivity.insert(
                        0,
                        PointActivity(
                          type: ActivityType.reward,
                          points: points,
                          reason: reason,
                          date: DateTime.now().toString().substring(0, 10),
                        ),
                      );
                    });
                    Navigator.pop(context);

                    // 显示成功提示
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '积分奖励成功！',
                          style: TextStyle(fontSize: ResponsiveSize.sp(16)),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    // 显示错误提示
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '请输入有效的积分和奖励原因',
                          style: TextStyle(fontSize: ResponsiveSize.sp(16)),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text(
                  '确定',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(18),
                    color: const Color(0xFF8B4513),
                  ),
                ),
              ),
            ],
            insetPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.w(24),
              vertical: ResponsiveSize.h(24),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
            ),
          ),
    );
  }

  Widget _buildRecordsContent() {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(32)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        border: Border.all(color: const Color(0xFFDEB887)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildStatusFilter(),
              SizedBox(width: ResponsiveSize.w(16)),
              _buildDateRangePicker(),
            ],
          ),
          SizedBox(height: ResponsiveSize.h(32)),
          _buildExchangeListHeader(),
          SizedBox(height: ResponsiveSize.h(16)),
          Expanded(
            child: ListView.builder(
              itemCount: _exchangeRecords.length,
              itemBuilder:
                  (context, index) =>
                      _buildExchangeRecordItem(_exchangeRecords[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(16),
        vertical: ResponsiveSize.h(8),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
        border: Border.all(color: const Color(0xFFDEB887)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '配送状态',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(16),
              color: Colors.grey[800],
            ),
          ),
          SizedBox(width: ResponsiveSize.w(8)),
          Icon(Icons.arrow_drop_down, color: Colors.grey[800]),
        ],
      ),
    );
  }

  Widget _buildDateRangePicker() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(16),
        vertical: ResponsiveSize.h(8),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
        border: Border.all(color: const Color(0xFFDEB887)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today,
            size: ResponsiveSize.w(20),
            color: Colors.grey[800],
          ),
          SizedBox(width: ResponsiveSize.w(8)),
          Text(
            '选择日期范围',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(16),
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeListHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(20),
        vertical: ResponsiveSize.h(16),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8DC),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                '学生信息',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8B4513),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                '兑换奖品',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8B4513),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                '积分',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8B4513),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                '状态',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8B4513),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                '日期',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8B4513),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeRecordItem(ExchangeRecord record) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveSize.h(12)),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(20),
        vertical: ResponsiveSize.h(16),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
        border: Border.all(color: const Color(0xFFDEB887)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    record.studentName,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(20),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8B4513),
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(4)),
                  Text(
                    record.className,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(20),
                      color: const Color(0xFF8B4513),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                record.prizeName,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  color: const Color(0xFF8B4513),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                '-${record.points}分',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  color: Colors.red,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(child: _buildStatusChip(record.status)),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                record.date,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  color: const Color(0xFF8B4513),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ExchangeStatus status) {
    Color color;
    String label;

    switch (status) {
      case ExchangeStatus.pending:
        color = Colors.orange;
        label = '待发货';
        break;
      case ExchangeStatus.shipping:
        color = Colors.blue;
        label = '配送中';
        break;
      case ExchangeStatus.delivered:
        color = Colors.green;
        label = '已送达';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(12),
        vertical: ResponsiveSize.h(4),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: ResponsiveSize.sp(14)),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
