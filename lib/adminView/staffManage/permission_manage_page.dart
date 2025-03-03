import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';
import '../models/staff_model.dart';
import 'add_campus_dialog.dart';
import 'campus_manage_page.dart';

class Role {
  String name;
  String description;
  List<String> permissions;
  final bool isCustom;
  String? campus;

  Role({
    required this.name,
    required this.description,
    required this.permissions,
    this.isCustom = false,
    this.campus,
  });
}

class PermissionManagePage extends StatefulWidget {
  const PermissionManagePage({super.key});

  @override
  State<PermissionManagePage> createState() => _PermissionManagePageState();
}

class _PermissionManagePageState extends State<PermissionManagePage> {
  final List<Role> _predefinedRoles = [
    Role(
      name: '超级管理员',
      description: '学校总负责人，具有所有管理功能',
      permissions: ['all'],
      campus: '总校区',
    ),
    Role(
      name: '校区管理员',
      description: '具有本校区内的所有管理功能',
      permissions: ['campus_manage', 'subject_manage', 'role_manage'],
      campus: '总校区',
    ),
    Role(
      name: '科目管理员',
      description: '具有本科目的所有管理功能',
      permissions: ['subject_manage', 'role_manage'],
      campus: '分校区1',
    ),
    Role(
      name: '科目主管',
      description: '具有科目内全部教学教务相关功能',
      permissions: ['teaching_manage', 'staff_manage'],
      campus: '分校区1',
    ),
    Role(
      name: '教务',
      description: '管理班级、学员、课程、教材等日常教务教学工作',
      permissions: ['class_manage', 'student_manage', 'course_manage'],
      campus: '分校区2',
    ),
    Role(
      name: '学管师',
      description: '学员学习管理，跟踪学习过程，协调家校沟通',
      permissions: ['student_track', 'parent_communication'],
      campus: '分校区2',
    ),
    Role(
      name: '老师',
      description: '负责上课、准备教学内容、发布检查作业',
      permissions: ['teach', 'homework_manage', 'class_view'],
      campus: '分校区1',
    ),
    Role(
      name: '课程顾问',
      description: '负责招生跟进，管理意向学员',
      permissions: ['prospect_manage'],
      campus: '分校区2',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      body: Padding(
        padding: EdgeInsets.all(ResponsiveSize.w(32)),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: ResponsiveSize.h(24)),
            Expanded(child: _buildRoleList()),
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
          '权限管理',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(28),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8B4513),
          ),
        ),
        const Spacer(),
        _buildCampusManageButton(),
        SizedBox(width: ResponsiveSize.w(16)),
        _buildAddCustomRoleButton(),
      ],
    );
  }

  Widget _buildCampusManageButton() {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CampusManagePage()),
        );
      },
      icon: Icon(
        Icons.business,
        size: ResponsiveSize.w(20),
        color: const Color(0xFF8B4513),
      ),
      label: Text(
        '校区管理',
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
    );
  }

  Widget _buildAddCustomRoleButton() {
    return ElevatedButton.icon(
      onPressed: _showAddCustomRoleDialog,
      icon: Icon(
        Icons.add,
        size: ResponsiveSize.w(20),
        color: const Color(0xFF8B4513),
      ),
      label: Text(
        '添加自定义角色',
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
    );
  }

  Widget _buildRoleList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        border: Border.all(color: const Color(0xFFDEB887)),
      ),
      child: ListView.builder(
        itemCount: _predefinedRoles.length,
        itemBuilder: (context, index) {
          final role = _predefinedRoles[index];
          return _buildRoleItem(role);
        },
      ),
    );
  }

  Widget _buildRoleItem(Role role) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(16)),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFDEB887))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role.name,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(20),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8B4513),
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(8)),
                Text(
                  role.description,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: const Color(0xFF8B4513),
              size: ResponsiveSize.w(24),
            ),
            onPressed: () => _showEditRolePermissionsDialog(role),
          ),
        ],
      ),
    );
  }

  void _showAddCustomRoleDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String? selectedCampus;

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
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
                            Icons.add_moderator,
                            color: const Color(0xFF8B4513),
                            size: ResponsiveSize.w(32),
                          ),
                          SizedBox(width: ResponsiveSize.w(16)),
                          Text(
                            '添加自定义角色',
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
                        bottom:
                            MediaQuery.of(context).viewInsets.bottom +
                            ResponsiveSize.h(32),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDialogTextField(
                            controller: nameController,
                            label: '角色名称',
                            hintText: '请输入角色名称',
                          ),
                          SizedBox(height: ResponsiveSize.h(24)),
                          _buildDialogTextField(
                            controller: descriptionController,
                            label: '角色说明',
                            hintText: '请输入角色说明',
                            maxLines: 3,
                          ),
                          SizedBox(height: ResponsiveSize.h(24)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '所属校区',
                                style: TextStyle(
                                  fontSize: ResponsiveSize.sp(20),
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF8B4513),
                                ),
                              ),
                              SizedBox(height: ResponsiveSize.h(12)),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFFDEB887),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveSize.w(8),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedCampus,
                                    isExpanded: true,
                                    hint: Text(
                                      '请选择所属校区',
                                      style: TextStyle(
                                        color: const Color(
                                          0xFF8B4513,
                                        ).withOpacity(0.5),
                                        fontSize: ResponsiveSize.sp(18),
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveSize.w(16),
                                      vertical: ResponsiveSize.h(12),
                                    ),
                                    items:
                                        ['总校区', '分校区1', '分校区2'].map((campus) {
                                          return DropdownMenuItem<String>(
                                            value: campus,
                                            child: Text(
                                              campus,
                                              style: TextStyle(
                                                fontSize: ResponsiveSize.sp(18),
                                                color: const Color(0xFF8B4513),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        (context as Element).markNeedsBuild();
                                        selectedCampus = value;
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
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
                                  if (_validateCustomRole(
                                    nameController.text,
                                    selectedCampus,
                                    descriptionController.text,
                                  )) {
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

  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    int? maxLines,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(20),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF8B4513),
          ),
        ),
        SizedBox(height: ResponsiveSize.h(12)),
        TextField(
          controller: controller,
          maxLines: maxLines ?? 1,
          style: TextStyle(fontSize: ResponsiveSize.sp(18)),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: const Color(0xFF8B4513).withOpacity(0.5),
              fontSize: ResponsiveSize.sp(18),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.w(16),
              vertical: ResponsiveSize.h(16),
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
              borderSide: const BorderSide(color: Color(0xFF8B4513)),
            ),
          ),
          enabled: enabled,
        ),
      ],
    );
  }

  bool _validateCustomRole(String name, String? campus, String description) {
    if (name.isEmpty || campus == null || description.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请填写所有必填项')));
      return false;
    }
    return true;
  }

  void _showEditRolePermissionsDialog(Role role) {
    final nameController = TextEditingController(text: role.name);
    final descriptionController = TextEditingController(text: role.description);

    // 模拟已分配该角色的员工数据
    final List<Staff> assignedStaff = [
      Staff(
        id: '1',
        name: '张三',
        role: role.name,
        gender: '男',
        workYears: 3,
        age: 28,
        username: 'zhangsan',
        classes: ['一年级一班'],
        phone: '13800138000',
        hasEditPermission: false,
        joinDate: DateTime.now(),
        campus: '总校区',
      ),
      Staff(
        id: '2',
        name: '李四',
        role: role.name,
        gender: '男',
        workYears: 5,
        age: 32,
        username: 'lisi',
        classes: ['二年级一班'],
        phone: '13900139000',
        hasEditPermission: false,
        joinDate: DateTime.now(),
        campus: '分校区1',
      ),
      Staff(
        id: '3',
        name: '王五',
        role: role.name,
        gender: '男',
        workYears: 2,
        age: 25,
        username: 'wangwu',
        classes: ['三年级一班'],
        phone: '13700137000',
        hasEditPermission: false,
        joinDate: DateTime.now(),
        campus: '分校区2',
      ),
    ];

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.w(100),
              vertical: ResponsiveSize.h(40),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
            ),
            child: Container(
              width: ResponsiveSize.w(800),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(ResponsiveSize.w(32)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: const Color(0xFF8B4513),
                            size: ResponsiveSize.w(32),
                          ),
                          SizedBox(width: ResponsiveSize.w(16)),
                          Text(
                            '编辑角色',
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
                      SizedBox(height: ResponsiveSize.h(32)),
                      _buildDialogTextField(
                        controller: nameController,
                        label: '角色名称',
                        hintText: '请输入角色名称',
                        enabled: role.isCustom, // 只有自定义角色可以修改名称
                      ),
                      SizedBox(height: ResponsiveSize.h(24)),
                      _buildDialogTextField(
                        controller: descriptionController,
                        label: '角色说明',
                        hintText: '请输入角色说明',
                        maxLines: 3,
                        enabled: role.isCustom, // 只有自定义角色可以修改说明
                      ),
                      SizedBox(height: ResponsiveSize.h(24)),
                      Text(
                        '已分配员工',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(20),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF8B4513),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(12)),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFDEB887)),
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(8),
                          ),
                        ),
                        height: ResponsiveSize.h(200),
                        child: ListView.builder(
                          itemCount: assignedStaff.length,
                          itemBuilder: (context, index) {
                            final staff = assignedStaff[index];
                            return ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    staff.name,
                                    style: TextStyle(
                                      fontSize: ResponsiveSize.sp(18),
                                      color: const Color(0xFF8B4513),
                                    ),
                                  ),
                                  SizedBox(width: ResponsiveSize.w(16)),
                                  Text(
                                    '(${staff.role})', // 显示当前角色
                                    style: TextStyle(
                                      fontSize: ResponsiveSize.sp(16),
                                      color: const Color(
                                        0xFF8B4513,
                                      ).withOpacity(0.7),
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      _showChangeRoleDialog(staff); // 调用角色调整对话框
                                    },
                                    child: Text(
                                      '调整角色',
                                      style: TextStyle(
                                        fontSize: ResponsiveSize.sp(16),
                                        color: const Color(0xFF8B4513),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(40)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (role.isCustom) // 只有自定义角色可以删除
                            TextButton(
                              onPressed: () {
                                // TODO: 实现删除角色功能
                                Navigator.pop(context);
                              },
                              child: Text(
                                '删除角色',
                                style: TextStyle(
                                  fontSize: ResponsiveSize.sp(20),
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              '取消',
                              style: TextStyle(
                                fontSize: ResponsiveSize.sp(20),
                                color: const Color(0xFF8B4513),
                              ),
                            ),
                          ),
                          SizedBox(width: ResponsiveSize.w(24)),
                          ElevatedButton(
                            onPressed: () {
                              if (role.isCustom) {
                                // 更新自定义角色信息
                                setState(() {
                                  role.name = nameController.text;
                                  role.description = descriptionController.text;
                                });
                              }
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF8B4513),
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveSize.w(32),
                                vertical: ResponsiveSize.h(16),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  ResponsiveSize.w(8),
                                ),
                              ),
                            ),
                            child: Text(
                              '保存',
                              style: TextStyle(fontSize: ResponsiveSize.sp(20)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  void _showAddCampusDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddCampusDialog(),
    ).then((result) {
      if (result != null) {
        // TODO: 处理返回的校区信息
        print('New campus added: $result');
      }
    });
  }

  void _showChangeRoleDialog(Staff staff) {
    String selectedRole = staff.role;
    final List<String> roles =
        _predefinedRoles.map((role) => role.name).toSet().toList();

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, dialogSetState) => Dialog(
                  insetPadding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.w(100),
                    vertical: ResponsiveSize.h(24),
                  ),
                  child: Container(
                    width: ResponsiveSize.w(500),
                    padding: EdgeInsets.all(ResponsiveSize.w(24)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '调整 ${staff.name} 的角色',
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
                        ),
                        SizedBox(height: ResponsiveSize.h(32)),
                        Text(
                          '当前角色：${staff.role}',
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(18),
                            color: const Color(0xFF8B4513),
                          ),
                        ),
                        SizedBox(height: ResponsiveSize.h(24)),
                        Text(
                          '选择新角色：',
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(18),
                            color: const Color(0xFF8B4513),
                          ),
                        ),
                        SizedBox(height: ResponsiveSize.h(16)),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFDEB887)),
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.w(8),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedRole,
                              isExpanded: true,
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveSize.w(16),
                                vertical: ResponsiveSize.h(12),
                              ),
                              items:
                                  roles.map((role) {
                                    return DropdownMenuItem<String>(
                                      value: role,
                                      child: Text(
                                        role,
                                        style: TextStyle(
                                          fontSize: ResponsiveSize.sp(18),
                                          color: const Color(0xFF8B4513),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  dialogSetState(() {
                                    selectedRole = value;
                                  });
                                }
                              },
                            ),
                          ),
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
                            SizedBox(width: ResponsiveSize.w(24)),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  staff.role = selectedRole;
                                });

                                // 更新对话框内的显示
                                dialogSetState(() {});

                                // 延迟关闭对话框，让用户看到更新效果
                                Future.delayed(
                                  const Duration(milliseconds: 300),
                                  () {
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
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
}
