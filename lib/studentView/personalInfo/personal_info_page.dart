import 'package:flutter/material.dart';
import '../../utils/responsive_size.dart';

class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/personalbg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(  // 使用 Stack 作为主布局
            children: [
              // 返回按钮
              Padding(
                padding: EdgeInsets.all(ResponsiveSize.w(20)),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(
                      'assets/backbutton1.png',
                      width: ResponsiveSize.w(100),
                      height: ResponsiveSize.w(100),
                    ),
                  ),
                ),
              ),
              // 主要内容区域
              Positioned(
                left: ResponsiveSize.px(100),
                top: ResponsiveSize.py(165),
                child: Container(
                  width: ResponsiveSize.w(1166),  // 固定宽度
                  height: ResponsiveSize.h(750),  // 固定高度
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                    border: Border.all(
                      color: const Color(0xFF2E7D32),
                      width: ResponsiveSize.w(2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    // 标题部分
                    Padding(
                      padding: EdgeInsets.only(
                        top: ResponsiveSize.h(30),
                        left: ResponsiveSize.w(40)
                      ),
                      child: Row(
                        children: [
                          Text(
                            '个人信息',
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(32),
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2E7D32),
                            ),
                          ),
                          SizedBox(width: ResponsiveSize.w(15)),
                          Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(24),
                              color: const Color(0xFF2E7D32),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                                        // 内容区域 - 分为左右两栏
                    Expanded(
                      child: Row(
                        children: [
                          // 左侧个人信息
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.all(ResponsiveSize.w(30)),
                              margin: EdgeInsets.all(ResponsiveSize.w(20)),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                                    blurRadius: ResponsiveSize.w(10),
                                    spreadRadius: ResponsiveSize.w(1),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // 头像部分
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: ResponsiveSize.w(140),
                                        height: ResponsiveSize.w(140),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xFF2E7D32).withOpacity(0.1),
                                        ),
                                      ),
                                      Container(
                                        width: ResponsiveSize.w(120),
                                        height: ResponsiveSize.w(120),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0xFF2E7D32),
                                            width: ResponsiveSize.w(3),
                                          ),
                                          image: const DecorationImage(
                                            image: AssetImage('assets/star.png'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: ResponsiveSize.h(20)),
                                  // 个人信息列表
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(ResponsiveSize.w(20)),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF2E7D32).withOpacity(0.05),
                                              borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
                                            ),
                                            child: Column(
                                              children: [
                                                _buildInfoItem('姓名', '陈超'),
                                                _buildDivider(),
                                                _buildInfoItem('年龄', '8岁'),
                                                _buildDivider(),
                                                _buildInfoItem('用户名', 'chenchao123'),
                                                _buildDivider(),
                                                _buildInfoItem('使用期限', '2024.12.31'),
                                                _buildDivider(),
                                                _buildInfoItem('会员积分', '2680'),
                                                _buildDivider(),
                                                _buildInfoItem('当前阶段', 'Level 2'),
                                              ],
                                            ),
                                          ),
                                                                                    SizedBox(height: ResponsiveSize.h(20)),
                                          // 荣誉墙
                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(ResponsiveSize.w(15)),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  const Color(0xFF2E7D32).withOpacity(0.1),
                                                  const Color(0xFF2E7D32).withOpacity(0.05),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.emoji_events,
                                                      color: const Color(0xFF2E7D32),
                                                      size: ResponsiveSize.w(24),
                                                    ),
                                                    SizedBox(width: ResponsiveSize.w(10)),
                                                    Text(
                                                      '荣誉墙',
                                                      style: TextStyle(
                                                        fontSize: ResponsiveSize.sp(20),
                                                        fontWeight: FontWeight.bold,
                                                        color: const Color(0xFF2E7D32),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: ResponsiveSize.h(15)),
                                                Text(
                                                  '暂无荣誉',
                                                  style: TextStyle(
                                                    color: const Color(0xFF2E7D32),
                                                    fontSize: ResponsiveSize.sp(16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // 右侧功能按钮
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveSize.w(30),
                                vertical: ResponsiveSize.h(20)
                              ),
                              margin: EdgeInsets.all(ResponsiveSize.w(20)),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                                    blurRadius: ResponsiveSize.w(10),
                                    spreadRadius: ResponsiveSize.w(1),
                                  ),
                                ],
                              ),
                                                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildFeatureButton('我的收藏', Icons.favorite_border),
                                  _buildFeatureButton('我的阶段', Icons.timeline),
                                  _buildFeatureButton('我的作品', Icons.palette),
                                  _buildFeatureButton('老师点评', Icons.rate_review),
                                  _buildFeatureButton('修改密码', Icons.lock_outline),
                                  _buildFeatureButton('分享APP', Icons.share),
                                ],
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(8)),
      child: Container(
        height: ResponsiveSize.h(1),
        color: const Color(0xFF2E7D32).withOpacity(0.1),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label：',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(16),
              color: const Color(0xFF2E7D32).withOpacity(0.8),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveSize.sp(16),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButton(String title, IconData icon) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: ResponsiveSize.h(8)),
      child: ElevatedButton(
        onPressed: () {
          // 处理按钮点击事件
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF2E7D32),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.w(25),
            vertical: ResponsiveSize.h(20)
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
            side: BorderSide(
              color: const Color(0xFF2E7D32).withOpacity(0.3),
              width: ResponsiveSize.w(1),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: ResponsiveSize.w(22)),
                SizedBox(width: ResponsiveSize.w(12)),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, size: ResponsiveSize.w(16)),
          ],
        ),
      ),
    );
  }
}