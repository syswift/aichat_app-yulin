import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';
import './models/daily_task.dart';
import './daily_task_setting_page.dart';
import '../../questionBankManage/schoolQuestion/school_question_bank.dart';
import 'system_homework_page.dart';

class CreateSystemHomeworkPage extends StatefulWidget {
  final Function(SystemHomeworkItem) onCreateHomework;
  final SystemHomeworkItem? initialHomework;

  const CreateSystemHomeworkPage({
    super.key,
    required this.onCreateHomework,
    this.initialHomework,
  });

  @override
  State<CreateSystemHomeworkPage> createState() => _CreateSystemHomeworkPageState();
}

class _CreateSystemHomeworkPageState extends State<CreateSystemHomeworkPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  int _selectedDays = 7; // 默认7天
  
  // 修改数据结构定义
  late List<List<DailyTask>> _dailyTasks;

  @override
  void initState() {
    super.initState();
    // 初始化每日任务列表
    _dailyTasks = List.generate(7, (index) => <DailyTask>[]);
    // 如果有初始数据，填充到表单中
    if (widget.initialHomework != null) {
      _nameController.text = widget.initialHomework!.name;
      _noteController.text = widget.initialHomework!.note;
      if (widget.initialHomework!.dailyTasks != null) {
        _dailyTasks = widget.initialHomework!.dailyTasks!;
        _selectedDays = widget.initialHomework!.dailyTasks!.length;
      }
    }
  }

  // 当切换天数时更新任务列表
  void _updateSelectedDays(int days) {
    setState(() {
      _selectedDays = days;
      // 保留原有数据，只在需要时扩展列表
      if (days > _dailyTasks.length) {
        _dailyTasks.addAll(
          List.generate(days - _dailyTasks.length, (index) => <DailyTask>[])
        );
      } else if (days < _dailyTasks.length) {
        _dailyTasks = _dailyTasks.sublist(0, days);
      }
    });
  }

  // 修改天数选择按钮的处理方法
  Widget _buildDayOption(int days) {
    bool isSelected = _selectedDays == days;
    return GestureDetector(
      onTap: () => _updateSelectedDays(days),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(24),
          vertical: ResponsiveSize.h(12),
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFE4C4) : Colors.white,
          border: Border.all(
            color: const Color(0xFFDEB887),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
        ),
        child: Text(
          '$days天',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(16),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: const Color(0xFF5A2E17),
          ),
        ),
      ),
    );
  }

  // 添加保存方法
  Map<String, dynamic> _getFormData() {
    return {
      'name': _nameController.text,
      'note': _noteController.text,
      'days': _selectedDays,
      'dailyTasks': _dailyTasks.map((dayTasks) => 
        dayTasks.map((task) => task.toJson()).toList()
      ).toList(),
    };
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(20),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF5A2E17),
          ),
        ),
        SizedBox(height: ResponsiveSize.h(12)),
        child,
      ],
    );
  }

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: ResponsiveSize.sp(16),
        color: const Color(0xFF5A2E17).withOpacity(0.5),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(16),
        vertical: ResponsiveSize.h(12),
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
        borderSide: const BorderSide(color: Color(0xFF8B4513), width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  void _importFromQuestionBank() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SchoolQuestionBankPage(),
      ),
    );
  }

  void _handleCreate() {
    if (_formKey.currentState!.validate()) {
      bool hasEmptyDays = _dailyTasks.any((dayTasks) => dayTasks.isEmpty);
      if (hasEmptyDays) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请确保每天都设置了任务')),
        );
        return;
      }

      final newHomework = SystemHomeworkItem(
        name: _nameController.text,
        note: _noteController.text,
        dailyTasks: _dailyTasks,
      );
      
      widget.onCreateHomework(newHomework);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1D6),
      body: Stack(
        children: [
          // 返回按钮
          Positioned(
            top: ResponsiveSize.h(40),
            left: ResponsiveSize.w(32),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Image.asset(
                'assets/backbutton1.png',
                width: ResponsiveSize.w(80),
                height: ResponsiveSize.h(80),
              ),
            ),
          ),

          // 标题
          Positioned(
            top: ResponsiveSize.h(55),
            left: ResponsiveSize.w(140),
            child: Text(
              '创建系统作业',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(28),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5A2E17),
              ),
            ),
          ),

          // 确认创建按钮
          Positioned(
            top: ResponsiveSize.h(55),
            right: ResponsiveSize.w(32),
            child: ElevatedButton(
              onPressed: _handleCreate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFE4C4),
                foregroundColor: const Color(0xFF8B4513),
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.w(40),
                  vertical: ResponsiveSize.h(16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                  side: const BorderSide(
                    color: Color(0xFFDEB887),
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                '确认创建',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(22),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // 主要内容
          Padding(
            padding: EdgeInsets.only(
              top: ResponsiveSize.h(150),
              left: ResponsiveSize.w(32),
              right: ResponsiveSize.w(32),
              bottom: ResponsiveSize.h(32),
            ),
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(ResponsiveSize.w(32)),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: ResponsiveSize.w(10),
                      offset: Offset(0, ResponsiveSize.h(4)),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 系统作业名称
                      _buildSection(
                        title: '系统作业名称',
                        child: TextFormField(
                          controller: _nameController,
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(18),
                            color: const Color(0xFF5A2E17),
                          ),
                          decoration: _buildInputDecoration('请输入系统作业名称'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入系统作业名称';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(24)),

                      // 添加备注输入框
                      _buildSection(
                        title: '系统作业备注',
                        child: TextFormField(
                          controller: _noteController,
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(18),
                            color: const Color(0xFF5A2E17),
                          ),
                          decoration: _buildInputDecoration('请输入系统作业备注'),
                          maxLines: 3, // 允许多行输入
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入系统作业备注';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(24)),

                      // 周期选择
                      _buildSection(
                        title: '选择周期',
                        child: Row(
                          children: [
                            _buildDayOption(7),
                            SizedBox(width: ResponsiveSize.w(16)),
                            _buildDayOption(10),
                          ],
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(24)),

                      // 每日任务设置
                      _buildSection(
                        title: '每日任务设置',
                        child: Column(
                          children: List.generate(_selectedDays, (dayIndex) {
                            return Container(
                              margin: EdgeInsets.only(bottom: ResponsiveSize.h(16)),
                              padding: EdgeInsets.all(ResponsiveSize.w(16)),
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFDEB887)),
                                borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '第${dayIndex + 1}天',
                                        style: TextStyle(
                                          fontSize: ResponsiveSize.sp(18),
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF5A2E17),
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DailyTaskSettingPage(
                                                existingTasks: _dailyTasks[dayIndex],
                                                onTaskAdded: (task) {
                                                  setState(() {
                                                    _dailyTasks[dayIndex].add(task);
                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.add, size: ResponsiveSize.w(20)),
                                        label: Text('添加任务'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFFFE4C4),
                                          foregroundColor: const Color(0xFF8B4513),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_dailyTasks[dayIndex].isNotEmpty) ...[
                                    SizedBox(height: ResponsiveSize.h(16)),
                                    ..._dailyTasks[dayIndex].map((task) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: ResponsiveSize.h(8)),
                                        padding: EdgeInsets.all(ResponsiveSize.w(16)),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                                          border: Border.all(color: const Color(0xFFDEB887)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '任务名称：${task.taskName}',
                                              style: TextStyle(
                                                fontSize: ResponsiveSize.sp(16),
                                                color: const Color(0xFF5A2E17),
                                              ),
                                            ),
                                            SizedBox(height: ResponsiveSize.h(8)),
                                            Text(
                                              '任务备注：${task.taskNote}',
                                              style: TextStyle(
                                                fontSize: ResponsiveSize.sp(14),
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            if (task.isFromQuestionBank && task.questionBankInfo != null) ...[
                                              SizedBox(height: ResponsiveSize.h(8)),
                                              Text(
                                                '共${task.questionBankInfo!['totalQuestionCount']}道题',
                                                style: TextStyle(
                                                  fontSize: ResponsiveSize.sp(14),
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: (task.questionBankInfo!['banks'] as List).map<Widget>((bank) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(top: ResponsiveSize.h(4)),
                                                    child: Text(
                                                      '题库：${bank['title']} (${bank['grade']} ${bank['subject']})',
                                                      style: TextStyle(
                                                        fontSize: ResponsiveSize.sp(14),
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    '数量：${task.taskCount}',
                                                    style: TextStyle(
                                                      fontSize: ResponsiveSize.sp(14),
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  SizedBox(width: ResponsiveSize.w(16)),
                                                  // 编辑按钮
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.edit,
                                                      size: ResponsiveSize.w(20),
                                                      color: const Color(0xFF8B4513),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => DailyTaskSettingPage(
                                                            existingTasks: _dailyTasks[dayIndex],
                                                            onTaskAdded: (newTask) {
                                                              setState(() {
                                                                _dailyTasks[dayIndex].add(newTask);
                                                              });
                                                            },
                                                            taskToEdit: task,
                                                            onTaskEdited: (editedTask) {
                                                              setState(() {
                                                                final index = _dailyTasks[dayIndex].indexOf(task);
                                                                if (index != -1) {
                                                                  _dailyTasks[dayIndex][index] = editedTask;
                                                                }
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  // 删除按钮
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      size: ResponsiveSize.w(20),
                                                      color: Colors.red[400],
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _dailyTasks[dayIndex].remove(task);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 