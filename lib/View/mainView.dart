import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:must/View/LearningView/SequenceQuizView.dart';
import 'package:must/style.dart' as myStyle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../data/api_service.dart';
import '../data/musicjson.dart';
import '../data/searchJson.dart';
import 'BookMarkView.dart';
import 'HomeView/HomeView.dart';
import 'LearningView/TempSequenceQuizView.dart';
import 'MySettingView.dart';
import 'SearchView/SearchView.dart';
import 'WordBookView/WordBookView.dart';

class MainView extends StatefulWidget {

  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;
  final TextEditingController _searchQueryController = TextEditingController();
  final FocusNode _searchFocusNode =
      FocusNode(); // 검색 TextField를 위한 FocusNode 추가


  final List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    WordBookView(),
    BookMarkView(),
    // const MySettingView(),
  ];

  @override
  void initState() {
    super.initState();
    if (_selectedIndex < 0 || _selectedIndex >= _widgetOptions.length) {
      _selectedIndex = 0; // 기본값으로 초기화
    }
  }

  @override
  void dispose() {
    _searchQueryController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void moveFromHome(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSearchPressed() {
    if (_searchQueryController.text.isNotEmpty) {
      String query = _searchQueryController.text;
      print("query is $query");
      Get.to(()=>SearchView(query:query));
      //변경 전 검색등록
      // Get.to(()=>TempSearchView(query:query));
    } else {
      // TextField가 비어있다면 포커스를 줍니다.
      print("empty");
      FocusScope.of(context).requestFocus(_searchFocusNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 15.h,
              child: const Image(
                  image: AssetImage('assets/logo_1.png'),
                  fit: BoxFit.fitHeight),
            ),
            SizedBox(
              width: 10.w,
            ),
            Flexible(
              child: TextField(
                controller: _searchQueryController,
                autofocus: false,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  isDense: true,
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: myStyle.mainColor, width: 1.0), // 활성 상태일 때 보더 없앰
                  ),
                ),
                onSubmitted: (query) {
                  // 검색어 처리 로직
                },
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                size: 25.h,
                color: myStyle.mainColor,
              ),
              onPressed: _onSearchPressed,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: myStyle.basicGray,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.sticky_note_2_outlined), label: '단어장'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: '마크'),
          // BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 설정'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: myStyle.mainColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
