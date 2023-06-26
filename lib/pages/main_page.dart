import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:teacherhelper/pages/create_classroom_page.dart';
import 'package:teacherhelper/pages/login_page.dart';
import 'package:teacherhelper/pages/student_list_page.dart';
import 'package:teacherhelper/pages/student_register_page.dart';

import '../datamodels/myappusers.dart';
import 'classroom_list_page.dart';
import 'student_register_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _storage = FlutterSecureStorage();

  User? user = FirebaseAuth.instance.currentUser;

  User? _user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    final userJson = await _storage.read(key: user!.uid);
    if (userJson != null) {
      setState(() {
        final myAppUser = MyAppUser.fromJson(json.decode(userJson));
        _user = myAppUser.toUser() as User?;
      });
    }
  }

  void _logout() async {
    await _storage.delete(key: 'user');
    setState(() {
      _user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text("메인 페이지"),
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: _logout,
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudentRegistrationPage()),
                    );
                  },
                  child: Text("학생 등록하기"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudentListPage()),
                    );
                  },
                  child: Text("등록된 학생 보기"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
