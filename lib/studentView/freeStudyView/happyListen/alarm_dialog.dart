import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';
import 'audio_item.dart';

class AlarmDialog extends StatefulWidget {
  final List<AudioItem> audioList;

  const AlarmDialog({
    super.key,
    required this.audioList,
  });

  @override
  State<AlarmDialog> createState() => _AlarmDialogState();
}

class _AlarmDialogState extends State<AlarmDialog> {
  DateTime selectedTime = DateTime.now().add(const Duration(minutes: 1));
  AudioItem? selectedAudio;
  List<bool> weekdays = List.generate(7, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: ResponsiveSize.w(500),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 顶部标题栏
            Container(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveSize.h(25),
                horizontal: ResponsiveSize.w(30),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFD4956B),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ResponsiveSize.w(20)),
                  topRight: Radius.circular(ResponsiveSize.w(20)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '设置闹钟',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveSize.sp(28),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Icons.alarm,
                    color: Colors.white,
                    size: ResponsiveSize.w(28),
                  ),
                ],
              ),
            ),
            // 内容区域
            Container(
              padding: EdgeInsets.all(ResponsiveSize.w(35)),
              child: Column(
                children: [
                  _buildTimeDisplay(),
                  SizedBox(height: ResponsiveSize.h(35)),
                  _buildAudioSelector(),
                  SizedBox(height: ResponsiveSize.h(35)),
                  _buildRepeatOption(),
                ],
              ),
            ),
            // 底部按钮
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(25)),
                      ),
                      child: Text(
                        '取消',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: ResponsiveSize.sp(22),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: ResponsiveSize.h(60),
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (selectedAudio != null) {
                          Navigator.pop(context, {
                            'time': selectedTime,
                            'audioPath': selectedAudio!.path,
                            'weekdays': weekdays,
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: ResponsiveSize.h(25)),
                      ),
                      child: Text(
                        '确定',
                        style: TextStyle(
                          color: const Color(0xFFB17144),
                          fontSize: ResponsiveSize.sp(22),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeDisplay() {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(20)),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E6),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4956B).withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: const Color(0xFFD4956B),
                size: ResponsiveSize.w(20),
              ),
              SizedBox(width: ResponsiveSize.w(10)),
              Text(
                '闹钟时间',
                style: TextStyle(
                  color: const Color(0xFFD4956B),
                  fontSize: ResponsiveSize.sp(18),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.h(15)),
          GestureDetector(
            onTap: _showTimePicker,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.w(15),
                vertical: ResponsiveSize.h(10),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    selectedTime.toString().substring(11, 16),
                    style: TextStyle(
                      color: const Color(0xFFB17144),
                      fontSize: ResponsiveSize.sp(30),
                      fontWeight: FontWeight.bold,
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

  Widget _buildAudioSelector() {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(20)),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E6),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4956B).withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.music_note,
                color: const Color(0xFFD4956B),
                size: ResponsiveSize.w(20),
              ),
              SizedBox(width: ResponsiveSize.w(10)),
              Text(
                '闹钟铃声',
                style: TextStyle(
                  color: const Color(0xFFD4956B),
                  fontSize: ResponsiveSize.sp(18),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.h(15)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.w(15),
              vertical: ResponsiveSize.h(5),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ResponsiveSize.w(10)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<AudioItem>(
                value: selectedAudio,
                hint: Text(
                  '选择闹钟铃声',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ResponsiveSize.sp(16),
                  ),
                ),
                items: widget.audioList.map((audio) {
                  return DropdownMenuItem(
                    value: audio,
                    child: Text(
                      audio.title,
                      style: TextStyle(
                        color: const Color(0xFFB17144),
                        fontSize: ResponsiveSize.sp(18),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAudio = value;
                  });
                },
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFFD4956B),
                ),
                isExpanded: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepeatOption() {
    final weekdayNames = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.w(25)),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E6),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(15)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4956B).withOpacity(0.15),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.repeat,
                color: const Color(0xFFD4956B),
                size: ResponsiveSize.w(24),
              ),
              SizedBox(width: ResponsiveSize.w(10)),
              Text(
                '重复',
                style: TextStyle(
                  color: const Color(0xFFD4956B),
                  fontSize: ResponsiveSize.sp(22),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.h(20)),
          Wrap(
            spacing: ResponsiveSize.w(12),
            runSpacing: ResponsiveSize.h(12),
            children: List.generate(7, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    weekdays[index] = !weekdays[index];
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.w(20),
                    vertical: ResponsiveSize.h(10),
                  ),
                  decoration: BoxDecoration(
                    color: weekdays[index] ? const Color(0xFFD4956B) : Colors.white,
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
                    border: Border.all(
                      color: const Color(0xFFD4956B),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    weekdayNames[index],
                    style: TextStyle(
                      color: weekdays[index] ? Colors.white : const Color(0xFFB17144),
                      fontSize: ResponsiveSize.sp(18),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Future<void> _showTimePicker() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFD4956B),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFFD4956B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        final now = DateTime.now();
        selectedTime = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );
        if (selectedTime.isBefore(now)) {
          selectedTime = selectedTime.add(const Duration(days: 1));
        }
      });
    }
  }
} 