import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';
import 'listening_homework_page.dart';
import 'speaking_homework_page.dart';
import 'reading_homework_page.dart';
import 'writing_homework_page.dart';

class TaskCalendarPage extends StatefulWidget {
  final List<Map<String, dynamic>> homeworkList;

  const TaskCalendarPage({
    super.key,
    required this.homeworkList,
  });

  @override
  State<TaskCalendarPage> createState() => _TaskCalendarPageState();
}

class _TaskCalendarPageState extends State<TaskCalendarPage> {
  DateTime selectedDate = DateTime.now();
  late DateTime startDate;
  late List<DateTime> weekDates;
  String selectedStatus = '状态';
  bool showAllTasks = false;
  bool isTodaySelected = false;
  final List<String> statusList = ['全部', '未完成', '已完成', '有点评'];

  @override
  void initState() {
    super.initState();
    _initializeDates();
  }

  void _initializeDates() {
    startDate = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    weekDates = List.generate(7, (index) => startDate.add(Duration(days: index)));
  }

  void _goToToday() {
    setState(() {
      selectedDate = DateTime.now();
      _initializeDates();
      showAllTasks = false;
    });
  }

  String _getWeekdayText(int weekday) {
    const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return weekdays[weekday - 1];
  }

  List<Map<String, dynamic>> get displayedHomework {
    if (showAllTasks) {
      return widget.homeworkList.where((homework) {
        return selectedStatus == '状态' || selectedStatus == '全部' || 
               homework['status'] == selectedStatus;
      }).toList();
    }
    return _getHomeworkForDate(selectedDate);
  }

  List<Map<String, dynamic>> _getHomeworkForDate(DateTime date) {
    String dateStr = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return widget.homeworkList.where((homework) {
      bool dateMatch = homework['dueDate'] == dateStr;
      bool statusMatch = selectedStatus == '状态' || selectedStatus == '全部' || 
                        homework['status'] == selectedStatus;
      return dateMatch && statusMatch;
    }).toList();
  }
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
              bottom: false,
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
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(16)),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          startDate = startDate.subtract(const Duration(days: 7));
                          weekDates = List.generate(
                            7,
                            (index) => startDate.add(Duration(days: index)),
                          );
                        });
                      },
                      icon: Icon(
                        Icons.chevron_left,
                        size: ResponsiveSize.w(24),
                      ),
                    ),
                    ...weekDates.map((date) {
                      bool isSelected = date.year == selectedDate.year &&
                          date.month == selectedDate.month &&
                          date.day == selectedDate.day;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDate = date;
                            showAllTasks = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveSize.w(20),
                            vertical: ResponsiveSize.h(10),
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.transparent,
                            borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                _getWeekdayText(date.weekday),
                                style: TextStyle(
                                  fontSize: ResponsiveSize.sp(25),
                                  color: isSelected ? Colors.white : Colors.black87,
                                ),
                              ),
                              SizedBox(height: ResponsiveSize.h(5)),
                              Text(
                                '${date.month}/${date.day}',
                                style: TextStyle(
                                  fontSize: ResponsiveSize.sp(22),
                                  color: isSelected ? Colors.white : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                                        IconButton(
                      onPressed: () {
                        setState(() {
                          startDate = startDate.add(const Duration(days: 7));
                          weekDates = List.generate(
                            7,
                            (index) => startDate.add(Duration(days: index)),
                          );
                        });
                      },
                      icon: Icon(
                        Icons.chevron_right,
                        size: ResponsiveSize.w(24),
                      ),
                    ),
                    SizedBox(width: ResponsiveSize.w(100)),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isTodaySelected = !isTodaySelected;
                          _goToToday();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(25),
                          vertical: ResponsiveSize.h(12),
                        ),
                        decoration: BoxDecoration(
                          color: isTodaySelected ? Colors.blue : Colors.white,
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: ResponsiveSize.w(1),
                          ),
                        ),
                        child: Text(
                          '今日',
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(25),
                            fontWeight: FontWeight.w500,
                            color: isTodaySelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: ResponsiveSize.w(10)),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showAllTasks = !showAllTasks;
                          isTodaySelected = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(25),
                          vertical: ResponsiveSize.h(12),
                        ),
                        decoration: BoxDecoration(
                          color: showAllTasks ? Colors.blue : Colors.white,
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: ResponsiveSize.w(1),
                          ),
                        ),
                        child: Text(
                          '全部任务',
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(25),
                            fontWeight: FontWeight.w500,
                            color: showAllTasks ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: ResponsiveSize.h(20)),
            // 表头部分
            Container(
              padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(12)),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: ResponsiveSize.w(1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Colors.grey[200]!,
                            width: ResponsiveSize.w(1),
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '类型',
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(25),
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                                    Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Colors.grey[200]!,
                            width: ResponsiveSize.w(1),
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '作业详情',
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(25),
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Colors.grey[200]!,
                            width: ResponsiveSize.w(1),
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '阶段',
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(25),
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        '状态',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(25),
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveSize.h(10)),
            Expanded(
              child: _buildHomeworkList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeworkList() {
    final homeworkToShow = displayedHomework;
    
    if (homeworkToShow.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: ResponsiveSize.w(100),
              color: Colors.grey[400],
            ),
            SizedBox(height: ResponsiveSize.h(20)),
            Text(
              selectedStatus == '状态' || selectedStatus == '全部' 
                  ? '暂无学习内容' 
                  : '暂无$selectedStatus的内容',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(25),
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }
        return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: homeworkToShow.length,
      itemBuilder: (context, index) {
        final homework = homeworkToShow[index];
        return GestureDetector(
          onTap: () {
            String type = homework['type'];
            Widget page;
            
            switch (type) {
              case '听力理解':
                page = ListeningHomeworkPage(homework: homework);
                break;
              case '口语表达':
                page = SpeakingHomeworkPage(homework: homework);
                break;
              case '自读闯关':
                page = ReadingHomeworkPage(homework: homework);
                break;
              case '书写听写':
                page = WritingHomeworkPage(homework: homework);
                break;
              default:
                return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            ).then((result) {
              if (result != null) {
                setState(() {
                  final index = widget.homeworkList.indexWhere((h) => 
                    h['title'] == homework['title'] && h['type'] == homework['type']
                  );
                  if (index != -1) {
                    widget.homeworkList[index] = result;
                  }
                });
              }
            });
          },
          child: Container(
            margin: EdgeInsets.only(bottom: ResponsiveSize.h(16)),
            padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(16)),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: ResponsiveSize.w(4),
                  offset: Offset(0, ResponsiveSize.h(2)),
                ),
              ],
            ),
            child: Row(
              children: [
                // 类型 - 1份
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.grey[200]!,
                          width: ResponsiveSize.w(1),
                        ),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: ResponsiveSize.w(130),
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(8),
                          vertical: ResponsiveSize.h(4),
                        ),
                        decoration: BoxDecoration(
                          color: _getTypeColor(homework['type']),
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _getTypeIcon(homework['type']),
                            SizedBox(width: ResponsiveSize.w(4)),
                            Text(
                              homework['type'].length > 4 ? homework['type'].substring(0, 2) : homework['type'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ResponsiveSize.sp(22),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                                // 作业详情 - 3份
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.grey[200]!,
                          width: ResponsiveSize.w(1),
                        ),
                      ),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: ResponsiveSize.w(500),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                              child: Image.asset(
                                homework['cover'],
                                width: ResponsiveSize.w(120),
                                height: ResponsiveSize.h(120),
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: ResponsiveSize.w(16)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    homework['title'],
                                    style: TextStyle(
                                      fontSize: ResponsiveSize.sp(22),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: ResponsiveSize.h(8)),
                                  Text(
                                    '发布日期：${homework['publishDate']}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: ResponsiveSize.sp(20),
                                    ),
                                  ),
                                  Text(
                                    '截止日期：${homework['dueDate']}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: ResponsiveSize.sp(20),
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
                // 阶段 - 1份
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.grey[200]!,
                          width: ResponsiveSize.w(1),
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        homework['level'] ?? 'Level 1',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(22),
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
                // 状态 - 1份
                Expanded(
                  flex: 1,
                  child: Center(
                    child: _buildStatusTag(homework['status']),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
        horizontal: ResponsiveSize.w(16),
        vertical: ResponsiveSize.h(8),
      ),
      decoration: BoxDecoration(
        color: tagColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
        border: Border.all(
          color: tagColor.withOpacity(0.5),
          width: ResponsiveSize.w(1),
        ),
      ),
      child: Text(
        status,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: tagColor,
          fontSize: ResponsiveSize.sp(22),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}