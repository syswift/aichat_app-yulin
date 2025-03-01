import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../../../utils/responsive_size.dart';
import 'my_templates_page.dart';
import '../../../services/supabase_service.dart';

class ClassTaskAssignmentPage extends StatefulWidget {
  final TemplateItem template;

  const ClassTaskAssignmentPage({Key? key, required this.template})
    : super(key: key);

  @override
  State<ClassTaskAssignmentPage> createState() =>
      _ClassTaskAssignmentPageState();
}

class _ClassTaskAssignmentPageState extends State<ClassTaskAssignmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  DateTime _publishDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.template.name;
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFDEB887),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<String?> _uploadCoverImage(String coverPath) async {
    try {
      File? imageFile;
      String filename = '';

      if (coverPath.startsWith('assets/')) {
        // If it's an asset, we need to create a temporary file first
        final ByteData data = await rootBundle.load(coverPath);
        final Directory tempDir = await getTemporaryDirectory();
        final String tempPath =
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png';
        imageFile = await File(tempPath).writeAsBytes(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        );
        // Create a unique filename for the asset
        filename =
            'cover_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}.png';
      } else {
        // If it's a file path
        imageFile = File(coverPath);
        // Get just the filename from the path
        filename = coverPath.split('/').last;

        // Ensure unique filename to avoid conflicts
        final extension =
            filename.contains('.') ? filename.split('.').last : 'png';
        filename =
            'cover_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}.$extension';
      }

      // Upload to Supabase Storage
      final response = await SupabaseService.client.storage
          .from('cover')
          .upload(filename, imageFile);

      return filename;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  Future<void> _assignTaskToClass() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 格式化日期为ISO标准格式
      final formattedPublishDate = DateFormat(
        'yyyy-MM-dd',
      ).format(_publishDate);
      final formattedDueDate = DateFormat('yyyy-MM-dd').format(_dueDate);

      // 上传封面图片到存储并获取文件名
      String? coverFilename = await _uploadCoverImage(widget.template.cover);

      if (coverFilename == null) {
        throw Exception('封面上传失败');
      }

      // 准备要插入的数据
      final homeworkData = {
        'title': _titleController.text,
        'type':
            widget.template.type != null
                ? _getTypeName(widget.template.type!)
                : '未分类',
        'status': '未完成',
        'cover': coverFilename, // 只存储文件名
        'publish_date': formattedPublishDate,
        'due_date': formattedDueDate,
        'content': widget.template.description ?? '',
      };

      // 插入数据到Supabase
      final response =
          await SupabaseService.client
              .from('homeworks')
              .insert(homeworkData)
              .select();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '任务已成功布置',
              style: TextStyle(fontSize: ResponsiveSize.sp(16)),
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '布置失败: $e',
              style: TextStyle(fontSize: ResponsiveSize.sp(16)),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
              '布置课堂任务',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(28),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5A2E17),
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
                      // 模板预览
                      Text(
                        '任务模板预览',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(22),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(16)),
                      Container(
                        padding: EdgeInsets.all(ResponsiveSize.w(16)),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(12),
                          ),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            // 封面图
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.w(8),
                              ),
                              child: Container(
                                width: ResponsiveSize.w(120),
                                height: ResponsiveSize.h(120),
                                color: Colors.grey[200],
                                child:
                                    widget.template.cover.startsWith('assets/')
                                        ? Image.asset(
                                          widget.template.cover,
                                          fit: BoxFit.cover,
                                        )
                                        : Image.file(
                                          File(widget.template.cover),
                                          fit: BoxFit.cover,
                                        ),
                              ),
                            ),
                            SizedBox(width: ResponsiveSize.w(16)),
                            // 模板信息
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.template.name,
                                    style: TextStyle(
                                      fontSize: ResponsiveSize.sp(20),
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF333333),
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveSize.h(8)),
                                  Text(
                                    '类型: ${widget.template.type != null ? _getTypeName(widget.template.type!) : "未分类"}',
                                    style: TextStyle(
                                      fontSize: ResponsiveSize.sp(16),
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveSize.h(8)),
                                  if (widget.template.description != null)
                                    Text(
                                      widget.template.description!,
                                      style: TextStyle(
                                        fontSize: ResponsiveSize.sp(16),
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: ResponsiveSize.h(32)),

                      // 任务标题
                      Text(
                        '任务标题',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(22),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(12)),
                      TextFormField(
                        controller: _titleController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入任务标题';
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: ResponsiveSize.sp(16)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.w(12),
                            ),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.w(12),
                            ),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.w(12),
                            ),
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

                      // 截止日期
                      Text(
                        '截止日期',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(22),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(12)),
                      InkWell(
                        onTap: () => _selectDueDate(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveSize.w(20),
                            vertical: ResponsiveSize.h(16),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.w(12),
                            ),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('yyyy-MM-dd').format(_dueDate),
                                style: TextStyle(
                                  fontSize: ResponsiveSize.sp(16),
                                  color: Colors.grey[800],
                                ),
                              ),
                              Icon(
                                Icons.calendar_today,
                                color: Colors.grey[600],
                                size: ResponsiveSize.w(24),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: ResponsiveSize.h(48)),

                      // 提交按钮
                      Center(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _assignTaskToClass,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDEB887),
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveSize.w(60),
                              vertical: ResponsiveSize.h(20),
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.w(12),
                              ),
                            ),
                          ),
                          child:
                              _isLoading
                                  ? SizedBox(
                                    width: ResponsiveSize.w(24),
                                    height: ResponsiveSize.h(24),
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                  : Text(
                                    '确认布置',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ResponsiveSize.sp(22),
                                      fontWeight: FontWeight.w600,
                                    ),
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

  String _getTypeName(String typeKey) {
    final Map<String, String> typeNames = {
      'listening': '听力理解',
      'reading': '自读闯关',
      'recording': '录音',
      'video': '视频',
      'exercise': '习题',
    };
    return typeNames[typeKey] ?? typeKey;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
