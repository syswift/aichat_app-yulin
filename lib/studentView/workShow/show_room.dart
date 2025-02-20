import 'dart:io';
import 'package:flutter/material.dart';
import 'dialog/add_work_dialog.dart';
import 'audioMode/audio_record_page.dart';
import 'audioMode/audio_player_page.dart';
import 'videoMode/video_player_page.dart';
import 'imageMode/image_view_page.dart';
import '../../utils/responsive_size.dart';

class WorkItem {
  final String id;
  final String title;
  final String author;
  final int points;
  final String type;
  final String? audioPath;
  final String? imagePath;
  final String? videoPath;
  final String? teacherComment;
  final DateTime? commentTime;
  final DateTime? createTime;
  final bool hasNewComment;
  final bool hasComment;

  const WorkItem({
    required this.id,
    required this.title,
    required this.author,
    required this.points,
    required this.type,
    this.audioPath,
    this.imagePath,
    this.videoPath,
    this.teacherComment,
    this.commentTime,
    this.createTime,
    this.hasNewComment = false,
    this.hasComment = false,
  });

  WorkItem copyWith({
    String? id,
    String? title,
    String? author,
    int? points,
    String? type,
    String? audioPath,
    String? imagePath,
    String? videoPath,
    String? teacherComment,
    DateTime? commentTime,
    DateTime? createTime,
    bool? hasNewComment,
    bool? hasComment,
  }) {
    return WorkItem(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      points: points ?? this.points,
      type: type ?? this.type,
      audioPath: audioPath ?? this.audioPath,
      imagePath: imagePath ?? this.imagePath,
      videoPath: videoPath ?? this.videoPath,
      teacherComment: teacherComment ?? this.teacherComment,
      commentTime: commentTime ?? this.commentTime,
      createTime: createTime ?? this.createTime,
      hasNewComment: hasNewComment ?? this.hasNewComment,
      hasComment: hasComment ?? this.hasComment,
    );
  }
}
class ShowRoom extends StatefulWidget {
  final bool isTeacherView;

  const ShowRoom({
    super.key,
    this.isTeacherView = false,
  });

  @override
  State<ShowRoom> createState() => _ShowRoomState();
}

class _ShowRoomState extends State<ShowRoom> {
  String currentSection = '全校作品';
  String currentTab = '全部作品';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String searchQuery = '';
  bool showDeleteButtons = false;
  final Set<String> _viewedComments = {};

  void _changeSection(String section) {
    setState(() {
      currentSection = section;
      showDeleteButtons = false;
    });
  }

  void _addNewWork(String title, String audioPath, String imagePath, String? videoPath) {
    final newWork = WorkItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      author: '小明',
      points: 0,
      type: '录音',
      audioPath: audioPath,
      imagePath: imagePath,
      videoPath: videoPath,
      createTime: DateTime.now(),
      hasNewComment: false,
      hasComment: false,
    );

    final currentWorks = List<WorkItem>.from(workItemsNotifier.value);
    currentWorks.insert(0, newWork);
    workItemsNotifier.value = currentWorks;
  }

  void _addNewVideoWork(String title, String videoPath, String imagePath, String? audioPath) {
    final newWork = WorkItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      author: '小明',
      points: 0,
      type: '创作',
      videoPath: videoPath,
      imagePath: imagePath,
      audioPath: audioPath,
      createTime: DateTime.now(),
      hasNewComment: false,
      hasComment: false,
    );

    final currentWorks = List<WorkItem>.from(workItemsNotifier.value);
    currentWorks.insert(0, newWork);
    workItemsNotifier.value = currentWorks;
  }

  void _addNewImageWork(String title, String imagePath) {
    final newWork = WorkItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      author: '小明',
      points: 0,
      type: '图片',
      audioPath: null,
      imagePath: imagePath,
      videoPath: null,
      teacherComment: "非常棒的作品！构图合理，色彩搭配协调，充分展现了创作主题。继续保持！",
      commentTime: DateTime.now().subtract(const Duration(days: 1)),
      createTime: DateTime.now(),
      hasNewComment: true,
      hasComment: true,
    );

    final currentWorks = List<WorkItem>.from(workItemsNotifier.value);
    currentWorks.insert(0, newWork);
    workItemsNotifier.value = currentWorks;
  }
    final ValueNotifier<Set<String>> likedWorkIds = ValueNotifier<Set<String>>({});
  final ValueNotifier<List<WorkItem>> workItemsNotifier = ValueNotifier<List<WorkItem>>([
    WorkItem(
      id: '1',
      title: 'The Baby Animals',
      author: '安诺',
      points: 1319,
      type: '录音',
      createTime: DateTime.now().subtract(const Duration(days: 30)),
      teacherComment: '发音准确，语调自然，表现力很强！',
      commentTime: DateTime.now().subtract(const Duration(days: 25)),
      audioPath: 'assets/test_audio.mp3',
      imagePath: 'assets/cartoon.png',
      hasNewComment: true,
      hasComment: true,
    ),
    WorkItem(
      id: '2',
      title: 'My Baby Sister',
      author: 'Tiffany',
      points: 2070,
      type: '创作',
      createTime: DateTime.now().subtract(const Duration(days: 45)),
      teacherComment: '创意十足，画面构图合理，色彩搭配协调！',
      commentTime: DateTime.now().subtract(const Duration(days: 40)),
      videoPath: 'assets/test_video.mp4',
      imagePath: 'assets/cartoon.png',
      hasNewComment: true,
      hasComment: true,
    ),
    WorkItem(
      id: '4',
      title: 'At The Market',
      author: 'Ella',
      points: 1515,
      type: '录音',
      createTime: DateTime.now().subtract(const Duration(days: 60)),
      teacherComment: '朗读流畅，重音准确，感情充沛！',
      commentTime: DateTime.now().subtract(const Duration(days: 55)),
      audioPath: 'assets/test_audio.mp3',
      imagePath: 'assets/cartoon.png',
      hasNewComment: false,
      hasComment: true,
    ),
    WorkItem(
      id: '5',
      title: 'Waking Up',
      author: 'Amy诗悦',
      points: 1445,
      type: '创作',
      createTime: DateTime.now().subtract(const Duration(days: 20)),
      teacherComment: '画面生动有趣，故事情节完整！',
      commentTime: DateTime.now().subtract(const Duration(days: 15)),
      videoPath: 'assets/test_video.mp4',
      imagePath: 'assets/cartoon.png',
      hasNewComment: true,
      hasComment: true,
    ),
    WorkItem(
      id: '7',
      title: 'Drawing',
      author: '朱卉恩',
      points: 1270,
      type: '录音',
      createTime: DateTime.now().subtract(const Duration(days: 15)),
      teacherComment: '发音标准，语速适中，表达清晰！',
      commentTime: DateTime.now().subtract(const Duration(days: 10)),
      audioPath: 'assets/test_audio.mp3',
      imagePath: 'assets/cartoon.png',
      hasNewComment: false,
      hasComment: true,
    ),
    WorkItem(
      id: '8',
      title: 'Ten Fat Sausages',
      author: '小鱼',
      points: 385,
      type: '创作',
      createTime: DateTime.now().subtract(const Duration(days: 10)),
      teacherComment: '想象力丰富，画面细节丰富！',
      commentTime: DateTime.now().subtract(const Duration(days: 5)),
      videoPath: 'assets/test_video.mp4',
      imagePath: 'assets/cartoon.png',
      hasNewComment: true,
      hasComment: true,
    ),
    WorkItem(
      id: '9',
      title: 'My First Recording',
      author: '小明',
      points: 1500,
      type: '录音',
      createTime: DateTime.now().subtract(const Duration(days: 5)),
      teacherComment: '很棒的首次尝试，继续加油！',
      commentTime: DateTime.now().subtract(const Duration(days: 2)),
      audioPath: 'assets/test_audio.mp3',
      imagePath: 'assets/cartoon.png',
      hasNewComment: true,
      hasComment: true,
    ),
  ]);

  void _markCommentAsViewed(String workId) {
    if (!_viewedComments.contains(workId)) {
      setState(() {
        _viewedComments.add(workId);
        final currentWorks = List<WorkItem>.from(workItemsNotifier.value);
        final index = currentWorks.indexWhere((work) => work.id == workId);
        if (index != -1) {
          currentWorks[index] = currentWorks[index].copyWith(
            hasNewComment: false,
            hasComment: currentWorks[index].teacherComment != null,
          );
          workItemsNotifier.value = currentWorks;
        }
      });
    }
  }
    void toggleLike(String workId) {
    final currentLikes = likedWorkIds.value;
    final currentWorks = List<WorkItem>.from(workItemsNotifier.value);
    final workIndex = currentWorks.indexWhere((work) => work.id == workId);
    
    if (workIndex == -1) return;

    if (currentLikes.contains(workId)) {
      currentLikes.remove(workId);
      currentWorks[workIndex] = currentWorks[workIndex].copyWith(
        points: currentWorks[workIndex].points - 1
      );
    } else {
      currentLikes.add(workId);
      currentWorks[workIndex] = currentWorks[workIndex].copyWith(
        points: currentWorks[workIndex].points + 1
      );
    }

    likedWorkIds.value = Set<String>.from(currentLikes);
    workItemsNotifier.value = currentWorks;
  }

  void deleteWork(WorkItem work) {
    if (work.author == '小明') {
      final currentWorks = List<WorkItem>.from(workItemsNotifier.value);
      currentWorks.removeWhere((item) => item.id == work.id);
      workItemsNotifier.value = currentWorks;
      
      setState(() {
        showDeleteButtons = false;
      });
    }
  }

  List<WorkItem> get filteredWorks {
    final works = workItemsNotifier.value;
    
    if (searchQuery.isNotEmpty) {
      return works.where((work) =>
        work.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
        work.author.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }
    
    List<WorkItem> sectionFiltered = works;
    switch (currentSection) {
      case '明星作品':
        sectionFiltered = works.where((work) => work.points >= 1500).toList();
        break;
      case '班级作品':
        sectionFiltered = works.where((work) => work.author != '小明').toList();
        break;
      case '我的作品':
        sectionFiltered = works.where((work) => work.author == '小明').toList();
        break;
      case '全校作品':
        sectionFiltered = works;
        break;
    }
    
    if (currentTab == '全部作品') return sectionFiltered;
    return sectionFiltered.where((work) => '${work.type}作品' == currentTab).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    likedWorkIds.dispose();
    workItemsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);

    return Scaffold(
      body: GestureDetector(
        onTap: () => _searchFocusNode.unfocus(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/zuopinxiuchangbg1.png'),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: ResponsiveSize.w(50),
                      top: ResponsiveSize.h(20),
                    ),
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
                Expanded(
                  child: Stack(
                    children: [
                      _buildMainContent(),
                      _buildSideBar(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
    Widget _buildSideBar() {
    return Positioned(
      left: ResponsiveSize.px(50),
      top: ResponsiveSize.py(120),
      child: SizedBox(
        width: ResponsiveSize.w(320),
        height: ResponsiveSize.h(650),
        child: Column(
          children: [
            Expanded(
              child: _buildSideBarItem('明星作品', 'assets/superstar.png'),
            ),
            Expanded(
              child: _buildSideBarItem('全校作品', 'assets/schoolstar.png'),
            ),
            Expanded(
              child: _buildSideBarItem('班级作品', 'assets/classstar.png'),
            ),
            if (!widget.isTeacherView)
              Expanded(
                child: _buildSideBarItem('我的作品', 'assets/mystar.png'),
              ),
          ],
        ),
      ),
    );
  }
    Widget _buildSideBarItem(String title, String iconPath) {
    bool isSelected = currentSection == title;
    bool isFirst = title == '明星作品';
    bool isLast = title == '我的作品';
    
    return GestureDetector(
      onTap: () => _changeSection(title),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(20)),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFFFBE5C9)  
              : Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.only(
            topLeft: isFirst ? Radius.circular(ResponsiveSize.w(35)) : Radius.zero,
            topRight: isFirst ? Radius.circular(ResponsiveSize.w(35)) : Radius.zero,
            bottomLeft: isLast ? Radius.circular(ResponsiveSize.w(35)) : Radius.zero,
            bottomRight: isLast ? Radius.circular(ResponsiveSize.w(35)) : Radius.zero,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: ResponsiveSize.w(4),
              offset: Offset(0, ResponsiveSize.h(2)),
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(10),
          vertical: 0
        ),
        child: Row(
          children: [
            Container(
              width: ResponsiveSize.w(80),
              height: ResponsiveSize.w(80),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: ResponsiveSize.w(4),
                    offset: Offset(0, ResponsiveSize.h(2)),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: ResponsiveSize.w(60),
                  height: ResponsiveSize.w(60),
                ),
              ),
            ),
            SizedBox(width: ResponsiveSize.w(20)),
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF7B5C55),
                fontSize: ResponsiveSize.sp(30),
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
    Widget _buildTabBarWithSearch() {
    return Container(
      padding: EdgeInsets.only(
        left: ResponsiveSize.w(20),
        right: ResponsiveSize.w(20),
        top: ResponsiveSize.h(20),
        bottom: ResponsiveSize.h(15),
      ),
      child: Row(
        children: [
          _buildTab('全部作品', currentTab == '全部作品'),
          SizedBox(width: ResponsiveSize.w(20)),
          _buildTab('录音作品', currentTab == '录音作品'),
          SizedBox(width: ResponsiveSize.w(20)),
          _buildTab('创作作品', currentTab == '创作作品'),
          SizedBox(width: ResponsiveSize.w(20)),
          _buildTab('图片作品', currentTab == '图片作品'),
          const Spacer(),
          Expanded(
            child: _buildSearchBar(),
          ),
          if (!widget.isTeacherView) ...[
            SizedBox(width: ResponsiveSize.w(15)),
            _buildActionButtons(),
          ],
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentTab = title;
          showDeleteButtons = false;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.w(20),
          vertical: ResponsiveSize.h(10),
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: ResponsiveSize.w(4),
                    offset: Offset(0, ResponsiveSize.h(2)),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveSize.sp(25),
            fontWeight: FontWeight.bold,
            color: isSelected ? const Color(0xFF4A6FA5) : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: ResponsiveSize.h(60),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
      ),
      child: Center(
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          style: TextStyle(fontSize: ResponsiveSize.sp(23)),
          decoration: InputDecoration(
            hintText: '搜索作品或作者',
            hintStyle: TextStyle(fontSize: ResponsiveSize.sp(23)),
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveSize.h(12),
                horizontal: ResponsiveSize.w(8)
              ),
              child: Icon(Icons.search, size: ResponsiveSize.w(30)),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.w(20),
              vertical: ResponsiveSize.h(15)
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => AddWorkDialog(
                onRecordPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AudioRecordPage(
                        onSaveWork: (title, audioPath, imagePath, videoPath) {
                          _addNewWork(title, audioPath, imagePath, videoPath);
                        },
                      ),
                    ),
                  );
                },
                onSaveWork: (title, path, imagePath) {
                  if (path.endsWith('.mp4')) {
                    _addNewVideoWork(title, path, imagePath, null);
                  } else if (path.endsWith('.jpg') || path.endsWith('.png')) {
                    _addNewImageWork(title, path);
                  } else {
                    _addNewWork(title, path, imagePath, null);
                  }
                },
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.w(20),
              vertical: ResponsiveSize.h(10)
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
            ),
            child: Text(
              '添加',
              style: TextStyle(
                fontSize: ResponsiveSize.sp(25),
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (currentSection == '我的作品') ...[
          SizedBox(width: ResponsiveSize.w(20)),
          GestureDetector(
            onTap: () {
              setState(() {
                showDeleteButtons = !showDeleteButtons;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.w(20),
                vertical: ResponsiveSize.h(10)
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
              ),
              child: Text(
                showDeleteButtons ? '取消' : '删除',
                style: TextStyle(
                  fontSize: ResponsiveSize.sp(25),
                  color: showDeleteButtons ? Colors.grey : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMainContent() {
    return Positioned(
      right: ResponsiveSize.px(50),
      top: ResponsiveSize.py(70),
      child: SizedBox(
        width: ResponsiveSize.w(900),
        height: ResponsiveSize.h(700),
        child: Column(
          children: [
            _buildTabBarWithSearch(),
            Expanded(
              child: ValueListenableBuilder<List<WorkItem>>(
                valueListenable: workItemsNotifier,
                builder: (context, workItems, child) {
                  final works = filteredWorks;
                  return GridView.builder(
                    padding: EdgeInsets.all(ResponsiveSize.w(20)),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: ResponsiveSize.w(20),
                      mainAxisSpacing: ResponsiveSize.h(20),
                    ),
                    itemCount: works.length,
                    itemBuilder: (context, index) => _buildWorkItem(works[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

    Widget _buildWorkItem(WorkItem work) {
    bool isMyWork = work.author == '小明';
    
    return GestureDetector(
      onTap: () {
        // 立即更新点评状态
        if (work.hasNewComment) {
          _markCommentAsViewed(work.id);
        }

        if (work.videoPath != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerPage(
                title: work.title,
                videoPath: work.videoPath!,
                imagePath: work.imagePath,
                createTime: work.createTime,
                teacherComment: work.teacherComment,
                commentTime: work.commentTime,
              ),
            ),
          );
        } else if (work.audioPath != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AudioPlayerPage(
                title: work.title,
                audioPath: work.audioPath!,
                imagePath: work.imagePath ?? '',
                createTime: work.createTime ?? DateTime.now(),
                teacherComment: work.teacherComment ?? '',
                commentTime: work.commentTime,
              ),
            ),
          );
        } else if (work.imagePath != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageViewPage(
                title: work.title,
                imagePath: work.imagePath!,
                createTime: work.createTime ?? DateTime.now(),
                teacherComment: work.teacherComment ?? '',
                commentTime: work.commentTime,
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: ResponsiveSize.w(5),
              offset: Offset(0, ResponsiveSize.h(2)),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ResponsiveSize.w(15)),
                        topRight: Radius.circular(ResponsiveSize.w(15)),
                      ),
                      child: work.imagePath != null
                          ? work.imagePath!.startsWith('assets/')
                              ? Image.asset(
                                  work.imagePath!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: ResponsiveSize.h(220),
                                )
                              : Image.file(
                                  File(work.imagePath!),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: ResponsiveSize.h(220),
                                )
                          : Image.asset(
                              'assets/cartoon.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: ResponsiveSize.h(220),
                            ),
                    ),
                    // 作品类型标签
                    Positioned(
                      top: ResponsiveSize.h(10),
                      left: ResponsiveSize.w(10),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.w(12),
                          vertical: ResponsiveSize.h(6),
                        ),
                        decoration: BoxDecoration(
                          color: _getTagColor(work.type),
                          borderRadius: BorderRadius.circular(ResponsiveSize.w(12)),
                        ),
                        child: Text(
                          work.type,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveSize.sp(18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                   // 在 Stack 的 children 中，替换原来的点评标记代码
// 新设计的点评标记
if (work.hasNewComment || work.hasComment)
  Positioned(
    top: ResponsiveSize.h(10),
    right: ResponsiveSize.w(10),
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.w(16),
        vertical: ResponsiveSize.h(8),
      ),
      decoration: BoxDecoration(
        color: work.hasNewComment 
            ? const Color(0xFFFF6B6B).withOpacity(0.95)  // 柔和的红色
            : const Color(0xFF4CAF50).withOpacity(0.95),  // 柔和的绿色
        borderRadius: BorderRadius.circular(ResponsiveSize.w(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            work.hasNewComment 
                ? Icons.star_rounded
                : Icons.check_circle,
            color: Colors.white,
            size: ResponsiveSize.w(20),
          ),
          SizedBox(width: ResponsiveSize.w(4)),
          Text(
            work.hasNewComment ? '新点评' : '已点评',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveSize.sp(16),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    ),
  ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(ResponsiveSize.w(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        work.title,
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(24),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: ResponsiveSize.h(8)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              work.author,
                              style: TextStyle(
                                fontSize: ResponsiveSize.sp(22),
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ValueListenableBuilder<Set<String>>(
                            valueListenable: likedWorkIds,
                            builder: (context, likedIds, child) {
                              return Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => toggleLike(work.id),
                                    child: Image.asset(
                                      likedIds.contains(work.id)
                                          ? 'assets/like.png'
                                          : 'assets/flower.png',
                                      width: ResponsiveSize.w(24),
                                      height: ResponsiveSize.w(24),
                                    ),
                                  ),
                                  SizedBox(width: ResponsiveSize.w(5)),
                                  Text(
                                    work.points.toString(),
                                    style: TextStyle(
                                      fontSize: ResponsiveSize.sp(20),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (currentSection == '我的作品' && isMyWork && showDeleteButtons)
              Positioned(
                top: ResponsiveSize.h(10),
                right: ResponsiveSize.w(10),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => AlertDialog(
                        title: const Text('确认删除'),
                        content: const Text('确定要删除这个作品吗？'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                showDeleteButtons = false;
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text('取消'),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteWork(work);
                              Navigator.of(context).pop();
                            },
                            child: const Text('确定'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(ResponsiveSize.w(8)),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                    ),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: ResponsiveSize.w(20),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  Color _getTagColor(String type) {
    switch (type) {
      case '录音':
        return const Color(0xFF5B7FFF);  // 靛蓝色
      case '创作':
        return const Color(0xFFFF9B3F);  // 橙色
      case '图片':
        return const Color(0xFFB86EFF);  // 紫色
      default:
        return Colors.grey;
    }
  }
}