import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:teacherhelper/datamodels/assignment.dart';
import 'package:teacherhelper/datamodels/assignmentHistory.dart';

class AssignmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _assignmentCollection =
      FirebaseFirestore.instance.collection('assignments');
  final CollectionReference _classroomsCollection =
      FirebaseFirestore.instance.collection('classrooms');
  final CollectionReference _studentsCollection =
      FirebaseFirestore.instance.collection('students');

  Future<List<Assignment>> getAssignments() async {
    try {
      final querySnapshot = await _assignmentCollection.get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Assignment.fromJson(data as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch assignments: $e');
    }
  }

  Future<void> updateAssignment(Assignment assignment) async {
    try {
      await _assignmentCollection
          .doc(assignment.id)
          .update(assignment.toJson());
    } catch (e) {
      throw Exception('Failed to update assignment: $e');
    }
  }

  Future<void> deleteAssignment(String assignmentId) async {
    try {
      await _assignmentCollection.doc(assignmentId).delete();
    } catch (e) {
      throw Exception('Failed to delete assignment: $e');
    }
  }

  Future<List<Assignment>> getAssignmentsByClassroom(String classroomId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('classrooms')
          .doc(classroomId)
          .collection('Assignments')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Assignment.fromJson(data as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch assignments by classroom: $e');
    }
  }

  Future<List<Assignment>> getAssignmentsByStudent(String studentId) async {
    try {
      final querySnapshot = await _assignmentCollection
          .where('students', arrayContains: studentId)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Assignment.fromJson(data as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch assignments by student: $e');
    }
  }

  Future<void> createAssignmentForClassroom(
      Assignment assignment, String classroomId) async {
    try {
      final classroomDoc = await _classroomsCollection.doc(classroomId).get();

      if (classroomDoc.exists) {
        // 반(classroom)의 assignments 필드에 과제 추가
        await _classroomsCollection.doc(classroomId).update({
          'assignments': FieldValue.arrayUnion([assignment.toJson()])
        });

        // 반(classroom)에 속한 학생들의 Id 가져오기
        final studentIds = (classroomDoc.data()
            as Map<String, dynamic>)['students'] as List<String>?;

        // 학생들의 assignments 필드에 과제 추가
        for (final studentId in studentIds!) {
          await _studentsCollection.doc(studentId).update({
            'assignments': FieldValue.arrayUnion([assignment.toJson()])
          });
        }
      }
    } catch (e) {
      throw Exception('Failed to create assignment: $e');
    }
  }

  Future<void> createAssignmentForStudent(
      Assignment assignment, String studentId) async {
    try {
      // 학생(student)의 assignments 필드에 과제 추가
      await _studentsCollection.doc(studentId).update({
        'assignments': FieldValue.arrayUnion([assignment.toJson()])
      });
    } catch (e) {
      throw Exception('Failed to create assignment: $e');
    }
  }

  //after 0806

  // 과제 등록 기능.
  // 사용 페이지 : classroomDetailPage
  Future<String> addAssignmentToStudents(
      Assignment assignment, String classroomId) async {
    final studentsSnapshot = await _classroomsCollection
        .doc(classroomId)
        .collection('Students')
        .get();
    try {
      for (var studentDoc in studentsSnapshot.docs) {
        await studentDoc.reference
            .collection('assignments')
            .add(assignment.toJson());
      }
      // 학생 등록 후 반에 과제 등록
      final documentRef = await _assignmentCollection.add(assignment.toJson());
      return documentRef.id;
    } catch (e) {
      throw Exception('Failed to add assignment: $e');
    }
  }

  // 학생 등록시 과제도 등록하게 만드는 메소드
  Future<void> addAssignmentToStudent(
      String classroomId, String studentId, Assignment assignment) async {
    try {
      final studentRef = _classroomsCollection
          .doc(classroomId)
          .collection('Students')
          .doc(studentId);
      await studentRef.collection('assignments').add(assignment.toJson());
    } catch (e) {
      throw Exception('Failed to add assignment to student: $e');
    }
  }

  // 학생 페이지에서 과제들 불러오기
  Future<List<Assignment>> getAssignmentsForStudent(
      String classroomId, String? studentId) async {
    try {
      final assignmentDocs = await _firestore
          .collection('classrooms')
          .doc(classroomId) // Replace with the actual classroom ID
          .collection('Students')
          .doc(studentId)
          .collection('assignments')
          .get();

      return assignmentDocs.docs.map((doc) {
        final data = doc.data();
        return Assignment.fromJson(data, doc.id);
      }).toList();
    } catch (e) {
      // Handle error
      throw Exception('Failed to fetch student assignments: $e');
    }
  }

  Future<void> addPoint(classroomId, studentId, assignment) async {
    DateTime nowDate = DateTime.now();

    AssignmentHistory history = AssignmentHistory(
      checkDate: nowDate,
      isAdd: true,
    );

    try {
      final assignmentRef = _classroomsCollection
          .doc(classroomId)
          .collection('Students')
          .doc(studentId)
          .collection('assignments')
          .doc(assignment.id);

      assignment.point = (int.parse(assignment.point) + 1).toString();
      await assignmentRef.update(assignment.toJson());
      await assignmentRef.collection('history').add(history.toJson());
    } catch (e) {
      throw Exception('Failed to add assignment to student: $e');
    }
  }
}
