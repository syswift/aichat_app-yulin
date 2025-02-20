import 'package:flutter/material.dart';
import '../models/staff_model.dart';
import '../../../utils/responsive_size.dart';

class AddStaffPage extends StatefulWidget {
  final Function(Staff) onStaffAdded;

  const AddStaffPage({
    super.key,
    required this.onStaffAdded,
  });

  @override
  State<AddStaffPage> createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedGender;
  String? _selectedRole;
  DateTime _selectedDate = DateTime.now();
  String? _selectedCampus;

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveSize.w(32)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: ResponsiveSize.h(32)),
            _buildForm(),
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
          '添加员工',
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: '姓名',
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入姓名';
                }
                return null;
              },
            ),
            SizedBox(height: ResponsiveSize.h(20)),
            _buildGenderSelector(),
            SizedBox(height: ResponsiveSize.h(20)),
            _buildTextField(
              label: '年龄',
              controller: _ageController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入年龄';
                }
                if (int.tryParse(value) == null) {
                  return '请输入有效的年龄';
                }
                return null;
              },
            ),
            SizedBox(height: ResponsiveSize.h(20)),
            _buildRoleSelector(),
            SizedBox(height: ResponsiveSize.h(20)),
            _buildTextField(
              label: '手机号',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入手机号';
                }
                if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                  return '请输入有效的手机号';
                }
                return null;
              },
            ),
            SizedBox(height: ResponsiveSize.h(20)),
            _buildDateField(),
            SizedBox(height: ResponsiveSize.h(20)),
            _buildCampusSelector(),
            SizedBox(height: ResponsiveSize.h(32)),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }
    Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(16),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF8B4513),
          ),
        ),
        SizedBox(height: ResponsiveSize.h(8)),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(fontSize: ResponsiveSize.sp(16)),
          decoration: InputDecoration(
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
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

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '性别',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(16),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF8B4513),
          ),
        ),
        SizedBox(height: ResponsiveSize.h(8)),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          items: ['男', '女'].map((gender) {
            return DropdownMenuItem(
              value: gender,
              child: Text(
                gender,
                style: TextStyle(fontSize: ResponsiveSize.sp(16)),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedGender = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return '请选择性别';
            }
            return null;
          },
          decoration: InputDecoration(
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
            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.w(16),
              vertical: ResponsiveSize.h(12),
            ),
          ),
        ),
      ],
    );
  }
    Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '角色',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(16),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF8B4513),
          ),
        ),
        SizedBox(height: ResponsiveSize.h(8)),
        DropdownButtonFormField<String>(
          value: _selectedRole,
          items: [
            '超级管理员',
            '校区管理员',
            '科目管理员',
            '科目主管',
            '教务',
            '学管师',
            '老师',
            '课程顾问',
          ].map((role) {
            return DropdownMenuItem(
              value: role,
              child: Text(
                role,
                style: TextStyle(fontSize: ResponsiveSize.sp(16)),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedRole = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return '请选择角色';
            }
            return null;
          },
          decoration: InputDecoration(
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
            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.w(16),
              vertical: ResponsiveSize.h(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '入职时间',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(16),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF8B4513),
          ),
        ),
        SizedBox(height: ResponsiveSize.h(8)),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFF8B4513),
                      onPrimary: Colors.white,
                      surface: Color(0xFFFFE4C4),
                      onSurface: Color(0xFF8B4513),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              setState(() {
                _selectedDate = picked;
              });
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.w(16),
              vertical: ResponsiveSize.h(12),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFDEB887)),
              borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    color: const Color(0xFF8B4513),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: const Color(0xFF8B4513),
                  size: ResponsiveSize.w(20),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
    Widget _buildCampusSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '所属校区',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(16),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF8B4513),
          ),
        ),
        SizedBox(height: ResponsiveSize.h(8)),
        DropdownButtonFormField<String>(
          value: _selectedCampus,
          items: ['总校区', '分校区1', '分校区2'].map((campus) {
            return DropdownMenuItem(
              value: campus,
              child: Text(
                campus,
                style: TextStyle(fontSize: ResponsiveSize.sp(16)),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCampus = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return '请选择所属校区';
            }
            return null;
          },
          decoration: InputDecoration(
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.w(16),
              vertical: ResponsiveSize.h(16),
            ),
          ),
        ),
      ],
    );
  }
    Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _handleCreate,
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color(0xFF8B4513),
          backgroundColor: const Color(0xFFFFE4C4),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.w(48),
            vertical: ResponsiveSize.h(16),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
            side: const BorderSide(color: Color(0xFFDEB887)),
          ),
          textStyle: TextStyle(
            fontSize: ResponsiveSize.sp(20),
            fontWeight: FontWeight.bold,
          ),
        ),
        child: const Text('创建'),
      ),
    );
  }

  void _handleCreate() {
    if (_formKey.currentState!.validate()) {
      final newStaff = Staff.create(
        name: _nameController.text,
        gender: _selectedGender!,
        age: int.parse(_ageController.text),
        role: _selectedRole!,
        phone: _phoneController.text,
        joinDate: _selectedDate,
        campus: _selectedCampus!,
      );
      widget.onStaffAdded(newStaff);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}