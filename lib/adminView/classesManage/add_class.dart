import 'package:flutter/material.dart';
import '../models/class_info.dart';
import '../models/student_model.dart';
import '../../../utils/responsive_size.dart';

class AddClassPage extends StatefulWidget {
  final Function(ClassInfo) onClassAdded;
  final ClassInfo? classInfo;

  const AddClassPage({
    super.key,
    required this.onClassAdded,
    this.classInfo,
  });

  @override
  State<AddClassPage> createState() => _AddClassPageState();
}

class _AddClassPageState extends State<AddClassPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();
  final _teacherController = TextEditingController();
  String? _selectedGrade;
  final List<Student> _selectedStudents = [];

  // 模拟数据
  final List<String> _grades = [
    '一年级',
    '二年级',
    '三年级',
  ];

  // 模拟可选学生数据
  final List<Student> _availableStudents = [
    Student(
      id: '1',
      name: '张三',
      contact: '李四',
      phone: '13800138000',
      classNames: [],
      level: 'Level 1',
      planner: '王老师',
      joinDate: DateTime.now(),
    ),
    Student(
      id: '2',
      name: '王五',
      contact: '赵六',
      phone: '13900139000',
      classNames: [],
      level: 'Level 2',
      planner: '李老师',
      joinDate: DateTime.now(),
    ),
  ];
    @override
  void initState() {
    super.initState();
    if (widget.classInfo != null) {
      _nameController.text = widget.classInfo!.name;
      _selectedGrade = widget.classInfo!.grade;
      _noteController.text = widget.classInfo!.note ?? '';
      _teacherController.text = widget.classInfo!.teacher ?? '';
      _selectedStudents.addAll(widget.classInfo!.students);
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                ResponsiveSize.w(32),
                ResponsiveSize.h(32),
                ResponsiveSize.w(32),
                ResponsiveSize.h(100)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: ResponsiveSize.h(32)),
                  _buildForm(),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomBar(),
          ),
        ],
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
          widget.classInfo == null ? '创建班级' : '编辑班级',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(28),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8B4513),
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(ResponsiveSize.w(32)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
          border: Border.all(color: const Color(0xFFDEB887)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: ResponsiveSize.w(10),
              offset: Offset(0, ResponsiveSize.h(5)),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: _nameController,
              label: '班级名称',
              hintText: '请输入班级名称',
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return '请输入班级名称';
                }
                return null;
              },
            ),
            SizedBox(height: ResponsiveSize.h(24)),
            _buildDropdown(
              label: '所属年级',
              value: _selectedGrade,
              items: _grades,
              onChanged: (value) {
                setState(() {
                  _selectedGrade = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return '请选择所属年级';
                }
                return null;
              },
            ),
            SizedBox(height: ResponsiveSize.h(24)),
            _buildTextField(
              controller: _noteController,
              label: '备注',
              hintText: '请输入备注信息（选填）',
              maxLines: 3,
            ),
            SizedBox(height: ResponsiveSize.h(24)),
            _buildTextField(
              controller: _teacherController,
              label: '负责老师',
              hintText: '请输入负责老师姓名',
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return '请输入负责老师姓名';
                }
                return null;
              },
            ),
            SizedBox(height: ResponsiveSize.h(24)),
            _buildStudentSection(),
          ],
        ),
      ),
    );
  }
    Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(18),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF8B4513),
          ),
        ),
        SizedBox(height: ResponsiveSize.h(8)),
        TextFormField(
          controller: controller,
          maxLines: maxLines ?? 1,
          validator: validator,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(18),
            color: const Color(0xFF8B4513),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: ResponsiveSize.sp(18),
              color: const Color(0xFF8B4513).withOpacity(0.5),
            ),
            filled: true,
            fillColor: const Color(0xFFFFF8DC),
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
              borderSide: const BorderSide(color: Color(0xFF8B4513), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.w(16),
              vertical: ResponsiveSize.h(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(18),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF8B4513),
          ),
        ),
        SizedBox(height: ResponsiveSize.h(8)),
        DropdownButtonFormField<String>(
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
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFFF8DC),
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
              borderSide: const BorderSide(color: Color(0xFF8B4513), width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.w(16),
              vertical: ResponsiveSize.h(12),
            ),
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: const Color(0xFF8B4513),
            size: ResponsiveSize.w(24),
          ),
          isExpanded: true,
          dropdownColor: Colors.white,
        ),
      ],
    );
  }
    Widget _buildStudentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '学员列表',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(18),
                fontWeight: FontWeight.w500,
                color: const Color(0xFF8B4513),
              ),
            ),
            Text(
              '总人数：${_selectedStudents.length}',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(18),
                fontWeight: FontWeight.w500,
                color: const Color(0xFF8B4513),
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveSize.h(16)),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDEB887)),
            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
          ),
          child: Column(
            children: [
              _buildStudentListHeader(),
              if (_selectedStudents.isEmpty)
                Container(
                  padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(24)),
                  child: Text(
                    '暂无学员',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(16),
                      color: Colors.grey,
                    ),
                  ),
                )
              else
                ...(_selectedStudents.map((student) => _buildStudentItem(student)).toList()),
              _buildAddStudentButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStudentListHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveSize.h(12),
        horizontal: ResponsiveSize.w(16)
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFDEB887)),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '学员姓名',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8B4513),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '联系人',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8B4513),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '联系电话',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8B4513),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '规划师',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8B4513),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '加入时间',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8B4513),
                  ),
                ),
              ),
            ),
            SizedBox(width: ResponsiveSize.w(48)),
          ],
        ),
      ),
    );
  }
    Widget _buildStudentItem(Student student) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveSize.h(12),
        horizontal: ResponsiveSize.w(16)
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFDEB887)),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  student.name,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    color: const Color(0xFF8B4513),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  student.contact,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    color: const Color(0xFF8B4513),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  student.phone,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    color: const Color(0xFF8B4513),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  student.planner,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    color: const Color(0xFF8B4513),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  _formatDate(student.joinDate),
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    color: const Color(0xFF8B4513),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: ResponsiveSize.w(48),
              child: IconButton(
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: Colors.red,
                  size: ResponsiveSize.w(24),
                ),
                onPressed: () {
                  setState(() {
                    _selectedStudents.remove(student);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddStudentButton() {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(16)),
      child: Center(
        child: IconButton(
          icon: Icon(
            Icons.add_circle_outline,
            color: const Color(0xFF8B4513),
            size: ResponsiveSize.w(32),
          ),
          onPressed: _showAddStudentDialog,
        ),
      ),
    );
  }

  void _showAddStudentDialog() {
    final searchController = TextEditingController();
    DateTime? startDate;
    DateTime? endDate;
    List<Student> selectedStudentsInDialog = List.from(_selectedStudents);
    bool showAllStudents = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          List<Student> filteredStudents = _availableStudents.where((student) {
            bool matchesSearch = searchController.text.isEmpty ||
                student.name.toLowerCase().contains(searchController.text.toLowerCase()) ||
                student.contact.toLowerCase().contains(searchController.text.toLowerCase());

            if (showAllStudents) {
              return matchesSearch;
            }

            if (startDate != null && endDate != null) {
              return matchesSearch && 
                     student.joinDate.isAfter(startDate) && 
                     student.joinDate.isBefore(endDate.add(const Duration(days: 1)));
            }

            return matchesSearch;
          }).toList();

          return Dialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.w(100),
              vertical: ResponsiveSize.h(40),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
            ),
            backgroundColor: Colors.white,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(ResponsiveSize.w(24)),
                    child: _buildDialogHeader(),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(24),
                        ),
                        child: Column(
                          children: [
                            _buildSearchAndFilter(
                              searchController,
                              startDate,
                              endDate,
                              showAllStudents,
                              setState,
                            ),
                            SizedBox(height: ResponsiveSize.h(16)),
                            _buildStudentListView(
                              filteredStudents,
                              selectedStudentsInDialog,
                              setState,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(ResponsiveSize.w(24)),
                    child: _buildDialogBottomButtons(
                      selectedStudentsInDialog,
                      setState,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 辅助方法：构建日期选择按钮
  Widget _buildDateButton({
    required String label,
    required DateTime? date,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF8B4513),
        side: const BorderSide(color: Color(0xFFDEB887)),
        backgroundColor: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: ResponsiveSize.w(16)),
          SizedBox(width: ResponsiveSize.w(8)),
          Text(
            date == null ? label : _formatDate(date),
            style: TextStyle(fontSize: ResponsiveSize.sp(14)),
          ),
        ],
      ),
    );
  }

  // 辅助方法：格式化日期
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: ResponsiveSize.w(10),
            offset: Offset(0, -ResponsiveSize.h(5)),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: ResponsiveSize.w(200),
            height: ResponsiveSize.h(50),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final updatedClass = widget.classInfo?.copyWith(
                    name: _nameController.text,
                    grade: _selectedGrade!,
                    note: _noteController.text,
                    teacher: _teacherController.text,
                    studentCount: _selectedStudents.length,
                    students: _selectedStudents,
                  ) ?? ClassInfo.create(
                    name: _nameController.text,
                    grade: _selectedGrade!,
                    note: _noteController.text,
                    teacher: _teacherController.text,
                    studentCount: _selectedStudents.length,
                    students: _selectedStudents,
                  );
                  widget.onClassAdded(updatedClass);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF8B4513),
                backgroundColor: const Color(0xFFFFE4C4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(25)),
                  side: const BorderSide(color: Color(0xFFDEB887)),
                ),
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.w(24),
                  vertical: ResponsiveSize.h(12),
                ),
                textStyle: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text(widget.classInfo == null ? '创建' : '保存'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    _teacherController.dispose();
    super.dispose();
  }

  Widget _buildSearchAndFilter(
    TextEditingController searchController,
    DateTime? startDate,
    DateTime? endDate,
    bool showAllStudents,
    StateSetter setState,
  ) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(16)),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8DC),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
        border: Border.all(color: const Color(0xFFDEB887)),
      ),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            onChanged: (value) => setState(() {}),
            decoration: InputDecoration(
              hintText: '搜索学员姓名或联系人',
              hintStyle: TextStyle(
                color: const Color(0xFF8B4513).withOpacity(0.5),
              ),
              prefixIcon: Icon(
                Icons.search,
                color: const Color(0xFF8B4513),
                size: ResponsiveSize.w(24),
              ),
              filled: true,
              fillColor: Colors.white,
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
          SizedBox(height: ResponsiveSize.h(16)),
          Row(
            children: [
              Expanded(
                child: _buildDateButton(
                  label: '开始日期',
                  date: startDate,
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => startDate = date);
                    }
                  },
                ),
              ),
              SizedBox(width: ResponsiveSize.w(8)),
              const Text('至'),
              SizedBox(width: ResponsiveSize.w(8)),
              Expanded(
                child: _buildDateButton(
                  label: '结束日期',
                  date: endDate,
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: endDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => endDate = date);
                    }
                  },
                ),
              ),
              SizedBox(width: ResponsiveSize.w(16)),
              TextButton.icon(
                onPressed: () => setState(() {
                  showAllStudents = !showAllStudents;
                  if (showAllStudents) {
                    startDate = null;
                    endDate = null;
                  }
                }),
                icon: Icon(
                  showAllStudents ? Icons.check_box : Icons.check_box_outline_blank,
                  color: const Color(0xFF8B4513),
                ),
                label: Text(
                  '显示全部',
                  style: TextStyle(
                    color: const Color(0xFF8B4513),
                    fontSize: ResponsiveSize.sp(14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentListView(
    List<Student> filteredStudents,
    List<Student> selectedStudentsInDialog,
    StateSetter setState,
  ) {
    return Column(
      children: [
        _buildDialogRow(
          isHeader: true,
          texts: ['学员姓名', '联系人', '联系电话', '规划师', '加入时间'],
        ),
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.4,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filteredStudents.length,
            itemBuilder: (context, index) {
              final student = filteredStudents[index];
              final isSelected = selectedStudentsInDialog.contains(student);
              return _buildDialogRow(
                isHeader: false,
                texts: [
                  student.name,
                  student.contact,
                  student.phone,
                  student.planner,
                  _formatDate(student.joinDate),
                ],
                lastCell: Checkbox(
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value ?? false) {
                        selectedStudentsInDialog.add(student);
                      } else {
                        selectedStudentsInDialog.remove(student);
                      }
                    });
                  },
                  activeColor: const Color(0xFF8B4513),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDialogBottomButtons(
    List<Student> selectedStudentsInDialog,
    StateSetter setState,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '已选择: ${selectedStudentsInDialog.length}人',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(16),
            color: const Color(0xFF8B4513),
          ),
        ),
        SizedBox(width: ResponsiveSize.w(24)),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xFF8B4513),
            backgroundColor: const Color(0xFFFFE4C4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
            ),
          ),
          child: Text(
            '取消',
            style: TextStyle(fontSize: ResponsiveSize.sp(16)),
          ),
        ),
        SizedBox(width: ResponsiveSize.w(16)),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedStudents.clear();
              _selectedStudents.addAll(selectedStudentsInDialog);
            });
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF8B4513),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
            ),
          ),
          child: Text(
            '确定',
            style: TextStyle(fontSize: ResponsiveSize.sp(16)),
          ),
        ),
      ],
    );
  }

  Widget _buildDialogRow({
    required bool isHeader,
    required List<String> texts,
    Widget? lastCell,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isHeader ? const Color(0xFFFFF8DC) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFDEB887).withOpacity(0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          ...List.generate(texts.length, (index) => 
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: const Color(0xFFDEB887).withOpacity(0.3),
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    texts[index],
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(16),
                      fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                      color: const Color(0xFF8B4513),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Center(
                child: lastCell ?? Text(
                  '选择',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                    color: const Color(0xFF8B4513),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogHeader() {
    return Row(
      children: [
        Icon(
          Icons.person_add,
          color: const Color(0xFF8B4513),
          size: ResponsiveSize.w(28),
        ),
        SizedBox(width: ResponsiveSize.w(12)),
        Text(
          '添加学员',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(24),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8B4513),
          ),
        ),
        const Spacer(),
        IconButton(
          icon: Icon(
            Icons.close,
            color: const Color(0xFF8B4513),
            size: ResponsiveSize.w(24),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}