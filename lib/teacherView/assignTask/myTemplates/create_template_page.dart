import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import './my_templates_page.dart';
import '../../../utils/responsive_size.dart';  // 添加响应式尺寸工具

class CreateTemplatePage extends StatefulWidget {
  final TemplateItem? template;
  
  const CreateTemplatePage({super.key, this.template});

  @override
  State<CreateTemplatePage> createState() => _CreateTemplatePageState();
}

class _CreateTemplatePageState extends State<CreateTemplatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedTaskType;
  String? _coverImage;
  final ImagePicker _picker = ImagePicker();
  bool isEditMode = false;

  final List<Map<String, dynamic>> taskTypes = [
    {'type': 'listening', 'name': '听力', 'icon': Icons.headphones},
    {'type': 'reading', 'name': '阅读', 'icon': Icons.menu_book},
    {'type': 'recording', 'name': '录音', 'icon': Icons.mic},
    {'type': 'video', 'name': '视频', 'icon': Icons.videocam},
    {'type': 'exercise', 'name': '习题', 'icon': Icons.assignment},
  ];
    @override
  void initState() {
    super.initState();
    if (widget.template != null) {
      isEditMode = true;
      _nameController.text = widget.template!.name;
      _noteController.text = widget.template!.note;
      _coverImage = widget.template!.cover;
      _selectedTaskType = widget.template!.type;
      if (widget.template!.description != null) {
        _descriptionController.text = widget.template!.description!;
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _coverImage = image.path;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _saveTemplate() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedTaskType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '请选择任务内容',
            style: TextStyle(fontSize: ResponsiveSize.sp(16)),
          ),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    List<String> templates = prefs.getStringList('templates') ?? [];
    
    final newTemplate = {
      'name': _nameController.text,
      'note': _noteController.text,
      'cover': _coverImage ?? 'assets/default_cover.png',
      'description': _descriptionController.text,
      'type': _selectedTaskType,
    };

    if (isEditMode) {
      final index = templates.indexWhere((template) {
        final Map<String, dynamic> templateMap = json.decode(template);
        return templateMap['name'] == widget.template!.name;
      });
      if (index != -1) {
        templates[index] = json.encode(newTemplate);
      }
    } else {
      templates.add(json.encode(newTemplate));
    }

    await prefs.setStringList('templates', templates);
    if (mounted) {
      Navigator.pop(context, true);
    }
  }
    void _showTaskTypeDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: ResponsiveSize.w(800),
              height: ResponsiveSize.h(500),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveSize.w(16)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  // 顶部图片区域
                  Stack(
                    children: [
                      Container(
                        height: ResponsiveSize.h(167),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(ResponsiveSize.w(16)),
                            topRight: Radius.circular(ResponsiveSize.w(16)),
                          ),
                          image: const DecorationImage(
                            image: AssetImage('assets/popuphomework.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      // 标题完全居中
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.only(top: ResponsiveSize.h(30)),
                            child: Text(
                              '选择任务内容',
                              style: TextStyle(
                                fontSize: ResponsiveSize.sp(32),
                                fontWeight: FontWeight.w600,
                                color: const Color.fromRGBO(90, 46, 23, 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // 内容区域
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                        ResponsiveSize.w(32),
                        ResponsiveSize.h(24),
                        ResponsiveSize.w(32),
                        ResponsiveSize.h(24),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(ResponsiveSize.w(16)),
                          bottomRight: Radius.circular(ResponsiveSize.w(16)),
                        ),
                      ),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 3.0,
                          crossAxisSpacing: ResponsiveSize.w(20),
                          mainAxisSpacing: ResponsiveSize.h(20),
                        ),
                        itemCount: taskTypes.length,
                        itemBuilder: (context, index) {
                          final type = taskTypes[index];
                          final isSelected = type['type'] == _selectedTaskType;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedTaskType = type['type'];
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: ResponsiveSize.h(40),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFFFE4C4) : Colors.white,
                                borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFFDEB887) : Colors.grey[300]!,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    type['icon'] as IconData,
                                    size: ResponsiveSize.w(28),
                                    color: isSelected ? const Color(0xFF8B4513) : Colors.grey[600],
                                  ),
                                  SizedBox(width: ResponsiveSize.w(12)),
                                  Text(
                                    type['name'] as String,
                                    style: TextStyle(
                                      fontSize: ResponsiveSize.sp(20),
                                      color: isSelected ? const Color(0xFF8B4513) : Colors.grey[800],
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
                        // 关闭按钮放在右上角
            Positioned(
              top: ResponsiveSize.h(-20),
              right: ResponsiveSize.w(-20),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  padding: EdgeInsets.all(ResponsiveSize.w(4)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: ResponsiveSize.w(8),
                        offset: Offset(0, ResponsiveSize.h(2)),
                      ),
                    ],
                  ),
                  child: Icon(Icons.close, size: ResponsiveSize.w(24)),
                ),
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
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
              isEditMode ? '编辑课堂任务模板' : '创建课堂任务模板',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(28),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5A2E17),
              ),
            ),
          ),
          
          // 创建/保存按钮
          Positioned(
            top: ResponsiveSize.h(55),
            right: ResponsiveSize.w(32),
            child: ElevatedButton(
              onPressed: _saveTemplate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFE4C4),
                foregroundColor: const Color(0xFF8B4513),
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.w(40),
                  vertical: ResponsiveSize.h(16),
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
                isEditMode ? '保存修改' : '创建',
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
              bottom: ResponsiveSize.h(32),
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
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 任务内容和封面的行
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 左侧任务内容
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '任务内容',
                                  style: TextStyle(
                                    fontSize: ResponsiveSize.sp(22),
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                                SizedBox(height: ResponsiveSize.h(16)),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: InkWell(
                                    onTap: _showTaskTypeDialog,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ResponsiveSize.w(32),
                                        vertical: ResponsiveSize.h(16),
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFE4C4),
                                        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                                        border: Border.all(
                                          color: const Color(0xFFDEB887),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _selectedTaskType != null ? Icons.check_circle : Icons.add_circle_outline,
                                            size: ResponsiveSize.w(24),
                                            color: const Color(0xFF8B4513),
                                          ),
                                          SizedBox(width: ResponsiveSize.w(8)),
                                          Text(
                                            _selectedTaskType != null
                                                ? taskTypes.firstWhere((type) => type['type'] == _selectedTaskType)['name']
                                                : '添加任务内容',
                                            style: TextStyle(
                                              fontSize: ResponsiveSize.sp(18),
                                              color: const Color(0xFF8B4513),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                                                    SizedBox(width: ResponsiveSize.w(32)),
                          // 右侧任务封面
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '任务封面',
                                  style: TextStyle(
                                    fontSize: ResponsiveSize.sp(22),
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                                SizedBox(height: ResponsiveSize.h(16)),
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    width: double.infinity,
                                    height: ResponsiveSize.h(200),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                                      border: Border.all(color: const Color(0xFFDEB887), width: 2),
                                    ),
                                    child: _coverImage != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
                                            child: Container(
                                              color: Colors.grey[200],
                                              child: _coverImage!.startsWith('assets/')
                                                  ? Image.asset(
                                                      _coverImage!,
                                                      fit: BoxFit.contain,
                                                    )
                                                  : Image.file(
                                                      File(_coverImage!),
                                                      fit: BoxFit.contain,
                                                    ),
                                            ),
                                          )
                                        : Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add_photo_alternate,
                                                size: ResponsiveSize.w(48),
                                                color: Colors.grey[400],
                                              ),
                                              SizedBox(height: ResponsiveSize.h(8)),
                                              Text(
                                                '点击添加封面',
                                                style: TextStyle(
                                                  fontSize: ResponsiveSize.sp(16),
                                                  color: Colors.grey[400],
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

                      SizedBox(height: ResponsiveSize.h(32)),
                                            // 任务名称
                      Text(
                        '任务名称',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(22),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(12)),
                      TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入任务名称';
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: ResponsiveSize.sp(16)),
                        decoration: InputDecoration(
                          hintText: '请输入任务名称',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: ResponsiveSize.sp(16),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                            borderSide: const BorderSide(
                              color: Color(0xFFDEB887),
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: ResponsiveSize.w(20),
                            vertical: ResponsiveSize.h(16),
                          ),
                        ),
                      ),

                      SizedBox(height: ResponsiveSize.h(32)),
                      // 任务描述
                      Row(
                        children: [
                          Text(
                            '任务描述',
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(22),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          SizedBox(width: ResponsiveSize.w(8)),
                          Text(
                            '(全员可见)',
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(16),
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                                            SizedBox(height: ResponsiveSize.h(12)),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        style: TextStyle(fontSize: ResponsiveSize.sp(16)),
                        decoration: InputDecoration(
                          hintText: '请输入任务描述',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: ResponsiveSize.sp(16),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                            borderSide: const BorderSide(
                              color: Color(0xFFDEB887),
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: ResponsiveSize.w(20),
                            vertical: ResponsiveSize.h(16),
                          ),
                        ),
                      ),

                      SizedBox(height: ResponsiveSize.h(32)),
                      // 备注信息
                      Row(
                        children: [
                          Text(
                            '备注信息',
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(22),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          SizedBox(width: ResponsiveSize.w(8)),
                          Text(
                            '(选填，仅老师及以上可见，限100字)',
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(16),
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                                            SizedBox(height: ResponsiveSize.h(12)),
                      TextFormField(
                        controller: _noteController,
                        maxLines: 3,
                        maxLength: 100,
                        style: TextStyle(fontSize: ResponsiveSize.sp(16)),
                        decoration: InputDecoration(
                          hintText: '请输入备注信息',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: ResponsiveSize.sp(16),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                            borderSide: const BorderSide(
                              color: Color(0xFFDEB887),
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: ResponsiveSize.w(20),
                            vertical: ResponsiveSize.h(16),
                          ),
                        ),
                      ),
                    ],
                  ),
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
    _noteController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}