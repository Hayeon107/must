import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:must/View/EnrollView/PerformEnroll.dart';
import 'package:must/View/HomeView/LevelView.dart';
import 'package:must/View/SongDetailView/SongDetailView.dart';
import 'package:must/style.dart' as myStyle;
import '../../data/api_service.dart';
import '../../data/searchJson.dart';
import '../mainView.dart';
import 'package:http/http.dart' as http;

class PerformEnroll extends StatefulWidget {
  PerformEnroll({required this.song, required this.thumbnail, super.key});

  SearchSong song;
  var thumbnail;

  @override
  State<PerformEnroll> createState() => _PerformEnrollState();
}

class _PerformEnrollState extends State<PerformEnroll> {
  bool isLoading = true; // 로딩 상태 변수 추가

  @override
  void initState() {
    super.initState();
    _enrollSong();
  }

  void _enrollSong() async {
    await enrollSongData(widget.song.songId, widget.song.bugsId);
    setState(() {
      isLoading = false; // 로딩 상태 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: myStyle.mainColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50.h),
          isLoading
              ? Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20.h),
              Text(
                "등록 중입니다...",
                style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: 'NotoSansCJK',
                    fontWeight: FontWeight.w600,
                    color: myStyle.mainColor),
              ),
            ],
          )
              : Column(
            children: [
              Text(
                "등록이 완료되었습니다.",
                style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: 'NotoSansCJK',
                    fontWeight: FontWeight.w600,
                    color: myStyle.mainColor),
              ),
              SizedBox(height: 7.h),
              InkWell(
                onTap: () {
                  Get.to(() => SongDetailView(
                      song: widget.song, thumbnail: widget.thumbnail));
                },
                child: Text(
                  "학습 바로가기 >",
                  style:
                  TextStyle(color: myStyle.mainColor, fontSize: 17.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          SizedBox(
            child: widget.thumbnail != null
                ? Image.memory(widget.thumbnail,
                width: 150.w, fit: BoxFit.cover)
                : Container(width: 150.w, height: 150.h, color: Colors.grey),
          ),
          Text(widget.song.title,
              style: myStyle.textTheme.titleMedium,
              textAlign: TextAlign.center),
          Text(widget.song.artist, style: myStyle.textTheme.labelMedium),
          SizedBox(height: 50.h),
          InkWell(
            onTap: () {
              Get.offAll(() => MainView());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home, color: myStyle.mainColor, size: 18.h),
                Text(
                  "홈으로",
                  style: TextStyle(
                      fontFamily: 'NotoSansCJK',
                      fontWeight: FontWeight.w600,
                      color: myStyle.mainColor,
                      fontSize: 18.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}