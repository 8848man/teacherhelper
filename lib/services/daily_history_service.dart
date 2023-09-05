import 'package:cloud_firestore/cloud_firestore.dart';

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
  ) async {
    try {
      // DailyHistory 컬렉션 레퍼런스 생성
      CollectionReference dailyHistoryCollection =
          _classroomsCollection.doc(classroomId).collection('DailyHistory');

      // DailyHistory에 추가할 데이터 생성
      Map<String, dynamic> data = {
        'studentNumber': int.parse(studentNumber),
        'dailyName': dailyName,
        'studentName': studentName,
        'order': order,
        'checkDate': checkDate ?? FieldValue.serverTimestamp(),
        'isChecked': true
      };

      // DailyHistory 컬렉션에 데이터 추가
      await dailyHistoryCollection.add(data);

      print('DailyHistory 추가 완료');
    } catch (e) {
      print('DailyHistory 추가 오류: $e');
      throw Exception('Failed to add DailyHistory: $e');
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>?>
      fetchDailysByClassroomIdAndDailyOrder(
          String classroomId, int? order) async {
    try {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      Timestamp todayTimestamp = Timestamp.fromDate(today);

      // Firestore 쿼리
      final querySnapshot = await FirebaseFirestore.instance
          .collection('classrooms')
          .doc(classroomId)
          .collection('DailyHistory')
          .where('order', isEqualTo: order)
          .where('checkDate', isGreaterThanOrEqualTo: todayTimestamp)
          .where('checkDate',
              isLessThan: Timestamp(todayTimestamp.seconds + 86400, 0))
          // .orderBy('studentNumber') // 학생 번호로 정렬
          // .limit(1)
          .get();

      print('test001');
      print(order);
      querySnapshot.docs.forEach((doc) {
        final data = doc.data();
        print(data); // 해당 문서의 모든 데이터 출력
      });
      if (querySnapshot.docs.isNotEmpty) {
        print('test002');
        return querySnapshot.docs;
      } else {
        return null; // 결과가 없을 경우 null 반환
      }
    } catch (e) {}
  }
}
