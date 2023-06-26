import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/services/student_service.dart';

class StudentProvider with ChangeNotifier {
  List<Student> _students = [];

  // 학생 리스트 가져오기
  List<Student> get students => [..._students];

  // 학생 추가
  void addStudent(Student student) {
    _students.add(student);
    notifyListeners();
  }

  // 학생 삭제
  void deleteStudent(Student student) {
    _students.remove(student);
    notifyListeners();
  }

  // 학생 리스트 저장
  void setStudents(List<Student> students) {
    _students = students;
    notifyListeners();
  }
}
