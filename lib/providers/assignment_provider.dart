import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/assignment.dart';
import 'package:teacherhelper/services/assignment_service.dart';
import 'package:teacherhelper/services/classroom_service.dart';
import 'package:teacherhelper/services/student_service.dart';

class AssignmentProvider with ChangeNotifier {
  final AssignmentService _assignmentService;

  AssignmentProvider() : _assignmentService = AssignmentService();
  final ClassroomService _classroomService = ClassroomService();
  final StudentService _studentService = StudentService();

  List<Assignment> _assignments = [];
  List<Assignment> get assignments => _assignments;

  Future<void> fetchAssignments() async {
    try {
      _assignments = await _assignmentService.getAssignments();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch assignments: $e');
    }
  }

  Future<void> updateAssignment(Assignment assignment) async {
    try {
      await _assignmentService.updateAssignment(assignment);
      final index =
          _assignments.indexWhere((element) => element.id == assignment.id);
      if (index != -1) {
        _assignments[index] = assignment;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update assignment: $e');
    }
  }

  Future<void> deleteAssignment(String assignmentId) async {
    try {
      await _assignmentService.deleteAssignment(assignmentId);
      _assignments.removeWhere((assignment) => assignment.id == assignmentId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete assignment: $e');
    }
  }

  Future<List<Assignment>> getAssignmentsByClassroom(String classroomId) async {
    try {
      return await _assignmentService.getAssignmentsByClassroom(classroomId);
    } catch (e) {
      throw Exception('Failed to fetch assignments by classroom: $e');
    }
  }

  Future<List<Assignment>> getAssignmentsByStudent(String studentId) async {
    try {
      return await _assignmentService.getAssignmentsByStudent(studentId);
    } catch (e) {
      throw Exception('Failed to fetch assignments by student: $e');
    }
  }

  Future<void> createAssignmentForClassroom(
      Assignment assignment, String classroomId) async {
    try {
      // 반(classroom)에 과제 등록
      await _assignmentService.createAssignmentForClassroom(
          assignment, classroomId);
    } catch (e) {
      throw Exception('Failed to create assignment: $e');
    }
  }

  Future<void> createAssignmentForStudent(
      Assignment assignment, String studentId) async {
    try {
      // 학생(student)에 과제 등록
      await _assignmentService.createAssignmentForStudent(
          assignment, studentId);
    } catch (e) {
      throw Exception('Failed to create assignment: $e');
    }
  }

  //after 0806

  // 과제 등록 메소드
  Future<void> addAssignment(Assignment assignment, String classroomId) async {
    try {
      final String assignmentId = await _assignmentService
          .addAssignmentToStudents(assignment, classroomId);
      await _classroomService.addAssignmentToClassroom(classroomId, assignment);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add assignment: $e');
    }
  }

  // 학생 등록시 학생에게도 과제 등록 메소드
  Future<void> addAssignmentToStudent(
      String classroomId, String studentId, Assignment assignment) async {
    try {
      if (studentId != null && studentId != '') {
        _assignmentService.addAssignmentToStudent(
            classroomId, studentId, assignment);
      } else
        () {
          print('studentId exeption');
        };
    } catch (e) {
      throw Exception('Failed to add assignment to student: $e');
    }
  }

  // 학생 페이지에서 과제들 불러오기
  Future<List<Assignment>> getAssignmentsForStudent(
      String classroomId, String? studentId) async {
    try {
      return await _assignmentService.getAssignmentsForStudent(
          classroomId, studentId);
    } catch (e) {
      // Handle error
      throw Exception('Failed to fetch student assignments: $e');
    }
  }

  Future<void> addPoint(classroomId, studentId, assignment) async {
    try {
      _assignmentService.addPoint(classroomId, studentId, assignment);
      ChangeNotifier();
    } catch (e) {
      throw Exception('Failed to add assignment to student: $e');
    }
  }
}
