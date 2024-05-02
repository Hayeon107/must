import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/View/LearningView/MeaningQuizView.dart';
import 'package:must/View/LearningView/SequenceQuizView.dart';
import 'package:must/View/LearningView/SoundQuizView.dart';
import 'package:must/View/WordBookView/WordBookView.dart';
import 'package:must/style.dart' as myStyle;
import 'package:must/View/Widget/LearningWidget.dart';
import 'package:must/View/Widget/SongDetailCardAPI.dart';

import '../../data/json2.dart';
import '../../data/searchJson.dart';

class SongDetailView extends StatefulWidget {
  SongDetailView({required this.song, required this.thumbnail,super.key});

  SearchSong song;
  var thumbnail;

  @override
  State<SongDetailView> createState() => _SongDetailViewState(song: song, thumbnail: thumbnail);
}

class _SongDetailViewState extends State<SongDetailView> {
  _SongDetailViewState({required this.song, required this.thumbnail});
  SearchSong song;
  var thumbnail;
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: myStyle.mainColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.h),
        child: Column(
          children: [
            SongDetailCardAPI(song: song,thumbnail: thumbnail,),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "학습하기",
                  style: myStyle.textTheme.bodyLarge,
                ),
                Row(
                  children: [
                    Text("아는 단어 제외"),
                    Switch(
                      activeColor: myStyle.mainColor,
                      value: _isChecked,
                      onChanged: (value) {
                        setState(
                              () {
                            _isChecked = value;
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LearningWidget(
                      content: '단어장',
                      comment: '노래에 등장하는 단어들을 확인합니다',
                      moveTo: WordBookView(),
                    ),
                    LearningWidget(
                      content: '단어 퀴즈 - 뜻 맞추기',
                      comment: '단어를 보고 한국어 뜻을 골라주세요',
                      moveTo: MeaningQuizView(),
                    ),
                    LearningWidget(
                      content: '단어 퀴즈 - 발음 맞추기',
                      comment: '단어를 보고 알맞은 발음을 골라주세요',
                      moveTo: SoundQuizView(),
                    ),
                    LearningWidget(
                      content: '순서맞추기',
                      comment: '뜻을 보고 문장의 순서를 맞춰주세요',
                      moveTo: SequenceQuizView(),
                    ),
                    Text("가사",style: myStyle.textTheme.bodyLarge,),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5.w),
                      child: Text(song.lyrics.replaceAll('\\n', '\n'), style: TextStyle(fontSize: 13.sp, height: 1.5),),
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
}