import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacherhelper/datamodels/attitudeHistory.dart';

class AttitudeHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _classroomsCollection =
      FirebaseFirestore.instance.collection('classrooms');

  // 데일리 체크 메소드
  Future<void> checkAttitude(
    String classroomId,
    AttitudeHistory attitudeHistory,
  ) async {
    try {
      // AttitudeHistory 컬렉션 레퍼런스 생성
      CollectionReference attitudeHistoryCollection =
          _classroomsCollection.doc(classroomId).collection('AttitudeHistory');

      // AttitudeHistory에 추가할 데이터 생성
      // Map<String, dynamic> data = {
      //   'studentNumber': int.parse(studentNumber),
      //   'attitudeName': attitudeName,
      //   'studentName': studentName,
      //   'order': order,
      //   'checkDate': checkDate ?? FieldValue.serverTimestamp(),
      //   'isChecked': true,
      // };

      // AttitudeHistory attitude = AttitudeHistory(
      //   studentName: studentName,
      //   studentNumber: int.parse(studentNumber),
      //   attitudeName: attitudeName,
      //   checkDate: checkDate,
      //   order: order,
      //   isAdd: true,
      // );

      // AttitudeHistory 컬렉션에 데이터 추가
      await attitudeHistoryCollection.add(attitudeHistory.toJson());

      print('AttitudeHistory 추가 완료');
    } catch (e) {
      print('AttitudeHistory 추가 오류: $e');
      throw Exception('Failed to add AttitudeHistory: $e');
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>?>
      fetchAttitudesByClassroomIdAndAttitudeOrder(
          String classroomId, int? order) async {
    try {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      Timestamp todayTimestamp = Timestamp.fromDate(today);

      // Firestore 쿼리
      final querySnapshot = await FirebaseFirestore.instance
          .collection('classrooms')
          .doc(classroomId)
          .collection('AttitudeHistory')
          .where('order', isEqualTo: order)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs;
      } else {
        return null; // 결과가 없을 경우 null 반환
      }
    } catch (e) {
      print(e);
      return null; // 에러 발생 시 null 반환 또는 예외 처리
    }
  }
}
