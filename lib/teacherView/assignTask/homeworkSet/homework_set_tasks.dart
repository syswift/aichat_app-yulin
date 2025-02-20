import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../utils/responsive_size.dart';  // 添加响应式尺寸工具

class HomeworkSetTask {
  String taskName;
  String taskType;
  String taskDescription;
  String note;
  DateTime? startDate;
  DateTime? endDate;
  String? coverPath;

  HomeworkSetTask({
    required this.taskName,
    required this.taskType,
    required this.taskDescription,
    required this.note,
    this.startDate,
    this.endDate,
    this.coverPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'taskName': taskName,
      'taskType': taskType,
      'taskDescription': taskDescription,
      'note': note,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'coverPath': coverPath,
    };
  }

  factory HomeworkSetTask.fromJson(Map<String, dynamic> json) {
    return HomeworkSetTask(
      taskName: json['taskName'],
      taskType: json['taskType'],
      taskDescription: json['taskDescription'],
      note: json['note'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      coverPath: json['coverPath'],
    );
  }
}
class HomeworkSetTasks extends StatefulWidget {
  final List<HomeworkSetTask> tasks;
  final DateTime? setStartDate;
  final DateTime? setEndDate;
  final Function(List<HomeworkSetTask>) onTasksChanged;

  const HomeworkSetTasks({
    super.key,
    required this.tasks,
    this.setStartDate,
    this.setEndDate,
    required this.onTasksChanged,
  });

  @override
  State<HomeworkSetTasks> createState() => _HomeworkSetTasksState();
}

class _HomeworkSetTasksState extends State<HomeworkSetTasks> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskTypeController = TextEditingController();
  final TextEditingController _taskDescController = TextEditingController();
  final TextEditingController _taskNoteController = TextEditingController();
  DateTime? _taskStartDate;
  DateTime? _taskEndDate;
  String? _taskCoverPath;
  bool _isAddingTask = false;

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '任务列表',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(20),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5A2E17),
              ),
            ),
            _buildAddTaskButton(),
          ],
        ),
        SizedBox(height: ResponsiveSize.h(16)),
        if (_isAddingTask) ...[
          _buildAddTaskForm(),
          SizedBox(height: ResponsiveSize.h(16)),
        ],
        ...widget.tasks.map((task) => _buildTaskItem(task)),
      ],
    );
  }
    Widget _buildAddTaskForm() {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveSize.h(16)),
      padding: EdgeInsets.all(ResponsiveSize.w(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
        border: Border.all(color: const Color(0xFFDEB887)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左侧表单
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    TextField(
                      controller: _taskNameController,
                      decoration: _buildInputDecoration('任务名称'),
                    ),
                    SizedBox(height: ResponsiveSize.h(16)),
                    TextField(
                      controller: _taskTypeController,
                      decoration: _buildInputDecoration('任务种类'),
                    ),
                    SizedBox(height: ResponsiveSize.h(16)),
                    TextField(
                      controller: _taskDescController,
                      maxLines: 3,
                      decoration: _buildInputDecoration('任务描述'),
                    ),
                    SizedBox(height: ResponsiveSize.h(16)),
                    TextField(
                      controller: _taskNoteController,
                      maxLines: 2,
                      decoration: _buildInputDecoration('备注信息'),
                    ),
                  ],
                ),
              ),
              SizedBox(width: ResponsiveSize.w(16)),
              // 右侧封面和日期
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    // 任务封面
                    GestureDetector(
                      onTap: _pickTaskCover,
                      child: Container(
                        height: ResponsiveSize.h(160),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                          color: Colors.grey[200],
                          border: Border.all(color: const Color(0xFFDEB887)),
                        ),
                        child: _taskCoverPath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                                child: Image.file(
                                  File(_taskCoverPath!),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: Text(
                                  '点击上传任务封面',
                                  style: TextStyle(
                                    color: const Color(0xFF8B4513),
                                    fontSize: ResponsiveSize.sp(14),
                                  ),
                                ),
                              ),
                      ),
                    ),
                                        SizedBox(height: ResponsiveSize.h(16)),
                    // 日期选择
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => _selectDate(true),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(12)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                                side: const BorderSide(color: Color(0xFFDEB887)),
                              ),
                            ),
                            child: Text(
                              _taskStartDate == null
                                  ? '开始日期'
                                  : DateFormat('yyyy/MM/dd HH:mm').format(_taskStartDate!),
                              style: TextStyle(
                                fontSize: ResponsiveSize.sp(14),
                                color: const Color(0xFF5A2E17),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(4)),
                          child: const Text('至'),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () => _selectDate(false),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(12)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                                side: const BorderSide(color: Color(0xFFDEB887)),
                              ),
                            ),
                            child: Text(
                              _taskEndDate == null
                                  ? '结束日期'
                                  : DateFormat('yyyy/MM/dd').format(_taskEndDate!),
                              style: TextStyle(
                                fontSize: ResponsiveSize.sp(14),
                                color: const Color(0xFF5A2E17),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
                    SizedBox(height: ResponsiveSize.h(16)),
          // 按钮组
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _isAddingTask = false;
                    _clearTaskInputs();
                  });
                },
                child: Text(
                  '取消',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    color: const Color(0xFF8B4513),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveSize.w(16)),
              ElevatedButton(
                onPressed: _addTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFE4C4),
                  foregroundColor: const Color(0xFF8B4513),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                    side: const BorderSide(
                      color: Color(0xFFDEB887),
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  '添加任务',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddTaskButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isAddingTask = true;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFE4C4),
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(24),
          vertical: ResponsiveSize.h(12),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
          side: const BorderSide(
            color: Color(0xFFDEB887),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add,
            size: ResponsiveSize.w(20),
            color: const Color(0xFF8B4513),
          ),
          SizedBox(width: ResponsiveSize.w(8)),
          Text(
            '添加任务',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(16),
              color: const Color(0xFF8B4513),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
    Widget _buildTaskItem(HomeworkSetTask task) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: EdgeInsets.only(
            bottom: ResponsiveSize.h(16),
            top: ResponsiveSize.h(8),
            left: ResponsiveSize.w(8)
          ),
          padding: EdgeInsets.all(ResponsiveSize.w(16)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
            border: Border.all(color: const Color(0xFFDEB887)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左侧任务信息
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.taskName,
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(20),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5A2E17),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(8)),
                    Text(
                      '任务种类: ${task.taskType}',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(16),
                        color: const Color(0xFF5A2E17),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(12)),
                    Text(
                      task.taskDescription,
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(16),
                        color: const Color(0xFF5A2E17),
                      ),
                    ),
                    if (task.note.isNotEmpty) ...[
                      SizedBox(height: ResponsiveSize.h(8)),
                      Text(
                        '备注: ${task.note}',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(16),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                                        SizedBox(height: ResponsiveSize.h(8)),
                    Row(
                      children: [
                        Text(
                          '${DateFormat('yyyy/MM/dd HH:mm').format(task.startDate!)} - ${DateFormat('yyyy/MM/dd HH:mm').format(task.endDate!)}',
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(16),
                            color: const Color(0xFF5A2E17),
                          ),
                        ),
                        SizedBox(width: ResponsiveSize.w(16)),
                        Text(
                          '共${task.endDate!.difference(task.startDate!).inDays + 1}天',
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(16),
                            color: const Color(0xFF5A2E17),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: ResponsiveSize.w(16)),
              // 右侧任务封面
              if (task.coverPath != null)
                Container(
                  width: ResponsiveSize.w(200),
                  height: ResponsiveSize.h(160),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                    image: DecorationImage(
                      image: FileImage(File(task.coverPath!)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        ),
        // 删除按钮
        Positioned(
          top: ResponsiveSize.h(-15),
          left: ResponsiveSize.w(-8),
          child: IconButton(
            icon: Container(
              padding: EdgeInsets.all(ResponsiveSize.w(4)),
              decoration: BoxDecoration(
                color: const Color(0xFFDEB887),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFDEB887),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: ResponsiveSize.w(1),
                    blurRadius: ResponsiveSize.w(2),
                    offset: Offset(0, ResponsiveSize.h(1)),
                  ),
                ],
              ),
              child: Icon(
                Icons.close,
                color: const Color(0xFF8B4513),
                size: ResponsiveSize.w(20),
              ),
            ),
            onPressed: () => _removeTask(task),
          ),
        ),
      ],
    );
  }
    InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: const Color(0xFF5A2E17).withOpacity(0.5),
        fontSize: ResponsiveSize.sp(16),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
        borderSide: const BorderSide(
          color: Color(0xFFDEB887),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
        borderSide: const BorderSide(
          color: Color(0xFFDEB887),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
        borderSide: const BorderSide(
          color: Color(0xFF8B4513),
          width: 2,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(16),
        vertical: ResponsiveSize.h(12),
      ),
    );
  }

  void _addTask() {
    if (_taskNameController.text.isEmpty ||
        _taskTypeController.text.isEmpty ||
        _taskStartDate == null ||
        _taskEndDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写完整任务信息')),
      );
      return;
    }

    if (widget.setStartDate != null && widget.setEndDate != null) {
      if (_taskStartDate!.isBefore(widget.setStartDate!) ||
          _taskEndDate!.isAfter(widget.setEndDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('任务时间必须在作业集时间范围内')),
        );
        return;
      }
    }

    final newTask = HomeworkSetTask(
      taskName: _taskNameController.text,
      taskType: _taskTypeController.text,
      taskDescription: _taskDescController.text,
      note: _taskNoteController.text,
      startDate: _taskStartDate,
      endDate: _taskEndDate,
      coverPath: _taskCoverPath,
    );

    final updatedTasks = [...widget.tasks, newTask];
    widget.onTasksChanged(updatedTasks);
    
    setState(() {
      _isAddingTask = false;
      _clearTaskInputs();
    });
  }
    Future<void> _pickTaskCover() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _taskCoverPath = image.path;
      });
    }
  }

  void _removeTask(HomeworkSetTask task) {
    final updatedTasks = [...widget.tasks]..remove(task);
    widget.onTasksChanged(updatedTasks);
  }

  void _clearTaskInputs() {
    _taskNameController.clear();
    _taskTypeController.clear();
    _taskDescController.clear();
    _taskNoteController.clear();
    _taskStartDate = null;
    _taskEndDate = null;
    _taskCoverPath = null;
  }

  Future<void> _selectDate(bool isStart) async {
    if (!mounted) return;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8B4513),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF5A2E17),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF8B4513),
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Color(0xFF5A2E17),
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null && mounted) {
        setState(() {
          final DateTime combinedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (isStart) {
            _taskStartDate = combinedDateTime;
          } else {
            _taskEndDate = combinedDateTime;
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _taskTypeController.dispose();
    _taskDescController.dispose();
    _taskNoteController.dispose();
    super.dispose();
  }
}