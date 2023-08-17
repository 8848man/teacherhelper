import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/pages/classes/classroom_list_page.dart';
import 'package:teacherhelper/pages/classes/create_classroom_page.dart';
import 'package:teacherhelper/pages/login_page.dart';
import 'package:teacherhelper/pages/students/student_list_page.dart';
import 'package:teacherhelper/pages/students/student_register_page.dart';
import 'package:teacherhelper/services/auth_service.dart';

import '../datamodels/myappusers.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _storage = FlutterSecureStorage();

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("메인 페이지"),
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  authService.signOut;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage1()),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (user == null) ...[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage1()),
                      );
                    },
                    child: Text("로그인"),
                  ),
                ] else ...[
                  Text("현재 로그인한 유저: ${user!.email}"),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CreateClassroomPage(teacherUid: user!.uid),
                        ),
                      );
                    },
                    child: Text("반 등록하기"),
                  ),
                ],
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClassroomListPage()),
                    );
                  },
                  child: Text("등록된 반 보기"),
                ),

                // 0801 DB 개편으로 사라진 로직
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => StudentRegistrationPage()),
                //     );
                //   },
                //   child: Text("학생 등록하기"),
                // ),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => StudentListPage()),
                //     );
                //   },
                //   child: Text("등록된 학생 보기"),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
