import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';

class QrLoginCard extends StatelessWidget {
  const QrLoginCard({super.key});

  final Color _themeColor = const Color(0xFFF6BA66);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: _themeColor.withOpacity(0.3),
          width: ResponsiveSize.w(2),
        ),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
      ),
      padding: EdgeInsets.fromLTRB(
        ResponsiveSize.w(20),
        ResponsiveSize.h(20),
        ResponsiveSize.w(20),
        ResponsiveSize.h(0)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: ResponsiveSize.w(200),
            height: ResponsiveSize.h(200),
            decoration: BoxDecoration(
              color: _themeColor.withOpacity(0.1),
              border: Border.all(
                color: _themeColor,
                width: ResponsiveSize.w(2),
              ),
              borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
              boxShadow: [
                BoxShadow(
                  color: _themeColor.withOpacity(0.2),
                  blurRadius: ResponsiveSize.w(10),
                  spreadRadius: ResponsiveSize.w(2),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.qr_code_scanner,
                size: ResponsiveSize.w(100),
                color: _themeColor,
              ),
            ),
          ),
          SizedBox(height: ResponsiveSize.h(16)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.w(16),
              vertical: ResponsiveSize.h(8)
            ),
            decoration: BoxDecoration(
              color: _themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  size: ResponsiveSize.w(18),
                  color: _themeColor,
                ),
                SizedBox(width: ResponsiveSize.w(6)),
                Text(
                  '请使用鹅爸爸App扫描二维码登录',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(14),
                    color: const Color(0xFF5C3D2E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ResponsiveSize.h(10)),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(8)),
            ),
            child: Text(
              '邀请码注册',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(16),
                fontWeight: FontWeight.w600,
                color: _themeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}