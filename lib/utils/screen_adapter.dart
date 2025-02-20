import 'package:flutter/material.dart';

class ScreenAdapter {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double scaleWidth;
  static late double scaleHeight;
  
  static const double designWidth = 1366.0;  // iPad Pro 13-inch 横屏宽度
  static const double designHeight = 1024.0; // iPad Pro 13-inch 横屏高度

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    scaleWidth = screenWidth / designWidth;
    scaleHeight = screenHeight / designHeight;
  }

  static double setWidth(double width) {
    return width * scaleWidth;
  }

  static double setHeight(double height) {
    return height * scaleHeight;
  }

  static double setFontSize(double fontSize) {
    return fontSize * ((scaleWidth + scaleHeight) / 2);
  }
}