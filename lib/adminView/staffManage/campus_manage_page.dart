import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';
import '../models/campus_model.dart';
import 'add_campus_dialog.dart';

class CampusManagePage extends StatefulWidget {
  const CampusManagePage({super.key});

  @override
  State<CampusManagePage> createState() => _CampusManagePageState();
}

class _CampusManagePageState extends State<CampusManagePage> {
  // 模拟数据
  final List<Campus> _campusList = [
    Campus(
      id: '1',
      name: '总校区',
      address: '北京市朝阳区xxx街道xxx号',
      managerName: '张三',
      managerPhone: '13800138000',
      createdAt: DateTime(2020, 1, 1),
    ),
    Campus(
      id: '2',
      name: '分校区1',
      address: '北京市海淀区xxx街道xxx号',
      managerName: '李四',
      managerPhone: '13900139000',
      createdAt: DateTime(2021, 6, 1),
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
            Expanded(
              child: _buildCampusList(),
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
          '校区管理',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(28),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8B4513),
          ),
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: _showAddCampusDialog,
          icon: Icon(
            Icons.add_location_alt,
            size: ResponsiveSize.w(20),
            color: const Color(0xFF8B4513),
          ),
          label: Text(
            '添加校区',
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

  Widget _buildCampusList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
        border: Border.all(color: const Color(0xFFDEB887)),
      ),
      child: ListView.builder(
        itemCount: _campusList.length,
        itemBuilder: (context, index) {
          final campus = _campusList[index];
          return _buildCampusItem(campus);
        },
      ),
    );
  }

  Widget _buildCampusItem(Campus campus) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(16)),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFDEB887)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campus.name,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(20),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8B4513),
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(8)),
                Text(
                  '地址：${campus.address}',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '管理员：${campus.managerName}',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    color: const Color(0xFF8B4513),
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(8)),
                Text(
                  '电话：${campus.managerPhone}',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    color: const Color(0xFF8B4513),
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
            onPressed: () => _showEditCampusDialog(campus),
          ),
        ],
      ),
    );
  }

  void _showEditCampusDialog(Campus campus) {
    final nameController = TextEditingController(text: campus.name);
    final addressController = TextEditingController(text: campus.address);
    final managerNameController = TextEditingController(text: campus.managerName);
    final managerPhoneController = TextEditingController(text: campus.managerPhone);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
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
                  Icon(
                    Icons.edit_location_alt,
                    color: const Color(0xFF8B4513),
                    size: ResponsiveSize.w(28),
                  ),
                  SizedBox(width: ResponsiveSize.w(12)),
                  Text(
                    '编辑校区信息',
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
              SizedBox(height: ResponsiveSize.h(24)),
              _buildDialogTextField(
                controller: nameController,
                label: '校区名称',
                hintText: '请输入校区名称',
              ),
              SizedBox(height: ResponsiveSize.h(16)),
              _buildDialogTextField(
                controller: addressController,
                label: '校区地址',
                hintText: '请输入校区地址',
              ),
              SizedBox(height: ResponsiveSize.h(16)),
              _buildDialogTextField(
                controller: managerNameController,
                label: '校区管理员',
                hintText: '请输入校区管理员姓名',
              ),
              SizedBox(height: ResponsiveSize.h(16)),
              _buildDialogTextField(
                controller: managerPhoneController,
                label: '联系电话',
                hintText: '请输入管理员联系电话',
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: ResponsiveSize.h(32)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                  SizedBox(width: ResponsiveSize.w(16)),
                  ElevatedButton(
                    onPressed: () {
                      if (_validateInputs(
                        nameController.text,
                        addressController.text,
                        managerNameController.text,
                        managerPhoneController.text,
                      )) {
                        // TODO: 处理更新校区信息的逻辑
                        setState(() {
                          // 更新校区信息
                          final index = _campusList.indexOf(campus);
                          _campusList[index] = Campus(
                            id: campus.id,
                            name: nameController.text,
                            address: addressController.text,
                            managerName: managerNameController.text,
                            managerPhone: managerPhoneController.text,
                            createdAt: campus.createdAt,
                          );
                        });
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF8B4513),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                      ),
                    ),
                    child: Text(
                      '保存',
                      style: TextStyle(fontSize: ResponsiveSize.sp(16)),
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

  bool _validateInputs(
    String name,
    String address,
    String managerName,
    String managerPhone,
  ) {
    if (name.isEmpty ||
        address.isEmpty ||
        managerName.isEmpty ||
        managerPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写所有必填项')),
      );
      return false;
    }
    return true;
  }

  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType? keyboardType,
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
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: const Color(0xFF8B4513).withOpacity(0.5),
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
        ),
      ],
    );
  }

  void _showAddCampusDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddCampusDialog(),
    ).then((result) {
      if (result != null) {
        setState(() {
          _campusList.add(
            Campus(
              id: (_campusList.length + 1).toString(),
              name: result['name'],
              address: result['address'],
              managerName: result['managerName'],
              managerPhone: result['managerPhone'],
              createdAt: DateTime.now(),
            ),
          );
        });
      }
    });
  }
} 