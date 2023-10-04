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

  // classroomId로 태도 데이터 가져오기 페이지 탭에 필요
  Future<List<Attitude>> fetchAttitudesByClassroomId(String classroomId) async {
    try {
      _attitudes =
          await _attitudeService.fetchAttitudesByClassroomId(classroomId);

      return _attitudes;
    } catch (e) {
      throw Exception('Failed to get attitude to attitudes : $e');
    }
  }

  // 태도 추가하기
  Future<void> addAttitude(Attitude attitude, String classroomId) async {
    try {
      final querySnapshot = await _attitudeService.getLastOrder(classroomId);

      Map<String, dynamic> dataMap =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      int lastOrder = dataMap['order'] + 1;

      attitude.order = lastOrder;

      attitude.classroomId = classroomId;

      await _attitudeService.addAttitudeToStudents(attitude, classroomId);
      await _attitudeService.addAttitudeToClassroom(attitude, classroomId);

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // 학생 태도 체크하기
  Future<void> checkAttitude(
      Attitude attitudeData, String studentName, int studentNumber) async {
    attitudeData.studentName = studentName;
    attitudeData.studentNumber = studentNumber;

    try {
      attitudeData.point = attitudeData.point! + 1;
      _attitudeService.checkAttitude(attitudeData);
    } catch (e) {
      throw Exception(e);
    }

    notifyListeners();
  }

  // // 학반에 태도 추가하기
  // Future<void> addAttitudeToClassroom(
  //     Attitude attitude, String classroomId) async {
  //   try {
  //     // 마지막 order를 저장하기 위한 변수
  //     final querySnapshot = await _attitudeService.getLastOrder(classroomId);

  //     Map<String, dynamic> dataMap =
  //         querySnapshot.docs.first.data() as Map<String, dynamic>;
  //     int lastOrder = dataMap['order'] + 1;

  //     attitude.order = lastOrder;

  //     _attitudeService.addAttitudeToClassroom(attitude, classroomId);
  //   } catch (e) {
  //     throw Exception('Failed to add assignment to classroom: $e');
  //   }
  // }
}
