import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/pages/classes/classroom_detail_page.dart';
import 'package:teacherhelper/pages/students/student_list_page.dart';
import 'package:teacherhelper/pages/students/student_register_page.dart';
import 'package:teacherhelper/services/auth_service.dart';

import '/providers/classroom_provider.dart';

class ClassroomListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final classroomProvider = Provider.of<ClassroomProvider>(context);

    final classrooms = classroomProvider.classrooms;
    final currentUserUid = AuthService().currentUser()?.uid.toString();

    useEffect(() {
      classroomProvider.fetchClassrooms(currentUserUid!);
    }, []);

    return Scaffold(
      appBar: AppBar(title: Text("등록된 반 보기")),
      body: Consumer<ClassroomProvider>(
        builder: (context, classroomProvider, child) {
          return ListView.builder(
            itemCount: classrooms.length,
            itemBuilder: (context, index) {
              final classroom = classrooms[index];
              return ListTile(
                title: Text(classroom.name),
                subtitle: Text("학년: ${classroom.grade}, id : ${classroom.uid}"),
                onTap: () {
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
    );
  }
}
