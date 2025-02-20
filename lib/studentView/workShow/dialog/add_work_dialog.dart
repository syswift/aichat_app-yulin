import '../audioMode/audio_upload_page.dart';
import 'package:flutter/material.dart';
import '../videoMode/video_record_page.dart';
import '../videoMode/video_upload_page.dart';
import '../imageMode/image_upload_page.dart';
import '../../../utils/responsive_size.dart';

class AddWorkDialog extends StatelessWidget {
  final VoidCallback onRecordPressed;
  final Function(String, String, String) onSaveWork;

  const AddWorkDialog({
    super.key,
    required this.onRecordPressed,
    required this.onSaveWork,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: ResponsiveSize.w(600),
        height: ResponsiveSize.h(500), // 增加高度以适应新的图片模式
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
        ),
        child: Column(
          children: [
            // 顶部背景图片和标题
            Container(
              height: ResponsiveSize.h(100),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(ResponsiveSize.w(20))
                ),
                image: const DecorationImage(
                  image: AssetImage('assets/addbackground.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  '选择课件模式',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(30),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // 选项内容
            Padding(
              padding: EdgeInsets.all(ResponsiveSize.w(30)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 音频模式
                  Row(
                    children: [
                      Text(
                        '音频模式：',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(20),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: ResponsiveSize.w(20)),
                      _buildOptionButton('录音', context),
                      SizedBox(width: ResponsiveSize.w(20)),
                      _buildOptionButton('音频', context),
                    ],
                  ),
                  SizedBox(height: ResponsiveSize.h(20)),
                  // 视频模式
                  Row(
                    children: [
                      Text(
                        '视频模式：',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(20),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: ResponsiveSize.w(20)),
                      _buildOptionButton('拍摄', context),
                      SizedBox(width: ResponsiveSize.w(20)),
                      _buildOptionButton('视频', context),
                    ],
                  ),
                  SizedBox(height: ResponsiveSize.h(20)),
                  // 图片模式
                  Row(
                    children: [
                      Text(
                        '图片模式：',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(20),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: ResponsiveSize.w(20)),
                      _buildOptionButton('图片', context),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String text, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (text == '录音') {
          onRecordPressed();
        } else if (text == '音频') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AudioUploadPage(
                onSaveWork: (title, audioPath, imagePath) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  onSaveWork(title, audioPath, imagePath);
                },
              ),
            ),
          );
        } else if (text == '拍摄') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoRecordPage(
                onSaveWork: (title, videoPath, imagePath) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  onSaveWork(title, videoPath, imagePath);
                },
              ),
            ),
          );
        } else if (text == '视频') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoUploadPage(
                onSaveWork: (title, videoPath, imagePath) {
                  debugPrint('保存视频作品 - 标题: $title');
                  debugPrint('视频路径: $videoPath');
                  debugPrint('图片路径: $imagePath');
                  Navigator.pop(context);
                  Navigator.pop(context);
                  onSaveWork(title, videoPath, imagePath);
                },
              ),
            ),
          );
        } else if (text == '图片') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageUploadPage(
                onSaveWork: (title, imagePath) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  onSaveWork(title, imagePath, imagePath);
                },
              ),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(30),
          vertical: ResponsiveSize.h(8)
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(20),
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}