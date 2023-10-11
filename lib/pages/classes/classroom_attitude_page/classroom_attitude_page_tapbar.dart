import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/attitude.dart';
import 'package:teacherhelper/datamodels/classroom.dart';
import 'package:teacherhelper/pages/classes/classroom_attitude_page/classroom_attitude_page.dart';
import 'package:teacherhelper/pages/classes/classroom_attitude_page/floating_action_button_attitude.dart';
import 'package:teacherhelper/pages/navigations/navbar.dart';
import 'package:teacherhelper/providers/attitude_provider.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';

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
    // _attitudeProvider.fetchAttitudesByClassroomId(widget.classroomId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer2<ClassroomProvider, AttitudeProvider>(
          builder: (context, classroomProvider, attitudeProvider, child) {
        // 반 전환을 위한 드롭다운 버튼 변수 설정
        final List<Classroom> classrooms = classroomProvider.classrooms;

        Map<String, String> classroomData = {};

        for (Classroom classroom in classrooms) {
          classroomData[classroom.name] = classroom.uid!;
        }
        List<String> myKeyList = classroomData.keys.toList();

        String? thisClassroomId;

        classroomData.forEach((key, value) {
          if (value == widget.classroomId) {
            thisClassroomId = key;
          }
        });

        String dropdownValue = thisClassroomId!;
        // 반 전환을 위한 드롭다운 버튼 변수 설정 끝
        return FutureBuilder<List<Attitude>>(
            future: _attitudeProvider
                .fetchAttitudesByClassroomId(widget.classroomId),
            builder: (context, snapshot) {
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
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.12,
                                  child: DropdownButton<String>(
                                    value: dropdownValue,
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    style: const TextStyle(
                                      color: Colors.deepPurple,
                                    ),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String? value) {
                                      // 사용자가 항목을 선택했을 때 실행할 코드
                                      dropdownValue = value!;
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            // 이동하고 싶은 화면을 반환하는 builder 함수를 작성합니다.
                                            return ClassroomAttitudePageTapBar(
                                              classroomId:
                                                  classroomData[value]!,
                                            ); // YourNextScreen은 이동하고자 하는 화면입니다.
                                          },
                                        ),
                                      );
                                    },
                                    items: myKeyList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
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
                  // floatingActionButtonLocation:
                  //     FloatingActionButtonLocation.endDocked,
                ),
              );
            });
      }),
    );
  }
}
