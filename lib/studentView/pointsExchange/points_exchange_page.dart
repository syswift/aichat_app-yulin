import 'package:flutter/material.dart';
import './student_points_page.dart';
import './exchange_record_page.dart';
import '../../../utils/responsive_size.dart';

class PointsExchangePage extends StatefulWidget {
  const PointsExchangePage({super.key});

  @override
  State<PointsExchangePage> createState() => _PointsExchangePageState();
}

class _PointsExchangePageState extends State<PointsExchangePage> {
  String _selectedButton = '已上架奖品';
  Map<String, int> prizeStock = {
    '测试奖品1': 50,
    '测试奖品2': 30,
  };

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/rewardbg1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 返回按钮
              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveSize.w(20),
                  top: ResponsiveSize.h(10)
                ),
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
              ),
              
              // 主要内容区域
              Container(
                height: MediaQuery.of(context).size.height * 0.65,
                margin: EdgeInsets.fromLTRB(
                  ResponsiveSize.w(40),
                  ResponsiveSize.h(20),
                  ResponsiveSize.w(40),
                  ResponsiveSize.h(40)
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(30)),
                  border: Border.all(
                    color: const Color(0xFFFFE4B5),
                    width: ResponsiveSize.w(3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFE4B5).withOpacity(0.1),
                      blurRadius: ResponsiveSize.w(10),
                      spreadRadius: ResponsiveSize.w(5),
                    ),
                  ],
                ),
                                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(27)),
                  child: Column(
                    children: [
                      // 上部分：标题选项区
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              color: const Color(0xFFFFE4B5),
                              width: ResponsiveSize.w(2),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            _buildTabButton('已上架奖品', 'assets/rewardedprize.png'),
                            _buildTabButton('学员积分', 'assets/studentpointslogo.png'),
                            _buildTabButton('兑奖记录', 'assets/recordedgift.png'),
                          ].map((widget) => Expanded(child: widget)).toList(),
                        ),
                      ),
                      
                      // 下部分：内容展示区
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: _buildContent(),
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

  Widget _buildTabButton(String text, String iconPath) {
    bool isSelected = _selectedButton == text;
    
    return Material(
      color: isSelected ? const Color(0xFFFFE4B5) : Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedButton = text;
          });
        },
        child: Container(
          height: ResponsiveSize.h(100),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconPath,
                width: ResponsiveSize.w(35),
                height: ResponsiveSize.h(35),
              ),
              SizedBox(height: ResponsiveSize.h(12)),
              Text(
                text,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(22),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: const Color(0xFF5C3D2E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedButton) {
      case '已上架奖品':
        return _buildPrizesContent();
      case '学员积分':
        return const StudentPointsPage();
      case '兑奖记录':
        return const ExchangeRecordPage();
      default:
        return const SizedBox.shrink();
    }
  }
    Widget _buildPrizesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            ResponsiveSize.w(24),
            ResponsiveSize.h(20),
            ResponsiveSize.w(24),
            ResponsiveSize.h(16)
          ),
          child: Text(
            '可兑换奖品',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(24),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5C3D2E),
            ),
          ),
        ),
        Expanded(
          child: GridView.count(
            padding: EdgeInsets.fromLTRB(
              ResponsiveSize.w(35),
              0,
              ResponsiveSize.w(35),
              ResponsiveSize.h(35)
            ),
            crossAxisCount: 4,
            mainAxisSpacing: ResponsiveSize.h(30),
            crossAxisSpacing: ResponsiveSize.w(30),
            childAspectRatio: ResponsiveSize.w(0.7),
            children: [
              _buildPrizeCard(
                image: 'assets/prize1.png',
                name: '测试奖品1',
                points: 100,
                stock: prizeStock['测试奖品1'] ?? 0,
              ),
              _buildPrizeCard(
                image: 'assets/prize2.png',
                name: '测试奖品2',
                points: 200,
                stock: prizeStock['测试奖品2'] ?? 0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrizeCard({
    required String image,
    required String name,
    required int points,
    required int stock,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
        border: Border.all(
          color: const Color(0xFFFFE4B5),
          width: ResponsiveSize.w(2),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFE4B5).withOpacity(0.1),
            blurRadius: ResponsiveSize.w(8),
            spreadRadius: ResponsiveSize.w(2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(ResponsiveSize.w(13))
              ),
              child: Image.asset(
                image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(ResponsiveSize.w(12)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(20),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5C3D2E),
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/star.png',
                        width: ResponsiveSize.w(24),
                        height: ResponsiveSize.h(24),
                      ),
                      SizedBox(width: ResponsiveSize.w(8)),
                      Text(
                        '$points',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(19),
                          color: const Color(0xFF5C3D2E),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '库存: $stock',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(17),
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                                    SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: stock > 0 ? () => _showExchangeDialog(name, points, stock) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFE4B5),
                        padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(12)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                        ),
                      ),
                      child: Text(
                        stock > 0 ? '立即兑换' : '已售罄',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(18),
                          color: const Color(0xFF5C3D2E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showExchangeDialog(String prizeName, int points, int stock) async {
    int exchangeCount = 1;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
              ),
              title: Text(
                '确认兑换',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(24),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5C3D2E),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '奖品：$prizeName',
                    style: TextStyle(fontSize: ResponsiveSize.sp(18)),
                  ),
                  SizedBox(height: ResponsiveSize.h(10)),
                  Text(
                    '所需积分：${points * exchangeCount}',
                    style: TextStyle(fontSize: ResponsiveSize.sp(18)),
                  ),
                  SizedBox(height: ResponsiveSize.h(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: exchangeCount > 1
                            ? () => setState(() => exchangeCount--)
                            : null,
                        icon: Icon(
                          Icons.remove_circle_outline,
                          size: ResponsiveSize.w(24),
                        ),
                        color: const Color(0xFF5C3D2E),
                      ),
                      SizedBox(width: ResponsiveSize.w(20)),
                      Text(
                        '$exchangeCount',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: ResponsiveSize.w(20)),
                      IconButton(
                        onPressed: exchangeCount < stock
                            ? () => setState(() => exchangeCount++)
                            : null,
                        icon: Icon(
                          Icons.add_circle_outline,
                          size: ResponsiveSize.w(24),
                        ),
                        color: const Color(0xFF5C3D2E),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    '取消',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(18),
                      color: Colors.grey,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      prizeStock[prizeName] = stock - exchangeCount;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('成功兑换 $exchangeCount 个 $prizeName'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: Text(
                    '确认兑换',
                    style: TextStyle(
                      fontSize: ResponsiveSize.sp(18),
                      color: const Color(0xFF5C3D2E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}