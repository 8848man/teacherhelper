import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacherhelper/datamodels/attitude.dart';
import 'package:teacherhelper/datamodels/student.dart';

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

      return Attitude(
        name: data['name'],
        order: data['order'],
        id: id,
        isBad: data['isBad'],
      );
    }).toList()
      ..sort((a, b) => a.order!.compareTo(b.order!));
  }

  // Future<void> fetchAttitudesByClassroomId(String classroomId) async {}

  // 학반 등록시 기본 태도 등록
  Future<void> addDefaultAttitude(
      String? classroomId, List<String> studentIds) async {
    try {
      List<Attitude> attitudeList = [];
      Attitude noiseAttitude = Attitude(
        name: '떠듦',
        order: 1,
        isBad: true,
        classroomId: classroomId,
      );
      attitudeList.add(noiseAttitude);
      Attitude badAttitudeAttitude = Attitude(
        name: '태도 불량',
        order: 2,
        isBad: true,
        classroomId: classroomId,
      );
      attitudeList.add(badAttitudeAttitude);

      var batch = FirebaseFirestore.instance.batch();

      // 반에 attitude를 등록
      for (var attitude in attitudeList) {
        // Attitude 객체를 Firestore 문서로 변환
        Map<String, dynamic> attitudeData = attitude.toJson();

        // Attitude 컬렉션의 참조 생성
        var attitudeRef =
            _classroomsCollection.doc(classroomId).collection('Attitude').doc();

        // 배치에 쓰기 작업 추가
        batch.set(attitudeRef, attitudeData);
      }

      // 학생에 attitude를 등록
      for (var studentId in studentIds) {
        for (var attitude in attitudeList) {
          Map<String, dynamic> attitudeData = attitude.toJson();
          attitudeData['studentId'] = studentId;

          // Attitude 컬렉션의 참조 생성
          var attitudeRef = _classroomsCollection
              .doc(classroomId)
              .collection('Students')
              .doc(studentId)
              .collection('attitude')
              .doc();

          // 배치에 쓰기 작업 추가
          batch.set(attitudeRef, attitudeData);
        }
      }

      // 배치 실행
      await batch.commit();
    } catch (e) {
      print(e);
    }
  }

  // 태도 마지막 Order 가져오기. attitude 추가시 필요
  Future<QuerySnapshot> getLastOrder(String classroomId) async {
    try {
      final querySnapshot = await _classroomsCollection
          .doc(classroomId)
          .collection('Attitude')
          .orderBy('order', descending: true)
          .limit(1)
          .get();
      return querySnapshot;
    } catch (e) {
      throw Exception('Error fetching Attitude data: $e');
    }
  }

  // classroom에 태도 추가
  Future<void> addAttitudeToClassroom(
      Attitude attitude, String classroomId) async {
    try {
      _classroomsCollection
          .doc(classroomId)
          .collection('Attitude')
          .add(attitude.toJson());
    } catch (e) {
      print(e);
    }
  }

  // student에 태도 추가
  Future<void> addAttitudeToStudents(
      Attitude attitude, String classroomId) async {
    try {
      final studentsSnapshot = await _classroomsCollection
          .doc(classroomId)
          .collection('Attitude')
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

  // attitude 데이터 가져오기. 생활 페이지에서 사용
  Future<List<Attitude>> getAttitudesByClassroomAndOrder(
      String classroomId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collectionGroup('attitude')
        .where('classroomId', isEqualTo: classroomId)
        .where('studentId', isNotEqualTo: '')
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      final id = doc.id; // 문서의 ID를 가져옵니다.

      return Attitude(
        name: data?['name'],
        order: data?['order'],
        id: id,
        isBad: data?['isBad'],
        point: data?['point'],
        studentId: data?['studentId'],
        classroomId: data?['classroomId'],
      );
    }).toList();
  }

  // attitude 체크 로직. 개선 필요
  Future<void> checkAttitude(Attitude attitudeData) async {
    try {
      final batch = _firestore.batch();
      attitudeData.checkDate = DateTime.now();
      final attitudeRef = _classroomsCollection
          .doc(attitudeData.classroomId)
          .collection('Students')
          .doc(attitudeData.studentId)
          .collection('attitude')
          .doc(attitudeData.id);
      final attitudeHistoryRef =
          attitudeRef.collection('attitudeHistory').doc();

      final addPoint = {'point': attitudeData.point};
      final addHistory = attitudeData.toJson();
      batch.update(attitudeRef, addPoint);
      batch.set(attitudeHistoryRef, addHistory);

      // 필드 업데이트를 수행합니다.
      batch.commit().then((_) {
        print("필드 업데이트가 성공했습니다.");
      }).catchError((error) {
        print("필드 업데이트 중 오류가 발생했습니다: $error");
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}
