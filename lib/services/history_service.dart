import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacherhelper/datamodels/attitude.dart';
import 'package:teacherhelper/datamodels/daily_history.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // attitude 데이터 가져오기.
  Future<List<Attitude>> getAttitudesByClassroom(String classroomId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collectionGroup('attitudeHistory')
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
        checkDate: data?['checkDate'] != null
            ? data!['checkDate'].toDate()
            : DateTime.now(),
      );
    }).toList();
  }

  Future<List<DailyHistory>> getDailysByClassroom(String classroomId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collectionGroup('dailyHistory')
        .where('classroomId', isEqualTo: classroomId)
        .where('studentId', isNotEqualTo: '')
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      final id = doc.id; // 문서의 ID를 가져옵니다.

      return DailyHistory(
        order: data?['order'],
        id: id,
        studentId: data?['studentId'],
        classroomId: data?['classroomId'],
        checkDate: data?['checkDate'] != null
            ? data!['checkDate'].toDate()
            : DateTime.now(),
        dailyName: data?['dailyName'],
      );
    }).toList();
  }
}
