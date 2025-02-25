import 'package:flutter/material.dart';

class ResponsiveSize {
  static double _scale = 1.0;
  static double _offsetX = 0.0;
  static double _offsetY = 0.0;
  static const double _baseWidth = 1366.0; // iPad Pro 13-inch 横屏宽度
  static const double _baseHeight = 1024.0;

  static var screenWidth; // iPad Pro 13-inch 横屏高度

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    // 计算缩放比例
    _scale = screenWidth / _baseWidth;

    // 计算位置偏移量
    _offsetX = (screenWidth - (_baseWidth * _scale)) / 2;
    _offsetY = (screenHeight - (_baseHeight * _scale)) / 2;
  }

  // 宽度缩放，考虑偏移量
  static double w(double size) => size * _scale;

  // 高度缩放，考虑偏移量
  static double h(double size) => size * _scale;

  // 水平位置，考虑偏移量
  static double px(double position) => (position * _scale) + _offsetX;

  // 垂直位置，考虑偏移量
  static double py(double position) => (position * _scale) + _offsetY;

  // 字体大小缩放
  static double sp(double size) => size * _scale;

  static EdgeInsets all(double value) => EdgeInsets.all(w(value));

  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: w(horizontal), vertical: h(vertical));

  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => EdgeInsets.only(
    left: px(left),
    top: py(top),
    right: px(right),
    bottom: py(bottom),
  );

  static BorderRadius radius(double radius) => BorderRadius.circular(w(radius));
}
