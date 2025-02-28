import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import '../../../utils/responsive_size.dart';
import '../../services/background_service.dart';

class SystemSettingsPage extends StatefulWidget {
  const SystemSettingsPage({super.key});

  @override
  State<SystemSettingsPage> createState() => _SystemSettingsPageState();
}

class _SystemSettingsPageState extends State<SystemSettingsPage> {
  // Supabase client
  final _supabase = Supabase.instance.client;
  // Storage bucket name
  final String _storageBucket = 'background';

  String _currentBackground = '';
  File? _customBackgroundImage;
  bool _isPreviewMode = false;
  final ImagePicker _picker = ImagePicker();
  bool _isImagePickerActive = false;
  bool _isUploading = false;
  String _selectedBackgroundForPreview = '';

  // 定义页面主题色
  final Color _primaryColor = const Color(0xFF3A5F8E); // 深蓝色主题
  final Color _secondaryColor = const Color(0xFF7497C2); // 中蓝色
  final Color _accentColor = const Color(0xFF2E4C7B); // 深蓝色（按钮用）
  final Color _buttonTextColor = Colors.white; // 按钮文字颜色
  final Color _successColor = const Color(0xFF4CAF50); // 成功色（更柔和的绿色）
  final Color _dangerColor = const Color(0xFFE57373); // 危险色（更柔和的红色）
  final Color _warningColor = const Color(0xFFFFB74D); // 警告色（橙色）

  @override
  void initState() {
    super.initState();
    _initializeDefaults();
  }

  // Initialize default values without loading from database
  void _initializeDefaults() {
    setState(() {
      _currentBackground = '';
      _selectedBackgroundForPreview = '';
    });
  }

  // Upload image to Supabase storage and return the filename
  Future<String?> _uploadImageToSupabase(File imageFile) async {
    setState(() {
      _isUploading = true;
    });

    try {
      final fileExtension = path.extension(imageFile.path).replaceAll('.', '');
      final fileName = '${const Uuid().v4()}.$fileExtension';

      await _supabase.storage.from(_storageBucket).upload(fileName, imageFile);

      return fileName;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('上传图片时出错: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  // Update the background setting in system_settings table
  Future<bool> _updateBackgroundSetting(String fileName) async {
    try {
      await _supabase
          .from('system_settings')
          .update({'setting_value': fileName})
          .eq('setting_name', 'background');

      return true;
    } catch (e) {
      debugPrint('Error updating background setting: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('更新设置时出错: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  Future<void> _saveBackground() async {
    // Only handle new uploads
    if (_customBackgroundImage != null) {
      final uploadedFileName = await _uploadImageToSupabase(
        _customBackgroundImage!,
      );

      if (uploadedFileName != null) {
        // Update the system_settings table with the new background
        final updated = await _updateBackgroundSetting(uploadedFileName);

        if (updated) {
          setState(() {
            _currentBackground = uploadedFileName;
            _customBackgroundImage = null;
            // Clear the background cache so the new background will be loaded
            BackgroundService().clearCache();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('背景已更新'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  Future<void> _pickImage() async {
    // Check if image picker is already active
    if (_isImagePickerActive) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请等待当前操作完成'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    setState(() {
      _isImagePickerActive = true;
    });

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final imageFile = File(image.path);

        setState(() {
          _customBackgroundImage = imageFile;
          _selectedBackgroundForPreview =
              'temp_preview'; // Use a temp identifier for preview
          _isPreviewMode = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('选择图片时出错: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isImagePickerActive = false;
        });
      }
    }
  }

  // Get image provider based on path type
  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath == 'temp_preview' && _customBackgroundImage != null) {
      // Use local file for temporary preview
      return FileImage(_customBackgroundImage!);
    } else {
      // For all other backgrounds, get from Supabase storage
      final publicUrl = _supabase.storage
          .from(_storageBucket)
          .getPublicUrl(imagePath);
      return NetworkImage(publicUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _primaryColor,
        elevation: 0,
        title: Text(
          '系统设置',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(24),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: ResponsiveSize.w(28),
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_isPreviewMode)
            TextButton(
              onPressed: () {
                setState(() {
                  _isPreviewMode = false;
                });
              },
              child: Text(
                '退出预览',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(18),
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      body:
          _isPreviewMode
              ? _buildPreview()
              : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [_primaryColor, Colors.white],
                    stops: const [0.0, 0.3],
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(ResponsiveSize.w(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader('个性化设置'),
                          SizedBox(height: ResponsiveSize.h(20)),
                          _buildBackgroundSettings(),
                          SizedBox(height: ResponsiveSize.h(40)),

                          // Placeholder for future settings sections
                          _buildSectionHeader('高级设置'),
                          SizedBox(height: ResponsiveSize.h(20)),
                          _buildComingSoonCard('系统主题', Icons.palette),
                          SizedBox(height: ResponsiveSize.h(20)),
                          _buildComingSoonCard('字体设置', Icons.text_fields),
                          SizedBox(height: ResponsiveSize.h(20)),
                          _buildComingSoonCard('声音设置', Icons.volume_up),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
    );
  }

  Widget _buildPreview() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: _getImageProvider(_selectedBackgroundForPreview),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveSize.w(20)),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
                  ),
                  child: Text(
                    '预览模式',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(32),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(20)),
                if (_isUploading)
                  Column(
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: ResponsiveSize.h(10)),
                      Text(
                        '正在上传图片...',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(18),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                else
                  ElevatedButton(
                    onPressed: () async {
                      await _saveBackground();
                      setState(() {
                        _isPreviewMode = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _successColor,
                      foregroundColor: _buttonTextColor,
                      elevation: 5,
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.w(30),
                        vertical: ResponsiveSize.h(15),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveSize.w(30),
                        ),
                      ),
                    ),
                    child: Text(
                      '应用此背景',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                SizedBox(height: ResponsiveSize.h(10)),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isPreviewMode = false;
                    });
                  },
                  child: Text(
                    '取消',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(18),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveSize.h(10),
        horizontal: ResponsiveSize.w(15),
      ),
      decoration: BoxDecoration(
        color: _primaryColor,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: ResponsiveSize.w(5),
            offset: Offset(0, ResponsiveSize.h(3)),
          ),
        ],
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: ResponsiveSize.sp(22),
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBackgroundSettings() {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: ResponsiveSize.w(8),
            offset: Offset(0, ResponsiveSize.h(3)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '背景图片设置',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.help_outline,
                  size: ResponsiveSize.w(24),
                  color: Colors.grey,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('背景图片设置帮助'),
                          content: const Text(
                            '您可以上传自定义图片作为系统背景。\n\n'
                            '上传图片后可以预览效果，满意后点击"应用此背景"即可保存。',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('明白了'),
                            ),
                          ],
                        ),
                  );
                },
              ),
            ],
          ),
          Divider(thickness: ResponsiveSize.h(1)),
          SizedBox(height: ResponsiveSize.h(10)),
          Text(
            '上传背景',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(18),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: ResponsiveSize.h(15)),
          Row(
            children: [
              GestureDetector(
                onTap:
                    _customBackgroundImage != null
                        ? () {
                          setState(() {
                            _selectedBackgroundForPreview = 'temp_preview';
                            _isPreviewMode = true;
                          });
                        }
                        : _pickImage,
                child: Container(
                  width: ResponsiveSize.w(200),
                  height: ResponsiveSize.h(120),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
                    color: Colors.grey[200],
                    image:
                        _customBackgroundImage != null
                            ? DecorationImage(
                              image: FileImage(_customBackgroundImage!),
                              fit: BoxFit.cover,
                            )
                            : null,
                  ),
                  child:
                      _customBackgroundImage == null
                          ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: ResponsiveSize.w(40),
                                color: _primaryColor.withOpacity(0.7),
                              ),
                              SizedBox(height: ResponsiveSize.h(8)),
                              Text(
                                '点击上传图片',
                                style: TextStyle(
                                  fontSize: ResponsiveSize.sp(14),
                                  color: _primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                          : Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  vertical: ResponsiveSize.h(6),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                ),
                                child: Text(
                                  '点击预览',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: ResponsiveSize.sp(12),
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                ),
              ),
              SizedBox(width: ResponsiveSize.w(15)),
              if (_customBackgroundImage != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.refresh),
                      label: Text(
                        '更换图片',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(16),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _secondaryColor,
                        foregroundColor: _buttonTextColor,
                        elevation: 3,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(20),
                          vertical: ResponsiveSize.h(10),
                        ),
                      ),
                      onPressed: _pickImage,
                    ),
                    SizedBox(height: ResponsiveSize.h(10)),
                    TextButton.icon(
                      icon: Icon(Icons.delete_outline, color: _dangerColor),
                      label: Text(
                        '删除',
                        style: TextStyle(
                          color: _dangerColor,
                          fontSize: ResponsiveSize.sp(16),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _customBackgroundImage = null;
                        });
                      },
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: ResponsiveSize.h(20)),
          if (_customBackgroundImage != null)
            Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.visibility),
                label: Text(
                  '预览上传的背景',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentColor,
                  foregroundColor: _buttonTextColor,
                  elevation: 4,
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.w(30),
                    vertical: ResponsiveSize.h(15),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(30)),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _selectedBackgroundForPreview = 'temp_preview';
                    _isPreviewMode = true;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildComingSoonCard(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: ResponsiveSize.w(8),
            offset: Offset(0, ResponsiveSize.h(3)),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveSize.w(12)),
            decoration: BoxDecoration(
              color: _secondaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
            ),
            child: Icon(icon, size: ResponsiveSize.w(30), color: _primaryColor),
          ),
          SizedBox(width: ResponsiveSize.w(20)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ResponsiveSize.h(5)),
              Text(
                '即将推出',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(14),
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.w(12),
              vertical: ResponsiveSize.h(6),
            ),
            decoration: BoxDecoration(
              color: _warningColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
            ),
            child: Text(
              '开发中',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(14),
                color: _warningColor.darker(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 扩展方法，用于颜色调整
extension ColorExtension on Color {
  Color darker() {
    return Color.fromARGB(
      alpha,
      (red * 0.7).round(),
      (green * 0.7).round(),
      (blue * 0.7).round(),
    );
  }

  Color lighter() {
    return Color.fromARGB(
      alpha,
      red + ((255 - red) * 0.3).round(),
      green + ((255 - green) * 0.3).round(),
      blue + ((255 - blue) * 0.3).round(),
    );
  }
}
