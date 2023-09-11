import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/assignment.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/services/auth_service.dart';
import 'package:teacherhelper/services/student_service.dart';

class StudentProvider with ChangeNotifier {
  final StudentService _studentService = StudentService();
  final currentUserUid = AuthService().currentUser()?.uid;

  List<Student> _students = [];
  List<Student> get students => _students;
  set students(List<Student> students) {
    _students = students;
    notifyListeners();
  }

  // 학생 불러오기
  Future<QuerySnapshot> read(String uid) {
    return _studentService.read(uid);
  }

  // studentId로 학생 가져오기
  Future<Student> fetchStudentById(String studentId) {
    return _studentService.getStudentById(studentId);
  }

  // 현재 로그인한 teacherUid로 학생 가져오기
  Future<List<Student>> getStudentsByTeacher() async {
    final currentUserUid = AuthService().currentUser()?.uid;
    try {
      final List<Student> students =
          await _studentService.getStudentsByTeacher(currentUserUid!);
      return students;
    } catch (e) {
      throw Exception('Failed to fetch students: $e');
    }
  }

  // classroomId로 학생 가져오기
  Future<void> fetchStudentsByClassroom(String classroomId) async {
    try {
      // final List<Student> fetchedStudents =
      //     await _studentService.fetchStudentsByClassroom(classroomId);
      // students = fetchedStudents;
      print('fetch');
      _students = [];
      _students = await _studentService.fetchStudentsByClassroom(classroomId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch students: $e');
    }
  }

  // 학생을 반에서 삭제하기
  Future<void> unregisterStudentFromClassroom(
      String studentId, String classroomId) async {
    await _studentService.unregisterStudentFromClassroom(
        studentId, classroomId);
    ChangeNotifier();
  }

  // 학생 추가
  Future<String?> create(
    Student student,
    String classroomId,
  ) async {
    return _studentService.create(student, classroomId);
    // notifyListeners();
  }

  // 학생 삭제
  void delete(String uid) {
    _studentService.delete(uid);
    notifyListeners();
  }

  void update(Student student) {
    _studentService.update(student);
    notifyListeners();
  }

  // 반 등록 / 수정 페이지에서 학생을 등록하거나 수정하는 함수
  Future<void> updateOrRegistStudents(
      List<Student> students, String classroomId) async {
    List<Student> checkedStudents =
        students.where((student) => student.isChecked!).toList();
    await _studentService.updateOrRegistStudents(checkedStudents, classroomId);
  }

  // 학생 리스트 저장
  // void setStudents(List<Student> students) {
  //   _students = students;
  //   notifyListeners();
  // }

  // after 0806
  // classroomId로 학생 가져오기.
  Future<List<Student>> getStudentsByClassroom(String classroomId) async {
    try {
      final List<Student> students =
          await _studentService.getStudentsByClassroom(classroomId);
      return students;
    } catch (e) {
      throw Exception('Failed to fetch students: $e');
    }
  }

  void resetStudents() {
    _students = [];
    notifyListeners();
  }
}
