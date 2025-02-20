import 'package:flutter/material.dart';
import '../../../utils/responsive_size.dart';

class PointsRuleDialog extends StatelessWidget {
  const PointsRuleDialog({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveSize.w(20)),
      ),
      child: Container(
        width: ResponsiveSize.w(600),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/pointrulebg.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(ResponsiveSize.w(20))),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: ResponsiveSize.h(30)),
                child: Container(
                  width: double.infinity,
                  height: ResponsiveSize.h(70),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/recordtitle.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: ResponsiveSize.h(25)),
                      child: Text(
                        '积分规则',
                        style: TextStyle(
                          fontSize: ResponsiveSize.sp(24),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: const [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(ResponsiveSize.w(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuestionSection(
                      'Q1 什么是积分?',
                      '积分是体现学员综合成就的计数方式，包括学员APP使用成就(获得的星星，红花，奖章)以及老师的直接鼓励(老师所赠送积分)。'
                    ),
                    SizedBox(height: ResponsiveSize.h(15)),
                    _buildQuestionSection(
                      'Q2 什么是可兑积分?',
                      '学员积分可以用来兑换精美奖品，可兑积分就是积分减去兑奖所花积分后的剩余积分。'
                    ),
                    SizedBox(height: ResponsiveSize.h(15)),
                    _buildQuestionSection(
                      'Q3 学员怎样获取积分?',
                      '''1.老师可以根据学员线上线下的各种突出表现直接奖励积分。老师每天仅可对单个学员赠送一次积分，积分范围是1-15。

2.100颗星星对应1个积分;50朵红花对应1个积分;5个奖章对应1个积分

1)如何获得星星:(每天可获得的星星上限800)
a)听一篇课文或完成一次听力练习，即可获得5颗星星;
b)阅读一篇课文或完成一次阅读练习，即可获得20颗星星;
c)录音一篇课文或完成一次录音练习，即可获得30颗星星;
d)自主创作一个创作作品或完成一次创作练习，即可获得30颗星星;
e)自主学习完成一次课文习题或完成一次课文习题练习，即可获得30颗星星;
f)自主学习完成一次试卷或完成一次试卷练习，即可获得30颗星星;
g)自主学习完成一次视频配音或完成一次视频配音练习，即可获得30颗星星;
h)参与一次线上直播课，即可获得30颗星星;
i)完成一次AI真人对话练习，即可获得30颗星星;
j)完成一次单词闯关，即可获得30颗星星。'''
                    ),
                    SizedBox(height: ResponsiveSize.h(15)),
                    _buildQuestionSection(
                      'Q4 老师(或管理员)能否直接创建兑奖记录，如何使用?',
                      '老师(或管理员)在"兑奖记录"页里点击"创建"按钮可直接创建兑奖记录。不通过学员预先发起兑奖请求，而由老师直接选择学员，所获奖品，发奖时间等信息来创建兑奖记录，作为当前各种线下发奖场景的一种简便记录方式。'
                    ),
                    SizedBox(height: ResponsiveSize.h(15)),
                    _buildQuestionSection(
                      'Q5 学员获取积分是否有限制?',
                      '为了公平性及防止刷分，系统将跟踪学员每日获得积分，过滤掉不合理的刷分行为，上限为学员每天最多获得800个星星，500朵红花。'
                    ),
                    SizedBox(height: ResponsiveSize.h(20)),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          '确定',
                          style: TextStyle(
                            fontSize: ResponsiveSize.sp(20),
                            color: Colors.blue,
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
      ),
    );
  }

  Widget _buildQuestionSection(String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveSize.w(10)),
          decoration: BoxDecoration(
            color: Colors.blue.shade50.withOpacity(0.8),
            borderRadius: BorderRadius.circular(ResponsiveSize.w(8)),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Text(
            question,
            style: TextStyle(
              fontSize: ResponsiveSize.sp(18),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(height: ResponsiveSize.h(10)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(10)),
          child: Text(
            answer,
            style: TextStyle(
              fontSize: ResponsiveSize.sp(16),
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}