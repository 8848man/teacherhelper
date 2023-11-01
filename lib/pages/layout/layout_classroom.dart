import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tabbed_view/tabbed_view.dart';
import 'package:teacherhelper/datamodels/classroom.dart';
import 'package:teacherhelper/datamodels/image_urls.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/providers/layout_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';

class ClassroomLayout extends StatefulWidget {
  const ClassroomLayout({
    super.key,
  });

  @override
  State<ClassroomLayout> createState() => _ClassroomLayoutState();
}

class _ClassroomLayoutState extends State<ClassroomLayout> {
  late TabbedViewController _controller;
  ImageUrls imageUrls = ImageUrls();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 컨텐츠 탭 생성
    generateTabs();
    String currentDate = DateFormat('yyyy년 MM월 dd일')
        .format(DateTime.now()); // 현재 날짜를 원하는 형식으로 포맷
    // 메인컨텐츠 탭
    TabbedView tabbedView = TabbedView(controller: _controller);
    Widget w = TabbedViewTheme(
        data: TabbedViewThemeData.classic()..menu.ellipsisOverflowText = true,
        child: tabbedView);
    return Consumer2<ClassroomProvider, StudentProvider>(
        builder: (context, classroomProvider, studentProvider, child) {
      return SafeArea(
        child: Scaffold(
          appBar: _myAppBar(currentDate, classroomProvider.classroom),
          body: Row(
            children: [
              // 사이드바 컨테이너
              _myCustomSideBar(),

              // 우측 메인 박스 및 바텀 네비게이션
              Expanded(
                child: Column(
                  children: [
                    // 메인 컨텐츠 박스
                    _myContentsBox(w),

                    // 바텀 네비게이션
                    _myBottomNavigation(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // 앱바
  AppBar _myAppBar(String currentDate, Classroom classroom) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.03,
            child: Image.asset('assets/checkmark_circle.png'),
          ),
          Container(
            width: MediaQuery.sizeOf(context).width * 0.3,
            child: Text(
              'SchoolCheck',
              style: TextStyle(color: Colors.orange),
            ),
          ),
          Container(
            width: MediaQuery.sizeOf(context).width * 1 / 3,
            child: Center(
              child: Text(currentDate, style: TextStyle(color: Colors.orange)),
            ),
          ),
          Expanded(
            child: Container(
              child: Align(
                alignment: Alignment.centerRight, // Text를 오른쪽에 정렬
                child: Text(classroom.name,
                    style: TextStyle(color: Colors.orange)),
              ),
            ),
          )
        ],
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(2.0),
        child: Container(
          color: Colors.orange,
          height: 2.0,
        ),
      ),
      elevation: 0, // 그림자를 없애는 부분
    );
  }

  // 사이드바
  Widget _myCustomSideBar() {
    return Consumer<LayoutProvider>(builder: (context, layoutProvider, child) {
      List<String> sidebarImages = layoutProvider.getSidebarImages();
      return Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Color(0xFFC4C4C4), // Border 색상 설정
              width: 1.0, // Border 너비 설정
            ),
          ),
        ),
        width: 90,
        child: Column(
          children: [
            // 내 정보
            Container(
              width: 70,
              padding: EdgeInsets.all(10),
              height: MediaQuery.sizeOf(context).height * 0.1,
              color: Colors.white,
              child: GestureDetector(
                child: Image.asset(sidebarImages[0]),
                onTap: () {
                  layoutProvider.setSelected(0);
                },
              ),
            ),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
              color: Color(0xFFC4C4C4),
            ),
            // 전체 메뉴
            Container(
              width: 70,
              padding: EdgeInsets.all(10),
              height: MediaQuery.sizeOf(context).height * 0.1,
              color: Colors.white,
              child: GestureDetector(
                child: Image.asset(sidebarImages[1]),
                onTap: () {
                  layoutProvider.setSelected(1);
                },
              ),
            ),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
              color: Color(0xFFC4C4C4),
            ),
            Expanded(
              child: Column(
                children: [
                  // 일상
                  Container(
                    width: 70,
                    padding: EdgeInsets.all(10),
                    height: MediaQuery.sizeOf(context).height * 0.1,
                    color: Colors.white,
                    child: GestureDetector(
                      child: Image.asset(sidebarImages[2]),
                      onTap: () {
                        layoutProvider.setSelected(2);
                      },
                    ),
                  ),
                  // 수업
                  Container(
                    width: 70,
                    padding: EdgeInsets.all(10),
                    height: MediaQuery.sizeOf(context).height * 0.1,
                    color: Colors.white,
                    child: GestureDetector(
                      child: Image.asset(sidebarImages[3]),
                      onTap: () {
                        layoutProvider.setSelected(3);
                      },
                    ),
                  ),
                  // 통계
                  Container(
                    width: 70,
                    padding: EdgeInsets.all(10),
                    height: MediaQuery.sizeOf(context).height * 0.1,
                    color: Colors.white,
                    child: GestureDetector(
                      child: Image.asset(sidebarImages[4]),
                      onTap: () {
                        layoutProvider.setSelected(4);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
              color: Color(0xFFC4C4C4),
            ),
            // 앱 옵션 버튼
            Container(
              width: 70,
              padding: EdgeInsets.all(10),
              height: MediaQuery.sizeOf(context).height * 0.1,
              color: Colors.white,
              child: GestureDetector(
                child: Image.asset(sidebarImages[5]),
                onTap: () {
                  layoutProvider.setSelected(5);
                },
              ),
            ),
            // 로그아웃 버튼
            Container(
              width: 70,
              padding: EdgeInsets.all(10),
              height: MediaQuery.sizeOf(context).height * 0.1,
              color: Colors.white,
              child: Image.asset(sidebarImages[6]),
            ),
          ],
        ),
      );
    });
  }

  // 메인 컨텐츠 박스
  Widget _myContentsBox(Widget w) {
    return Expanded(
      child: Container(
        child: w,
        padding: EdgeInsets.all(16),
      ),
    );
  }

  // 바텀 네비게이션
  Widget _myBottomNavigation() {
    return Consumer<LayoutProvider>(builder: (context, layoutProvider, child) {
      List<String> navbarImages = layoutProvider.getNavbarImages();
      return Container(
        width: double.infinity,
        height: 90,
        color: Color(0xFF344054),
        child: Row(
          children: [
            SizedBox(
              width: 90,
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Center(
                          child: GestureDetector(
                            child: Image.asset(navbarImages[0]),
                            onTap: () {
                              layoutProvider.setSelectedBottomNav(0);
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Center(
                          child: GestureDetector(
                            child: Image.asset(navbarImages[1]),
                            onTap: () {
                              layoutProvider.setSelectedBottomNav(1);
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Center(
                          child: GestureDetector(
                            child: Image.asset(navbarImages[2]),
                            onTap: () {
                              layoutProvider.setSelectedBottomNav(2);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Image.asset(
                    'assets/icons_for_bottomnav/dailys/plus_button.png'),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Center(
                          child: GestureDetector(
                            child: Image.asset(navbarImages[3]),
                            onTap: () {
                              layoutProvider.setSelectedBottomNav(3);
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Center(
                          child: GestureDetector(
                            child: Image.asset(navbarImages[4]),
                            onTap: () {
                              layoutProvider.setSelectedBottomNav(4);
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Center(
                          child: GestureDetector(
                            child: Image.asset(navbarImages[5]),
                            onTap: () {
                              layoutProvider.setSelectedBottomNav(5);
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 90),
                  ],
                ),
              ),
            ),
            Container(
              width: 90,
              child: Image.asset(navbarImages[6]),
            ),
          ],
        ),
      );
    });
  }

  // 컨텐츠 탭 생성 함수(컨텐츠 박스 위젯을 위해 필요함)
  void generateTabs() {
    // 변수 초기화
    List<TabData> tabs = [];

    // 컨텐츠 탭 생성
    for (int i = 1; i <= 3; i++) {
      tabs.add(
        TabData(
          text: 'Tab number is $i',
          leading: (context, status) => const Icon(Icons.star, size: 16),
          content: contentsWidget(),
        ),
      );
    }

    _controller = TabbedViewController(tabs);
  }

  // 컨텐츠박스 내부 위젯
  Widget contentsWidget() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(color: Colors.amber),
        ),
        Expanded(
          flex: 4,
          child: Container(
            color: Colors.orange,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 500,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0), // 둥근 테두리 설정
                  border: Border.all(
                      width: 1.0, color: Colors.black), // 테두리 선 스타일 설정
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          '활동지 완료',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      //체크박스 넣을 공간
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                            height: 50, width: 50, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // 학생들 정렬
        Expanded(
          flex: 15,
          child: Container(
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(70, 15, 70, 15),
              child: Container(
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
