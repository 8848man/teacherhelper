import 'package:flutter/material.dart';
import 'package:teacherhelper/pages/classes/classroom_daily_page.dart/classroom_daily_page.dart';
import 'package:teacherhelper/pages/classes/subpage/classroom_sub_page.dart';
import 'package:teacherhelper/pages/classes/classroom_daily_page.dart/floating_action_button_daily.dart';
import 'package:teacherhelper/pages/navigations/navbar.dart';

class ClassroomDailyPageTapBar extends StatefulWidget {
  final String classroomId; // classroomId 변수 추가

  ClassroomDailyPageTapBar({required this.classroomId});

  @override
  _ClassroomDailyPageTapBarState createState() =>
      _ClassroomDailyPageTapBarState();
}

class _ClassroomDailyPageTapBarState extends State<ClassroomDailyPageTapBar> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: NavBar(),
          appBar: AppBar(title: Text("생활 탭")),
          body: TabBarView(
            children: [
              ClassroomDailyPage(
                classroomId: widget.classroomId,
              ),
              ClassroomDailyPage(
                classroomId: widget.classroomId,
              ),
              ClassroomDailyPage(
                classroomId: widget.classroomId,
              ),
            ],
          ),
          extendBodyBehindAppBar: true, // add this line

          bottomNavigationBar: Container(
            color: Colors.white, //색상
            child: Container(
              height: 70,
              padding: EdgeInsets.only(bottom: 10, top: 5),
              child: const TabBar(
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
                tabs: [
                  Tab(
                    icon: Icon(Icons.music_note),
                    text: '출석',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.home_outlined,
                    ),
                    text: '가정통신문',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.apps,
                    ),
                    text: '+a',
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButtonDaily(
            classroomId: widget.classroomId,
          ),
        ),
      ),
    );
  }
}
