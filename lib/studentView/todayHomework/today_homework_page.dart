import 'package:flutter/material.dart';
import 'task_calendar_page.dart';
import '../../../utils/responsive_size.dart';
import 'writing_homework_page.dart';
import 'listening_homework_page.dart';
import 'speaking_homework_page.dart';
import 'reading_homework_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

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

  // Replace hardcoded data with state variables
  List<Map<String, dynamic>> homeworkList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchHomeworkData();
  }

  Future<void> _fetchHomeworkData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final supabase = Supabase.instance.client;
      // Changed from 'homework' to 'homeworks'
      final response = await supabase.from('homeworks').select();

      setState(() {
        homeworkList = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = '加载作业失败: $error';
        isLoading = false;
      });
      print('Error fetching homework data: $error');
    }
  }

  // Add a helper method to format dates
  String _formatDate(dynamic dateValue) {
    if (dateValue == null) return '未设置';

    try {
      // Handle String format from database
      if (dateValue is String) {
        final parsedDate = DateTime.parse(dateValue);
        return DateFormat('yyyy-MM-dd').format(parsedDate);
      }

      // Handle DateTime objects
      if (dateValue is DateTime) {
        return DateFormat('yyyy-MM-dd').format(dateValue);
      }

      // Handle timestamp format
      if (dateValue is Map) {
        if (dateValue.containsKey('date')) {
          return dateValue['date'].toString().substring(
            0,
            10,
          ); // Extract YYYY-MM-DD
        }
      }

      // Return as is if it's already formatted or we can't parse it
      return dateValue.toString();
    } catch (e) {
      print('Error formatting date: $e for value $dateValue');
      return '格式错误';
    }
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
        // Replace Column with SafeArea + Flex layout
        child: SafeArea(
          child: Column(
            children: [
              // Top navigation and filters - use minimal fixed height
              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveSize.w(10),
                  right: ResponsiveSize.w(8),
                  top: ResponsiveSize.h(10),
                  bottom: ResponsiveSize.h(10),
                ),
                child: Row(
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        'assets/backbutton1.png',
                        width: ResponsiveSize.w(80), // Reduced size
                        height: ResponsiveSize.h(80), // Reduced size
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
                          itemBuilder:
                              (context) =>
                                  statusList.map((String value) {
                                    return PopupMenuItem<String>(
                                      value: value,
                                      height: ResponsiveSize.h(45),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ResponsiveSize.w(20),
                                      ),
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
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.w(20),
                            ),
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
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.w(20),
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
                                builder:
                                    (context) => TaskCalendarPage(
                                      homeworkList: homeworkList,
                                    ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(ResponsiveSize.w(12)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.w(20),
                              ),
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

              // Type selection - use auto-sized container
              Container(
                height: ResponsiveSize.h(45), // Reduced height
                margin: EdgeInsets.only(bottom: ResponsiveSize.h(10)),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.w(15),
                  ),
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
                        margin: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(20),
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? const Color(0xFF2E7D32)
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(25),
                          ),
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
                                color:
                                    isSelected ? Colors.white : Colors.black87,
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

              // Main content - use Expanded to take remaining space
              Expanded(
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    // Remove fixed height and use all available space
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
                    // Use ClipRRect to ensure content respects border radius
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                      child:
                          isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : errorMessage != null
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      errorMessage!,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: ResponsiveSize.sp(22),
                                      ),
                                    ),
                                    SizedBox(height: ResponsiveSize.h(20)),
                                    ElevatedButton(
                                      onPressed: _fetchHomeworkData,
                                      child: const Text('重试'),
                                    ),
                                  ],
                                ),
                              )
                              : homeworkList.isEmpty
                              ? Center(
                                child: Text(
                                  '暂无作业数据',
                                  style: TextStyle(
                                    fontSize: ResponsiveSize.sp(24),
                                  ),
                                ),
                              )
                              : GridView.builder(
                                padding: EdgeInsets.all(ResponsiveSize.w(16)),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      childAspectRatio: 0.85,
                                      crossAxisSpacing: ResponsiveSize.w(16),
                                      mainAxisSpacing: ResponsiveSize.h(16),
                                    ),
                                itemCount: _getFilteredHomeworkList().length,
                                itemBuilder: (context, index) {
                                  return _buildHomeworkCard(
                                    _getFilteredHomeworkList()[index],
                                  );
                                },
                              ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredHomeworkList() {
    return homeworkList.where((homework) {
      bool typeMatch = currentType == '全部' || homework['type'] == currentType;
      bool statusMatch =
          currentStatus == '全部' || homework['status'] == currentStatus;
      return typeMatch && statusMatch;
    }).toList();
  }

  Widget _buildHomeworkCard(Map<String, dynamic> homework) {
    return GestureDetector(
      onTap: () {
        // 创建一个新的 Map 来传递数据
        final Map<String, dynamic> homeworkData = Map<String, dynamic>.from(
          homework,
        );

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
          MaterialPageRoute(builder: (context) => page),
        ).then((updatedHomework) {
          if (updatedHomework != null) {
            setState(() {
              final index = homeworkList.indexWhere(
                (h) =>
                    h['title'] == updatedHomework['title'] &&
                    h['type'] == updatedHomework['type'],
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
                  top: Radius.circular(ResponsiveSize.w(12)),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Use Supabase Storage URL instead of local asset
                    Image.network(
                      _getCoverImageUrl(homework['cover']),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value:
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                          ),
                        );
                      },
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
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(12),
                          ),
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
                          '发布日期：${_formatDate(homework['publish_date'])}',
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
                              '截止日期：${_formatDate(homework['due_date'])}',
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
        return Icon(
          Icons.headphones,
          color: Colors.white,
          size: ResponsiveSize.w(16),
        );
      case '口语表达':
        return Icon(Icons.mic, color: Colors.white, size: ResponsiveSize.w(16));
      case '自读闯关':
        return Icon(
          Icons.menu_book,
          color: Colors.white,
          size: ResponsiveSize.w(16),
        );
      case '书写听写':
        return Icon(
          Icons.edit,
          color: Colors.white,
          size: ResponsiveSize.w(16),
        );
      default:
        return Icon(
          Icons.assignment,
          color: Colors.white,
          size: ResponsiveSize.w(16),
        );
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
        vertical: ResponsiveSize.h(4),
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

  // Add a helper method to get the Supabase Storage URL for cover images
  String _getCoverImageUrl(String coverPath) {
    final supabase = Supabase.instance.client;
    // If coverPath is already a full URL, return it as is
    if (coverPath.startsWith('http')) {
      return coverPath;
    }
    // Remove 'assets/' prefix if exists
    String filename = coverPath.replaceFirst('assets/', '');
    // Get public URL from Supabase storage
    return supabase.storage.from('cover').getPublicUrl(filename);
  }
}
