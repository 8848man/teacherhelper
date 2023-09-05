import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/daily.dart';
import 'package:teacherhelper/pages/classes/classroom_daily_page.dart/classroom_daily_page.dart';
import 'package:teacherhelper/pages/classes/subpage/classroom_sub_page.dart';
import 'package:teacherhelper/pages/classes/classroom_daily_page.dart/floating_action_button_daily.dart';
import 'package:teacherhelper/pages/navigations/navbar.dart';
import 'package:teacherhelper/providers/daily_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';

class ClassroomDailyPageTapBar extends StatefulWidget {
  final String classroomId; // classroomId 변수 추가

  ClassroomDailyPageTapBar({required this.classroomId});

  @override
  _ClassroomDailyPageTapBarState createState() =>
      _ClassroomDailyPageTapBarState();
}

class _ClassroomDailyPageTapBarState extends State<ClassroomDailyPageTapBar> {
  final DailyProvider _dailyProvider = DailyProvider(); // DailyProvider 인스턴스 생성
  @override
  void initState() {
    super.initState();
    _dailyProvider.fetchDailysByClassroomId(widget.classroomId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) {
        return FutureBuilder<List<Daily>>(
            future: _dailyProvider.fetchDailysByClassroomId(widget.classroomId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // 데이터 로딩 중에 표시할 위젯
              } else if (snapshot.hasError) {
                return Text(
                    'Error: ${snapshot.error}'); // 데이터 로딩 중 에러 발생 시 표시할 위젯
              } else if (snapshot.hasData) {
                List<Daily> dailyList = snapshot.data!;
                // 오늘 날짜를 위한 변수 할당
                DateTime now = DateTime.now();
                int year = now.year;
                int month = now.month;
                int day = now.day;

                List<int?> orderList =
                    dailyList.map((daily) => daily.order).toList();
                return DefaultTabController(
                  length: dailyList.length,
                  child: Scaffold(
                    drawer: NavBar(),
                    appBar: AppBar(
                      // backgroundColor: Colors.white,
                      title: Row(
                        children: [
                          Text("생활 탭"),
                          Spacer(),
                          Center(
                            child: Text(
                              "$year년 $month월 $day일",
                            ),
                          ),
                        ],
                      ),
                    ),
                    body: TabBarView(
                      children: List.generate(orderList.length, (index) {
                        return ClassroomDailyPage(
                          classroomId: widget.classroomId,
                          order: orderList[index],
                          dailyName: dailyList[index].name,
                          now: now,
                        );
                      }),
                    ),
                    extendBodyBehindAppBar: true, // add this line

                    bottomNavigationBar: Container(
                      color: Colors.white, //색상
                      child: Container(
                        height: 70,
                        padding: EdgeInsets.only(bottom: 10, top: 5),
                        child: TabBar(
                          //tab 하단 indicator size -> .label = label의 길이
                          //tab 하단 indicator size -> .tab = tab의 길이
                          indicatorSize: TabBarIndicatorSize.label,
                          //tab 하단 indicator color
                          indicatorColor: Colors.red,
                          //tab 하단 indicator weight
                          indicatorWeight: 2,
                          //label color
                          labelColor: Colors.red,
                          //unselected label color
                          unselectedLabelColor: Colors.black38,
                          labelStyle: TextStyle(
                            fontSize: 13,
                          ),
                          tabs: dailyList.map((daily) {
                            return Tab(
                              icon: Icon(Icons.music_note),
                              text: daily.name,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    floatingActionButton: FloatingActionButtonDaily(
                      classroomId: widget.classroomId,
                    ),
                  ),
                );
              } else {
                return Text('No data available'); // 데이터가 없을 때 표시할 위젯
              }
            });
      }),
    );
  }
}
