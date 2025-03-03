import 'package:flutter/material.dart';
import 'dart:math';
import '../../../utils/responsive_size.dart';

class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key});

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  String? selectedLevel;
  String? selectedWeek;
  int levelCount = 4;
  int weekCount = 8;
  final int contentCount = 20;
  List<bool> completedTasks = List.generate(20, (index) => false);
  int lastUnlockedTask = 0;

  final List<Color> levelColors = [
    const Color.fromARGB(255, 230, 136, 136),
    const Color.fromARGB(255, 251, 202, 110),
    const Color.fromARGB(255, 156, 194, 62),
    const Color.fromARGB(255, 45, 178, 176),
  ];
  // 处理任务完成
  void handleTaskCompletion(int index) {
    if (index <= lastUnlockedTask) {
      setState(() {
        completedTasks[index] = true;
        if (index == lastUnlockedTask) {
          lastUnlockedTask = index + 1;

          // 检查是否完成了所有任务（最后一个任务）
          if (index == contentCount - 1) {
            _showCongratulationsDialog();
          }
        }
      });
    }
  }

  // 检查任务是否被锁定
  bool isTaskLocked(int index) {
    return index > lastUnlockedTask;
  }

  void handleLevelSelection(int levelIndex) {
    setState(() {
      selectedLevel = 'Level ${levelIndex + 1}';
      selectedWeek = 'Week 1';
      completedTasks = List.generate(20, (index) => false);
      lastUnlockedTask = 0;
    });
  }

  // 获取当前选中Level的颜色
  Color getCurrentLevelColor() {
    if (selectedLevel == null) return levelColors[0];
    int levelIndex = int.parse(selectedLevel!.split(' ')[1]) - 1;
    return levelColors[levelIndex];
  }

  // 获取当前选中的内容标题
  String getCurrentContent() {
    if (selectedLevel == null || selectedWeek == null) {
      return '请选择级别和周数';
    }
    int levelNum = int.parse(selectedLevel!.split(' ')[1]);
    int weekNum = int.parse(selectedWeek!.split(' ')[1]);
    return 'Level $levelNum 的第$weekNum周内容';
  }

  // 生成明亮的随机颜色
  Color generateBrightColor() {
    Random random = Random();
    int r = random.nextInt(156) + 100;
    int g = random.nextInt(156) + 100;
    int b = random.nextInt(156) + 100;

    int maxComponent = max(r, max(g, b));
    if (maxComponent < 200) {
      double scale = 200.0 / maxComponent;
      r = min(255, (r * scale).round());
      g = min(255, (g * scale).round());
      b = min(255, (b * scale).round());
    }

    return Color.fromARGB(255, r, g, b);
  }

  // 构建内容网格
  Widget buildContentGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(ResponsiveSize.w(15)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
        crossAxisSpacing: ResponsiveSize.w(15),
        mainAxisSpacing: ResponsiveSize.h(15),
      ),
      itemCount: contentCount,
      itemBuilder: (context, index) {
        bool isLocked = isTaskLocked(index);
        return Stack(
          children: [
            GestureDetector(
              onTap: isLocked ? null : () => handleTaskCompletion(index),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
                  border: Border.all(
                    color: const Color.fromARGB(255, 255, 214, 126),
                    width: ResponsiveSize.w(2),
                  ),
                  color: isLocked ? Colors.grey[300] : Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(13)),
                  child: Stack(
                    children: [
                      Image.asset('assets/sunset.png', fit: BoxFit.cover),
                      if (isLocked)
                        Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Center(
                            child: Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: ResponsiveSize.w(40),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (completedTasks[index])
              Positioned(
                top: ResponsiveSize.h(5),
                right: ResponsiveSize.w(5),
                child: Image.asset(
                  'assets/passmedal.png',
                  width: ResponsiveSize.w(30),
                  height: ResponsiveSize.h(30),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/rhythmbg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // 黄色容器放在最底层
              Positioned(
                left: ResponsiveSize.px(20),
                right: ResponsiveSize.px(20),
                top: ResponsiveSize.py(250),
                bottom: ResponsiveSize.py(100),
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    heightFactor: 0.87,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 214, 126),
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.w(30),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: ResponsiveSize.w(10),
                                offset: Offset(0, ResponsiveSize.h(5)),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // 第一个白色方框（带滚动的级别列表）
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: double.infinity,
                                  margin: EdgeInsets.only(
                                    left: 0,
                                    right: ResponsiveSize.w(15),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                        ResponsiveSize.w(30),
                                      ),
                                      bottomLeft: Radius.circular(
                                        ResponsiveSize.w(30),
                                      ),
                                      topRight: Radius.circular(
                                        ResponsiveSize.w(20),
                                      ),
                                      bottomRight: Radius.circular(
                                        ResponsiveSize.w(20),
                                      ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: ResponsiveSize.w(5),
                                        offset: Offset(0, ResponsiveSize.h(3)),
                                      ),
                                    ],
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      final availableHeight =
                                          constraints.maxHeight -
                                          ResponsiveSize.h(15);
                                      final itemHeight = availableHeight / 4;

                                      return SingleChildScrollView(
                                        padding: EdgeInsets.only(
                                          left: ResponsiveSize.w(15),
                                          right: ResponsiveSize.w(15),
                                          top: ResponsiveSize.h(15),
                                        ),
                                        child: Column(
                                          children: List.generate(levelCount, (
                                            index,
                                          ) {
                                            if (index >= levelColors.length) {
                                              levelColors.add(
                                                generateBrightColor(),
                                              );
                                            }

                                            return Container(
                                              width: double.infinity,
                                              height:
                                                  itemHeight -
                                                  ResponsiveSize.h(10),
                                              margin: EdgeInsets.only(
                                                bottom: ResponsiveSize.h(10),
                                              ),
                                              decoration: BoxDecoration(
                                                color: levelColors[index],
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      ResponsiveSize.w(15),
                                                    ),
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        ResponsiveSize.w(15),
                                                      ),
                                                  onTap: () {
                                                    handleLevelSelection(index);
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      selectedLevel ==
                                                              'Level ${index + 1}'
                                                          ? '当前级别: Level ${index + 1}'
                                                          : 'Level ${index + 1}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            ResponsiveSize.sp(
                                                              28,
                                                            ),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              // 第二个白色方框（周数列表）
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: double.infinity,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: ResponsiveSize.w(15),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveSize.w(20),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: ResponsiveSize.w(5),
                                        offset: Offset(0, ResponsiveSize.h(3)),
                                      ),
                                    ],
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      final availableHeight =
                                          constraints.maxHeight -
                                          ResponsiveSize.h(15);
                                      final itemHeight = availableHeight / 4;

                                      return SingleChildScrollView(
                                        padding: EdgeInsets.only(
                                          left: ResponsiveSize.w(15),
                                          right: ResponsiveSize.w(15),
                                          top: ResponsiveSize.h(15),
                                        ),
                                        child: Column(
                                          children: List.generate(weekCount, (
                                            index,
                                          ) {
                                            return Container(
                                              width: double.infinity,
                                              height:
                                                  itemHeight -
                                                  ResponsiveSize.h(10),
                                              margin: EdgeInsets.only(
                                                bottom: ResponsiveSize.h(10),
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    selectedLevel == null
                                                        ? Colors.grey[300]
                                                        : getCurrentLevelColor(),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      ResponsiveSize.w(15),
                                                    ),
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        ResponsiveSize.w(15),
                                                      ),
                                                  onTap:
                                                      selectedLevel == null
                                                          ? null
                                                          : () {
                                                            setState(() {
                                                              selectedWeek =
                                                                  'Week ${index + 1}';
                                                            });
                                                          },
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          selectedWeek ==
                                                                  'Week ${index + 1}'
                                                              ? '当前内容: 第${index + 1}周'
                                                              : 'Week ${index + 1}',
                                                          style: TextStyle(
                                                            color:
                                                                selectedLevel ==
                                                                        null
                                                                    ? Colors
                                                                        .grey[600]
                                                                    : Colors
                                                                        .white,
                                                            fontSize:
                                                                ResponsiveSize.sp(
                                                                  24,
                                                                ),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        if (selectedWeek !=
                                                            'Week ${index + 1}')
                                                          Text(
                                                            '第${index + 1}周',
                                                            style: TextStyle(
                                                              color:
                                                                  selectedLevel ==
                                                                          null
                                                                      ? Colors
                                                                          .grey[600]
                                                                      : Colors
                                                                          .white,
                                                              fontSize:
                                                                  ResponsiveSize.sp(
                                                                    20,
                                                                  ),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              // 第三个白色方框（较宽）
                              Expanded(
                                flex: 4,
                                child: Container(
                                  height: double.infinity,
                                  margin: EdgeInsets.only(
                                    left: ResponsiveSize.w(15),
                                    right: 0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                        ResponsiveSize.w(20),
                                      ),
                                      bottomLeft: Radius.circular(
                                        ResponsiveSize.w(20),
                                      ),
                                      topRight: Radius.circular(
                                        ResponsiveSize.w(30),
                                      ),
                                      bottomRight: Radius.circular(
                                        ResponsiveSize.w(30),
                                      ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: ResponsiveSize.w(5),
                                        offset: Offset(0, ResponsiveSize.h(3)),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(
                                          ResponsiveSize.w(15),
                                        ),
                                        child: Text(
                                          getCurrentContent(),
                                          style: TextStyle(
                                            fontSize: ResponsiveSize.sp(24),
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF5C3D2E),
                                          ),
                                        ),
                                      ),
                                      const Divider(height: 1),
                                      Expanded(
                                        child:
                                            selectedLevel == null ||
                                                    selectedWeek == null
                                                ? Center(
                                                  child: Text(
                                                    '请先选择级别和周数',
                                                    style: TextStyle(
                                                      fontSize:
                                                          ResponsiveSize.sp(20),
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                )
                                                : buildContentGrid(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // 级别规则按钮
              Positioned(
                left: ResponsiveSize.px(90),
                top: ResponsiveSize.py(230),
                child: Container(
                  height: ResponsiveSize.h(60),
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.w(20),
                    vertical: ResponsiveSize.h(10),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: ResponsiveSize.w(5),
                        offset: Offset(0, ResponsiveSize.h(3)),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
                      onTap: () {
                        // 处理级别规则按钮点击事件
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/levelcheck.png',
                            width: ResponsiveSize.w(40),
                            height: ResponsiveSize.h(40),
                          ),
                          SizedBox(width: ResponsiveSize.w(15)),
                          Text(
                            '级别规则',
                            style: TextStyle(
                              color: const Color(0xFF5C3D2E),
                              fontSize: ResponsiveSize.sp(24),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 返回按钮
              Positioned(
                left: ResponsiveSize.w(50),
                top: ResponsiveSize.h(20),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    'assets/backbutton1.png',
                    width: ResponsiveSize.w(100),
                    height: ResponsiveSize.h(100),
                  ),
                ),
              ),

              // 小孩图片放在最上层
              Positioned(
                right: ResponsiveSize.px(170),
                top: ResponsiveSize.py(160),
                child: Image.asset(
                  'assets/childmusic.png',
                  width: ResponsiveSize.w(200),
                  height: ResponsiveSize.h(200),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCongratulationsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            constraints: BoxConstraints(
              maxWidth: ResponsiveSize.w(500),
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            padding: EdgeInsets.all(ResponsiveSize.w(30)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ResponsiveSize.w(40)),
              border: Border.all(
                color: const Color(0xFFFFD700),
                width: ResponsiveSize.w(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow.withOpacity(0.3),
                  blurRadius: ResponsiveSize.w(25),
                  spreadRadius: ResponsiveSize.w(8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.emoji_events,
                      size: ResponsiveSize.w(150),
                      color: const Color(0xFFFFD700),
                    ),
                    Positioned(
                      top: ResponsiveSize.h(15),
                      left: ResponsiveSize.w(50),
                      child: Icon(
                        Icons.star,
                        size: ResponsiveSize.w(50),
                        color: const Color(0xFFFFA000),
                      ),
                    ),
                    Positioned(
                      top: ResponsiveSize.h(35),
                      right: ResponsiveSize.w(50),
                      child: Icon(
                        Icons.star,
                        size: ResponsiveSize.w(50),
                        color: const Color(0xFFFFA000),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveSize.h(25)),
                Text(
                  '太棒了！',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(40),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF5C3D2E),
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(15)),
                Text(
                  '你完成了 $selectedLevel 的第${selectedWeek?.split(' ')[1]}周内容',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(28),
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: ResponsiveSize.w(30),
                    ),
                    SizedBox(width: ResponsiveSize.w(10)),
                    Text(
                      '继续保持，你是最棒的！',
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(24),
                        color: const Color(0xFFF5A623),
                      ),
                    ),
                    SizedBox(width: ResponsiveSize.w(10)),
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: ResponsiveSize.w(30),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveSize.h(40)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // TODO: 实现分享功能
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2BAE85),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(25),
                          vertical: ResponsiveSize.h(15),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(25),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.share),
                          SizedBox(width: ResponsiveSize.w(8)),
                          Text(
                            '分享成就',
                            style: TextStyle(fontSize: ResponsiveSize.sp(20)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: ResponsiveSize.w(20)),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5A623),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(35),
                          vertical: ResponsiveSize.h(15),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(25),
                          ),
                        ),
                      ),
                      child: Text(
                        '继续学习',
                        style: TextStyle(fontSize: ResponsiveSize.sp(20)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
