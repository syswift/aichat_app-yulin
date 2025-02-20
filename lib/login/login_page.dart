import 'package:flutter/material.dart';
import 'sms_login_card.dart';
import 'account_login_card.dart';
import 'qr_login_card.dart';
import '../../../utils/responsive_size.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 1;
  final Color _themeColor = const Color(0xFFF6BA66);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: _currentIndex
    );
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

// 在 LoginPage 中
@override
Widget build(BuildContext context) {
  ResponsiveSize.init(context);
  return Scaffold(
    resizeToAvoidBottomInset: false, // 添加这一行
    body: _buildBackground(
      child: SafeArea(
        child: _buildLoginContainer(),
      ),
    ),
  );
}
  Widget _buildBackground({required Widget child}) {
  return Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/loginbg.png'),
        fit: BoxFit.cover,
      ),
    ),
    child: child,
  );
}

Widget _buildLoginContainer() {
  // 保持原始的 Alignment 值，因为它本身就是相对位置
  return Align(
    alignment: const Alignment(0.05, -0.38), // 这个是相对于整个屏幕的位置比例，不需要自适应
    child: Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width > ResponsiveSize.w(590)
            ? ResponsiveSize.w(590)
            : MediaQuery.of(context).size.width * 0.92,
      ),
      margin: EdgeInsets.only(right: ResponsiveSize.w(40)),
      child: _buildLoginCard(),
    ),
  );
}

Widget _buildLoginCard() {
  return Card(
    color: Colors.white.withOpacity(0.95),
    elevation: 8,
    shadowColor: _themeColor.withOpacity(0.3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(ResponsiveSize.w(30)),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLogoHeader(),
          SizedBox(height: ResponsiveSize.h(25)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(32)),
            child: _buildLoginTabs(),
          ),
          SizedBox(height: ResponsiveSize.h(10)),
          Padding(
            padding: EdgeInsets.fromLTRB(
              ResponsiveSize.w(32),
              0,
              ResponsiveSize.w(32),
              ResponsiveSize.h(32)
            ),
            child: _buildLoginContent(),
          ),
        ],
      ),
    ),
  );
}
Widget _buildLogoHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircleAvatar(
        radius: ResponsiveSize.w(25),
        backgroundImage: const AssetImage('assets/logo.png'),
      ),
      SizedBox(width: ResponsiveSize.w(12)),
      Text(
        '鹅爸爸',
        style: TextStyle(
          fontSize: ResponsiveSize.sp(26),
          fontWeight: FontWeight.bold,
          color: const Color(0xFF5C3D2E),
          shadows: [
            Shadow(
              color: Colors.white.withOpacity(0.8),
              offset: Offset(0, ResponsiveSize.h(1)),
              blurRadius: ResponsiveSize.w(2),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildLoginTabs() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _buildTabButton('短信登录', 0),
      _buildTabButton('账号登录', 1),
      _buildTabButton('扫码登录', 2),
    ],
  );
}

Widget _buildTabButton(String text, int index) {
  final isSelected = _currentIndex == index;
  
  return GestureDetector(
    onTap: () => _handleTabButtonTap(index),
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(24),
        vertical: ResponsiveSize.h(14),
      ),
      decoration: isSelected ? _selectedTabDecoration() : null,
      child: Text(
        text,
        style: _getTabTextStyle(isSelected),
      ),
    ),
  );
}

void _handleTabButtonTap(int index) {
  setState(() {
    _currentIndex = index;
    _tabController.animateTo(index);
  });
}

BoxDecoration _selectedTabDecoration() {
  return BoxDecoration(
    color: Colors.white.withOpacity(0.5),
    borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
    boxShadow: [
      BoxShadow(
        color: _themeColor.withOpacity(0.2),
        blurRadius: ResponsiveSize.w(8),
        spreadRadius: ResponsiveSize.w(1),
      ),
    ],
  );
}

TextStyle _getTabTextStyle(bool isSelected) {
  return TextStyle(
    color: isSelected ? const Color(0xFF5C3D2E) : Colors.grey.shade600,
    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
    fontSize: ResponsiveSize.sp(18),
  );
}
Widget _buildLoginContent() {
  return SizedBox(
    height: ResponsiveSize.h(350),
    width: double.infinity,
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: _buildLoginStack(),
    ),
  );
}

Widget _buildLoginStack() {
  return IndexedStack(
    key: ValueKey<int>(_currentIndex),
    index: _currentIndex,
    sizing: StackFit.expand,
    children: const [
      SmsLoginCard(key: ValueKey('sms')),
      AccountLoginCard(key: ValueKey('account')),
      QrLoginCard(key: ValueKey('qr')),
    ],
  );
}
}