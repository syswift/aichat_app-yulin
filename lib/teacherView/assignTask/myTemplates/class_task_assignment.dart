import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'my_templates_page.dart';
import '../../../utils/responsive_size.dart';  // 添加响应式尺寸工具

// 数据模型
class ClassInfo {
  final String name;
  final int studentCount;
  final List<StudentInfo> students;

  ClassInfo({
    required this.name,
    required this.studentCount,
    required this.students,
  });
}

class StudentInfo {
  final String name;
  final String? className;

  StudentInfo({
    required this.name,
    this.className,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentInfo &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          className == other.className;

  @override
  int get hashCode => name.hashCode ^ className.hashCode;
}

class ClassTaskAssignmentPage extends StatefulWidget {
  final TemplateItem template;

  const ClassTaskAssignmentPage({
    super.key,
    required this.template,
  });

  @override
  State<ClassTaskAssignmentPage> createState() => _ClassTaskAssignmentPageState();
}
class _ClassTaskAssignmentPageState extends State<ClassTaskAssignmentPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _noteController;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  
  List<String> _selectedClasses = [];
  List<StudentInfo> _selectedStudents = [];
  bool _isClassMode = true;

  // 模拟数据
  final List<ClassInfo> _classList = [
    ClassInfo(
      name: '一年级1班',
      studentCount: 35,
      students: [
        StudentInfo(name: '张三', className: '一年级1班'),
        StudentInfo(name: '李四', className: '一年级1班'),
        StudentInfo(name: '王明', className: '一年级1班'),
        StudentInfo(name: '李华', className: '一年级1班'),
      ],
    ),
    ClassInfo(
      name: '一年级2班',
      studentCount: 38,
      students: [
        StudentInfo(name: '王五', className: '一年级2班'),
        StudentInfo(name: '赵六', className: '一年级2班'),
        StudentInfo(name: '钱七', className: '一年级2班'),
        StudentInfo(name: '孙八', className: '一年级2班'),
      ],
    ),
    ClassInfo(
      name: '二年级1班',
      studentCount: 36,
      students: [
        StudentInfo(name: '刘一', className: '二年级1班'),
        StudentInfo(name: '陈二', className: '二年级1班'),
        StudentInfo(name: '张三', className: '二年级1班'),
        StudentInfo(name: '李四', className: '二年级1班'),
      ],
    ),
  ];

  final List<StudentInfo> _unassignedStudents = [
    StudentInfo(name: '周七', className: null),
    StudentInfo(name: '吴八', className: null),
    StudentInfo(name: '郑九', className: null),
    StudentInfo(name: '王十', className: null),
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.template.name);
    _descriptionController = TextEditingController(text: widget.template.description ?? '');
    _noteController = TextEditingController(text: widget.template.note);
  }
    @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
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
              '布置课堂任务',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(28),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5A2E17),
              ),
            ),
          ),
          
          // 确认布置按钮
          Positioned(
            top: ResponsiveSize.h(55),
            right: ResponsiveSize.w(32),
            child: ElevatedButton(
              onPressed: _assignTask,
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
                '确认布置',
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                                             // 左侧任务内容
                        Expanded(
                          flex: 3,
                          child: _buildSection(
                            title: '任务内容',
                            child: TextField(
                              controller: _titleController,
                              style: TextStyle(
                                fontSize: ResponsiveSize.sp(18),
                                color: const Color(0xFF5A2E17),
                              ),
                              decoration: _buildInputDecoration('请输入任务内容'),
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveSize.w(24)),
                        // 右侧任务封面
                        Expanded(
                          flex: 2,
                          child: _buildSection(
                            title: '任务封面',
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
                                  color: Colors.grey[200],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
                                  child: Image(
                                    image: widget.template.cover.startsWith('assets/')
                                        ? AssetImage(widget.template.cover)
                                        : FileImage(File(widget.template.cover)) as ImageProvider,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveSize.h(24)),
                    _buildSection(
                      title: '任务描述',
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(18),
                          color: const Color(0xFF5A2E17),
                        ),
                        decoration: _buildInputDecoration('请输入任务描述'),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(24)),
                    _buildSection(
                      title: '备注信息',
                      child: TextField(
                        controller: _noteController,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(18),
                          color: const Color(0xFF5A2E17),
                        ),
                        decoration: _buildInputDecoration('请输入备注信息'),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(24)),
                    _buildTimeSection(),
                    SizedBox(height: ResponsiveSize.h(24)),
                    _buildTargetSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
    Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(20),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5A2E17),
          ),
        ),
        SizedBox(height: ResponsiveSize.h(12)),
        child,
      ],
    );
  }

  Widget _buildTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
          title: '开始时间',
          child: _buildDateTimeSelector(
            date: _startDate,
            time: _startTime,
            onDateChanged: (date) => setState(() => _startDate = date),
            onTimeChanged: (time) => setState(() => _startTime = time),
          ),
        ),
        SizedBox(height: ResponsiveSize.h(16)),
        _buildSection(
          title: '截止时间',
          child: _buildDateTimeSelector(
            date: _endDate,
            time: _endTime,
            onDateChanged: (date) => setState(() => _endDate = date),
            onTimeChanged: (time) => setState(() => _endTime = time),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeSelector({
    required DateTime date,
    required TimeOfDay time,
    required Function(DateTime) onDateChanged,
    required Function(TimeOfDay) onTimeChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                onDateChanged(picked);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.w(16),
                vertical: ResponsiveSize.h(12),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFFFDFA7),
                ),
                borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                color: Colors.white,
              ),
              child: Text(
                DateFormat('yyyy-MM-dd').format(date),
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(18),
                  color: const Color(0xFF5A2E17),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: ResponsiveSize.w(16)),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: time,
              );
              if (picked != null) {
                onTimeChanged(picked);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.w(16),
                vertical: ResponsiveSize.h(12),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFFFDFA7),
                ),
                borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                color: Colors.white,
              ),
              child: Text(
                time.format(context),
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(18),
                  color: const Color(0xFF5A2E17),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildTargetSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '发布对象',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(20),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5A2E17),
          ),
        ),
        SizedBox(height: ResponsiveSize.h(12)),
        Row(
          children: [
            _buildModeButton('班级', true),
            SizedBox(width: ResponsiveSize.w(16)),
            _buildModeButton('学员', false),
          ],
        ),
        SizedBox(height: ResponsiveSize.h(16)),
        Wrap(
          spacing: ResponsiveSize.w(8),
          runSpacing: ResponsiveSize.h(8),
          children: [
            ..._buildSelectedChips(),
            _buildAddButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildModeButton(String text, bool isClass) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isClassMode = isClass;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(32),
          vertical: ResponsiveSize.h(16),
        ),
        decoration: BoxDecoration(
          color: _isClassMode == isClass
              ? const Color(0xFFFFE4C4)
              : Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
          border: Border.all(
            color: const Color(0xFFDEB887),
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(18),
            color: const Color(0xFF8B4513),
            fontWeight: _isClassMode == isClass
                ? FontWeight.w500
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSelectedChips() {
    if (_isClassMode) {
      return _selectedClasses.map((className) {
        final classInfo = _classList.firstWhere((c) => c.name == className);
        return _buildChip('$className (${classInfo.studentCount}人)', () {
          setState(() => _selectedClasses.remove(className));
        });
      }).toList();
    } else {
      return _selectedStudents.map((student) {
        return _buildChip(
          '${student.name}${student.className != null ? ' - ${student.className}' : ''}',
          () {
            setState(() => _selectedStudents.remove(student));
          },
        );
      }).toList();
    }
  }
    Widget _buildChip(String label, VoidCallback onDelete) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(12),
        vertical: ResponsiveSize.h(6),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDFA7),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveSize.sp(16),
              color: const Color(0xFF5A2E17),
            ),
          ),
          SizedBox(width: ResponsiveSize.w(4)),
          GestureDetector(
            onTap: onDelete,
            child: Icon(
              Icons.close,
              size: ResponsiveSize.w(18),
              color: const Color(0xFF5A2E17),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _showSelectionDialog,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(32),
          vertical: ResponsiveSize.h(16),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE4C4),
          borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
          border: Border.all(
            color: const Color(0xFFDEB887),
            width: 1,
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
              '添加',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(18),
                color: const Color(0xFF8B4513),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
    void _showSelectionDialog() {
    // 创建临时选择列表
    List<String> tempSelectedClasses = List.from(_selectedClasses);
    List<StudentInfo> tempSelectedStudents = List.from(_selectedStudents);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                '选择${_isClassMode ? "班级" : "成员"}',
                style: TextStyle(
                  color: const Color(0xFF5A2E17),
                  fontSize: ResponsiveSize.sp(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: ResponsiveSize.h(400),
                child: _isClassMode
                    ? _buildClassList(tempSelectedClasses, setState)
                    : _buildStudentList(tempSelectedStudents, setState),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    '取消',
                    style: TextStyle(
                      color: const Color(0xFF5A2E17),
                      fontSize: ResponsiveSize.sp(16),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    this.setState(() {
                      if (_isClassMode) {
                        _selectedClasses = List.from(tempSelectedClasses);
                      } else {
                        _selectedStudents = List.from(tempSelectedStudents);
                      }
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFDFA7),
                  ),
                  child: Text(
                    '确定',
                    style: TextStyle(
                      color: const Color(0xFF5A2E17),
                      fontSize: ResponsiveSize.sp(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildClassList(List<String> tempSelected, StateSetter setState) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _classList.length,
      itemBuilder: (context, index) {
        final classInfo = _classList[index];
        final isSelected = tempSelected.contains(classInfo.name);
        return CheckboxListTile(
          title: Row(
            children: [
              Text(
                classInfo.name,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(16),
                  color: const Color(0xFF5A2E17),
                ),
              ),
              SizedBox(width: ResponsiveSize.w(8)),
              Text(
                '(${classInfo.studentCount}人)',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(14),
                  color: const Color(0xFF5A2E17).withOpacity(0.6),
                ),
              ),
            ],
          ),
          value: isSelected,
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                tempSelected.add(classInfo.name);
              } else {
                tempSelected.remove(classInfo.name);
              }
            });
          },
          activeColor: const Color(0xFFFFDFA7),
          checkColor: const Color(0xFF5A2E17),
        );
      },
    );
  }
    Widget _buildStudentList(List<StudentInfo> tempSelected, StateSetter setState) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 班级学生列表
          ..._classList.map((classInfo) => ExpansionTile(
            title: Text(
              '${classInfo.name} (${classInfo.studentCount}人)',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(16),
                color: const Color(0xFF5A2E17),
              ),
            ),
            children: classInfo.students.map((student) => 
              _buildStudentCheckbox(student, tempSelected, setState)
            ).toList(),
          )),
          // 未分配班级的学生
          if (_unassignedStudents.isNotEmpty)
            ExpansionTile(
              title: Text(
                '未分配班级',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(16),
                  color: const Color(0xFF5A2E17),
                ),
              ),
              children: _unassignedStudents.map((student) => 
                _buildStudentCheckbox(student, tempSelected, setState)
              ).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildStudentCheckbox(
    StudentInfo student, 
    List<StudentInfo> tempSelected, 
    StateSetter setState
  ) {
    final isSelected = tempSelected.contains(student);
    return CheckboxListTile(
      title: Text(
        student.name,
        style: TextStyle(
          fontSize: ResponsiveSize.sp(16),
          color: const Color(0xFF5A2E17),
        ),
      ),
      value: isSelected,
      onChanged: (bool? value) {
        setState(() {
          if (value == true) {
            tempSelected.add(student);
          } else {
            tempSelected.remove(student);
          }
        });
      },
      activeColor: const Color(0xFFFFDFA7),
      checkColor: const Color(0xFF5A2E17),
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
          color: Color(0xFFFFDFA7),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
        borderSide: const BorderSide(
          color: Color(0xFFFFDFA7),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
        borderSide: const BorderSide(
          color: Color(0xFFFFDFA7),
          width: 2,
        ),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(16),
        vertical: ResponsiveSize.h(12),
      ),
    );
  }

  void _assignTask() {
    // TODO: 实现任务布置逻辑
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}