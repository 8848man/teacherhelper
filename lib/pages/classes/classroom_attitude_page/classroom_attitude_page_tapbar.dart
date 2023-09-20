import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/attitude.dart';
import 'package:teacherhelper/pages/classes/classroom_attitude_page/classroom_attitude_page.dart';
import 'package:teacherhelper/pages/navigations/navbar.dart';
import 'package:teacherhelper/providers/attitude_provider.dart';

class ClassroomAttitudePageTapBar extends StatefulWidget {
  final String classroomId; // classroomId 변수 추가

  const ClassroomAttitudePageTapBar({super.key, required this.classroomId});

  @override
  _ClassroomAttitudePageTapBarState createState() =>
      _ClassroomAttitudePageTapBarState();
}

class _ClassroomAttitudePageTapBarState
    extends State<ClassroomAttitudePageTapBar> {
  final AttitudeProvider _attitudeProvider = AttitudeProvider();
  @override
  void initState() {
    super.initState();
    _attitudeProvider.fetchAttitudesByClassroomId(widget.classroomId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) {
        return FutureBuilder<List<Attitude>>(
            future: _attitudeProvider
                .fetchAttitudesByClassroomId(widget.classroomId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // 데이터 로딩 중에 표시할 위젯
              } else if (snapshot.hasError) {
                return Text(
                    'Error: ${snapshot.error}'); // 데이터 로딩 중 에러 발생 시 표시할 위젯
              } else if (snapshot.hasData) {
                List<Attitude> attitudeList = snapshot.data!;
                // 오늘 날짜를 위한 변수 할당
                DateTime now = DateTime.now();
                int year = now.year;
                int month = now.month;
                int day = now.day;

                List<int?> orderList =
                    attitudeList.map((attitude) => attitude.order).toList();
                return DefaultTabController(
                  length: attitudeList.length,
                  child: Scaffold(
                    drawer: NavBar(classroomId: widget.classroomId),
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      iconTheme: const IconThemeData(color: Colors.orange),
                      elevation: 2, // 그림자의 높이를 조절 (4는 예시로 사용한 값)
                      shadowColor: Colors.orange, // 그림자의 색상을 파란색으로 설정
                      title: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.27,
                            child: const Text(
                              "SCHOOL CHECK",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.46,
                            child: Center(
                              child: Text(
                                "$year년 $month월 $day일",
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    color: Colors.pink,
                                    child: Image.asset(
                                        'assets/buttons/classroom_change_button.png'),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    color: Colors.pink[100],
                                    child: Image.asset(
                                        'assets/buttons/attendance_check_button.png'),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                    body: TabBarView(
                      children: List.generate(orderList.length, (index) {
                        return ClassroomAttitudePage(
                          classroomId: widget.classroomId,
                          order: orderList[index],
                          attitudeName: attitudeList[index].name,
                          now: now,
                          isBad: attitudeList[index].isBad,
                        );
                      }),
                    ),
                    extendBodyBehindAppBar: true, // add this line

                    bottomNavigationBar: Container(
                      color: Colors.white, //색상
                      child: Container(
                        height: 70,
                        padding: const EdgeInsets.only(bottom: 10, top: 5),
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
                          labelStyle: const TextStyle(
                            fontSize: 13,
                          ),
                          tabs: attitudeList.map((attitude) {
                            return Tab(
                              icon: const Icon(Icons.music_note),
                              text: attitude.name,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    // floatingActionButton: FloatingActionButtonAttitude(
                    //   classroomId: widget.classroomId,
                    // ),
                  ),
                );
              } else {
                return const Text('No data available'); // 데이터가 없을 때 표시할 위젯
              }
            });
      }),
    );
  }
}
