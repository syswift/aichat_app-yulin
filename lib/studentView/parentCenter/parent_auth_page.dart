import 'package:flutter/material.dart';
import 'parent_dashboard_page.dart';
import '../../utils/responsive_size.dart';
import 'dart:math' as math;

class ParentAuthPage extends StatefulWidget {
  const ParentAuthPage({super.key});

  @override
  State<ParentAuthPage> createState() => _ParentAuthPageState();
}

class _ParentAuthPageState extends State<ParentAuthPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _verifyPassword() {
    if (_passwordController.text == '123456') {
      // 示例密码
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ParentDashboardPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '密码错误，请重试',
            style: TextStyle(fontSize: ResponsiveSize.sp(16)),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context); // 确保在build开始时初始化

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/homeworkbg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(
                          bottom: math.max(0, ResponsiveSize.py(100)),
                          top: math.max(0, ResponsiveSize.py(50)),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.w(20),
                              ),
                              child: Image.asset(
                                'assets/settingbg.png',
                                width: ResponsiveSize.w(823),
                                height: ResponsiveSize.h(617),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              width: ResponsiveSize.w(823),
                              height: ResponsiveSize.h(617),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  ResponsiveSize.w(20),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '家长验证',
                                    style: TextStyle(
                                      fontSize: ResponsiveSize.sp(36),
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF333333),
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveSize.h(50)),
                                  SizedBox(
                                    width: ResponsiveSize.w(300),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveSize.w(10),
                                        ),
                                        border: Border.all(
                                          color: const Color(0xFF88c5fd),
                                          width: ResponsiveSize.w(1),
                                        ),
                                      ),
                                      child: TextField(
                                        controller: _passwordController,
                                        obscureText: !_isPasswordVisible,
                                        style: TextStyle(
                                          fontSize: ResponsiveSize.sp(16),
                                          color: const Color(0xFF333333),
                                        ),
                                        decoration: InputDecoration(
                                          labelText: '请输入家长密码',
                                          labelStyle: TextStyle(
                                            color: const Color(0xFF666666),
                                            fontSize: ResponsiveSize.sp(14),
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: ResponsiveSize.w(20),
                                            vertical: ResponsiveSize.h(15),
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _isPasswordVisible
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: const Color(0xFF88c5fd),
                                              size: ResponsiveSize.w(24),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isPasswordVisible =
                                                    !_isPasswordVisible;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveSize.h(30)),
                                  SizedBox(
                                    width: ResponsiveSize.w(150),
                                    height: ResponsiveSize.h(50),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF88c5fd),
                                            Color(0xFF6baafd),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveSize.w(25),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF88c5fd,
                                            ).withOpacity(0.3),
                                            blurRadius: ResponsiveSize.w(8),
                                            offset: Offset(
                                              0,
                                              ResponsiveSize.h(4),
                                            ),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: _verifyPassword,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              ResponsiveSize.w(25),
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: ResponsiveSize.w(20),
                                            vertical: ResponsiveSize.h(10),
                                          ),
                                        ),
                                        child: Text(
                                          '确认',
                                          style: TextStyle(
                                            fontSize: ResponsiveSize.sp(25),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ResponsiveSize.w(20)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
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
