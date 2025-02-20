import 'package:flutter/material.dart';
import 'task_calendar_page.dart';
import '../../../utils/responsive_size.dart';
import 'writing_homework_page.dart';
import 'listening_homework_page.dart';
import 'speaking_homework_page.dart';
import 'reading_homework_page.dart';
class TodayHomeworkPage extends StatefulWidget {
  const TodayHomeworkPage({super.key});

  @override
  State<TodayHomeworkPage> createState() => _TodayHomeworkPageState();
}

class _TodayHomeworkPageState extends State<TodayHomeworkPage> {
  String currentStatus = '全部';
  String currentType = '全部';
  final List<String> statusList = ['全部', '未完成', '有点评', '已完成'];
  final List<Map<String, dynamic>> homeworkTypes = [
    {'name': '全部', 'icon': Icons.all_inclusive},
    {'name': '听力理解', 'icon': Icons.headphones},
    {'name': '口语表达', 'icon': Icons.mic},
    {'name': '自读闯关', 'icon': Icons.menu_book},
    {'name': '书写听写', 'icon': Icons.edit},
  ];

  // 示例作业数据
 // 在 homeworkList 中添加 content 字段
final List<Map<String, dynamic>> homeworkList = [
  {
    'title': 'Unit 1 - Animals',
    'type': '听力理解',
    'status': '未完成',
    'cover': 'assets/cartoon.png',
    'publishDate': '2024-03-15',
    'dueDate': '2024-11-28',
    'content': '请听录音，回答以下问题：\n1. What animals are mentioned in the recording?\n2. What do they eat?',
  },
  {
    'title': 'Unit 2 - Daily Life',
    'type': '口语表达',
    'status': '有点评',
    'cover': 'assets/cartoon.png',
    'publishDate': '2024-03-16',
    'dueDate': '2024-11-29',
    'content': '请录制一段口语，描述你的日常生活：\n1. 描述你的早晨routine\n2. 描述你最喜欢的课程',
  },
  {
    'title': 'Unit 3 - Stories',
    'type': '自读闯关',
    'status': '已完成',
    'cover': 'assets/cartoon.png',
    'publishDate': '2024-03-14',
    'dueDate': '2024-11-30',
    'content': '请朗读以下段落：\nOnce upon a time, there was a little girl who loved to read books...',
  },
  // 保持原有的书写听写作业不变
  {
    'title': 'Unit 4 - Writing Practice',
    'type': '书写听写',
    'status': '未完成',
    'cover': 'assets/cartoon.png',
    'publishDate': '2024-03-17',
    'dueDate': '2024-11-30',
    'content': '请完成以下单词的书写练习：\n1. beautiful\n2. wonderful\n3. happiness\n4. sunshine\n5. rainbow',
  },
];

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fsbg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveSize.w(10),
                  right: ResponsiveSize.w(8),
                  top: ResponsiveSize.h(20),
                  bottom: ResponsiveSize.h(20),
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
                    const Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PopupMenuButton<String>(
                          offset: Offset(0, ResponsiveSize.h(15)),
                          position: PopupMenuPosition.under,
                          constraints: BoxConstraints(
                            minWidth: ResponsiveSize.w(135),
                            maxWidth: ResponsiveSize.w(135),
                          ),
                          itemBuilder: (context) => statusList.map((String value) {
                            return PopupMenuItem<String>(
                              value: value,
                              height: ResponsiveSize.h(45),
                              padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(20)),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontSize: ResponsiveSize.sp(22),
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onSelected: (String value) {
                            setState(() {
                              currentStatus = value;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                          ),
                          color: Colors.white,
                          elevation: 10,
                          child: Container(
                            width: ResponsiveSize.w(135),
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveSize.w(12),
                              vertical: ResponsiveSize.h(12),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: ResponsiveSize.w(10),
                                  offset: Offset(0, ResponsiveSize.h(5)),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  currentStatus,
                                  style: TextStyle(
                                    fontSize: ResponsiveSize.sp(22),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(width: ResponsiveSize.w(4)),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveSize.w(10)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskCalendarPage(
                                  homeworkList: homeworkList,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(ResponsiveSize.w(12)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: ResponsiveSize.w(10),
                                  offset: Offset(0, ResponsiveSize.h(5)),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.calendar_today,
                              size: ResponsiveSize.w(24),
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // 作业类型选择
            Container(
              height: ResponsiveSize.h(50),
              margin: EdgeInsets.symmetric(vertical: ResponsiveSize.h(10)),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(15)),
                itemCount: homeworkTypes.length,
                itemBuilder: (context, index) {
                  final type = homeworkTypes[index];
                  final isSelected = type['name'] == currentType;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        currentType = type['name'];
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(8)),
                      padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(20)),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF2E7D32) : Colors.white,
                        borderRadius: BorderRadius.circular(ResponsiveSize.w(25)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: ResponsiveSize.w(5),
                            offset: Offset(0, ResponsiveSize.h(2)),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            type['icon'],
                            color: isSelected ? Colors.white : Colors.black87,
                            size: ResponsiveSize.w(20),
                          ),
                          SizedBox(width: ResponsiveSize.w(8)),
                          Text(
                            type['name'],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontSize: ResponsiveSize.sp(25),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // 作业列表部分
            Container(
              margin: EdgeInsets.only(top: ResponsiveSize.h(20)),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.65,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: ResponsiveSize.w(4),
                        offset: Offset(0, ResponsiveSize.h(2)),
                      ),
                    ],
                  ),
                  child: GridView.builder(
                    padding: EdgeInsets.all(ResponsiveSize.w(16)),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: ResponsiveSize.w(16),
                      mainAxisSpacing: ResponsiveSize.h(16),
                    ),
                    itemCount: _getFilteredHomeworkList().length,
                    itemBuilder: (context, index) {
                      return _buildHomeworkCard(_getFilteredHomeworkList()[index]);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredHomeworkList() {
    return homeworkList.where((homework) {
      bool typeMatch = currentType == '全部' || homework['type'] == currentType;
      bool statusMatch = currentStatus == '全部' || homework['status'] == currentStatus;
      return typeMatch && statusMatch;
    }).toList();
  }

  Widget _buildHomeworkCard(Map<String, dynamic> homework) {
  return GestureDetector(
    onTap: () {
      // 创建一个新的 Map 来传递数据
      final Map<String, dynamic> homeworkData = Map<String, dynamic>.from(homework);
      
      Widget page;
      switch (homework['type']) {
        case '听力理解':
          page = ListeningHomeworkPage(homework: homeworkData);
          break;
        case '口语表达':
          page = SpeakingHomeworkPage(homework: homeworkData);
          break;
        case '自读闯关':
          page = ReadingHomeworkPage(homework: homeworkData);
          break;
        case '书写听写':
          page = WritingHomeworkPage(homework: homeworkData);
          break;
        default:
          return;
      }
      
      // 添加调试打印
      print('Homework data being passed: $homeworkData');
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      ).then((updatedHomework) {
        if (updatedHomework != null) {
          setState(() {
            final index = homeworkList.indexWhere((h) => 
              h['title'] == updatedHomework['title'] && 
              h['type'] == updatedHomework['type']
            );
            if (index != -1) {
              homeworkList[index] = updatedHomework;
            }
          });
        }
      });
    },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: ResponsiveSize.w(4),
              offset: Offset(0, ResponsiveSize.h(2)),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(ResponsiveSize.w(12))
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      homework['cover'],
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: ResponsiveSize.h(8),
                      left: ResponsiveSize.w(8),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(8),
                          vertical: ResponsiveSize.h(4),
                        ),
                        decoration: BoxDecoration(
                          color: _getTypeColor(homework['type']),
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _getTypeIcon(homework['type']),
                            SizedBox(width: ResponsiveSize.w(4)),
                            Text(
                              homework['type'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ResponsiveSize.sp(16),
                                fontWeight: FontWeight.bold,
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
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(ResponsiveSize.w(8)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      homework['title'],
                      style: TextStyle(
                        fontSize: ResponsiveSize.sp(20),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '发布日期：${homework['publishDate']}',
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(18),
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: ResponsiveSize.h(4)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '截止日期：${homework['dueDate']}',
                              style: TextStyle(
                                fontSize: ResponsiveSize.sp(18),
                                color: Colors.grey[600],
                              ),
                            ),
                            _buildStatusTag(homework['status']),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case '听力理解':
        return const Color(0xFF4A90E2);
      case '口语表达':
        return const Color(0xFFF5A623);
      case '自读闯关':
        return const Color(0xFF7ED321);
      case '书写听写':
        return const Color(0xFF9013FE);
      default:
        return Colors.grey;
    }
  }

  Icon _getTypeIcon(String type) {
    switch (type) {
      case '听力理解':
        return Icon(Icons.headphones, color: Colors.white, size: ResponsiveSize.w(16));
      case '口语表达':
        return Icon(Icons.mic, color: Colors.white, size: ResponsiveSize.w(16));
      case '自读闯关':
        return Icon(Icons.menu_book, color: Colors.white, size: ResponsiveSize.w(16));
      case '书写听写':
        return Icon(Icons.edit, color: Colors.white, size: ResponsiveSize.w(16));
      default:
        return Icon(Icons.assignment, color: Colors.white, size: ResponsiveSize.w(16));
    }
  }

  Widget _buildStatusTag(String status) {
    Color tagColor;
    switch (status) {
      case '未完成':
        tagColor = Colors.red;
        break;
      case '有点评':
        tagColor = Colors.blue;
        break;
      case '已完成':
        tagColor = Colors.green;
        break;
      default:
        tagColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(8),
        vertical: ResponsiveSize.h(4)
      ),
      decoration: BoxDecoration(
        color: tagColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
        border: Border.all(
          color: tagColor.withOpacity(0.5),
          width: ResponsiveSize.w(1),
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: tagColor,
          fontSize: ResponsiveSize.sp(18),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}