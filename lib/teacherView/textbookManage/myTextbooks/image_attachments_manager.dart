import 'package:flutter/material.dart';
import 'attachment_model.dart';
import 'image_attachment_widget.dart';

class ImageAttachmentsManager extends StatelessWidget {
  final List<AttachmentModel> attachments;
  final Function(int, Offset) onPositionChanged;
  final Function(int, double) onScaleChanged;
  final Function(int) onDelete;

  const ImageAttachmentsManager({
    super.key,
    required this.attachments,
    required this.onPositionChanged,
    required this.onScaleChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (int i = 0; i < attachments.length; i++)
          if (attachments[i].type == '图片')
            ImageAttachmentWidget(
              attachment: attachments[i],
              onPositionChanged: (position) => onPositionChanged(i, position),
              onScaleChanged: (scale) => onScaleChanged(i, scale),
              onDelete: () => onDelete(i),
            ),
      ],
    );
  }
}