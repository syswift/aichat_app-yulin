import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';

class FeatureSettingsPage extends StatefulWidget {
  const FeatureSettingsPage({super.key});

  @override
  State<FeatureSettingsPage> createState() => _FeatureSettingsPageState();
}

class _FeatureSettingsPageState extends State<FeatureSettingsPage> {
  final Map<String, bool> _accessControl = {
    // 晚间音频模式
    '晚间音频模式': false,
    
    // 自由学内容访问权限
    '动画视频访问': true,
    '分级阅读访问': true,
    '快乐听访问': true,
    
    // 固定学内容访问权限
    '韵律启蒙访问': true,
    '听力理解访问': true,
    '口语表达访问': true,
    '自读闯关访问': true,
    '书写听写访问': true,
    
    // 特殊功能访问权限
    'AI对练功能': true,
    '积分兑换功能': true,
    '作品秀场功能': true,
  };

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/parentbg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.w(40),
                    vertical: ResponsiveSize.h(20),
                  ),
                  child: Column(
                    children: [
                      _buildAccessSection(
                        '晚间模式',
                        ['晚间音频模式'],
                        Icons.nightlight_outlined,
                        const Color(0xFF9575CD),
                        '控制夜间使用时的音频模式',
                      ),
                      SizedBox(height: ResponsiveSize.h(30)),
                      _buildAccessSection(
                        '自由学内容',
                        ['动画视频访问', '分级阅读访问', '快乐听访问'],
                        Icons.auto_stories,
                        const Color(0xFF88c5fd),
                        '控制孩子对自由学习内容的访问权限',
                      ),
                      SizedBox(height: ResponsiveSize.h(30)),
                      _buildAccessSection(
                        '固定学内容',
                        ['韵律启蒙访问', '听力理解访问', '口语表达访问', '自读闯关访问', '书写听写访问'],
                        Icons.school_outlined,
                        const Color(0xFF81C784),
                        '控制孩子对固定学习内容的访问权限',
                      ),
                      SizedBox(height: ResponsiveSize.h(30)),
                      _buildAccessSection(
                        'AI对练',
                        ['AI对练功能'],
                        Icons.smart_toy_outlined,
                        const Color(0xFFFF9E9E),
                        '控制AI辅助学习功能的使用权限',
                      ),
                      SizedBox(height: ResponsiveSize.h(30)),
                      _buildAccessSection(
                        '积分兑换',
                        ['积分兑换功能'],
                        Icons.card_giftcard_outlined,
                        const Color(0xFFBA68C8),
                        '控制积分兑换功能的使用权限',
                      ),
                      SizedBox(height: ResponsiveSize.h(30)),
                      _buildAccessSection(
                        '作品秀场',
                        ['作品秀场功能'],
                        Icons.stars_outlined,
                        const Color(0xFFFFB74D),
                        '控制作品秀场功能的访问权限',
                      ),
                    ],
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

  Widget _buildAccessSection(
    String title,
    List<String> features,
    IconData icon,
    Color color,
    String description,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveSize.w(30)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: ResponsiveSize.w(15),
            spreadRadius: ResponsiveSize.w(5),
            offset: Offset(0, ResponsiveSize.h(5)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveSize.w(12)),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(14)),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: ResponsiveSize.w(28),
                ),
              ),
              SizedBox(width: ResponsiveSize.w(15)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(24),
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(4)),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(13),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.h(25)),
          ...features.map((feature) => _buildAccessItem(feature, color)),
        ],
      ),
    );
  }

  Widget _buildAccessItem(String feature, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(15)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: ResponsiveSize.w(1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getFeatureDisplayName(feature),
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(4)),
                Text(
                  _getFeatureDescription(feature),
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(13),
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _accessControl[feature] ?? false,
            onChanged: (value) {
              setState(() {
                _accessControl[feature] = value;
              });
            },
            activeColor: color,
          ),
        ],
      ),
    );
  }

  String _getFeatureDisplayName(String feature) {
    final Map<String, String> displayNames = {
      '晚间音频模式': '晚间音频模式',
      '动画视频访问': '动画视频',
      '分级阅读访问': '分级阅读',
      '快乐听访问': '快乐听',
      '韵律启蒙访问': '韵律启蒙',
      '听力理解访问': '听力理解',
      '口语表达访问': '口语表达',
      '自读闯关访问': '自读闯关',
      '书写听写访问': '书写听写',
      'AI对练功能': 'AI对练',
      '积分兑换功能': '积分兑换',
      '作品秀场功能': '作品秀场',
    };
    return displayNames[feature] ?? feature;
  }

  String _getFeatureDescription(String feature) {
    final Map<String, String> descriptions = {
      '晚间音频模式': '开启后，夜间只能听音频，无法观看视频画面（仅限固定学的动画视频）',
      '动画视频访问': '控制是否可以观看动画视频内容',
      '分级阅读访问': '控制是否可以访问分级阅读材料',
      '快乐听访问': '控制是否可以使用快乐听功能',
      '韵律启蒙访问': '控制是否可以学习韵律启蒙课程',
      '听力理解访问': '控制是否可以进行听力练习',
      '口语表达访问': '控制是否可以进行口语练习',
      '自读闯关访问': '控制是否可以参与自读闯关',
      '书写听写访问': '控制是否可以进行书写听写练习',
      'AI对练功能': '控制是否可以使用AI辅助学习功能',
      '积分兑换功能': '控制是否可以进行积分兑换',
      '作品秀场功能': '控制是否可以访问作品秀场',
    };
    return descriptions[feature] ?? '';
  }
}