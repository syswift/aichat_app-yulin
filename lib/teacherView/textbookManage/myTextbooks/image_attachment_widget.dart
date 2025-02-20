import 'package:flutter/material.dart';
import 'dart:io';
import 'attachment_model.dart';
import '../../../utils/responsive_size.dart';

class ImageAttachmentWidget extends StatefulWidget {
  final AttachmentModel attachment;
  final Function(Offset) onPositionChanged;
  final Function(double) onScaleChanged;
  final VoidCallback onDelete;

  const ImageAttachmentWidget({
    super.key,
    required this.attachment,
    required this.onPositionChanged,
    required this.onScaleChanged,
    required this.onDelete,
  });

  @override
  State<ImageAttachmentWidget> createState() => _ImageAttachmentWidgetState();
}

class _ImageAttachmentWidgetState extends State<ImageAttachmentWidget> {
  late Offset _position;
  late double _scale;
  bool _isEditMode = true;
  late double _imageWidth;
  late double _imageHeight;
  final double _baseSize = 200.0;

  @override
  void initState() {
    super.initState();
    _position = widget.attachment.position;
    _scale = widget.attachment.scale;
    _imageWidth = ResponsiveSize.w(_baseSize) * _scale;
    _imageHeight = ResponsiveSize.h(_baseSize) * _scale;
  }

  void _updateSize(double width, double height) {
    setState(() {
      _imageWidth = width;
      _imageHeight = height;
      _scale = width / ResponsiveSize.w(_baseSize); // 更新缩放比例
      widget.onScaleChanged(_scale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onTap: () {
          if (!_isEditMode) {
            setState(() => _isEditMode = true);
          }
        },
        onPanUpdate: (details) {
          if (_isEditMode) {
            setState(() {
              _position = Offset(
                _position.dx + details.delta.dx,
                _position.dy + details.delta.dy,
              );
              widget.onPositionChanged(_position);
            });
          }
        },
        child: Stack(
          children: [
            Container(
              width: _imageWidth,
              height: _imageHeight,
              decoration: BoxDecoration(
                border: _isEditMode ? Border.all(
                  color: const Color(0xFF8B4513),
                  width: ResponsiveSize.w(2),
                ) : null,
                borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                boxShadow: _isEditMode ? [
                  BoxShadow(
                    color: const Color(0xFF8B4513).withOpacity(0.3),
                    blurRadius: ResponsiveSize.w(8),
                    spreadRadius: ResponsiveSize.w(1),
                  )
                ] : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
                child: Image.file(
                  File(widget.attachment.filePath),
                  width: _imageWidth,
                  height: _imageHeight,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (_isEditMode) ...[
              // 删除按钮
              Positioned(
                right: ResponsiveSize.w(-10),
                top: ResponsiveSize.h(-10),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B4513),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: ResponsiveSize.w(18),
                    ),
                    constraints: BoxConstraints(
                      minWidth: ResponsiveSize.w(30),
                      minHeight: ResponsiveSize.h(30),
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: widget.onDelete,
                  ),
                ),
              ),
              // 切换编辑模式按钮
              Positioned(
                right: ResponsiveSize.w(-10),
                bottom: ResponsiveSize.h(-10),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B4513),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isEditMode ? Icons.visibility : Icons.edit,
                      color: Colors.white,
                      size: ResponsiveSize.w(18),
                    ),
                    constraints: BoxConstraints(
                      minWidth: ResponsiveSize.w(30),
                      minHeight: ResponsiveSize.h(30),
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() => _isEditMode = !_isEditMode);
                    },
                  ),
                ),
              ),
              // 右下角缩放控制点
              Positioned(
                right: ResponsiveSize.w(-10),
                bottom: ResponsiveSize.h(-10),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    final newWidth = _imageWidth + details.delta.dx;
                    final newHeight = _imageHeight + details.delta.dy;
                    if (newWidth >= ResponsiveSize.w(100) && 
                        newHeight >= ResponsiveSize.h(100)) { // 最小尺寸限制
                      _updateSize(newWidth, newHeight);
                    }
                  },
                  child: Container(
                    width: ResponsiveSize.w(20),
                    height: ResponsiveSize.h(20),
                    decoration: const BoxDecoration(
                      color: Color(0xFF8B4513),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.open_in_full,
                        color: Colors.white,
                        size: ResponsiveSize.w(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}