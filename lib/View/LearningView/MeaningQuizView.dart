import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:must/View/LearningView/QuizEndView.dart';
import 'package:must/style.dart' as myStyle;
import 'dart:math';
import '../../data/api_service.dart';
import '../../data/MeaningQuizParsing.dart';

import 'package:http/http.dart' as http;

class MeaningQuizView extends StatefulWidget {
  MeaningQuizView({required this.songId, required this.setNum, super.key});
  final int songId;
  final int setNum;

  @override
  State<MeaningQuizView> createState() => _MeaningQuizViewState();
}

class _MeaningQuizViewState extends State<MeaningQuizView> {
  final FlutterTts tts = FlutterTts();
  List<MeanQuiz> quizzes = []; //퀴즈 리스트
  int currentQuizIndex = 0; //현재 퀴즈 번호
  late String question; //문제
  late String answers; //답
  late List<String> choices; // 보기
  late int correctIndex; //정답
  late int selectedIndex; //고른인덱스
  String resultMessage = ''; //결과멘트
  String submitMent = '';  // 제출멘트
  late Color submitButtonColor; //선택버튼색
  int correctCnt = 0;
  bool end = false; //마지막

  @override
  void initState() {
    super.initState();
    question = '질문을 불러오는 중...'; // 초기 질문 값 설정
    choices = []; // 초기 옵션 리스트
    correctIndex = 0; // 초기 정답 인덱스
    selectedIndex = -1; // 초기 선택 인덱스
    submitButtonColor = myStyle.basicGray; // 초기 버튼 색상
    tts.setLanguage("ja-JP");
    tts.setSpeechRate(0.4); // 음성 속도 설정
    tts.setVolume(1.0); // 볼륨 설정
    tts.setPitch(1.0); // 음조 설정
    loadQuizData(); // 퀴즈 데이터 로드
  }

  void loadQuizData() async {
    await getQuiz(); // 퀴즈 데이터 로드
    setState(() {}); // 상태 업데이트
  }

  Future<void> getQuiz() async {
    quizzes = await getMeanQuizSet(widget.setNum, widget.songId);  // 클래스 레벨의 quizzes를 직접 업데이트
    print("Loaded ${quizzes.length} quizzes."); // 로드된 퀴즈의 수 로깅
    if (quizzes.isNotEmpty) {
      for (var quiz in quizzes) {
        // answers를 choices에 추가하고 랜덤으로 섞습니다.
        quiz.choices.add(quiz.answers[0]);
        quiz.choices.shuffle(Random());
      }
      updateQuizDisplay(0); // 첫 번째 퀴즈로 시작
    } else {
      print('Quiz data is empty');
    }
  }

  void updateQuizDisplay(int index) {
    if (quizzes.isNotEmpty) {  // 리스트가 비어 있지 않은지 확인
      setState(() {
        currentQuizIndex = index;
        question = quizzes[index].word;
        choices = quizzes[index].choices;
        answers = quizzes[index].answers[0];
        correctIndex = quizzes[index].choices.indexOf(answers); // 정답의 새로운 인덱스 찾기
        selectedIndex = -1;
        resultMessage = '';
        submitMent = "제출하기";
        submitButtonColor = myStyle.basicGray;
      });
    } else {
      print('Quiz data is empty');  // 로그를 남기거나 사용자에게 알림
    }
  }

  void endQuiz() async{
    await saveWord(1, widget.songId);
  }

  void submitAnswer() {
    if (selectedIndex == -1 || resultMessage.isNotEmpty) {
      // Avoid multiple submissions or no selection
      return;
    }

    setState(() {
      if (selectedIndex == correctIndex) {
        resultMessage = '정답입니다!';
        submitButtonColor = myStyle.pointColor;
        correctCnt++;
      } else {
        resultMessage = '오답입니다. 정답: $answers';
        submitButtonColor = myStyle.mainColor; // Assuming you have a color set for errors
      }

      // Always allow moving to the next question after a submission
      if (currentQuizIndex < quizzes.length - 1) {
        submitMent = "다음으로";
      } else {
        submitMent = "퀴즈 끝";
        end = true; // It's the last quiz
      }
    });
  }

  Widget optionButton(String option, int index) {
    return InkWell(
      onTap: end ? () {} : () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: selectedIndex == index ? myStyle.mainColor : Colors.white,
          border: Border.all(color: myStyle.mainColor),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(
            option,
            style: selectedIndex == index
                ? myStyle.textTheme.headlineMedium
                : myStyle.textTheme.labelMedium,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "의미 퀴즈",
          style: myStyle.textTheme.labelMedium,
        ),
        backgroundColor: Colors.white,
        foregroundColor: myStyle.mainColor,
      ),
      body: quizzes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : buildQuizBody(),
    );
  }

  Widget buildQuizBody() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.h),
      child: Column(
        children: [
          Text(
            '$currentQuizIndex/${quizzes.length}',
            style: myStyle.textTheme.bodyMedium,
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    question,
                    style: myStyle.textTheme.titleLarge,
                  ),
                  // TextButton(
                  //   onPressed: () => tts.speak("ははは"),
                  //   child: Text(
                  //     '읽기',
                  //     style: TextStyle(color: Colors.blue),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(resultMessage, style: myStyle.textTheme.bodyMedium),
                ),
                ...choices.asMap().entries.map((entry) {
                  int idx = entry.key;
                  String val = entry.value;
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 20.w),
                    child: optionButton(val, idx),
                  );
                }).toList(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 20.w),
                  child: InkWell(
                    onTap: () {
                      if (submitMent == "다음으로" || submitMent == "퀴즈 끝") {
                        if (currentQuizIndex < quizzes.length - 1) {
                          updateQuizDisplay(currentQuizIndex + 1); // Move to the next question
                        } else {
                          // 퀴즈가 끝났을 때
                          Get.until((route) => Get.previousRoute == '/'); // 스택에서 두 개의 화면 제거
                          Get.to(() => QuizEndView(correctCnt: correctCnt));
                          // Get.offAll(() => QuizEndView(correctCnt: correctCnt,));
                        }
                      } else {
                        submitAnswer();
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: submitButtonColor,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                        child: Text(
                          submitMent, style: myStyle.textTheme.headlineMedium,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
