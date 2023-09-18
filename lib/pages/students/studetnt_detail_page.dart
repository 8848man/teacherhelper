import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/providers/student_provider.dart';

class StudentDetailPage extends HookWidget {
  final String studentId;

  const StudentDetailPage({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("학생 상세 정보")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<Student>(
              future: Provider.of<StudentProvider>(context)
                  .fetchStudentById(studentId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final student = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("이름: ${student.name}"),
                      Text("성별: ${student.gender}"),
                      Text("생일: ${student.birthdate}"),
                      const SizedBox(height: 16.0),
                      const Text("선생님 성함: Loading..."), // TODO: 선생님 정보 가져오기
                      const SizedBox(height: 16.0),
                      const Text("등록된 반들: Loading..."), // TODO: 등록된 반 정보 가져오기
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
