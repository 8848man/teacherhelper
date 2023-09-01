import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';

class ClassroomStudentDeletePage extends StatelessWidget {
  final String classroomId;

  ClassroomStudentDeletePage({required this.classroomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("학생 삭제")),
      body: Consumer<StudentProvider>(
        builder: (context, studentProvider, child) {
          return FutureBuilder<List<Student>>(
            future: studentProvider.getStudentsByClassroom(classroomId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Failed to fetch students');
              }
              final students = snapshot.data!;

              return ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];

                  return ListTile(
                    title: Text(student.name),
                    subtitle: Text("학번: ${student.id}"),
                    onTap: () async {
                      await studentProvider.unregisterStudentFromClassroom(
                        student.id.toString(),
                        classroomId,
                      );
                      Navigator.pop(context);
                    },
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
