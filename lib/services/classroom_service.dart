// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ClassroomService extends ChangeNotifier {
//   final classroomCollection =
//       FirebaseFirestore.instance.collection('classroom');

//   Future<QuerySnapshot> read(String uid) async {
//     // 내 bucketList 가져오기
//     return classroomCollection.where('uid', isEqualTo: uid).get();
//   }

//   void createStudent(String name, int number, String uid) async {
//     // bucket 만들기
//     await classroomCollection.add({
//       'uid': uid, // 유저 식별자
//       'name': name, // 하고싶은 일
//       'number': number, // 학번
//     });
//     notifyListeners(); // 화면 갱신
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacherhelper/datamodels/assignment.dart';
import 'package:teacherhelper/datamodels/classroom.dart';

class ClassroomService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _classroomCollection =
      FirebaseFirestore.instance.collection('classrooms');

  Future<QuerySnapshot> read(String uid) async {
    return _classroomCollection.where('uid', isEqualTo: uid).get();
  }

  // 반 생성
  Future<void> createClassroom(Classroom classroom) async {
    try {
      final documentRef = _firestore.collection('classrooms').doc();
      classroom.id = documentRef.id;
      await documentRef.set(classroom.toJson());
    } catch (e) {
      throw Exception('Failed to create classroom: $e');
    }
  }

  // 반 불러올 때 필요한 uid
  Future<List<Classroom>> getClassroomsByTeacher(String teacherUid) async {
    try {
      final querySnapshot = await _firestore
          .collection('classrooms')
          .where('teacherUid', isEqualTo: teacherUid)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Classroom(
          id: data['id'],
          uid: doc.id,
          name: data['name'],
          grade: data['grade'],
          teacherUid: data['teacherUid'],
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch classrooms: $e');
    }
  }

  Future<List<String>> getClassroomNames(List<String> classroomIds) async {
    try {
      final snapshot = await _classroomCollection
          .where(FieldPath.documentId, whereIn: classroomIds)
          .get();

      final classroomNames = snapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['name'] as String)
          .toList();

      return classroomNames;
    } catch (e) {
      throw Exception('Failed to fetch classroom names: $e');
    }
  }

  // 학생을 반에 등록
  Future<void> registerStudentToClassroom(
      String studentId, String classroomId) async {
    try {
      final classroomDoc = _classroomCollection.doc(classroomId);
      await classroomDoc.update({
        'students': FieldValue.arrayUnion([studentId])
      });
    } catch (e) {
      throw Exception('Failed to register student to classroom: $e');
    }
  }

  // 반에서 학생 등록 해제
  Future<void> unregisterStudentFromClassroom(
      String studentId, String classroomId) async {
    try {
      final classroomDoc = _classroomCollection.doc(classroomId);
      await classroomDoc.update({
        'students': FieldValue.arrayRemove([studentId])
      });
    } catch (e) {
      throw Exception('Failed to unregister student from classroom: $e');
    }
  }

  // 반에 과제 id 등록
  Future<void> addAssignmentToClassroom(
      String classroomId, Assignment assignment) async {
    try {
      _classroomCollection
          .doc(classroomId)
          .collection('Assignments')
          .add(assignment.toJson());
    } catch (e) {
      throw Exception('Failed to add assignment to classroom: $e');
    }
  }
}
