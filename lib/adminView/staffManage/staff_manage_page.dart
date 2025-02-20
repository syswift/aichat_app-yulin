import 'package:flutter/material.dart';
import '../models/staff_model.dart';
import 'add_staff_page.dart';
import '../../../utils/responsive_size.dart';
import 'permission_manage_page.dart';
import 'package:intl/intl.dart';

class StaffManagePage extends StatefulWidget {
  const StaffManagePage({super.key});

  @override
  State<StaffManagePage> createState() => _StaffManagePageState();
}

class _StaffManagePageState extends State<StaffManagePage> {
  final TextEditingController _searchController = TextEditingController();

  // 模拟数据
  final List<Staff> _staffList = [
    Staff(
      id: '1',
      name: '张三',
      gender: '男',
      age: 28,
      username: 'zhangsan',
      classes: ['一年级一班', '二年级一班'],
      role: '教务',
      workYears: 5,
      phone: '13800138000',
      hasEditPermission: true,
      joinDate: DateTime(2020, 1, 1),
      campus: '总校区',
    ),
    Staff(
      id: '2',
      name: '李四',
      gender: '女',
      age: 25,
      username: 'lisi',
      classes: ['三年级一班'],
      role: '老师',
      workYears: 3,
      phone: '13900139000',
      hasEditPermission: false,
      joinDate: DateTime(2021, 6, 1),
      campus: '分校区1',
    ),
  ];

  // 添加预定义角色列表
  final List<Role> _predefinedRoles = [
    Role(name: '超级管理员', permissions: [], isCustom: false, description: '系统最高权限管理员'),
    Role(name: '校区管理员', permissions: [], isCustom: false, description: '校区管理员'),
    Role(name: '科目管理员', permissions: [], isCustom: false, description: '科目管理员'),
    Role(name: '科目主管', permissions: [], isCustom: false, description: '科目主管'),
    Role(name: '教务', permissions: [], isCustom: false, description: '教务人员'),
    Role(name: '学管师', permissions: [], isCustom: false, description: '学管师'),
    Role(name: '老师', permissions: [], isCustom: false, description: '教师'),
    Role(name: '课程顾问', permissions: [], isCustom: false, description: '课程顾问'),
  ];

  List<Staff> get filteredStaff {
    return _staffList.where((staff) {
      return staff.name.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );
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
              child: _buildStaffList(),
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
          '员工管理',
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
                builder: (context) => const PermissionManagePage(),
              ),
            );
          },
          icon: Icon(
            Icons.admin_panel_settings,
            size: ResponsiveSize.w(20),
            color: const Color(0xFF8B4513),
          ),
          label: Text(
            '权限管理',
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddStaffPage(
                  onStaffAdded: (staff) {
                    setState(() {
                      _staffList.insert(0, staff);
                    });
                  },
                ),
              ),
            );
          },
          icon: Icon(
            Icons.add,
            size: ResponsiveSize.w(20),
            color: const Color(0xFF8B4513),
          ),
          label: Text(
            '添加员工',
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
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              style: TextStyle(fontSize: ResponsiveSize.sp(16)),
              decoration: InputDecoration(
                hintText: '搜索员工姓名',
                hintStyle: TextStyle(fontSize: ResponsiveSize.sp(16)),
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
        ],
      ),
    );
  }

  Widget _buildStaffList() {
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
                children: filteredStaff.map((staff) => _buildStaffItem(staff)).toList(),
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
            _buildHeaderCell('员工姓名', 2),
            _buildHeaderCell('性别', 1),
            _buildHeaderCell('年龄', 1),
            _buildHeaderCell('用户名', 2),
            _buildHeaderCell('所属校区', 2),
            _buildHeaderCell('负责班级', 3),
            _buildHeaderCell('角色', 2),
            _buildHeaderCell('工龄', 1),
            _buildHeaderCell('入职时间', 2),
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

  Widget _buildStaffItem(Staff staff) {
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
            _buildContentCell(staff.name, 2),
            _buildContentCell(staff.gender, 1),
            _buildContentCell(staff.age.toString(), 1),
            _buildContentCell(staff.username, 2),
            _buildContentCell(staff.campus, 2),
            _buildContentCell(staff.classes.join('、'), 3),
            _buildContentCell(staff.role, 2),
            _buildContentCell(staff.workYears.toString(), 1),
            _buildContentCell(
              DateFormat('yyyy-MM-dd').format(staff.joinDate),
              2,
            ),
            Expanded(
              flex: 1,
              child: PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: const Color(0xFF8B4513),
                  size: ResponsiveSize.w(24),
                ),
                onSelected: (value) {
                  if (value == 'delete') {
                    _showDeleteConfirmDialog(staff);
                  } else if (value == 'assign_classes') {
                    _showAssignClassesDialog(staff);
                  } else if (value == 'change_role') {
                    _showChangeRoleDialog(staff);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'change_role',
                    child: Row(
                      children: [
                        Icon(
                          Icons.work,
                          color: const Color(0xFF8B4513),
                          size: ResponsiveSize.w(20),
                        ),
                        SizedBox(width: ResponsiveSize.w(8)),
                        Text(
                          '调整角色',
                          style: TextStyle(fontSize: ResponsiveSize.sp(16)),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'assign_classes',
                    child: Row(
                      children: [
                        Icon(
                          Icons.class_,
                          color: const Color(0xFF8B4513),
                          size: ResponsiveSize.w(20),
                        ),
                        SizedBox(width: ResponsiveSize.w(8)),
                        Text(
                          '分配班级',
                          style: TextStyle(fontSize: ResponsiveSize.sp(16)),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: ResponsiveSize.w(20),
                        ),
                        SizedBox(width: ResponsiveSize.w(8)),
                        Text(
                          '删除',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: ResponsiveSize.sp(16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
    void _showChangeRoleDialog(Staff staff) {
    String selectedRole = staff.role;
    final List<String> roles = _predefinedRoles.map((role) => role.name).toList();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, dialogSetState) => Dialog(
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
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedRole,
                      isExpanded: true,
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.w(16),
                        vertical: ResponsiveSize.h(12),
                      ),
                      items: roles.map((role) {
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
                        Navigator.pop(context);
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
                        style: TextStyle(fontSize: ResponsiveSize.sp(18)),
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
    Widget _buildContentCell(String text, int flex, {Color? color}) {
    return Expanded(
      flex: flex,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(18),
            color: color ?? const Color(0xFF8B4513),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(Staff staff) {
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
          '确定要删除员工 ${staff.name} 吗？',
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
                _staffList.remove(staff);
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

  void _showAssignClassesDialog(Staff staff) {
    final Set<String> selectedClasses = Set.from(staff.classes);
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        ),
        child: Container(
          width: ResponsiveSize.w(800),
          padding: EdgeInsets.all(ResponsiveSize.w(32)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题栏
              Row(
                children: [
                  Icon(
                    Icons.class_,
                    color: const Color(0xFF8B4513),
                    size: ResponsiveSize.w(32),
                  ),
                  SizedBox(width: ResponsiveSize.w(16)),
                  Text(
                    '为 ${staff.name} 分配班级',
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
              SizedBox(height: ResponsiveSize.h(40)),
              // 当前班级信息卡片
              Container(
                padding: EdgeInsets.all(ResponsiveSize.w(20)),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5E6),
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                  border: Border.all(
                    color: const Color(0xFFDEB887),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: const Color(0xFF8B4513),
                          size: ResponsiveSize.w(24),
                        ),
                        SizedBox(width: ResponsiveSize.w(8)),
                        Text(
                          '当前班级',
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(20),
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF8B4513),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveSize.h(12)),
                    Text(
                      staff.classes.isEmpty ? "未分配班级" : staff.classes.join("、"),
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(18),
                        color: const Color(0xFF8B4513).withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveSize.h(32)),
              // 班级选择区域
              Text(
                '选择班级：',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF8B4513),
                ),
              ),
              SizedBox(height: ResponsiveSize.h(16)),
              Container(
                height: ResponsiveSize.h(400),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                  border: Border.all(
                    color: const Color(0xFFDEB887),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B4513).withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.builder(
                  padding: EdgeInsets.all(ResponsiveSize.w(12)),
                  itemCount: ['一年级一班', '一年级二班', '二年级一班', '二年级二班'].length,
                  itemBuilder: (context, index) {
                    final className = ['一年级一班', '一年级二班', '二年级一班', '二年级二班'][index];
                    final isSelected = selectedClasses.contains(className);
                    return Container(
                      margin: EdgeInsets.only(bottom: ResponsiveSize.h(8)),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFFFF5E6) : Colors.white,
                        borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                        border: Border.all(
                          color: const Color(0xFFDEB887),
                          width: 1,
                        ),
                      ),
                      child: CheckboxListTile(
                        title: Text(
                          className,
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(18),
                            color: const Color(0xFF8B4513),
                            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                        value: isSelected,
                        activeColor: const Color(0xFF8B4513),
                        onChanged: (bool? value) {
                          if (value == true) {
                            selectedClasses.add(className);
                          } else {
                            selectedClasses.remove(className);
                          }
                          (context as Element).markNeedsBuild();
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: ResponsiveSize.h(32)),
              // 底部按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFDEB887)),
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.w(32),
                        vertical: ResponsiveSize.h(16),
                      ),
                    ),
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
                      staff.classes = selectedClasses.toList();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B4513),
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.w(32),
                        vertical: ResponsiveSize.h(16),
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
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}