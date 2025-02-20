import 'package:flutter/material.dart';
import '../models/student_model.dart';
import 'add_student_page.dart';
import '../../../utils/responsive_size.dart';

class StudentManagePage extends StatefulWidget {
  const StudentManagePage({super.key});

  @override
  State<StudentManagePage> createState() => _StudentManagePageState();

  static List<Student> students = [
    Student(
      id: '1',
      name: '张三',
      contact: '李四',
      phone: '13800138000',
      classNames: ['一年级一班'],
      level: 'Level 1',
      planner: '王老师',
      remark: '每周一三五上课',
      joinDate: DateTime(2024, 1, 1),
    ),
    Student(
      id: '2',
      name: '王五',
      contact: '赵六',
      phone: '13900139000',
      classNames: ['一年级二班'],
      level: 'Level 2',
      planner: '李老师',
      remark: '每周二四六上课',
      joinDate: DateTime(2024, 2, 1),
    ),
  ];
}

class _StudentManagePageState extends State<StudentManagePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isDeleteMode = false;
  final Set<String> _selectedStudents = {};
  String _selectedClass = '全部班级';
  String _selectedLevel = '全部阶段';

  // 模拟数据
  final List<String> _classes = [
    '全部班级',
    '一年级一班',
    '一年级二班',
    '二年级一班',
    '二年级二班',
  ];

  final List<String> _levels = [
    '全部阶段',
    'Level 1',
    'Level 2',
    'Level 3',
    'Level 4',
    'Level 5',
    'Level 6',
    'Level 7',
    'Level 8',
    'Level 9',
    'Level 10',
  ];

  final List<Student> _students = [
    Student(
      id: '1',
      name: '张三',
      contact: '李四',
      phone: '13800138000',
      classNames: ['一年级一班'],
      level: 'Level 1',
      planner: '王老师',
      remark: '每周一三五上课',
      joinDate: DateTime(2024, 1, 1),
    ),
    Student(
      id: '2',
      name: '王五',
      contact: '赵六',
      phone: '13900139000',
      classNames: ['一年级二班'],
      level: 'Level 2',
      planner: '李老师',
      remark: '每周二四六上课',
      joinDate: DateTime(2024, 2, 1),
    ),
  ];


  List<Student> get filteredStudents {
    return _students.where((student) {
      final matchesSearch = student.name.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          student.contact.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );

      final matchesClass = _selectedClass == '全部班级' ||
          student.classNames.contains(_selectedClass);

      final matchesLevel =
          _selectedLevel == '全部阶段' || student.level == _selectedLevel;

      return matchesSearch && matchesClass && matchesLevel;
    }).toList();
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
              child: _buildStudentList(),
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
          '学员管理',
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
                builder: (context) => AddStudentPage(
                  onStudentAdded: (student) {
                    setState(() {
                      _students.insert(0, student);
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
            '添加学员',
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
              vertical: ResponsiveSize.h(16)
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
                _selectedStudents.clear();
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
              vertical: ResponsiveSize.h(16)
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
              side: const BorderSide(color: Color(0xFFDEB887)),
            ),
          ),
        ),
        if (_isDeleteMode && _selectedStudents.isNotEmpty) ...[
          SizedBox(width: ResponsiveSize.w(16)),
          ElevatedButton.icon(
            onPressed: _deleteSelectedStudents,
            icon: Icon(
              Icons.delete_forever,
              size: ResponsiveSize.w(24),
            ),
            label: Text(
              '删除已选(${_selectedStudents.length})',
              style: TextStyle(fontSize: ResponsiveSize.sp(20)),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.w(24),
                vertical: ResponsiveSize.h(16)
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
            flex: 2,
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              style: TextStyle(
                fontSize: ResponsiveSize.sp(18),
                color: const Color(0xFF8B4513),
              ),
              decoration: InputDecoration(
                hintText: '搜索学员姓名或联系人',
                hintStyle: TextStyle(
                  fontSize: ResponsiveSize.sp(18),
                  color: const Color(0xFF8B4513).withOpacity(0.5),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: const Color(0xFF8B4513),
                  size: ResponsiveSize.w(24),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                  borderSide: const BorderSide(color: Color(0xFFDEB887)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                  borderSide: const BorderSide(color: Color(0xFFDEB887)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                  borderSide: const BorderSide(color: Color(0xFF8B4513)),
                ),
              ),
            ),
          ),
          SizedBox(width: ResponsiveSize.w(24)),
          Expanded(
            child: _buildDropdown(
              value: _selectedClass,
              items: _classes,
              onChanged: (value) {
                setState(() {
                  _selectedClass = value ?? '全部班级';
                });
              },
              hint: '选择班级',
            ),
          ),
          SizedBox(width: ResponsiveSize.w(24)),
          Expanded(
            child: _buildDropdown(
              value: _selectedLevel,
              items: _levels,
              onChanged: (value) {
                setState(() {
                  _selectedLevel = value ?? '全部阶段';
                });
              },
              hint: '选择阶段',
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
    Widget _buildStudentList() {
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
                children: filteredStudents.map((student) => _buildStudentItem(student)).toList(),
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
        horizontal: ResponsiveSize.w(24)
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFDEB887)),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            SizedBox(width: ResponsiveSize.w(48)),
            _buildHeaderCell('学员姓名', 2),
            _buildHeaderCell('联系人', 2),
            _buildHeaderCell('联系电话', 2),
            _buildHeaderCell('所在班级', 2),
            _buildHeaderCell('阶段', 1),
            _buildHeaderCell('规划师', 2),
            _buildHeaderCell('备注', 2),
            _buildHeaderCell('操作', 1),
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
    Widget _buildStudentItem(Student student) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveSize.h(16),
        horizontal: ResponsiveSize.w(24)
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
                  value: _selectedStudents.contains(student.id),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value ?? false) {
                        _selectedStudents.add(student.id);
                      } else {
                        _selectedStudents.remove(student.id);
                      }
                    });
                  },
                  activeColor: const Color(0xFF8B4513),
                ),
              )
            else
              SizedBox(width: ResponsiveSize.w(48)),
            _buildContentCell(student.name, 2),
            _buildContentCell(student.contact, 2),
            _buildContentCell(student.phone, 2),
            _buildContentCell(
              student.classNames.isEmpty 
                ? '-' 
                : student.classNames.join(', '),
              2
            ),
            _buildContentCell(student.level, 1),
            _buildContentCell(student.planner, 2),
            _buildContentCell(student.remark ?? '-', 2),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: const Color(0xFF8B4513),
                      size: ResponsiveSize.w(24),
                    ),
                    onPressed: () => _showEditStudentDialog(student),
                  ),
                ],
              ),
            ),
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

  void _deleteSelectedStudents() {
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
          '确定要删除选中的 ${_selectedStudents.length} 名学员吗？',
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
                _students.removeWhere(
                  (student) => _selectedStudents.contains(student.id),
                );
                _selectedStudents.clear();
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

  void _showEditStudentDialog(Student student) {
    final nameController = TextEditingController(text: student.name);
    final contactController = TextEditingController(text: student.contact);
    final phoneController = TextEditingController(text: student.phone);
    final plannerController = TextEditingController(text: student.planner);
    final remarkController = TextEditingController(text: student.remark);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        ),
        child: Container(
          width: ResponsiveSize.w(800),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(ResponsiveSize.w(32)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        color: const Color(0xFF8B4513),
                        size: ResponsiveSize.w(32),
                      ),
                      SizedBox(width: ResponsiveSize.w(16)),
                      Text(
                        '编辑学员信息',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(28),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF8B4513),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: const Color(0xFF8B4513),
                          size: ResponsiveSize.w(28),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: ResponsiveSize.w(32),
                    right: ResponsiveSize.w(32),
                    bottom: MediaQuery.of(context).viewInsets.bottom + ResponsiveSize.h(32),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEditField(
                        controller: nameController,
                        label: '学员姓名',
                        validator: (value) => value?.isEmpty ?? true ? '请输入学员姓名' : null,
                      ),
                      SizedBox(height: ResponsiveSize.h(24)),
                      _buildEditField(
                        controller: contactController,
                        label: '联系人',
                        validator: (value) => value?.isEmpty ?? true ? '请输入联系人' : null,
                      ),
                      SizedBox(height: ResponsiveSize.h(24)),
                      _buildEditField(
                        controller: phoneController,
                        label: '联系电话',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value?.isEmpty ?? true) return '请输入联系电话';
                          if (value!.length != 11) return '请输入11位手机号码';
                          return null;
                        },
                      ),
                      SizedBox(height: ResponsiveSize.h(24)),
                      _buildEditField(
                        controller: plannerController,
                        label: '规划师',
                        validator: (value) => value?.isEmpty ?? true ? '请输入规划师' : null,
                      ),
                      SizedBox(height: ResponsiveSize.h(24)),
                      _buildEditField(
                        controller: remarkController,
                        label: '备注',
                        maxLines: 3,
                      ),
                      SizedBox(height: ResponsiveSize.h(40)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                          SizedBox(width: ResponsiveSize.w(16)),
                          ElevatedButton(
                            onPressed: () {
                              if (_validateEditInputs(
                                nameController.text,
                                contactController.text,
                                phoneController.text,
                              )) {
                                setState(() {
                                  student.name = nameController.text;
                                  student.contact = contactController.text;
                                  student.phone = phoneController.text;
                                  student.planner = plannerController.text;
                                  student.remark = remarkController.text;
                                });
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B4513),
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveSize.w(24),
                                vertical: ResponsiveSize.h(12),
                              ),
                            ),
                            child: Text(
                              '确定',
                              style: TextStyle(
                                fontSize: ResponsiveSize.sp(18),
                                color: Colors.white,
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
          ),
        ),
      ),
    );
  }

  Widget _buildEditField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(16),
            color: const Color(0xFF8B4513),
          ),
        ),
        SizedBox(height: ResponsiveSize.h(8)),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines ?? 1,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFFF8DC),
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
          ),
        ),
      ],
    );
  }

  bool _validateEditInputs(
    String name,
    String contact,
    String phone,
  ) {
    if (name.isEmpty) return false;
    if (contact.isEmpty) return false;
    if (phone.isEmpty || phone.length != 11) return false;
    return true;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}