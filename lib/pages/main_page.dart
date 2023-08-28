import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/pages/classes/classroom_detail_page.dart';
import 'package:teacherhelper/pages/classes/create_classroom_page.dart';
import 'package:teacherhelper/pages/login_page.dart';
import 'package:teacherhelper/pages/register_page.dart';
import 'package:teacherhelper/pages/students/student_list_page.dart';
import 'package:teacherhelper/pages/students/student_register_page.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/services/auth_service.dart';

import '../datamodels/myappusers.dart';

class MainPage extends HookWidget {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final classroomProvider = Provider.of<ClassroomProvider>(context);

    final classrooms = classroomProvider.classrooms;
    final currentUserUid = AuthService().currentUser()?.uid.toString();

    useEffect(() {
      classroomProvider.fetchClassrooms(currentUserUid!);
    }, []);

    return Consumer<AuthService>(
      builder: (context, authService, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("${user!.email}님 안녕하세요"),
            actions: [
              Row(
                children: [
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
            ],
          ),
          body: Consumer<ClassroomProvider>(
            builder: (context, classroomProvider, child) {
              return ListView.builder(
                itemCount: classrooms.length,
                itemBuilder: (context, index) {
                  final classroom = classrooms[index];
                  return ListTile(
                    title: Text(classroom.name),
                    subtitle:
                        Text("학년: ${classroom.grade}, id : ${classroom.uid}"),
                    onTap: () {
                      Provider.of<ClassroomProvider>(context, listen: false)
                          .setClassroomId(classroom.uid!);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BottomNavi(classroomId: classroom.uid!),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  // Handle first button's action
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CreateClassroomPage(teacherUid: user!.uid),
                    ),
                  );
                },
                child: Icon(Icons.add),
                tooltip: '반 추가하기', // Tooltip에 표시할 텍스트
              ),
              SizedBox(height: 16),
              FloatingActionButton(
                onPressed: () {
                  // Handle second button's action
                },
                child: Icon(Icons.delete),
              ),
            ],
          ),
        );
      },
    );
  }
}

// class _MainPageState extends State<MainPage> {
//   User? user = FirebaseAuth.instance.currentUser;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final classroomProvider = Provider.of<ClassroomProvider>(context);

//     final classrooms = classroomProvider.classrooms;
//     final currentUserUid = AuthService().currentUser()?.uid.toString();

//     useEffect(() {
//       classroomProvider.fetchClassrooms(currentUserUid!);
//     }, []);
//     return Consumer<AuthService>(
//       builder: (context, authService, child) {
//         return Scaffold(
//           appBar: AppBar(
//             title: Text("${user!.email}님 안녕하세요"),
//             actions: [
//               Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.app_registration),
//                     onPressed: () {
//                       authService.signOut;
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => LoginPage1()),
//                       );
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.logout),
//                     onPressed: () {
//                       authService.signOut;
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => LoginPage1()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           body: Consumer<ClassroomProvider>(
//             builder: (context, classroomProvider, child) {
//               return ListView.builder(
//                 itemCount: classrooms.length,
//                 itemBuilder: (context, index) {
//                   final classroom = classrooms[index];
//                   return ListTile(
//                     title: Text(classroom.name),
//                     subtitle:
//                         Text("학년: ${classroom.grade}, id : ${classroom.uid}"),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               BottomNavi(classroomId: classroom.uid!),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
