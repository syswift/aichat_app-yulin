import 'package:flutter/material.dart';
import '../models/class_info.dart';
import '../models/student_model.dart';
import 'add_class.dart';
import '../../../utils/responsive_size.dart';

class ClassManagePage extends StatefulWidget {
  const ClassManagePage({super.key});

  @override
  State<ClassManagePage> createState() => _ClassManagePageState();
}

class _ClassManagePageState extends State<ClassManagePage> {
  String _selectedGrade = '全部年级';
  bool _isDeleteMode = false;
  final Set<String> _selectedClasses = {};

  // 模拟数据
  final List<String> _grades = [
    '全部年级',
    '一年级',
    '二年级',
    '三年级',
  ];

  final List<ClassInfo> _classes = [
    ClassInfo(
      id: '1',
      name: '一年级一班',
      grade: '一年级',
      studentCount: 2,
      teacher: '张老师',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      students: [
        Student(
          id: '1',
          name: '张三',
          contact: '李四',
          phone: '13800138000',
          classNames: ['一年级一班'],
          level: 'Level 1',
          planner: '王老师',
          joinDate: DateTime.now().subtract(const Duration(days: 20)),
        ),
        Student(
          id: '2',
          name: '王五',
          contact: '赵六',
          phone: '13900139000',
          classNames: ['一年级一班'],
          level: 'Level 2',
          planner: '李老师',
          joinDate: DateTime.now().subtract(const Duration(days: 15)),
        ),
      ],
    ),
    ClassInfo(
      id: '2',
      name: '一年级二班',
      grade: '一年级',
      studentCount: 28,
      teacher: '李老师',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    ClassInfo(
      id: '3',
      name: '二年级一班',
      grade: '二年级',
      studentCount: 30,
      teacher: '王老师',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  List<ClassInfo> get filteredClasses {
    if (_selectedGrade == '全部年级') {
      return _classes;
    }
    return _classes.where((c) => c.grade == _selectedGrade).toList();
  }
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
            SizedBox(height: ResponsiveSize.h(24)),
            _buildFilterBar(),
            SizedBox(height: ResponsiveSize.h(24)),
            Expanded(
              child: _buildClassList(),
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
          '班级管理',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(28),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8B4513),
          ),
        ),
        const Spacer(),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddClassPage(
                  onClassAdded: (classInfo) {
                    setState(() {
                      _classes.add(classInfo);
                    });
                  },
                ),
              ),
            );
          },
          icon: Icon(
            Icons.add,
            size: ResponsiveSize.w(24),
            color: const Color(0xFF8B4513),
          ),
          label: Text(
            '创建班级',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(20),
              color: const Color(0xFF8B4513),
            ),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xFF8B4513),
            backgroundColor: const Color(0xFFFFE4C4),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.w(24),
              vertical: ResponsiveSize.h(16),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
              side: const BorderSide(color: Color(0xFFDEB887)),
            ),
          ),
        ),
        SizedBox(width: ResponsiveSize.w(16)),
                ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _isDeleteMode = !_isDeleteMode;
              if (!_isDeleteMode) {
                _selectedClasses.clear();
              }
            });
          },
          icon: Icon(
            _isDeleteMode ? Icons.close : Icons.delete,
            size: ResponsiveSize.w(24),
            color: _isDeleteMode ? Colors.grey : const Color(0xFF8B4513),
          ),
          label: Text(
            _isDeleteMode ? '取消' : '删除',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(20),
              color: _isDeleteMode ? Colors.grey : const Color(0xFF8B4513),
            ),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xFF8B4513),
            backgroundColor: const Color(0xFFFFE4C4),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.w(24),
              vertical: ResponsiveSize.h(16),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
              side: const BorderSide(color: Color(0xFFDEB887)),
            ),
          ),
        ),
        if (_isDeleteMode && _selectedClasses.isNotEmpty) ...[
          SizedBox(width: ResponsiveSize.w(16)),
          ElevatedButton.icon(
            onPressed: _deleteSelectedClasses,
            icon: Icon(
              Icons.delete_forever,
              size: ResponsiveSize.w(24),
            ),
            label: Text(
              '删除已选(${_selectedClasses.length})',
              style: TextStyle(fontSize: ResponsiveSize.sp(20)),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.w(24),
                vertical: ResponsiveSize.h(16),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        border: Border.all(color: const Color(0xFFDEB887)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildDropdown(
              value: _selectedGrade,
              items: _grades,
              onChanged: (value) {
                setState(() {
                  _selectedGrade = value ?? '全部年级';
                });
              },
              hint: '选择年级',
            ),
          ),
        ],
      ),
    );
  }
    Widget _buildDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String hint,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(16)),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDEB887)),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
      ),
      child: DropdownButton<String>(
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(
                fontSize: ResponsiveSize.sp(18),
                color: const Color(0xFF8B4513),
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        isExpanded: true,
        hint: Text(
          hint,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(18),
            color: const Color(0xFF8B4513),
          ),
        ),
        underline: const SizedBox(),
        icon: Icon(
          Icons.arrow_drop_down,
          color: const Color(0xFF8B4513),
          size: ResponsiveSize.w(24),
        ),
      ),
    );
  }

  Widget _buildClassList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        border: Border.all(color: const Color(0xFFDEB887)),
      ),
      child: Column(
        children: [
          _buildListHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: filteredClasses.map((classInfo) => _buildClassItem(classInfo)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveSize.h(16),
        horizontal: ResponsiveSize.w(24),
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFDEB887)),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            if (_isDeleteMode)
              SizedBox(width: ResponsiveSize.w(48))
            else
              SizedBox(width: ResponsiveSize.w(24)),
            _buildHeaderCell('班级名称', 2),
            _buildHeaderCell('年级', 1),
            _buildHeaderCell('负责老师', 2),
            _buildHeaderCell('人数', 1),
            _buildHeaderCell('创建时间', 2),
          ],
        ),
      ),
    );
  }
    Widget _buildHeaderCell(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(8)),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: ResponsiveSize.sp(20),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF8B4513),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClassItem(ClassInfo classInfo) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveSize.h(16),
        horizontal: ResponsiveSize.w(24),
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFDEB887)),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            if (_isDeleteMode)
              SizedBox(
                width: ResponsiveSize.w(48),
                child: Checkbox(
                  value: _selectedClasses.contains(classInfo.id),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value ?? false) {
                        _selectedClasses.add(classInfo.id);
                      } else {
                        _selectedClasses.remove(classInfo.id);
                      }
                    });
                  },
                  activeColor: const Color(0xFF8B4513),
                ),
              )
            else
              SizedBox(width: ResponsiveSize.w(24)),
            Expanded(
              flex: 2,
              child: TextButton(
                onPressed: () => _editClass(classInfo),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.center,
                ),
                child: Text(
                  classInfo.name,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(18),
                    color: const Color(0xFF8B4513),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            _buildContentCell(classInfo.grade, 1),
            _buildContentCell(classInfo.teacher ?? '-', 2),
            _buildContentCell('${classInfo.studentCount}人', 1),
            _buildContentCell(_formatDateTime(classInfo.createdAt), 2),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCell(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(18),
            color: const Color(0xFF8B4513),
          ),
        ),
      ),
    );
  }

  void _deleteSelectedClasses() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '确认删除',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(20),
            color: const Color(0xFF8B4513),
          ),
        ),
        content: Text(
          '确定要删除选中的 ${_selectedClasses.length} 个班级吗？',
          style: TextStyle(fontSize: ResponsiveSize.sp(16)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '取消',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(16),
                color: const Color(0xFF8B4513),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _classes.removeWhere(
                  (classInfo) => _selectedClasses.contains(classInfo.id),
                );
                _selectedClasses.clear();
                _isDeleteMode = false;
              });
              Navigator.pop(context);
            },
            child: Text(
              '删除',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(16),
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
           '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _editClass(ClassInfo classInfo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddClassPage(
          classInfo: classInfo,
          onClassAdded: (updatedClass) {
            setState(() {
              final index = _classes.indexWhere((c) => c.id == classInfo.id);
              if (index != -1) {
                _classes[index] = updatedClass;
              }
            });
          },
        ),
      ),
    );
  }
}