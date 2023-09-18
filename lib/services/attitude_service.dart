import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacherhelper/datamodels/assignment.dart';
import 'package:teacherhelper/datamodels/assignmentHistory.dart';
import 'package:teacherhelper/datamodels/attitude.dart';

class AttitudeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _classroomsCollection =
      FirebaseFirestore.instance.collection('classrooms');
  final CollectionReference _studentsCollection =
      FirebaseFirestore.instance.collection('students');

  // 태도 가져오기
  Future<List<Attitude>> fetchAttitudesByClassroomId(String classroomId) async {
    final querySnapshot = await _classroomsCollection
        .doc(classroomId)
        .collection('Attitude')
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      final id = doc.id; // 문서의 ID를 가져옵니다.

      return Attitude(name: data['name'], order: data['order'], id: id);
    }).toList()
      ..sort((a, b) => a.order!.compareTo(b.order!));
  }

  // 학반 등록시 기본 태도 등록
  Future<void> addDefaultAttitude(String classroomId, Attitude attitude) async {
    _classroomsCollection
        .doc(classroomId)
        .collection('Attitude')
        .add(attitude.toJson());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLastOrder(String classroomId) {
    return _classroomsCollection
        .doc(classroomId)
        .collection('Attitude')
        .orderBy('order', descending: true)
        .limit(1)
        .get();
  }
}
