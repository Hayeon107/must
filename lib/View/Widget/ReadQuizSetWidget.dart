import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/style.dart' as myStyle;

import '../../data/api_service.dart';
import '../LearningView/ReadQuizView.dart';

class ReadQuizSetWidget extends StatefulWidget {
  ReadQuizSetWidget({
    required this.content,
    required this.comment,
    required this.songId,
    super.key,
  });

  final String content;
  final String comment;
  final int songId;

  @override
  State<ReadQuizSetWidget> createState() => _ReadQuizSetWidgetState();
}

class _ReadQuizSetWidgetState extends State<ReadQuizSetWidget> {
  @override
  void initState() {
    super.initState();
  }


  void loadQuizData() async {
    print('Loading quiz data for songId: ${widget.songId}');
    var quizSet = await fetchReadQuizData(widget.songId);
    print('Quiz data fetched: ${quizSet.toString()}');
    if (quizSet.success) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("퀴즈 세트"),
            content: Container(
              constraints: BoxConstraints(
                maxHeight: 400.0, // 최대 높이를 설정하여 overflow 방지
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  quizSet.setNum - 1,
                  (index) => ListTile(
                    title: Text('퀴즈 ${index + 1}'),
                    onTap: () {
                      Navigator.of(context).pop(); // AlertDialog 닫기
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReadQuizView(
                            songId: widget.songId,
                            setNum: index + 1,
                          ), // 상세 페이지로 이동
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                child: Text('닫기'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    } else {
      createQuiz('READING',widget.songId);
      print(widget.songId);
      print("create quizSet");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        loadQuizData();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 2.w),
        child: Row(
          children: [
            Icon(
              Icons.circle_outlined,
              color: myStyle.mainColor,
              size: 30.h,
            ),
            SizedBox(
              width: 10.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.content,
                  style: myStyle.textTheme.bodySmall,
                ),
                Text(
                  widget.comment,
                  style: myStyle.textTheme.displaySmall,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
