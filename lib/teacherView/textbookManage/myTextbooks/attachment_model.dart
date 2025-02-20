class AttachmentModel {
  final String type;
  final String name;
  final String filePath;
  Offset position;
  double scale;

  AttachmentModel({
    required this.type,
    required this.name,
    required this.filePath,
    this.position = const Offset(100, 100),
    this.scale = 1.0,
  });
}

class Offset {
  final double dx;
  final double dy;

  const Offset(this.dx, this.dy);
}