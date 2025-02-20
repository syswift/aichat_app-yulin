import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';

class AIStudyRoom extends StatelessWidget {
  const AIStudyRoom({super.key});
  
  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    return Scaffold(
      body: Stack(
        children: [
          // 背景图片
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/AIStudyRoom.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 返回按钮
          Positioned(
            top: ResponsiveSize.h(60),
            left: ResponsiveSize.w(40),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Image.asset(
                'assets/backbutton1.png',
                width: ResponsiveSize.w(100),
                height: ResponsiveSize.h(100),
              ),
            ),
          ),
          // 切换教材按钮
          Positioned(
            top: ResponsiveSize.h(60),
            right: ResponsiveSize.w(90),
            child: _buildCustomButton(
              label: '切换教材',
              onTap: () {
                // TODO: 处理切换教材的逻辑
              },
            ),
          ),
          // 开始聊天按钮
          Positioned(
            top: MediaQuery.of(context).size.height * 0.55,
            left: MediaQuery.of(context).size.width / 2,
            child: _buildCustomButton(
              label: '开始对话',
              onTap: () {
                // TODO: 处理开始对话的逻辑
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.w(25),
            vertical: ResponsiveSize.h(15),
          ),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 253, 170, 88),
            borderRadius: BorderRadius.circular(ResponsiveSize.w(30)),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 214, 214, 213),
                offset: Offset(
                  ResponsiveSize.w(4),
                  ResponsiveSize.h(4),
                ),
                blurRadius: ResponsiveSize.w(2),
                spreadRadius: ResponsiveSize.w(4),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveSize.sp(35),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}