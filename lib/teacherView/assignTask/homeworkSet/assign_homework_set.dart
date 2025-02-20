import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'homework_set_tasks.dart';
import '../../../utils/responsive_size.dart';

class Student {
  final String name;
  final String? className;

  Student({required this.name, this.className});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'className': className,
    };
  }
}

class Class {
  final String name;
  final int studentCount;
  final List<Student> students;

  Class({
    required this.name,
    required this.studentCount,
    required this.students,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'studentCount': studentCount,
      'students': students.map((s) => s.toJson()).toList(),
    };
  }
}

class AssignHomeworkSetPage extends StatefulWidget {
  const AssignHomeworkSetPage({super.key});

  @override
  State<AssignHomeworkSetPage> createState() => _AssignHomeworkSetPageState();
}

class _AssignHomeworkSetPageState extends State<AssignHomeworkSetPage> {
  final TextEditingController _setNameController = TextEditingController();
  final TextEditingController _setNoteController = TextEditingController();
  
  DateTime? _setStartDate;
  DateTime? _setEndDate;
  String? _setCoverPath;
  List<HomeworkSetTask> tasks = [];
  bool _isClassMode = true;
  List<Class> _selectedClasses = [];
  List<Student> _selectedStudents = [];
  String? _selectedType;
  String? _selectedLevel;

  final List<String> _homeworkTypes = ['听力', '口语', '阅读', '书写'];
  
  final List<String> _homeworkLevels = [
    'Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5',
    'Level 6', 'Level 7', 'Level 8', 'Level 9', 'Level 10'
  ];

  final List<Class> _classList = [
    Class(
      name: '一年级1班',
      studentCount: 35,
      students: [
        Student(name: '张三', className: '一年级1班'),
        Student(name: '李四', className: '一年级1班'),
        Student(name: '王明', className: '一年级1班'),
        Student(name: '李华', className: '一年级1班'),
      ],
    ),
    Class(
      name: '一年级2班',
      studentCount: 38,
      students: [
        Student(name: '王五', className: '一年级2班'),
        Student(name: '赵六', className: '一年级2班'),
        Student(name: '钱七', className: '一年级2班'),
        Student(name: '孙八', className: '一年级2班'),
      ],
    ),
    Class(
      name: '二年级1班',
      studentCount: 36,
      students: [
        Student(name: '周九', className: '二年级1班'),
        Student(name: '吴十', className: '二年级1班'),
        Student(name: '郑十一', className: '二年级1班'),
        Student(name: '王十二', className: '二年级1班'),
      ],
    ),
  ];

  final List<Student> _unassignedStudents = [
    Student(name: '张无忌', className: null),
    Student(name: '赵敏', className: null),
    Student(name: '周芷若', className: null),
  ];

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
              '布置作业集',
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
              onPressed: _assignHomeworkSet,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFE4C4),
                foregroundColor: const Color(0xFF8B4513),
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.w(40), 
                  vertical: ResponsiveSize.h(16)
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
              bottom: ResponsiveSize.h(32)
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
                    // 左右布局：左边名称和布置对象，右边封面
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 左侧内容
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 作业集名称
                              _buildSection(
                                title: '作业集名称',
                                child: TextField(
                                  controller: _setNameController,
                                  style: TextStyle(
                                    fontSize: ResponsiveSize.sp(18),
                                    color: const Color(0xFF5A2E17),
                                  ),
                                  decoration: _buildInputDecoration('请输入作业集名称'),
                                ),
                              ),
                              SizedBox(height: ResponsiveSize.h(24)),
                                                            // 作业集种类和阶段
                              _buildTypeAndLevelSection(),
                              SizedBox(height: ResponsiveSize.h(24)),

                              // 作业集布置对象
                              _buildSection(
                                title: '作业集布置对象',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 选项按钮
                                    Row(
                                      children: [
                                        _buildOptionButton(
                                          title: '班级',
                                          isSelected: _isClassMode,
                                          onTap: () => setState(() => _isClassMode = true),
                                        ),
                                        SizedBox(width: ResponsiveSize.w(16)),
                                        _buildOptionButton(
                                          title: '成员',
                                          isSelected: !_isClassMode,
                                          onTap: () => setState(() => _isClassMode = false),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: ResponsiveSize.h(16)),
                                    
                                    // 已选择的内容
                                    _isClassMode
                                        ? _buildSelectedClasses()
                                        : _buildSelectedStudents(),
                                    SizedBox(height: ResponsiveSize.h(16)),
                                    
                                    // 添加按钮
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: _showSelectionDialog,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          elevation: 0,
                                          side: const BorderSide(
                                            color: Color(0xFFDEB887),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: ResponsiveSize.w(32),
                                            vertical: ResponsiveSize.h(12),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: const Color(0xFF5A2E17),
                                              size: ResponsiveSize.w(20),
                                            ),
                                            SizedBox(width: ResponsiveSize.w(8)),
                                            Text(
                                              '添加${_isClassMode ? "班级" : "成员"}',
                                              style: TextStyle(
                                                color: const Color(0xFF5A2E17),
                                                fontSize: ResponsiveSize.sp(16),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: ResponsiveSize.w(24)),
                                                // 右侧封面
                        Expanded(
                          flex: 2,
                          child: _buildSection(
                            title: '作业集封面',
                            child: GestureDetector(
                              onTap: _pickCoverImage,
                              child: Container(
                                height: ResponsiveSize.h(200),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
                                  color: Colors.grey[200],
                                ),
                                child: _setCoverPath != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
                                        child: Image.file(
                                          File(_setCoverPath!),
                                          fit: BoxFit.contain,
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          '点击上传封面',
                                          style: TextStyle(
                                            color: const Color(0xFF8B4513),
                                            fontSize: ResponsiveSize.sp(16),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveSize.h(24)),

                    // 作业集周期
                    _buildSetTimeSection(),
                    SizedBox(height: ResponsiveSize.h(24)),

                    // 作业集备注
                    _buildSection(
                      title: '作业集备注',
                      child: TextField(
                        controller: _setNoteController,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(18),
                          color: const Color(0xFF5A2E17),
                        ),
                        decoration: _buildInputDecoration('请输入作业集备注'),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(32)),

                    // 任务列表
                    HomeworkSetTasks(
                      tasks: tasks,
                      setStartDate: _setStartDate,
                      setEndDate: _setEndDate,
                      onTasksChanged: (updatedTasks) {
                        setState(() {
                          tasks = updatedTasks;
                        });
                      },
                    ),
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

  Widget _buildTypeAndLevelSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 作业集种类
        Expanded(
          child: _buildSection(
            title: '作业集种类',
            child: PopupMenuButton<String>(
              offset: Offset(0, ResponsiveSize.h(20)),
              position: PopupMenuPosition.under,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.w(16),
                  vertical: ResponsiveSize.h(12)
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                  border: Border.all(color: const Color(0xFFDEB887)),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedType ?? '请选择种类',
                        style: TextStyle(
                          color: _selectedType == null 
                              ? const Color(0xFF5A2E17).withOpacity(0.5)
                              : const Color(0xFF5A2E17),
                          fontSize: ResponsiveSize.sp(16),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF5A2E17),
                    ),
                  ],
                ),
              ),
              itemBuilder: (context) => _homeworkTypes
                  .map((type) => PopupMenuItem(
                        value: type,
                        child: Text(
                          type,
                          style: TextStyle(
                            color: const Color(0xFF5A2E17),
                            fontSize: ResponsiveSize.sp(16),
                          ),
                        ),
                      ))
                  .toList(),
              onSelected: (String value) {
                setState(() {
                  _selectedType = value;
                });
              },
            ),
          ),
        ),
        SizedBox(width: ResponsiveSize.w(24)),
                // 作业集阶段
        Expanded(
          child: _buildSection(
            title: '作业集阶段（选填）',
            child: PopupMenuButton<String>(
              offset: Offset(0, ResponsiveSize.h(20)),
              position: PopupMenuPosition.under,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.w(16),
                  vertical: ResponsiveSize.h(12)
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                  border: Border.all(color: const Color(0xFFDEB887)),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedLevel ?? '请选择阶段',
                        style: TextStyle(
                          color: _selectedLevel == null 
                              ? const Color(0xFF5A2E17).withOpacity(0.5)
                              : const Color(0xFF5A2E17),
                          fontSize: ResponsiveSize.sp(16),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF5A2E17),
                    ),
                  ],
                ),
              ),
              itemBuilder: (context) => _homeworkLevels
                  .map((level) => PopupMenuItem(
                        value: level,
                        child: Text(
                          level,
                          style: TextStyle(
                            color: const Color(0xFF5A2E17),
                            fontSize: ResponsiveSize.sp(16),
                          ),
                        ),
                      ))
                  .toList(),
              onSelected: (String value) {
                setState(() {
                  _selectedLevel = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(24),
          vertical: ResponsiveSize.h(8)
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFDFA7) : Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
          border: Border.all(
            color: const Color(0xFFDEB887),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: const Color(0xFF5A2E17),
            fontSize: ResponsiveSize.sp(16),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
    Widget _buildSelectedClasses() {
    if (_selectedClasses.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: ResponsiveSize.w(8),
      runSpacing: ResponsiveSize.h(8),
      children: _selectedClasses.map((classInfo) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.w(12),
            vertical: ResponsiveSize.h(6)
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFDFA7),
            borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                classInfo.name,
                style: TextStyle(
                  color: const Color(0xFF5A2E17),
                  fontSize: ResponsiveSize.sp(14),
                ),
              ),
              SizedBox(width: ResponsiveSize.w(4)),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedClasses.remove(classInfo);
                  });
                },
                child: Icon(
                  Icons.close,
                  size: ResponsiveSize.w(16),
                  color: const Color(0xFF5A2E17),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSelectedStudents() {
    if (_selectedStudents.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: ResponsiveSize.w(8),
      runSpacing: ResponsiveSize.h(8),
      children: _selectedStudents.map((student) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.w(12),
            vertical: ResponsiveSize.h(6)
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFDFA7),
            borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${student.name}${student.className != null ? ' (${student.className})' : ''}',
                style: TextStyle(
                  color: const Color(0xFF5A2E17),
                  fontSize: ResponsiveSize.sp(14),
                ),
              ),
              SizedBox(width: ResponsiveSize.w(4)),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedStudents.remove(student);
                  });
                },
                child: Icon(
                  Icons.close,
                  size: ResponsiveSize.w(16),
                  color: const Color(0xFF5A2E17),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
    Widget _buildSetTimeSection() {
    int totalDays = 0;
    if (_setStartDate != null && _setEndDate != null) {
      totalDays = _setEndDate!.difference(_setStartDate!).inDays + 1;
    }

    return _buildSection(
      title: '作业集周期',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '开始时间',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(16),
              color: const Color(0xFF5A2E17),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: ResponsiveSize.h(8)),
          InkWell(
            onTap: () => _selectDateTime(true),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.w(16),
                vertical: ResponsiveSize.h(12)
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                border: Border.all(color: const Color(0xFFDEB887)),
                color: Colors.white,
              ),
              child: Text(
                _setStartDate == null
                    ? '选择开始时间'
                    : DateFormat('yyyy/MM/dd HH:mm').format(_setStartDate!),
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(16),
                  color: _setStartDate == null
                      ? const Color(0xFF5A2E17).withOpacity(0.5)
                      : const Color(0xFF5A2E17),
                ),
              ),
            ),
          ),
          SizedBox(height: ResponsiveSize.h(16)),

          Text(
            '结束时间',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(16),
              color: const Color(0xFF5A2E17),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: ResponsiveSize.h(8)),
          InkWell(
            onTap: () => _selectDateTime(false),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.w(16),
                vertical: ResponsiveSize.h(12)
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                border: Border.all(color: const Color(0xFFDEB887)),
                color: Colors.white,
              ),
              child: Text(
                _setEndDate == null
                    ? '选择结束时间'
                    : DateFormat('yyyy/MM/dd HH:mm').format(_setEndDate!),
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(16),
                  color: _setEndDate == null
                      ? const Color(0xFF5A2E17).withOpacity(0.5)
                      : const Color(0xFF5A2E17),
                ),
              ),
            ),
          ),
                    if (totalDays > 0) ...[
            SizedBox(height: ResponsiveSize.h(8)),
            Text(
              '共计 $totalDays 天',
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

  void _showSelectionDialog() {
    List<Class> tempSelectedClasses = List.from(_selectedClasses);
    List<Student> tempSelectedStudents = List.from(_selectedStudents);

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
    Widget _buildClassList(List<Class> tempSelected, StateSetter setState) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _classList.length,
      itemBuilder: (context, index) {
        final classInfo = _classList[index];
        final isSelected = tempSelected.contains(classInfo);
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
                tempSelected.add(classInfo);
              } else {
                tempSelected.remove(classInfo);
              }
            });
          },
          activeColor: const Color(0xFFFFDFA7),
          checkColor: const Color(0xFF5A2E17),
        );
      },
    );
  }

  Widget _buildStudentList(List<Student> tempSelected, StateSetter setState) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._classList.map((classInfo) => ExpansionTile(
            title: Text(
              '${classInfo.name} (${classInfo.studentCount}人)',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(16),
                color: const Color(0xFF5A2E17),
              ),
            ),
            children: classInfo.students.map((student) => 
              CheckboxListTile(
                title: Text(
                  student.name,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    color: const Color(0xFF5A2E17),
                  ),
                ),
                subtitle: Text(
                  student.className ?? '',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(14),
                    color: const Color(0xFF5A2E17).withOpacity(0.7),
                  ),
                ),
                value: tempSelected.contains(student),
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
              )
            ).toList(),
          )),
                    if (_unassignedStudents.isNotEmpty)
            ExpansionTile(
              title: Text(
                '未分配班级学生',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(16),
                  color: const Color(0xFF5A2E17),
                ),
              ),
              children: _unassignedStudents.map((student) =>
                CheckboxListTile(
                  title: Text(
                    student.name,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(16),
                      color: const Color(0xFF5A2E17),
                    ),
                  ),
                  value: tempSelected.contains(student),
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
                )
              ).toList(),
            ),
        ],
      ),
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
    Future<void> _selectDateTime(bool isStart) async {
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
            _setStartDate = combinedDateTime;
          } else {
            _setEndDate = combinedDateTime;
          }
        });
      }
    }
  }

  Future<void> _pickCoverImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _setCoverPath = image.path;
      });
    }
  }

  Future<void> _assignHomeworkSet() async {
    if (_setNameController.text.isEmpty ||
        _selectedType == null ||
        _setStartDate == null ||
        _setEndDate == null ||
        tasks.isEmpty ||
        (_isClassMode && _selectedClasses.isEmpty) ||
        (!_isClassMode && _selectedStudents.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '请填写完整作业集信息并至少添加一个任务和选择布置对象',
            style: TextStyle(fontSize: ResponsiveSize.sp(14)),
          ),
        ),
      );
      return;
    }

    final homeworkSet = {
      'name': _setNameController.text,
      'type': _selectedType,
      'level': _selectedLevel,
      'cover': _setCoverPath,
      'startDate': _setStartDate!.toIso8601String(),
      'endDate': _setEndDate!.toIso8601String(),
      'note': _setNoteController.text,
      'isClassMode': _isClassMode,
      'selectedClasses': _selectedClasses.map((c) => c.toJson()).toList(),
      'selectedStudents': _isClassMode 
          ? [] 
          : _selectedStudents.map((s) => s.toJson()).toList(),
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };

    final prefs = await SharedPreferences.getInstance();
    List<String> homeworkSets = prefs.getStringList('homework_sets') ?? [];
    homeworkSets.add(json.encode(homeworkSet));
    await prefs.setStringList('homework_sets', homeworkSets);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '作业集布置成功',
            style: TextStyle(fontSize: ResponsiveSize.sp(14)),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _setNameController.dispose();
    _setNoteController.dispose();
    super.dispose();
  }
}