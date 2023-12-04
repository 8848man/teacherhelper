import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/new_student.dart';

import '../services/new_student_service.dart';

class NewStudentProvider extends ChangeNotifier {
  final NewStudentService _studentService;

  NewStudentProvider() : _studentService = NewStudentService();

  List<NewStudent> _students = [];
  List<NewStudent> get students => _students;

  // classroomId로 학생들 가져오기
  Future<List<NewStudent>> getStudentsByClassroomId(String classroomId) async {
    print(getStudentsByClassroomId);
    _students = [];
    _students = await _studentService.getStudentsByClassroomId(classroomId);
    return _students;
    notifyListeners();
  }

  Future<void> updateStudents() async {}

  Future<void> deleteStudent() async {}
}
