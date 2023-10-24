import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacherhelper/datamodels/daily_history.dart';
import 'package:teacherhelper/datamodels/student.dart';

class DailyHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _classroomsCollection =
      FirebaseFirestore.instance.collection('classrooms');

  // 데일리 체크 메소드
  Future<void> checkDaily(
    String classroomId,
    String studentNumber,
    String dailyName,
    String? studentName,
    int? order,
    DateTime? checkDate,
    DailyHistory dailyHistory,
  ) async {
    try {
      // Batch 작업을 시작합니다.
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // 이전 버전 데일리 히스토리 컬랙션
      CollectionReference dailyHistoryCollection =
          _classroomsCollection.doc(classroomId).collection('DailyHistory');

      // dailyHistory 시간 체크
      dailyHistory.checkDate = DateTime.now();

      dailyHistory.isChecked = true;

      // 학생 데일리 히스토리 컬랙션
      CollectionReference dailyHistoryCollectionReform = _classroomsCollection
          .doc(classroomId)
          .collection('Students')
          .doc(dailyHistory.studentId)
          .collection('daily')
          .doc(dailyHistory.dailyId)
          .collection('dailyHistory');

      // DailyHistory에 추가할 데이터 생성
      Map<String, dynamic> data = {
        'studentNumber': int.parse(studentNumber),
        'dailyName': dailyName,
        'studentName': studentName,
        'order': order,
        'checkDate': checkDate ?? FieldValue.serverTimestamp(),
        'isChecked': true
      };

      // DailyHistory 컬렉션에 데이터 추가 (batch에 추가합니다)
      batch.set(dailyHistoryCollection.doc(), data);

      // Student에 dailyHistory 추가
      batch.set(dailyHistoryCollectionReform.doc(), dailyHistory.toJson());
      // Batch 작업을 커밋하여 데이터를 Firestore에 저장합니다.
      await batch.commit();
    } catch (e) {
      print('DailyHistory 추가 오류: $e');
      throw Exception('Failed to add DailyHistory: $e');
    }
  }

  //
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>?>
      fetchDailysByClassroomIdAndDailyOrder(
          String classroomId, int? order) async {
    try {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      Timestamp todayTimestamp = Timestamp.fromDate(today);

      // Firestore 쿼리
      final querySnapshot = await _classroomsCollection
          .doc(classroomId)
          .collection('DailyHistory')
          .where('order', isEqualTo: order)
          .where('checkDate', isGreaterThanOrEqualTo: todayTimestamp)
          .where('checkDate',
              isLessThan: Timestamp(todayTimestamp.seconds + 86400, 0))
          // .orderBy('checkDate', descending: true)
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

  // 데일리 체크 해제
  void unCheckDaily(String classroomId, Student student) async {
    try {
      await _classroomsCollection
          .doc(classroomId)
          .collection('Students')
          .doc(student.id)
          .collection('daily');
    } catch (e) {
      print(e);
    }
  }
}
