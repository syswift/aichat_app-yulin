import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';
import '../../adminView/models/student_model.dart';
import '../classManage/models/comment_model.dart';
import '../classManage/models/ranking_model.dart';
import '../classManage/models/task_model.dart';

class StudentDetailPage extends StatefulWidget {
  final Student student;

  const StudentDetailPage({
    super.key,
    required this.student,
  });

  @override
  State<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  // 当前选中的菜单项
  String _selectedMenu = '排行榜';
  
  // 模拟数据 - 实际应用中这些数据应该从后端获取
  final List<RankingItem> _rankingList = [
    RankingItem(studentId: '1', studentName: '张三', score: 95),
    RankingItem(studentId: '2', studentName: '李四', score: 88),
    // ... 其他排名数据
  ];

  final List<TaskItem> _taskList = [
    TaskItem(
      id: '1',
      title: '数学作业1',
      status: '已完成',
      submitTime: DateTime.now(),
      score: 95,
    ),
    // ... 其他任务数据
  ];

  final List<TeacherComment> _commentList = [
    TeacherComment(
      id: '1',
      teacherName: '王老师',
      content: '学习态度认真，继续加油！',
      createTime: DateTime.now(),
    ),
    // ... 其他评论数据
  ];

  // 统一使用棕色系的颜色主题
  final _menuThemes = {
    '排行榜': {
      'color': const Color(0xFF8B4513), // 深棕色
      'icon': Icons.leaderboard,
      'bgColor': const Color(0xFFFFE4C4), // 浅棕色背景
    },
    '任务': {
      'color': const Color(0xFF8B4513), // 深棕色
      'icon': Icons.assignment,
      'bgColor': const Color(0xFFFFE4C4), // 浅棕色背景
    },
    '老师留言': {
      'color': const Color(0xFF8B4513), // 深棕色
      'icon': Icons.message,
      'bgColor': const Color(0xFFFFE4C4), // 浅棕色背景
    },
  };

  // 添加模拟的当前登录教师信息（后期从用户状态管理或后端获取）
  final _currentTeacher = {
    'id': 'T001',
    'name': '王小明',
    'title': '数学教师',
  };

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      body: Padding(
        padding: EdgeInsets.all(ResponsiveSize.w(32)),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: ResponsiveSize.h(32)),
            Expanded(
              child: Row(
                children: [
                  // 左侧信息栏
                  SizedBox(
                    width: ResponsiveSize.w(300),
                    child: _buildLeftPanel(),
                  ),
                  SizedBox(width: ResponsiveSize.w(32)),
                  // 右侧内容区
                  Expanded(
                    child: _buildRightPanel(),
                  ),
                ],
              ),
            ),
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
        Text(
          '学员详情',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(24),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8B4513),
          ),
        ),
      ],
    );
  }

  Widget _buildLeftPanel() {
    return Container(
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        child: Column(
          children: [
            // 上部分 - 个人信息
            Container(
              padding: EdgeInsets.all(ResponsiveSize.w(24)),
              decoration: BoxDecoration(
                border: const Border(
                  bottom: BorderSide(color: Color(0xFFDEB887)),
                ),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFE4C4),
                    Colors.white,
                  ],
                ),
              ),
              child: Column(
                children: [
                  // 头像
                  Container(
                    padding: EdgeInsets.all(ResponsiveSize.w(4)),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFDEB887),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: ResponsiveSize.w(50),
                      backgroundColor: Colors.white,
                      child: Text(
                        widget.student.name.substring(0, 1),
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(32),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF8B4513),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(16)),
                  // 用户名
                  Text(
                    widget.student.name,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(24),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8B4513),
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(8)),
                  // 班级信息
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.w(12),
                      vertical: ResponsiveSize.h(4),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDEB887).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                    ),
                    child: Text(
                      widget.student.classNames.join('、'),
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(16),
                        color: const Color(0xFF8B4513),
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(16)),
                  // 添加更多学生信息
                  _buildInfoItem('学习阶段', widget.student.level),
                  _buildInfoItem('指导老师', widget.student.planner),
                  _buildInfoItem('加入时间', _formatDate(widget.student.joinDate)),
                ],
              ),
            ),
            // 下部分 - 菜单选项
            Column(
              children: _buildMenuItems(),
            ),
          ],
        ),
      ),
    );
  }

  // 添加信息项组件
  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(4)),
      child: Row(
        children: [
          Text(
            '$label：',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(14),
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveSize.sp(14),
              color: const Color(0xFF8B4513),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // 修改菜单项构建方法
  List<Widget> _buildMenuItems() {
    return _menuThemes.entries.map((entry) {
      final isSelected = _selectedMenu == entry.key;
      final theme = entry.value;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? theme['bgColor'] as Color : Colors.transparent,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => setState(() => _selectedMenu = entry.key),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.w(24),
                vertical: ResponsiveSize.h(16),
              ),
              child: Row(
                children: [
                  Icon(
                    theme['icon'] as IconData,
                    color: theme['color'] as Color,
                    size: ResponsiveSize.w(24),
                  ),
                  SizedBox(width: ResponsiveSize.w(16)),
                  Text(
                    entry.key,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(16),
                      color: theme['color'] as Color,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  // 格式化日期
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Widget _buildRightPanel() {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(24)),
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
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: _buildRightContent(),
      ),
    );
  }

  Widget _buildRightContent() {
    switch (_selectedMenu) {
      case '排行榜':
        return _buildRankingList();
      case '任务':
        return _buildTaskList();
      case '老师留言':
        return _buildCommentList();
      default:
        return const SizedBox();
    }
  }

  // 排行榜内容
  Widget _buildRankingList() {
    return Column(
      children: [
        _buildRightHeader('积分排行榜'),
        Expanded(
          child: ListView.builder(
            itemCount: _rankingList.length,
            itemBuilder: (context, index) {
              return _buildRankingItem(_rankingList[index], index);
            },
          ),
        ),
      ],
    );
  }

  // 任务列表内容
  Widget _buildTaskList() {
    return Column(
      children: [
        _buildRightHeader('作业任务'),
        Expanded(
          child: ListView.builder(
            itemCount: _taskList.length,
            itemBuilder: (context, index) => _buildTaskItem(_taskList[index]),
          ),
        ),
      ],
    );
  }

  // 老师留言内容
  Widget _buildCommentList() {
    return Column(
      children: [
        _buildRightHeader(
          '老师留言',
          action: TextButton.icon(
            onPressed: _showAddCommentDialog,
            icon: const Icon(
              Icons.add,
              color: Color(0xFF8B4513),
            ),
            label: Text(
              '添加点评',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(16),
                color: const Color(0xFF8B4513),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _commentList.length,
            itemBuilder: (context, index) => _buildCommentItem(_commentList[index]),
          ),
        ),
      ],
    );
  }

  // 修改右侧标题栏
  Widget _buildRightHeader(String title, {Widget? action}) {
    return Container(
      padding: EdgeInsets.only(bottom: ResponsiveSize.h(16)),
      margin: EdgeInsets.only(bottom: ResponsiveSize.h(16)),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFDEB887)),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: ResponsiveSize.sp(20),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF8B4513),
            ),
          ),
          const Spacer(),
          if (action != null) action,
        ],
      ),
    );
  }

  void _showAddCommentDialog() {
    final commentController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        ),
        title: Row(
          children: [
            Icon(
              Icons.edit_note,
              color: const Color(0xFF8B4513),
              size: ResponsiveSize.w(24),
            ),
            SizedBox(width: ResponsiveSize.w(8)),
            Text(
              '添加点评',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(20),
                color: const Color(0xFF8B4513),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: ResponsiveSize.w(500),
          child: TextField(
            controller: commentController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: '请输入点评内容',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: ResponsiveSize.sp(14),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                borderSide: const BorderSide(color: Color(0xFFDEB887)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                borderSide: const BorderSide(color: Color(0xFFDEB887)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                borderSide: const BorderSide(color: Color(0xFF8B4513)),
              ),
              filled: true,
              fillColor: const Color(0xFFFFF8DC),
              contentPadding: EdgeInsets.all(ResponsiveSize.w(16)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '取消',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(16),
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (commentController.text.isNotEmpty) {
                _addNewComment(commentController.text);  // 抽取添加评论的逻辑
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B4513),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
              ),
            ),
            child: Text(
              '确定',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(16),
                color: Colors.white,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
    );
  }

  // 抽取添加评论的方法，方便后期与后端集成
  void _addNewComment(String content) {
    // TODO: 后期这里将改为调用后端API
    setState(() {
      _commentList.insert(
        0,
        TeacherComment(
          id: DateTime.now().toString(),  // 后期由后端生成ID
          teacherName: _currentTeacher['name']!,  // 使用当前登录教师的名字
          content: content,
          createTime: DateTime.now(),
        ),
      );
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
           '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildRankingItem(RankingItem item, int index) {
    final isTopThree = index < 3;
    final rankColors = [
      const Color(0xFFFFD700), // 金
      const Color(0xFFC0C0C0), // 银
      const Color(0xFFCD7F32), // 铜
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveSize.h(16),
        horizontal: ResponsiveSize.w(24),
      ),
      margin: EdgeInsets.only(bottom: ResponsiveSize.h(8)),
      decoration: BoxDecoration(
        color: isTopThree ? rankColors[index].withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
        border: Border.all(color: const Color(0xFFDEB887)),
      ),
      child: Row(
        children: [
          if (isTopThree) ...[
            Icon(
              Icons.emoji_events,
              color: rankColors[index],
              size: ResponsiveSize.w(24),
            ),
            SizedBox(width: ResponsiveSize.w(8)),
          ] else ...[
            Container(
              width: ResponsiveSize.w(24),
              height: ResponsiveSize.w(24),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFDEB887).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(14),
                  color: const Color(0xFF8B4513),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: ResponsiveSize.w(8)),
          ],
          Text(
            item.studentName,
            style: TextStyle(
              fontSize: ResponsiveSize.sp(16),
              color: const Color(0xFF8B4513),
              fontWeight: isTopThree ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.w(12),
              vertical: ResponsiveSize.h(4),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFDEB887).withOpacity(0.1),
              borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
            ),
            child: Text(
              '${item.score}分',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(16),
                color: const Color(0xFF8B4513),
                fontWeight: isTopThree ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 修改任务状态的颜色
  Widget _buildTaskItem(TaskItem task) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(16)),
      margin: EdgeInsets.only(bottom: ResponsiveSize.h(16)),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8DC),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
        border: Border.all(color: const Color(0xFFDEB887)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                task.title,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(18),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8B4513),
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.w(12),
                  vertical: ResponsiveSize.h(4),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4C4),
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                ),
                child: Text(
                  task.status,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(14),
                    color: const Color(0xFF8B4513),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.h(8)),
          Text(
            '提交时间：${_formatDateTime(task.submitTime)}',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(14),
              color: Colors.grey,
            ),
          ),
          if (task.score != null) ...[
            SizedBox(height: ResponsiveSize.h(8)),
            Text(
              '得分：${task.score}分',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(16),
                color: const Color(0xFF8B4513),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 优化评论列表项
  Widget _buildCommentItem(TeacherComment comment) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(16)),
      margin: EdgeInsets.only(bottom: ResponsiveSize.h(16)),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8DC),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
        border: Border.all(color: const Color(0xFFDEB887)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                comment.teacherName,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(16),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8B4513),
                ),
              ),
              const Spacer(),
              Text(
                _formatDateTime(comment.createTime),
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(14),
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.h(8)),
          Text(
            comment.content,
            style: TextStyle(
              fontSize: ResponsiveSize.sp(16),
              color: const Color(0xFF8B4513),
            ),
          ),
        ],
      ),
    );
  }
} 