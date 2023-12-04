import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabbed_view/tabbed_view.dart';
import 'package:teacherhelper/datamodels/classes.dart';
import 'package:teacherhelper/datamodels/daily.dart';
import 'package:teacherhelper/providers/classes_provider.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/providers/daily_provider.dart';
import 'package:teacherhelper/providers/layout_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';

class LayoutContents extends StatefulWidget {
  final Map<String, dynamic> data;
  final DateTime? thisDate;
  late bool dataFetched = false;

  LayoutContents({
    super.key,
    required this.data,
    this.thisDate,
  });

  @override
  State<StatefulWidget> createState() => _LayoutContentsState();
}

class _LayoutContentsState extends State<LayoutContents> {
  late TabbedViewController _controller;

  late List<int> selectedIndex;
  late List<Daily> dailys;
  late List<Classes> classes;

  @override
  void initState() {
    super.initState();
    final dailyProvider = Provider.of<DailyProvider>(context, listen: false);
    final classroomProvider =
        Provider.of<ClassroomProvider>(context, listen: false);
    if (widget.dataFetched != true) {
      dailyProvider.getDailyLayout(
          classroomProvider.classroom.uid!, DateTime.now());
      widget.dataFetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer5<LayoutProvider, DailyProvider, ClassesProvider,
            StudentProvider, ClassroomProvider>(
        builder: (context, layoutProvider, dailyProvider, classesProvider,
            studentProvider, classroomProvider, child) {
      selectedIndex = layoutProvider.selectedIndices;
      dailys = dailyProvider.dailys;
      classes = classesProvider.classes;
      generateTabs(dailys, classes, selectedIndex);

      TabbedView tabbedView = TabbedView(controller: _controller);
      Widget w = TabbedViewTheme(
          data: TabbedViewThemeData.classic()..menu.ellipsisOverflowText = true,
          child: tabbedView);
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

  void generateTabs(
    List<Daily> dailys,
    List<Classes> classes,
    List<int> selectedIndex,
  ) {
    print('generateTabs');
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
    }
    // 데이터가 없을 경우 처리
    if (tabNames.isEmpty) {
      tabDatas.add({'data': null, 'name': '추가하기', 'kind': 'noData'});
    }

    print(tabDatas);
    // 컨텐츠 탭 생성
    for (int i = 0; i < tabDatas.length; i++) {
      tabs.add(
        // TabData(
        //   text: tabDatas[i]['name'],
        //   leading: (context, status) => const Icon(Icons.star, size: 16),
        //   content: tabDatas.isEmpty
        //       ? contentsWidget('')
        //       : contentsWidget(tabDatas[i]),
        // ),
        TabData(
          text: tabDatas[i]['name'],
          leading: (context, status) => const Icon(Icons.star, size: 16),
          content: LayoutContents(
            data: tabDatas[i],
          ),
        ),
      );
    }
    _controller = TabbedViewController(tabs);
  }
}
