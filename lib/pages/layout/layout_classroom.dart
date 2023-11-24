import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tabbed_view/tabbed_view.dart';
import 'package:teacherhelper/datamodels/classes.dart';
import 'package:teacherhelper/datamodels/classroom.dart';
import 'package:teacherhelper/datamodels/daily.dart';
import 'package:teacherhelper/datamodels/image_urls.dart';
import 'package:teacherhelper/datamodels/new_student.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/providers/classes_provider.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/providers/daily_provider.dart';
import 'package:teacherhelper/providers/layout_provider.dart';
import 'package:teacherhelper/providers/loading_provider.dart';
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

  late List<int> selectedIndex;
  late List<Daily> dailys;
  late List<Classes> classes;

  late Classroom classroom;

  bool dataFetched = false;

  @override
  void initState() {
    super.initState();
    getDatas();
  }

  void getDatas() async {
    Provider.of<LoadingProvider>(context, listen: false).setLoading(true);
    final classroomProvider =
        Provider.of<ClassroomProvider>(context, listen: false);
    final studentProvider =
        Provider.of<StudentProvider>(context, listen: false);
    final dailyProvider = Provider.of<DailyProvider>(context, listen: false);
    final classesProvider =
        Provider.of<ClassesProvider>(context, listen: false);

    final layoutProvider = Provider.of<LayoutProvider>(context, listen: false);
    final classroomId = classroomProvider.classroom.uid!;

    classroom = classroomProvider.classroom;
    // 데이터들 가져오기
    dailyProvider.getDailyLayout(classroomId, thisDate);

    // classesProvider.getClassesLayout(classroomId, thisDate);

    // layoutProvider 데이터들 가져오기
    layoutProvider.getNewStudentsByClassroomId(classroomId);

    studentProvider.getStudentsByClassroomLayout(classroomId);

    Provider.of<LoadingProvider>(context, listen: false).setLoading(false);
  }
  // List<Daily> getDailys(String classroomId, DailyProvider dailyProvider) async {
  //   List<Daily> dailyList =
  //       await dailyProvider.getDailyLayout(classroomId, thisDate);
  //   return dailyList;
  // }

  @override
  Widget build(BuildContext context) {
    final dailyProvider = Provider.of<DailyProvider>(context, listen: true);
    final layoutProvider = Provider.of<LayoutProvider>(context, listen: true);
    final classesProvider = Provider.of<ClassesProvider>(context, listen: true);
    final studentProvider = Provider.of<StudentProvider>(context, listen: true);

    selectedIndex = layoutProvider.selectedIndices;
    dailys = dailyProvider.dailys;
    classes = classesProvider.classes;
    print('build Dailys is $dailys');
    generateTabs(
        dailys, classes, selectedIndex, studentProvider, layoutProvider);

    Future<bool> myDialog() async {
      bool returnValue = false;
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('생활/수업 삭제'),
            content: const Text('생활 또는 수업을 삭제하시겠습니까?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  returnValue = true;
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return returnValue;
    }

    bool _tabCloseInterceptor(int tabIndex) {
      bool isDelete = false;
      myDialog().then((result) {
        isDelete = result;

        if (isDelete == true) {
          print('The tab $tabIndex is busy and cannot be closed.');

          print('$tabIndex가 삭제됨');
          return isDelete;
        } else {
          print('삭제되지 않음');
          return isDelete;
        }
      });
      print('final isDelete is $isDelete');
      return isDelete;
    }

    String currentDate =
        DateFormat('yyyy년 MM월 dd일').format(thisDate); // 현재 날짜를 원하는 형식으로 포맷
    TabbedView tabbedView = TabbedView(
      controller: _controller,
      tabCloseInterceptor: _tabCloseInterceptor,
      // onTabSelection: _onTabSelection
    );
    Widget w = TabbedViewTheme(
      data: TabbedViewThemeData.classic()..menu.ellipsisOverflowText = true,
      child: tabbedView,
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: // 컨텐츠 탭 생성
          Stack(
        children: [
          SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: _myAppBar(currentDate, classroom),
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
          ),
        ],
      ),
    );
  }

  // 앱바
  AppBar _myAppBar(String currentDate, Classroom classroom) {
    return AppBar(
      automaticallyImplyLeading: false,
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
                        // generateTabs(dailys, classes, selectedIndex);
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
    return Consumer5<LayoutProvider, DailyProvider, ClassesProvider,
            ClassroomProvider, StudentProvider>(
        builder: (context, layoutProvider, dailyProvider, classesProvider,
            classroomProvider, studentProvider, child) {
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
                  onTap: () async {
                    if (layoutProvider.selectedIndices[2] == 1) {
                      setState(() {
                        Provider.of<LoadingProvider>(context, listen: false)
                            .setLoading(true);
                      });
                      await layoutProvider.createDailyLayout(
                          thisDate,
                          classroomProvider.classroom.uid!,
                          studentProvider.students);
                      setState(() {
                        Provider.of<LoadingProvider>(context, listen: false)
                            .setLoading(false);
                      });
                    } else if (layoutProvider.selectedIndices[3] == 1) {
                      // setState(() {
                      //   isLoading = true;
                      // });

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
    StudentProvider studentProvider,
    LayoutProvider layoutProvider,
  ) {
    // 변수 초기화
    List<TabData> tabs = [];
    int tabCounts = 0;
    List<Map<String, dynamic>> tabDatas = [];

    List<Student> students = studentProvider.students;
    List<NewStudent> newStudents = layoutProvider.newStudents;
    // List<StudentWithDaily> studentWithDaily =

    // 사이드탭이 일상일 경우의 탭 설정
    if (selectedIndex[2] == 1) {
      for (var daily in dailys) {
        tabDatas.add({
          'data': daily,
          'name': daily.name,
          'kind': 'daily',
          'students': students
        });
      }
    }
    // 사이드탭이 수업일 경우의 탭 설정
    else if (selectedIndex[3] == 1) {
      for (var classes in classes) {
        tabDatas.add({
          'data': classes,
          'name': classes.name,
          'kind': 'classes',
          'students': students
        });
      }
    }
    // 데이터가 없을 경우 처리
    if (tabDatas.isEmpty) {
      tabDatas.add({
        'data': null,
        'name': '추가하기',
        'kind': 'noData',
        'students': students
      });
    }

    // 컨텐츠 탭 생성
    for (int i = 0; i < tabDatas.length; i++) {
      tabs.add(
        TabData(
          text: tabDatas[i]['name'],
          leading: (context, status) => const Icon(Icons.star, size: 16),
          content: contentsWidget(tabDatas[i]),
        ),
      );
    }
    _controller = TabbedViewController(tabs);
  }

  // 컨텐츠박스 내부 위젯
  Widget contentsWidget(Map<String, dynamic> data) {
    TextEditingController textController =
        TextEditingController(text: data['name']);
    return Consumer5<LayoutProvider, DailyProvider, ClassesProvider,
            StudentProvider, ClassroomProvider>(
        builder: (context, layoutProvider, dailyProvider, classesProvider,
            studentProvider, classroomProvider, child) {
      final List<Student> students = data['students'];
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
                        Align(
                          alignment: Alignment.center,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: textController,
                            style: const TextStyle(fontSize: 30),
                            decoration: const InputDecoration(
                              hintText: '수정하고싶은 이름 입력',
                              border: InputBorder.none, // 밑줄 제거
                              focusedBorder:
                                  InputBorder.none, // 포커스된 상태에서 밑줄 제거
                            ),
                          ),
                        ),
                        //체크박스 넣을 공간
                        Align(
                          alignment: Alignment.centerRight,
                          // child: Container(
                          //     height: 50, width: 50, color: Colors.blue),
                          child: Image.asset('assets/buttons/check_button.png'),
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
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.7,
                        maxHeight: MediaQuery.of(context).size.height * 0.7,
                      ),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: students.length >= 20 ? 10 : 5,
                          crossAxisSpacing: students.length >= 20
                              ? MediaQuery.of(context).size.width * 0.018
                              : 100,
                          mainAxisSpacing: students.length >= 20
                              ? MediaQuery.of(context).size.height * 0.03
                              : 100,
                        ),
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          final student = students[index];
                          return Card(
                            color: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10000.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(student.studentNumber!),
                                Text(student.name),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
