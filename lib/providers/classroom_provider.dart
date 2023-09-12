import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/classroom.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/services/assignment_service.dart';
import 'package:teacherhelper/services/auth_service.dart';
import 'package:teacherhelper/services/classroom_service.dart';
import 'package:teacherhelper/services/daily_service.dart';

class ClassroomProvider with ChangeNotifier {
  final ClassroomService _classroomService;
  final DailyService _dailyService;
  final AssignmentService _assignmentService;
  final currentUserUid = AuthService().currentUser()?.uid;

  ClassroomProvider()
      : _classroomService = ClassroomService(),
        _dailyService = DailyService(),
        _assignmentService = AssignmentService();

  List<Classroom> _classrooms = [];
  List<Classroom> get classrooms => _classrooms;

  String? _classroomId;

  String? get classroomId => _classroomId;

  void setClassroomId(String id) {
    _classroomId = id;
    notifyListeners();
  }

  Future<QuerySnapshot> read(String? uid) async {
    return _classroomService.read(uid!);
  }

  // 반 등록
  Future<void> createClassroom(Classroom classroom) async {
    try {
      String? classroomId = await _classroomService.createClassroom(classroom);

      // 기본적으로 등록되어야 하는 일상 및 과제 등록
      await _dailyService.addDefaultDaily(classroom.id);
      await _assignmentService.addDefaultAssignment(classroom.id);
    } catch (e) {
      throw Exception('Failed to create classroom: $e');
    }
  }

  // 선생님 ID로 반 불러오기
  Future<void> fetchClassrooms(String teacherUid) async {
    _classrooms = await _classroomService.getClassroomsByTeacher(teacherUid);
    notifyListeners();
  }

  // 반 ID로 반 객체 가져오기
  Classroom getClassroomById(String classroomId) {
    return _classrooms.firstWhere((classroom) => classroom.uid == classroomId);
  }

  // 반 ID로 반 객체 가져오기
  Future<List<String>> fetchClassroomNames(List<String> classroomIds) async {
    return await _classroomService.getClassroomNames(classroomIds);
  }

  Future<void> registerStudentToClassroom(
      String studentId, String classroomId) async {
    await _classroomService.registerStudentToClassroom(studentId, classroomId);
    await fetchClassrooms(currentUserUid!);
  }

  Future<void> unregisterStudentFromClassroom(
      String studentId, String classroomId) async {
    await _classroomService.unregisterStudentFromClassroom(
        studentId, classroomId);
    await fetchClassrooms(currentUserUid!);
  }

  getAssignmentsForStudent(String classroomId, String? studentId) {}

  modifyClassroom(Classroom classroom) {}

  // 학생 관련 함수 모음

  //Future<void>

  // 학생 관련 함수 모음 끝
}
