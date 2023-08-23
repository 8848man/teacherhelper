import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/pages/assignments/assignment_create_page.dart';
import 'package:teacherhelper/pages/classes/classroom_student_delete_page.dart';
import 'package:teacherhelper/pages/classes/classroom_student_regist_page.dart';
import 'package:teacherhelper/pages/classes/subpage/classroom_classes_page.dart';
import 'package:teacherhelper/pages/classes/subpage/classroom_sub_page.dart';
import 'package:teacherhelper/pages/classes/subpage/classroom_violation_page_bottom_sheet.dart';
import 'package:teacherhelper/pages/classes/subpage/classroom_daily_page.dart';
import 'package:teacherhelper/pages/classes/subpage/classroom_violation_page.dart';
import 'package:teacherhelper/pages/navigations/navbar.dart';
import 'package:teacherhelper/pages/students/student_register_page.dart';
import 'package:teacherhelper/pages/students/studetnt_detail_page.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';

import '../students/student_assignments_page.dart';

class BottomNavi extends StatefulWidget {
  final String classroomId; // classroomId 변수 추가

  BottomNavi({required this.classroomId});

  @override
  _BottomNaviState createState() => _BottomNaviState();
}

class _BottomNaviState extends State<BottomNavi> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: NavBar(),
          appBar: AppBar(title: Text("반 상세 정보")),
          body: TabBarView(
            children: [
              ClassroomDailyPage(
                classroomId: widget.classroomId,
              ),
              ClassroomViolationPage(
                classroomId: widget.classroomId,
              ),
              ClassroomClassesPage(
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
                    text: '생활',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.home_outlined,
                    ),
                    text: '위반',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.apps,
                    ),
                    text: '수업',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
