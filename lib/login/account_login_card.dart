import 'package:flutter/material.dart';
import '../studentView/student_page.dart';
import '../../../utils/responsive_size.dart';

class AccountLoginCard extends StatefulWidget {
  const AccountLoginCard({super.key});

  @override
  State<AccountLoginCard> createState() => _AccountLoginCardState();
}

class _AccountLoginCardState extends State<AccountLoginCard> {
  final TextEditingController _usernameController = TextEditingController(text: 'admin');
  final TextEditingController _passwordController = TextEditingController(text: '1234');
  final Color _themeColor = const Color(0xFFF6BA66);
  bool _rememberPassword = false;
  bool _autoLogin = false;
  bool _obscureText = true;

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
          _buildUsernameField(),
          SizedBox(height: ResponsiveSize.h(12)),
          _buildPasswordField(),
          SizedBox(height: ResponsiveSize.h(8)),
          _buildCheckboxRow(),
          SizedBox(height: ResponsiveSize.h(12)),
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

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      style: TextStyle(fontSize: ResponsiveSize.sp(18)),
      decoration: InputDecoration(
        hintText: '请输入用户名',
        hintStyle: TextStyle(
          color: Colors.grey.shade600,
          fontSize: ResponsiveSize.sp(18),
        ),
        filled: true,
        fillColor: _themeColor.withOpacity(0.1),
        prefixIcon: Icon(
          Icons.person_outline, 
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

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscureText,
      style: TextStyle(fontSize: ResponsiveSize.sp(18)),
      decoration: InputDecoration(
        hintText: '请输入密码',
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
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: _themeColor,
            size: ResponsiveSize.w(24),
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(20),
          vertical: ResponsiveSize.h(16)
        ),
      ),
    );
  }

  Widget _buildCheckboxRow() {
    return Row(
      children: [
        _buildCustomCheckbox('记住密码', _rememberPassword, (value) {
          setState(() {
            _rememberPassword = value!;
          });
        }),
        const Spacer(),
        _buildCustomCheckbox('自动登录', _autoLogin, (value) {
          setState(() {
            _autoLogin = value!;
          });
        }),
      ],
    );
  }

  Widget _buildCustomCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Transform.scale(
          scale: 1.2,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: _themeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveSize.w(4)),
            ),
          ),
        ),
        SizedBox(width: ResponsiveSize.w(4)),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(16),
            color: Colors.grey.shade700,
          ),
        ),
      ],
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

  void _onLoginButtonPressed() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const StudentPage()),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}