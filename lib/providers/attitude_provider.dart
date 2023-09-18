import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/attitude.dart';
import 'package:teacherhelper/services/attitude_service.dart';

class AttitudeProvider with ChangeNotifier {
  final AttitudeService _attitudeService;

  final CollectionReference _classroomsCollection =
      FirebaseFirestore.instance.collection('classrooms');

  AttitudeProvider() : _attitudeService = AttitudeService();

  List<Attitude> _attitudes = [];
  List<Attitude> get attitudes => _attitudes;

  // classroomId로 태도 데이터 가져오기
  Future<List<Attitude>> fetchAttitudesByClassroomId(String classroomId) async {
    try {
      _attitudes =
          await _attitudeService.fetchAttitudesByClassroomId(classroomId);
      return _attitudes;
    } catch (e) {
      throw Exception('Failed to get attitude to attitudes : $e');
    }
  }

  // Attitude 추가할 때 Students에도 추가하기.
  Future<void> addAtittudeToStudents(
      Attitude attitude, String classroomId) async {
    try {
      final studentsSnapshot = await _classroomsCollection
          .doc(classroomId)
          .collection('Students')
          .get();

      for (var studentDoc in studentsSnapshot.docs) {
        await studentDoc.reference
            .collection('attitude')
            .add(attitude.toJson());
      }
    } catch (e) {
      throw Exception('Failed to add attitude: $e');
    }
  }

  // 반 추가할 때 기본적으로 등록되는 태도.
  Future<void> addDefaultAttitude(String classroomId) async {
    try {
      List<Attitude> attitudeList = [];
      Attitude chattingAttitude = Attitude(
        name: '떠듦',
        order: 1,
      );
      attitudeList.add(chattingAttitude);
      Attitude badAttitude = Attitude(name: '태도불량', order: 2);
      attitudeList.add(badAttitude);

      for (var attitude in attitudeList) {
        _attitudeService.addDefaultAttitude(classroomId, attitude);
      }
    } catch (e) {
      print(e);
    }
  }

  // 학반에 태도 추가하기
  Future<void> addAttitudeToClassroom(
      Attitude attitude, String classroomId) async {
    try {
      // 마지막 order를 저장하기 위한 변수

      final querySnapshot = await _classroomsCollection
          .doc(classroomId)
          .collection('Attitude')
          .orderBy('order', descending: true)
          .limit(1)
          .get();

      int lastOrder = querySnapshot.docs.first.data()['order'] + 1;

      attitude.order = lastOrder;

      _classroomsCollection
          .doc(classroomId)
          .collection('Attitude')
          .add(attitude.toJson());
    } catch (e) {
      throw Exception('Failed to add assignment to classroom: $e');
    }
  }
}
