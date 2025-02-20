import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';
import './create_system_homework_page.dart';
import 'models/daily_task.dart';

class SystemHomeworkItem {
  final String name;
  final String note;
  final String? description;
  final String? type;
  final List<List<DailyTask>>? dailyTasks;
  bool isSelected;

  SystemHomeworkItem({
    required this.name,
    required this.note,
    this.description,
    this.type,
    this.dailyTasks,
    this.isSelected = false,
  });
}

class HeaderItem {
  final String title;
  final int flex;

  HeaderItem({required this.title, required this.flex});
}

class SystemHomeworkPage extends StatefulWidget {
  const SystemHomeworkPage({super.key});

  @override
  State<SystemHomeworkPage> createState() => _SystemHomeworkPageState();
}

class _SystemHomeworkPageState extends State<SystemHomeworkPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<SystemHomeworkItem> systemHomeworkList = [
    SystemHomeworkItem(
      name: '系统作业1',
      note: '示例备注1',
    ),
    SystemHomeworkItem(
      name: '系统作业2',
      note: '示例备注2',
    ),
  ];

  static final List<HeaderItem> headers = [
    HeaderItem(title: '作业名称', flex: 3),
    HeaderItem(title: '备注', flex: 3),
    HeaderItem(title: '布置', flex: 1),
    HeaderItem(title: '编辑', flex: 1),
    HeaderItem(title: '操作', flex: 1),
  ];

  List<SystemHomeworkItem> _getFilteredList() {
    if (_searchController.text.isEmpty) {
      return systemHomeworkList;
    }
    return systemHomeworkList.where((item) {
      return item.name.contains(_searchController.text) ||
             item.note.contains(_searchController.text);
    }).toList();
  }

  Widget _buildHeaderItem(HeaderItem header) {
    return Expanded(
      flex: header.flex,
      child: SizedBox(
        width: double.infinity,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                header.title,
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(25),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
              if (header.title == '备注')
                Text(
                  ' (仅老师及以上可见)',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(16),
                    color: Colors.grey[600],
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _addSystemHomework(SystemHomeworkItem newHomework) {
    setState(() {
      systemHomeworkList.add(newHomework);
    });
  }

  void _deleteHomeworkSet(int index) {
    setState(() {
      systemHomeworkList.removeAt(index);
    });
    
    // 可以添加一个提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('系统作业已删除'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _editHomework(SystemHomeworkItem homework, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateSystemHomeworkPage(
          onCreateHomework: (editedHomework) {
            setState(() {
              systemHomeworkList[index] = editedHomework;
            });
          },
          initialHomework: homework,
        ),
      ),
    );
  }

  void _assignHomework(SystemHomeworkItem homework) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
          ),
          title: Text(
            '布置作业',
            style: TextStyle(
              fontSize: ResponsiveSize.sp(24),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5A2E17),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '确定要布置以下作业吗？',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(20),
                  color: const Color(0xFF333333),
                ),
              ),
              SizedBox(height: ResponsiveSize.h(12)),
              Text(
                '作业名称：${homework.name}',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(18),
                  color: const Color(0xFF666666),
                ),
              ),
              if (homework.dailyTasks != null)
                Text(
                  '共 ${homework.dailyTasks!.length} 天的任务',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(18),
                    color: const Color(0xFF666666),
                  ),
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
                  color: const Color(0xFF666666),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('作业布置成功')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFE4C4),
                foregroundColor: const Color(0xFF8B4513),
              ),
              child: Text(
                '确定',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(18),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: ResponsiveSize.h(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: ResponsiveSize.w(24)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '系统作业',
                  style: TextStyle(
                    fontSize: ResponsiveSize.sp(28),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF333333),
                  ),
                ),
                Row(
                  children: [
                    if (_isSearching)
                      Container(
                        width: ResponsiveSize.w(200),
                        height: ResponsiveSize.h(40),
                        margin: EdgeInsets.only(right: ResponsiveSize.w(16)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Center(
                          child: TextField(
                            controller: _searchController,
                            style: TextStyle(
                              fontSize: ResponsiveSize.sp(16),
                              color: const Color(0xFF333333),
                            ),
                            decoration: InputDecoration(
                              hintText: '搜索系统作业',
                              hintStyle: TextStyle(
                                fontSize: ResponsiveSize.sp(16),
                                color: const Color(0xFF999999),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: ResponsiveSize.w(16),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    IconButton(
                      icon: Icon(
                        _isSearching ? Icons.close : Icons.search,
                        size: ResponsiveSize.w(28),
                        color: const Color(0xFF666666),
                      ),
                      onPressed: () {
                        setState(() {
                          _isSearching = !_isSearching;
                          if (!_isSearching) {
                            _searchController.clear();
                          }
                        });
                      },
                    ),
                    SizedBox(width: ResponsiveSize.w(16)),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateSystemHomeworkPage(
                              onCreateHomework: (SystemHomeworkItem newHomework) {
                                _addSystemHomework(newHomework);
                              },
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFE4C4),
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(40),
                          vertical: ResponsiveSize.h(12),
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                          side: const BorderSide(
                            color: Color(0xFFDEB887),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        '创建',
                        style: TextStyle(
                          color: const Color(0xFF8B4513),
                          fontSize: ResponsiveSize.sp(22),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: ResponsiveSize.w(24)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: ResponsiveSize.h(24)),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ResponsiveSize.w(16)),
                  bottomLeft: Radius.circular(ResponsiveSize.w(16)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: ResponsiveSize.w(10),
                    offset: Offset(0, ResponsiveSize.h(4)),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.w(24),
                      vertical: ResponsiveSize.h(16),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE4C4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: ResponsiveSize.w(10),
                          offset: Offset(0, ResponsiveSize.h(4)),
                        ),
                      ],
                    ),
                    child: Row(
                      children: headers.map((header) => _buildHeaderItem(header)).toList(),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _getFilteredList().length,
                      itemBuilder: (context, index) {
                        final item = _getFilteredList()[index];
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveSize.w(24),
                            vertical: ResponsiveSize.h(20),
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[200]!,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              // 作业名称
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: Text(
                                    item.name,
                                    style: TextStyle(
                                      fontSize: ResponsiveSize.sp(22),
                                      color: Colors.grey[800],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              // 备注
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: Text(
                                    item.note,
                                    style: TextStyle(
                                      fontSize: ResponsiveSize.sp(22),
                                      color: Colors.grey[800],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              // 布置按钮
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () => _assignHomework(item),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/assignmentbutton.png',
                                          width: ResponsiveSize.w(50),
                                          height: ResponsiveSize.h(50),
                                        ),
                                        SizedBox(height: ResponsiveSize.h(4)),
                                        Text(
                                          '布置',
                                          style: TextStyle(
                                            fontSize: ResponsiveSize.sp(22),
                                            color: const Color(0xFF666666),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // 编辑按钮
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () => _editHomework(item, index),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/editbutton.png',
                                          width: ResponsiveSize.w(50),
                                          height: ResponsiveSize.h(50),
                                        ),
                                        SizedBox(height: ResponsiveSize.h(4)),
                                        Text(
                                          '编辑',
                                          style: TextStyle(
                                            fontSize: ResponsiveSize.sp(22),
                                            color: const Color(0xFF666666),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // 操作按钮
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: PopupMenuButton(
                                    icon: Icon(
                                      Icons.settings,
                                      color: const Color(0xFF666666),
                                      size: ResponsiveSize.w(35),
                                    ),
                                    offset: Offset(ResponsiveSize.w(35), ResponsiveSize.h(50)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
                                    ),
                                    color: Colors.white,
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        height: ResponsiveSize.h(40),
                                        child: Center(
                                          child: Text(
                                            '删除',
                                            style: TextStyle(
                                              fontSize: ResponsiveSize.sp(20),
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ),
                                        onTap: () => _deleteHomeworkSet(index),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  
} 