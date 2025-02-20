import 'package:flutter/material.dart';
import '../../../../utils/responsive_size.dart';

class TopBar extends StatelessWidget {
  final VoidCallback onBack;

  const TopBar({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ResponsiveSize.w(20)),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Image.asset(
              'assets/backbutton1.png',
              width: ResponsiveSize.w(100),
              height: ResponsiveSize.h(100),
            ),
          ),
        ],
      ),
    );
  }
} 