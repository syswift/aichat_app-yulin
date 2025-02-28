import 'package:flutter/material.dart';
import './quickReview/quick_review_page.dart';
import './studentProgress/student_progress_page.dart';
import './myTemplates/my_templates_page.dart';
import 'organizationTemplates/organization_templates_page.dart';
import './homeworkSet/homework_set_page.dart';
import './systemHomework/system_homework_page.dart';
import '../../../utils/responsive_size.dart';
import '../../services/background_service.dart';

enum TaskStatus {
  all('全部', Color(0xFFF5F5F5), Color(0xFF757575)),
  pending('待开始', Color(0xFFF5F5F5), Color(0xFF757575)),
  inProgress('进行中', Color(0xFFE3F2FD), Color(0xFF1976D2)),
  completed('已完结', Color(0xFFE8F5E9), Color(0xFF43A047)),
  expired('已过期', Color(0xFFFFEBEE), Color(0xFFE57373));

  final String label;
  final Color bgColor;
  final Color textColor;

  const TaskStatus(this.label, this.bgColor, this.textColor);
}

class TaskItem {
  final String name;
  final String target;
  final String dateRange;
  final TaskStatus status;

  TaskItem({
    required this.name,
    required this.target,
    required this.dateRange,
    required this.status,
  });
}

class HeaderItem {
  final String title;
  final int flex;
  final double leftPadding;

  HeaderItem({required this.title, required this.flex, this.leftPadding = 20});
}

class AssignTaskPage extends StatefulWidget {
  const AssignTaskPage({super.key});

  @override
  State<AssignTaskPage> createState() => _AssignTaskPageState();
}

class _AssignTaskPageState extends State<AssignTaskPage> {
  String selectedMenu = '已布置任务';
  TaskStatus selectedStatus = TaskStatus.all;
  final BackgroundService _backgroundService = BackgroundService();

  final List<TaskItem> taskList = [
    TaskItem(
      name: '大灰狼',
      target: '示例班级A',
      dateRange: '2024/03/15 - 2024/03/20',
      status: TaskStatus.inProgress,
    ),
    TaskItem(
      name: '写作：我的暑假',
      target: '示例班级B',
      dateRange: '2024/03/10 - 2024/03/25',
      status: TaskStatus.pending,
    ),
    TaskItem(
      name: '口语：春天来了',
      target: '示例班级C',
      dateRange: '2024/02/15 - 2024/03/01',
      status: TaskStatus.completed,
    ),
    TaskItem(
      name: '听力：动物声音',
      target: '示例班级D',
      dateRange: '2024/01/15 - 2024/02/15',
      status: TaskStatus.expired,
    ),
  ];

  final List<HeaderItem> headers = [
    HeaderItem(title: '任务名称', flex: 3),
    HeaderItem(title: '对象', flex: 2),
    HeaderItem(title: '起止日期', flex: 2),
    HeaderItem(title: '状态', flex: 1),
    HeaderItem(title: '操作', flex: 1),
  ];

  List<TaskItem> get filteredTasks {
    if (selectedStatus == TaskStatus.all) {
      return taskList;
    }
    return taskList.where((task) => task.status == selectedStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);

    return Scaffold(
      body: FutureBuilder<ImageProvider>(
        future: _backgroundService.getBackgroundImage(),
        builder: (context, snapshot) {
          final backgroundImage =
              snapshot.data ?? const AssetImage('assets/background.jpg');

          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: backgroundImage, fit: BoxFit.cover),
            ),
            child: Row(
              children: [
                _buildSideMenu(),
                Container(width: ResponsiveSize.w(1), color: Colors.grey[300]),
                Expanded(
                  child: Container(
                    color: const Color(0xFFFDF5E6),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSideMenu() {
    return Container(
      width: ResponsiveSize.w(200),
      color: Colors.white,
      child: Column(
        children: [
          SafeArea(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(ResponsiveSize.w(16)),
                child: Image.asset(
                  'assets/backbutton1.png',
                  width: ResponsiveSize.w(80),
                  height: ResponsiveSize.h(80),
                ),
              ),
            ),
          ),
          _buildMenuItem('已布置任务'),
          _buildMenuItem('系统作业'),
          _buildMenuItem('快速点评'),
          _buildMenuItem('学员完成度'),
          _buildMenuItem('我的模板'),
          _buildMenuItem('机构模板'),
          _buildMenuItem('作业集'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title) {
    bool isSelected = selectedMenu == title;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(8)),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedMenu = title;
          });
        },
        child: Container(
          width: ResponsiveSize.w(160),
          padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(16)),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFE4C4) : Colors.transparent,
            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
            border: Border(
              left: BorderSide(
                color:
                    isSelected ? const Color(0xFFDEB887) : Colors.transparent,
                width: ResponsiveSize.w(4),
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveSize.sp(22),
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFF8B4513) : Colors.grey[800],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (selectedMenu) {
      case '已布置任务':
        return _buildAssignedTasks();
      case '系统作业':
        return const SystemHomeworkPage();
      case '快速点评':
        return const QuickReviewPage();
      case '学员完成度':
        return const StudentProgressPage();
      case '我的模板':
        return const MyTemplatesPage();
      case '机构模板':
        return const OrganizationTemplatesPage();
      case '作业集':
        return const HomeworkSetPage();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHeader(HeaderItem header) {
    if (header.title == '状态') {
      return Expanded(
        flex: header.flex,
        child: Center(
          child: PopupMenuButton<TaskStatus>(
            offset: Offset(ResponsiveSize.w(20), ResponsiveSize.h(20)),
            position: PopupMenuPosition.under,
            constraints: BoxConstraints(minWidth: ResponsiveSize.w(120)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
            ),
            color: Colors.white,
            elevation: 3,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.w(16),
                vertical: ResponsiveSize.h(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    header.title,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(25),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.w(4)),
                  Icon(
                    Icons.arrow_drop_down,
                    color: const Color(0xFF333333),
                    size: ResponsiveSize.w(24),
                  ),
                ],
              ),
            ),
            itemBuilder:
                (context) =>
                    TaskStatus.values.map((status) {
                      return PopupMenuItem<TaskStatus>(
                        value: status,
                        height: ResponsiveSize.h(45),
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(16),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveSize.w(12),
                            vertical: ResponsiveSize.h(8),
                          ),
                          child: Center(
                            child: Text(
                              status.label,
                              style: TextStyle(
                                fontSize: ResponsiveSize.sp(22),
                                color:
                                    status == selectedStatus
                                        ? const Color(0xFF1E88E5)
                                        : const Color(0xFF333333),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
            onSelected: (TaskStatus status) {
              setState(() {
                selectedStatus = status;
              });
            },
          ),
        ),
      );
    }

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

  Widget _buildAssignedTasks() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.w(24),
            vertical: ResponsiveSize.h(16),
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE4C4),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ResponsiveSize.w(16)),
              topRight: Radius.circular(ResponsiveSize.w(16)),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: ResponsiveSize.w(10),
                offset: Offset(0, ResponsiveSize.h(4)),
              ),
            ],
          ),
          child: Row(
            children: headers.map((header) => _buildHeader(header)).toList(),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(ResponsiveSize.w(16)),
                bottomRight: Radius.circular(ResponsiveSize.w(16)),
              ),
            ),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.w(24),
                    vertical: ResponsiveSize.h(20),
                  ),
                  margin: EdgeInsets.only(bottom: ResponsiveSize.h(12)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
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
                        flex: 3,
                        child: Center(
                          child: Text(
                            task.name,
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(20),
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            task.target,
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(20),
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                task.dateRange.split(' - ')[0],
                                style: TextStyle(
                                  fontSize: ResponsiveSize.sp(20),
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: ResponsiveSize.h(4)),
                              Text(
                                task.dateRange.split(' - ')[1],
                                style: TextStyle(
                                  fontSize: ResponsiveSize.sp(20),
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveSize.w(12),
                              vertical: ResponsiveSize.h(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: ResponsiveSize.w(100),
                            ),
                            decoration: BoxDecoration(
                              color: task.status.bgColor,
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.w(20),
                              ),
                            ),
                            child: Text(
                              task.status.label,
                              style: TextStyle(
                                fontSize: ResponsiveSize.sp(20),
                                color: task.status.textColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: PopupMenuButton(
                            icon: Icon(
                              Icons.settings,
                              size: ResponsiveSize.w(28),
                              color: const Color(0xFF666666),
                            ),
                            offset: Offset(
                              ResponsiveSize.w(35),
                              ResponsiveSize.h(40),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.w(8),
                              ),
                            ),
                            color: Colors.white,
                            elevation: 3,
                            itemBuilder:
                                (context) => [
                                  PopupMenuItem(
                                    height: ResponsiveSize.h(36),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveSize.w(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '删除',
                                        style: TextStyle(
                                          fontSize: ResponsiveSize.sp(22),
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        taskList.removeAt(
                                          taskList.indexOf(task),
                                        );
                                      });
                                    },
                                  ),
                                ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
