import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/pages/students/studetnt_detail_page.dart';
import 'package:teacherhelper/providers/student_provider.dart';
import 'package:teacherhelper/datamodels/student.dart';

class StudentListPage extends StatelessWidget {
  const StudentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("학생 목록")),
      body: FutureBuilder<List<Student>>(
        future: studentProvider.getStudentsByTeacher(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final students = snapshot.data;

          if (students == null || students.isEmpty) {
            return const Center(child: Text('No students found.'));
          }

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return ListTile(
                title: Text(student.name),
                subtitle:
                    Text("성별: ${student.gender}, 생일: ${student.birthdate}"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          StudentDetailPage(studentId: student.id!),
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
