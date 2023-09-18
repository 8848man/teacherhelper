import 'package:flutter/material.dart';
import 'package:teacherhelper/pages/classes/classroom_daily_page.dart/classroom_daily_create_page.dart';
import 'package:teacherhelper/pages/classes/classroom_student_delete_page.dart';
import 'package:teacherhelper/pages/students/student_register_page.dart';

// 데일리 페이지 학생 추가, 과제 추가 버튼 모음
class FloatingActionButtonDaily extends StatelessWidget {
  final String classroomId;

  const FloatingActionButtonDaily({super.key, required this.classroomId});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () {
            // Handle first button's action
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => StudentRegistrationPage(
                  classroomId: classroomId,
                ),
              ),
            );
          },
          tooltip: '학생 등록하기',
          child: const Icon(Icons.person_add_alt),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          onPressed: () {
            // Handle second button's action
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClassroomStudentDeletePage(
                  classroomId: classroomId,
                ),
              ),
            );
          },
          tooltip: '학생 삭제하기',
          child: const Icon(Icons.person_remove_alt_1_outlined),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          onPressed: () {
            // Handle second button's action
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DailyCreatePage(
                  classroomId: classroomId,
                ),
              ),
            );
          },
          tooltip: '일과 과제 등록하기',
          child: const Icon(Icons.add_circle_outline),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          onPressed: () {
            // Handle second button's action
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClassroomStudentDeletePage(
                  classroomId: classroomId,
                ),
              ),
            );
          },
          tooltip: '일과 과제 삭제하기',
          child: const Icon(Icons.remove_circle_outline),
        ),
      ],
    );
  }
}
