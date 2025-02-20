import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';

class AddCampusDialog extends StatefulWidget {
  const AddCampusDialog({super.key});

  @override
  State<AddCampusDialog> createState() => _AddCampusDialogState();
}

class _AddCampusDialogState extends State<AddCampusDialog> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final managerNameController = TextEditingController();
  final managerPhoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    managerNameController.dispose();
    managerPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                      Icons.location_city,
                      color: const Color(0xFF8B4513),
                      size: ResponsiveSize.w(32),
                    ),
                    SizedBox(width: ResponsiveSize.w(16)),
                    Text(
                      '添加校区',
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
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    children: [
                      _buildDialogTextField(
                        controller: nameController,
                        label: '校区名称',
                        hintText: '请输入校区名称',
                      ),
                      SizedBox(height: ResponsiveSize.h(24)),
                      _buildDialogTextField(
                        controller: addressController,
                        label: '校区地址',
                        hintText: '请输入校区地址',
                      ),
                      SizedBox(height: ResponsiveSize.h(24)),
                      _buildDialogTextField(
                        controller: managerNameController,
                        label: '校区管理员',
                        hintText: '请输入校区管理员姓名',
                      ),
                      SizedBox(height: ResponsiveSize.h(24)),
                      _buildDialogTextField(
                        controller: managerPhoneController,
                        label: '联系电话',
                        hintText: '请输入管理员联系电话',
                        keyboardType: TextInputType.phone,
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
                                fontSize: ResponsiveSize.sp(20),
                                color: const Color(0xFF8B4513),
                              ),
                            ),
                          ),
                          SizedBox(width: ResponsiveSize.w(24)),
                          ElevatedButton(
                            onPressed: () {
                              if (_validateInputs()) {
                                _submitCampus();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF8B4513),
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveSize.w(32),
                                vertical: ResponsiveSize.h(16),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
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
    TextInputType? keyboardType,
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
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(18),
          ),
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
        ),
      ],
    );
  }

  bool _validateInputs() {
    if (nameController.text.isEmpty ||
        addressController.text.isEmpty ||
        managerNameController.text.isEmpty ||
        managerPhoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写所有必填项')),
      );
      return false;
    }
    return true;
  }

  void _submitCampus() {
    Navigator.pop(context, {
      'name': nameController.text,
      'address': addressController.text,
      'managerName': managerNameController.text,
      'managerPhone': managerPhoneController.text,
    });
  }
} 