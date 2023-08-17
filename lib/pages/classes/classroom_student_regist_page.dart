import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';

class ClassroomStudentRegistrationPage extends StatefulWidget {
  final String classroomId;

  ClassroomStudentRegistrationPage({required this.classroomId});

  @override
  State<ClassroomStudentRegistrationPage> createState() =>
      _ClassroomStudentRegistrationPageState();
}

class _ClassroomStudentRegistrationPageState
    extends State<ClassroomStudentRegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('학생 등록'),
      ),
      body: Consumer<StudentProvider>(
        builder: (context, studentProvider, child) {
          return FutureBuilder<List<Student>>(
            future: studentProvider.getStudentsByTeacher(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Failed to fetch students'));
              }
              final students = snapshot.data;

              return ListView.builder(
                itemCount: students!.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return ListTile(
                    title: Text(student.name),
                    subtitle: Text("학번: ${student.id}"),
                    onTap: () {
                      studentProvider.registerStudentToClassroom(
                        student.id.toString(),
                        widget.classroomId,
                      );
                      Provider.of<ClassroomProvider>(context, listen: false)
                          .registerStudentToClassroom(
                        widget.classroomId,
                        student.id.toString(),
                      );
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
