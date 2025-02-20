import 'package:flutter/material.dart';
import 'dart:async';
import '../studentView/student_page.dart';
import '../../../utils/responsive_size.dart';

class SmsLoginCard extends StatefulWidget {
  const SmsLoginCard({super.key});

  @override
  State<SmsLoginCard> createState() => _SmsLoginCardState();
}

class _SmsLoginCardState extends State<SmsLoginCard> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final Color _themeColor = const Color(0xFFF6BA66);
  bool _isTimerRunning = false;
  int _timerSeconds = 60;
  Timer? _timer;

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
        ResponsiveSize.h(30),
        ResponsiveSize.w(20),
        ResponsiveSize.h(25)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPhoneField(),
          SizedBox(height: ResponsiveSize.h(12)),
          _buildCodeField(),
          SizedBox(height: ResponsiveSize.h(20)),
          _buildLoginButton(),
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

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      style: TextStyle(fontSize: ResponsiveSize.sp(18)),
      decoration: InputDecoration(
        hintText: '请输入手机号',
        hintStyle: TextStyle(
          color: Colors.grey.shade600,
          fontSize: ResponsiveSize.sp(18),
        ),
        filled: true,
        fillColor: _themeColor.withOpacity(0.1),
        prefixIcon: Icon(
          Icons.phone_android,
          color: _themeColor,
          size: ResponsiveSize.w(24)
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
          borderSide: BorderSide(color: _themeColor.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
          borderSide: BorderSide(color: _themeColor.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
          borderSide: BorderSide(color: _themeColor, width: ResponsiveSize.w(2)),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(20),
          vertical: ResponsiveSize.h(16)
        ),
      ),
    );
  }

  Widget _buildCodeField() {
    return TextFormField(
      controller: _codeController,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: ResponsiveSize.sp(18)),
      decoration: InputDecoration(
        hintText: '请输入验证码',
        hintStyle: TextStyle(
          color: Colors.grey.shade600,
          fontSize: ResponsiveSize.sp(18),
        ),
        filled: true,
        fillColor: _themeColor.withOpacity(0.1),
        prefixIcon: Icon(
          Icons.lock_outline,
          color: _themeColor,
          size: ResponsiveSize.w(24)
        ),
        suffixIcon: TextButton(
          onPressed: _isTimerRunning ? null : _startTimer,
          child: Text(
            _isTimerRunning ? '$_timerSeconds秒' : '获取验证码',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(16),
              color: _isTimerRunning ? Colors.grey : _themeColor,
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
          borderSide: BorderSide(color: _themeColor.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
          borderSide: BorderSide(color: _themeColor.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
          borderSide: BorderSide(color: _themeColor, width: ResponsiveSize.w(2)),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(20),
          vertical: ResponsiveSize.h(16)
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: ResponsiveSize.h(54),
      decoration: BoxDecoration(
        color: _themeColor,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
        boxShadow: [
          BoxShadow(
            color: _themeColor.withOpacity(0.3),
            spreadRadius: ResponsiveSize.w(1),
            blurRadius: ResponsiveSize.w(8),
            offset: Offset(0, ResponsiveSize.h(4)),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _onLoginButtonPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          '登录',
          style: TextStyle(
            fontSize: ResponsiveSize.sp(20),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _startTimer() {
    setState(() {
      _isTimerRunning = true;
      _timerSeconds = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _isTimerRunning = false;
          _timer?.cancel();
        }
      });
    });
  }

  void _onLoginButtonPressed() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const StudentPage()),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}