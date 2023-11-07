import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tabbed_view/tabbed_view.dart';
import 'package:teacherhelper/datamodels/classes.dart';
import 'package:teacherhelper/datamodels/classroom.dart';
import 'package:teacherhelper/datamodels/daily.dart';
import 'package:teacherhelper/datamodels/image_urls.dart';
import 'package:teacherhelper/providers/classes_provider.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/providers/daily_provider.dart';
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
  // 날짜 통제 변수
  DateTime thisDate = DateTime.now();

  bool dataFetched = false;

  @override
  void initState() {
    super.initState();
    final classroomProvider =
        Provider.of<ClassroomProvider>(context, listen: false);
    final studentProvider =
        Provider.of<StudentProvider>(context, listen: false);
    final dailyProvider = Provider.of<DailyProvider>(context, listen: false);
    final classesProvider =
        Provider.of<ClassesProvider>(context, listen: false);

    final classroomId = classroomProvider.classroom.uid!;
    // 데이터들 가져오기
    dailyProvider.getDailyLayout(classroomId, thisDate);

    // classesProvider.getClassesLayout(classroomId, thisDate);
    studentProvider.getStudentsByClassroomLayout(classroomId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer5<ClassroomProvider, StudentProvider, DailyProvider,
            ClassesProvider, LayoutProvider>(
        builder: (context, classroomProvider, studentProvider, dailyProvider,
            classesProvider, layoutProvider, child) {
      List<int> selectedIndex = layoutProvider.selectedIndices;
      List<Daily> dailys = dailyProvider.dailys;
      List<Classes> classes = classesProvider.classes;
      // 컨텐츠 탭 생성
      generateTabs(dailys, classes, selectedIndex);
      String currentDate =
          DateFormat('yyyy년 MM월 dd일').format(thisDate); // 현재 날짜를 원하는 형식으로 포맷
      // 메인컨텐츠 탭
      TabbedView tabbedView = TabbedView(controller: _controller);
      Widget w = TabbedViewTheme(
          data: TabbedViewThemeData.classic()..menu.ellipsisOverflowText = true,
          child: tabbedView);
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
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.3,
            child: const Text(
              'SchoolCheck',
              style: TextStyle(color: Colors.orange),
            ),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 1 / 3,
            child: Center(
              child: Text(currentDate,
                  style: const TextStyle(color: Colors.orange)),
            ),
          ),
          Expanded(
            child: Container(
              child: Align(
                alignment: Alignment.centerRight, // Text를 오른쪽에 정렬
                child: Text(classroom.name,
                    style: const TextStyle(color: Colors.orange)),
              ),
            ),
          )
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2.0),
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
        decoration: const BoxDecoration(
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
              padding: const EdgeInsets.all(10),
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
              padding: const EdgeInsets.all(10),
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
                    padding: const EdgeInsets.all(10),
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
                    padding: const EdgeInsets.all(10),
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
                    padding: const EdgeInsets.all(10),
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
              padding: const EdgeInsets.all(10),
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
              padding: const EdgeInsets.all(10),
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
        padding: const EdgeInsets.all(16),
        child: w,
      ),
    );
  }

  // 바텀 네비게이션
  Widget _myBottomNavigation() {
    return Consumer4<LayoutProvider, DailyProvider, ClassesProvider,
            ClassroomProvider>(
        builder: (context, layoutProvider, dailyProvider, classesProvider,
            classroomProvider, child) {
      List<String> navbarImages = layoutProvider.getNavbarImages();
      return Container(
        width: double.infinity,
        height: 90,
        color: const Color(0xFF344054),
        child: Row(
          children: [
            const SizedBox(
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
                child: GestureDetector(
                  child: Image.asset(
                      'assets/icons_for_bottomnav/dailys/plus_button.png'),
                  onTap: () {
                    if (layoutProvider.selectedIndices[2] == 1) {
                      layoutProvider.createDailyLayout(
                          thisDate, classroomProvider.classroom.uid!);
                    } else if (layoutProvider.selectedIndices[3] == 1) {
                      print('수업 추가');
                    }
                  },
                ),
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
                    const SizedBox(width: 90),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 90,
              child: Image.asset(navbarImages[6]),
            ),
          ],
        ),
      );
    });
  }

  // 컨텐츠 탭 생성 함수(컨텐츠 박스 위젯을 위해 필요함)
  void generateTabs(
    List<Daily> dailys,
    List<Classes> classes,
    List<int> selectedIndex,
  ) {
    StudentProvider studentProvider =
        Provider.of<StudentProvider>(context, listen: false);

    // 변수 초기화
    List<TabData> tabs = [];
    List<String> tabNames = [];
    int tabCounts = 0;
    List<Map<String, dynamic>> tabDatas = [];

    // 사이드탭이 일상일 경우의 탭 설정
    if (selectedIndex[2] == 1) {
      for (Daily daily in dailys) {
        tabDatas.add({'data': daily, 'name': daily.name, 'kind': 'daily'});
      }
    }
    // 사이드탭이 수업일 경우의 탭 설정
    else if (selectedIndex[3] == 1) {
      for (Classes classes in classes) {
        tabDatas
            .add({'data': classes, 'name': classes.name, 'kind': 'classes'});
      }
    } else {}
    // 데이터가 없을 경우 처리
    if (tabNames.isEmpty) {
      tabDatas.add({'data': null, 'name': '추가하기', 'kind': 'noData'});
    }

    // 컨텐츠 탭 생성
    for (int i = 0; i < tabDatas.length; i++) {
      tabs.add(
        TabData(
          text: tabDatas[i]['name'],
          leading: (context, status) => const Icon(Icons.star, size: 16),
          content: tabDatas.isEmpty
              ? contentsWidget('')
              : contentsWidget(tabDatas[i]),
        ),
      );
    }
    _controller = TabbedViewController(tabs);
  }

  // 컨텐츠박스 내부 위젯
  Widget contentsWidget(var data) {
    return Consumer5<LayoutProvider, DailyProvider, ClassesProvider,
            StudentProvider, ClassroomProvider>(
        builder: (context, layoutProvider, dailyProvider, classesProvider,
            studentProvider, classroomProvider, child) {
      print('1nowFetched is $dataFetched');
      // List<Daily> dailys = dailyProvider.dailys;
      // List<Classes> classes = classesProvider.classes;
      if (data['kind'] == 'daily' && dataFetched == false) {
        dailyProvider.getDailyLayout(
            classroomProvider.classroom.uid!, thisDate);
        print('2nowFetched is $dataFetched');
        dataFetched = true;
        print('3nowFetched is $dataFetched');
      }
      // dataFetched = false;
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
                        const Align(
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
    });
  }
}
