import 'package:cloud_firestore/cloud_firestore.dart';

import '../datamodels/classroom.dart';
import '../datamodels/new_daily.dart';
import '../datamodels/new_student.dart';

class NewDailyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _classroomCollection =
      FirebaseFirestore.instance.collection('newClassrooms');

  // 일상 생성
  Future<void> createDaily(
      String classroomId, List<NewStudent> students, NewDaily daily) async {
    try {
      final WriteBatch batch = FirebaseFirestore.instance.batch();
      final CollectionReference dailyOriginCollection =
          _classroomCollection.doc(classroomId).collection('dailyOrigin');

      // 반에 일상 원형 데이터 생성
      batch.set(dailyOriginCollection.doc(), daily.toJson());

      final CollectionReference dailyHistoryCollection = FirebaseFirestore
          .instance
          .collection('newClassrooms')
          .doc(classroomId)
          .collection('newDailyHistory');
      // 학생들 개개인에 일상 추가
      for (final NewStudent student in students) {
        daily.studentId = student.id;

        batch.set(dailyHistoryCollection.doc(), daily.toJson());
      }

      // batch의 모든 쓰기 작업을 커밋
      await batch.commit();
      print('Data saved successfully.');
    } catch (e) {
      // 예외가 발생한 경우 처리
      print('Error saving data: $e');
      // 여기에서 예외 처리 작업 추가 가능
    }
  }

  // 해당 날짜에 따라 Daily 데이터 가져오기
  /**
   * 현재 DateTime으로 쿼리하는 방법이 잘 안되는중. 일단 모든 문서 가져와서 앱단에서 Date 조건문으로 처리하도록 구성
   */
  Future<List<NewDaily>> getDailyByClassroomId(
      String classroomId, DateTime thisDate) async {
    // DateTime startOfDay =
    //     DateTime(thisDate.year, thisDate.month, thisDate.day, 0, 0, 0, 0);
    // DateTime endOfDay =
    //     DateTime(thisDate.year, thisDate.month, thisDate.day, 23, 59, 59, 999);
    print('getDailysByService');
    try {
      // Firestore 인스턴스 생성
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      // 결과를 저장할 List
      List<NewDaily> result = [];

      print('classroomId is $classroomId');

      QuerySnapshot querySnapshot = await firestore
          .collectionGroup('newDailyHistory')
          .where('classroomId', isEqualTo: classroomId)
          .where('studentId', isNotEqualTo: "")
          .get();

      querySnapshot.docs.forEach((DocumentSnapshot document) {
        if (document.exists) {
          // NewDaily 객체로 변환하여 리스트에 추가
          NewDaily newDaily =
              NewDaily.fromJson(document.data() as Map<String, dynamic>);
          newDaily.id = document.id;
          result.add(newDaily);
        }
      });

      // 리스트 반환
      return result;
      // 리스트 반환
    } catch (e) {
      print('Error fetching data: $e');
      // 에러 발생 시 빈 리스트 반환 또는 다른 적절한 처리 수행
      return [];
    }
  }

  Future<void> checkDaily(NewDaily newDaily) async {
    try {
      newDaily.checkDate = DateTime.now();
      newDaily.isChecked = !newDaily.isChecked;
      final CollectionReference dialyHistoryCollection = _classroomCollection
          .doc(newDaily.classroomId)
          .collection('newDailyHistory');
      // 지정된 컬렉션 내 문서 업데이트
      await dialyHistoryCollection.doc(newDaily.id).update(newDaily.toJson());

      print('Document updated successfully!');
    } catch (e) {
      print('Error updating document: $e');
    }
  }
}
