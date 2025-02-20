import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import './assign_homework_set.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/responsive_size.dart';  // 添加响应式尺寸工具

class HomeworkSetItem {
  final String name;
  final String note;
  final String cover;
  final String? description;
  final String? type;
  bool isSelected;

  HomeworkSetItem({
    required this.name,
    required this.note,
    this.cover = 'assets/default_cover.png',
    this.description,
    this.type,
    this.isSelected = false,
  });

  factory HomeworkSetItem.fromJson(Map<String, dynamic> json) {
    return HomeworkSetItem(
      name: json['name'] as String,
      note: json['note'] as String,
      cover: json['cover'] as String,
      description: json['description'] as String?,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'note': note,
      'cover': cover,
      'description': description,
      'type': type,
    };
  }
}

class HeaderItem {
  final String title;
  final int flex;

  HeaderItem({required this.title, required this.flex});
}
class HomeworkSetPage extends StatefulWidget {
  const HomeworkSetPage({super.key});

  @override
  State<HomeworkSetPage> createState() => _HomeworkSetPageState();
}

class _HomeworkSetPageState extends State<HomeworkSetPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<HomeworkSetItem> homeworkSetList = [];

  static final List<HeaderItem> headers = [
    HeaderItem(title: '任务模板', flex: 3),
    HeaderItem(title: '备注', flex: 3),
    HeaderItem(title: '布置', flex: 1),
    HeaderItem(title: '编辑', flex: 1),
    HeaderItem(title: '操作', flex: 1),
  ];

  @override
  void initState() {
    super.initState();
    _loadHomeworkSets();
  }

  Future<void> _loadHomeworkSets() async {
    final prefs = await SharedPreferences.getInstance();
    final homeworkSets = prefs.getStringList('homework_sets') ?? [];
    setState(() {
      homeworkSetList = homeworkSets
          .map((set) => HomeworkSetItem.fromJson(json.decode(set)))
          .toList();
    });
  }

  List<HomeworkSetItem> _getFilteredList() {
    if (_searchController.text.isEmpty) {
      return homeworkSetList;
    }
    return homeworkSetList.where((item) {
      return item.name.contains(_searchController.text) ||
             item.note.contains(_searchController.text);
    }).toList();
  }

  Future<void> _deleteHomeworkSet(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> homeworkSets = prefs.getStringList('homework_sets') ?? [];
    homeworkSets.removeAt(index);
    await prefs.setStringList('homework_sets', homeworkSets);
    setState(() {
      homeworkSetList.removeAt(index);
    });
  }
    @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    
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
                  '作业集',
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
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(16),
                            color: const Color(0xFF333333),
                          ),
                          decoration: InputDecoration(
                            hintText: '搜索作业集',
                            hintStyle: TextStyle(
                              fontSize: ResponsiveSize.sp(16),
                              color: const Color(0xFF999999),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: ResponsiveSize.h(8),
                              horizontal: ResponsiveSize.w(16),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
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
                            builder: (context) => const AssignHomeworkSetPage(),
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
                      padding: EdgeInsets.zero,
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
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: ResponsiveSize.w(120),
                                        height: ResponsiveSize.h(120),
                                        margin: EdgeInsets.only(right: ResponsiveSize.w(12)),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(ResponsiveSize.w(4)),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(ResponsiveSize.w(4)),
                                          child: item.cover.startsWith('assets/')
                                              ? Image.asset(
                                                  item.cover,
                                                  fit: BoxFit.contain,
                                                )
                                              : Image.file(
                                                  File(item.cover),
                                                  fit: BoxFit.contain,
                                                ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          item.name,
                                          style: TextStyle(
                                            fontSize: ResponsiveSize.sp(22),
                                            color: Colors.grey[800],
                                          ),
                                          softWrap: true,
                                        ),
                                      ),
                                      SizedBox(width: ResponsiveSize.w(12)),
                                    ],
                                  ),
                                ),
                              ),
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
                                                            Expanded(
                                flex: 1,
                                child: Center(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
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
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
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
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                                                            Expanded(
                                flex: 1,
                                child: Center(
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}