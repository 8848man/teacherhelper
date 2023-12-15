import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tabbed_view/tabbed_view.dart';
import 'package:teacherhelper/datamodels/classroom.dart';
import 'package:teacherhelper/datamodels/student_with_data.dart';
import 'package:teacherhelper/widgets/layout_app_bar.dart';
import 'package:teacherhelper/providers/loading_provider.dart';
import 'package:teacherhelper/providers/new_layout_provider.dart';
import 'package:teacherhelper/providers/new_lesson_provider.dart';
import 'package:teacherhelper/providers/new_student_provider.dart';

import '../../datamodels/lesson.dart';
import '../../datamodels/new_daily.dart';
import '../../datamodels/new_student.dart';
import '../../providers/new_classroom_provider.dart';
import '../../providers/new_daily_provider.dart';
import '../../widgets/layout_bottom_navigation.dart';
import '../../widgets/layout_contents_widget.dart';
import '../../widgets/layout_sidebar.dart';

class NewLayoutClassroom extends StatefulWidget {
  const NewLayoutClassroom({
    super.key,
  });

  @override
  State<NewLayoutClassroom> createState() => _NewLayoutClassroomState();
}

class _NewLayoutClassroomState extends State<NewLayoutClassroom> {
  User? user = FirebaseAuth.instance.currentUser;
  late TabbedViewController _controller;
  // 날짜 통제 변수
  DateTime thisDate = DateTime.now();

  late List<int> selectedIndex;
  late List<int> selectedBottomNavIndices;
  List<StudentWithData> studentsWithData = [];
  late List<NewDaily> dailys;
  late Classroom classroom;

  late String classroomId;
  bool dataFetched = false;

  @override
  void initState() {
    super.initState();
    // getDatas();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   getDatas();
  // }

  Future<void> getDatasFromDB() async {
    DateTime thisDate = DateTime.now();
    final newLayoutProvider =
        Provider.of<NewLayoutProvider>(context, listen: false);
    final classroomProvider =
        Provider.of<NewClassroomProvider>(context, listen: false);
    final studentProvider =
        Provider.of<NewStudentProvider>(context, listen: false);
    final dailyProvider = Provider.of<NewDailyProvider>(context, listen: false);
    final lessonProvider =
        Provider.of<NewLessonProvider>(context, listen: false);

    await studentProvider.getStudentsByClassroomId(classroomId);
    await dailyProvider.getDailysByClassroomId(classroomId, thisDate);
  }

  Future<void> getDatas() async {
    // 서버에서 데이터 프로바이더로 할당

    // Provider.of<LoadingProvider>(context, listen: false).setLoading(true);
    final newLayoutProvider =
        Provider.of<NewLayoutProvider>(context, listen: false);
    final classroomProvider =
        Provider.of<NewClassroomProvider>(context, listen: false);
    final studentProvider =
        Provider.of<NewStudentProvider>(context, listen: false);

    classroomId = classroomProvider.classroom.uid!;
    try {
      await getDatasFromDB();
    } catch (e) {
      print('Error : $e');
    }
    final dailyProvider = Provider.of<NewDailyProvider>(context, listen: false);
    final lessonProvider =
        Provider.of<NewLessonProvider>(context, listen: false);

    // studentProvider에 students 가져오기

    // List<NewDaily> newDailys = dailyProvider.dailys;
    // List<Lesson> lessons = lessonProvider.lessons;
    List<NewStudent> newStudents = studentProvider.students;

    List<NewDaily> dailys = dailyProvider.dailys;

    List<Lesson> dummyLessons = [
      Lesson(
        classroomId: '',
        studentId: '',
        id: '1',
        name: '테스트 레슨',
        kind: 'lesson',
        isChecked: false,
      ),
      Lesson(
        classroomId: '',
        studentId: '',
        id: '2',
        name: '테스트 레슨2',
        kind: 'lesson',
        isChecked: false,
      ),
    ];
    // 학생 정보에 데이터 넣기
    for (NewStudent student in newStudents) {
      studentsWithData.add(
        StudentWithData(
          student: student,
          // dailys: newDailys,
          dailys:
              dailys.where((daily) => daily.studentId == student.id).toList(),
          lessons: dummyLessons,
        ),
      );
    }

    // 학생 정렬
    studentsWithData
        .sort((a, b) => a.student.number.compareTo(b.student.number));

    Provider.of<LoadingProvider>(context, listen: false).setLoading(false);
  }

  Future<void> generateTabs(
      List<int> selectedIndex,
      List<int> selectedBottomNavIndices,
      NewStudentProvider studentProvider,
      NewLayoutProvider layoutProvider,
      BuildContext context
      // List<StudentWithData> studentsWithData,
      ) async {
    // 변수 초기화
    List<TabData> tabs = [];
    int tabCount = 0;
    List<Map<String, dynamic>> tabDatas = [];
    // 사이드탭이 일상일 경우의 탭 설정
    if (selectedIndex[2] == 1) {
      for (var daily in studentsWithData[0].dailys!) {
        tabDatas.add({
          'data': daily,
          'name': daily.name,
          'index': layoutProvider.nowIndex,
          'kind': 'daily',
          'students': studentsWithData,
          'tabCount': tabCount++,
        });
      }
    }

    // 사이드탭이 수업일 경우의 탭 설정
    else if (selectedIndex[3] == 1) {
      for (var lessons in studentsWithData[0].lessons!) {
        tabDatas.add({
          'data': lessons,
          'name': lessons.name,
          'index': layoutProvider.nowIndex,
          'kind': 'classes',
          'students': studentsWithData,
        });
      }
    }

    // 데이터가 없을 경우 처리
    if (tabDatas.isEmpty) {
      tabDatas.add({
        'data': null,
        'name': '추가하기',
        'index': layoutProvider.nowIndex,
        'kind': 'noData',
        'students': studentsWithData,
      });
    }

    // 컨텐츠 탭 생성
    for (int i = 0; i < tabDatas.length; i++) {
      tabs.add(
        TabData(
          text: tabDatas[i]['name'],
          leading: (context, status) => const Icon(Icons.star, size: 16),
          // content: contentsWidget(tabDatas[i], context),
          content: ContentsWidget(
            data: tabDatas[i],
          ),
        ),
      );
    }
    _controller = TabbedViewController(tabs);
  }

  @override
  Widget build(BuildContext context) {
    // 바텀 네비게이션

    // 컨텐츠 탭 생성 함수(컨텐츠 박스 위젯을 위해 필요함)
    Future<void> futureDataSet() async {
      await getDatas();
      // await Future.delayed(Duration(seconds: 2));
    }

    return FutureBuilder(
      future: futureDataSet(), // 비동기 데이터 로딩 함수
      builder: (context, snapshot) {
        final layoutProvider =
            Provider.of<NewLayoutProvider>(context, listen: true);
        final newStudentProvider =
            Provider.of<NewStudentProvider>(context, listen: false);

        selectedIndex = layoutProvider.selectedIndices;
        selectedBottomNavIndices = layoutProvider.selectedBottomNavIndices;

        generateTabs(
          selectedIndex,
          selectedBottomNavIndices,
          newStudentProvider,
          layoutProvider,
          context,
          // studentsWithData,
        );

        // 데이터 로딩 중
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        // 데이터 로딩 완료 후, Scaffold 렌더링
        if (snapshot.hasData) {
          // 여기서 snapshot.data를 사용하여 필요한 데이터를 처리할 수 있습니다.
        }
        String currentDate =
            DateFormat('yyyy년 MM월 dd일').format(thisDate); // 현재 날짜를 원하는 형식으로 포맷

        // 탭뷰 생성
        TabbedView tabbedView = TabbedView(
          controller: _controller,
        );
        // 탭뷰 생성
        Widget w = TabbedViewTheme(
          data: TabbedViewThemeData.classic()..menu.ellipsisOverflowText = true,
          child: tabbedView,
        );
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: layoutAppBar(currentDate, context),
          body: Stack(
            children: [
              SafeArea(
                child: Row(
                  children: [
                    // 사이드바 컨테이너
                    layoutSideBar(),

                    // 우측 메인 박스 및 바텀 네비게이션
                    Expanded(
                      child: Column(
                        children: [
                          // 메인 컨텐츠 박스
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: w,
                            ),
                          ),

                          // 바텀 네비게이션
                          layoutBottomNavigation(context, classroomId),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

        // 에러 발생 시
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        return Container(); // 아무 것도 없는 기본 컨테이너
      },
    );
  }
}
