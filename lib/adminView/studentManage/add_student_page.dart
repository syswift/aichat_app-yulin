import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/student_model.dart';
import '../../../utils/responsive_size.dart';

class AddStudentPage extends StatefulWidget {
  final Function(Student) onStudentAdded;

  const AddStudentPage({
    super.key,
    required this.onStudentAdded,
  });

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _phoneController = TextEditingController();
  final _remarkController = TextEditingController();
  final _plannerController = TextEditingController();
  String? _selectedLevel;
  final List<String> _selectedClasses = [];

  // 模拟数据
  final List<String> _classes = [
    '一年级一班',
    '一年级二班',
    '二年级一班',
    '二年级二班',
  ];

  final List<String> _levels = [
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
          '创建学员',
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
            _buildFormField(
              title: '基本信息',
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: '学员姓名',
                  hintText: '请输入学员姓名',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return '请输入学员姓名';
                    }
                    return null;
                  },
                ),
                SizedBox(height: ResponsiveSize.h(24)),
                _buildTextField(
                  controller: _contactController,
                  label: '联系人',
                  hintText: '请输入联系人姓名',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return '请输入联系人姓名';
                    }
                    return null;
                  },
                ),
                SizedBox(height: ResponsiveSize.h(24)),
                _buildTextField(
                  controller: _phoneController,
                  label: '联系电话',
                  hintText: '请输入11位手机号码',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return '请输入联系电话';
                    }
                    if (value!.length != 11) {
                      return '请输入11位手机号码';
                    }
                    return null;
                  },
                ),
                SizedBox(height: ResponsiveSize.h(24)),
                _buildTextField(
                  controller: _plannerController,
                  label: '规划师',
                  hintText: '请输入规划师姓名',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return '请输入规划师姓名';
                    }
                    return null;
                  },
                ),
                SizedBox(height: ResponsiveSize.h(24)),
                _buildTextField(
                  controller: _remarkController,
                  label: '备注',
                  hintText: '请输入备注信息（选填）',
                  maxLines: 3,
                ),
              ],
            ),
            SizedBox(height: ResponsiveSize.h(32)),
            _buildFormField(
              title: '班级信息',
              children: [
                _buildClassesSelection(),
                SizedBox(height: ResponsiveSize.h(24)),
                _buildDropdown(
                  label: '所属阶段',
                  hint: '请选择阶段',
                  value: _selectedLevel,
                  items: _levels,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedLevel = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return '请选择所属阶段';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
    Widget _buildFormField({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(22),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8B4513),
          ),
        ),
        SizedBox(height: ResponsiveSize.h(16)),
        ...children,
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int? maxLines,
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
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
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
          maxLines: maxLines,
        ),
      ],
    );
  }
    Widget _buildDropdown({
    required String label,
    required String hint,
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
          hint: Text(
            hint,
            style: TextStyle(
              fontSize: ResponsiveSize.sp(18),
              color: const Color(0xFF8B4513).withOpacity(0.5),
            ),
          ),
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

  Widget _buildClassesSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '分配班级',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(18),
                fontWeight: FontWeight.w500,
                color: const Color(0xFF8B4513),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _showClassSelectionDialog,
              icon: Icon(
                Icons.add_circle_outline,
                size: ResponsiveSize.w(20),
                color: const Color(0xFF8B4513),
              ),
              label: Text(
                '添加班级',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(16),
                  color: const Color(0xFF8B4513),
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF8B4513),
                backgroundColor: const Color(0xFFFFE4C4),
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.w(16),
                  vertical: ResponsiveSize.h(8),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                  side: const BorderSide(color: Color(0xFFDEB887)),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveSize.h(16)),
        if (_selectedClasses.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(ResponsiveSize.w(24)),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8DC),
              borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
              border: Border.all(color: const Color(0xFFDEB887)),
            ),
            child: Center(
              child: Text(
                '暂未选择班级',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(16),
                  color: const Color(0xFF8B4513).withOpacity(0.5),
                ),
              ),
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(ResponsiveSize.w(16)),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8DC),
              borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
              border: Border.all(color: const Color(0xFFDEB887)),
            ),
            child: Wrap(
              spacing: ResponsiveSize.w(12),
              runSpacing: ResponsiveSize.h(12),
              children: _selectedClasses.map((className) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE4C4),
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                    border: Border.all(color: const Color(0xFFDEB887)),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.w(16),
                    vertical: ResponsiveSize.h(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        className,
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(16),
                          color: const Color(0xFF8B4513),
                        ),
                      ),
                      SizedBox(width: ResponsiveSize.w(8)),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _selectedClasses.remove(className);
                          });
                        },
                        child: Icon(
                          Icons.cancel,
                          size: ResponsiveSize.w(20),
                          color: const Color(0xFF8B4513),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  void _showClassSelectionDialog() {
    // 创建一个临时列表来存储选择状态
    List<String> tempSelectedClasses = List.from(_selectedClasses);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
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
                      '选择班级',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(20),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF8B4513),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        size: ResponsiveSize.w(24),
                        color: const Color(0xFF8B4513),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveSize.h(24)),
                Wrap(
                  spacing: ResponsiveSize.w(16),
                  runSpacing: ResponsiveSize.h(16),
                  children: _classes.map((className) {
                    final isSelected = tempSelectedClasses.contains(className);
                    return InkWell(
                      onTap: () {
                        setDialogState(() {
                          if (isSelected) {
                            tempSelectedClasses.remove(className);
                          } else {
                            tempSelectedClasses.add(className);
                          }
                        });
                      },
                      child: Container(
                        width: ResponsiveSize.w(160),
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(16),
                          vertical: ResponsiveSize.h(12),
                        ),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? const Color(0xFF8B4513)
                              : const Color(0xFFFFE4C4),
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                          border: Border.all(
                            color: isSelected 
                                ? const Color(0xFF8B4513)
                                : const Color(0xFFDEB887),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: const Color(0xFF8B4513).withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              className,
                              style: TextStyle(
                                fontSize: ResponsiveSize.sp(16),
                                fontWeight: isSelected 
                                    ? FontWeight.bold 
                                    : FontWeight.normal,
                                color: isSelected 
                                    ? Colors.white 
                                    : const Color(0xFF8B4513),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: ResponsiveSize.w(20),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: ResponsiveSize.h(24)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                    SizedBox(width: ResponsiveSize.w(16)),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedClasses.clear();
                          _selectedClasses.addAll(tempSelectedClasses);
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF8B4513),
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(24),
                          vertical: ResponsiveSize.h(12),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                        ),
                      ),
                      child: Text(
                        '确定',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
                  final newStudent = Student.create(
                    name: _nameController.text,
                    contact: _contactController.text,
                    phone: _phoneController.text,
                    classNames: _selectedClasses,
                    level: _selectedLevel!,
                    planner: _plannerController.text,
                    remark: _remarkController.text,
                  );
                  widget.onStudentAdded(newStudent);
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
              ),
              child: Text(
                '创建',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    _remarkController.dispose();
    _plannerController.dispose();
    super.dispose();
  }
}