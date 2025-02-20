import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';

class ExchangeRecordPage extends StatelessWidget {
  const ExchangeRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 顶部标题
        Padding(
          padding: EdgeInsets.only(
            left: ResponsiveSize.w(40),
            right: ResponsiveSize.w(40),
            top: ResponsiveSize.h(30)
          ),
          child: Text(
            '兑奖记录',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(30),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),

        // 表格标题
        Container(
          margin: EdgeInsets.all(ResponsiveSize.w(20)),
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveSize.h(15),
            horizontal: ResponsiveSize.w(20)
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE4B5),
            borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    '兑奖人',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(20),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5C3D2E),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    '奖品',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(20),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5C3D2E),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    '申请时间',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(20),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5C3D2E),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '状态',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(20),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5C3D2E),
                        ),
                      ),
                      SizedBox(width: ResponsiveSize.w(4)),
                      Icon(
                        Icons.arrow_drop_down,
                        color: const Color(0xFF5C3D2E),
                        size: ResponsiveSize.w(24),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    '操作',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(20),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5C3D2E),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 空状态提示
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/no_rewards.png',
                  width: ResponsiveSize.w(100),
                  height: ResponsiveSize.h(100),
                ),
                SizedBox(height: ResponsiveSize.h(20)),
                Text(
                  '还没有学员申请兑奖',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(24),
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(10)),
                Text(
                  '这里会显示学员的兑奖申请，你也可以直接创建兑奖记录',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}