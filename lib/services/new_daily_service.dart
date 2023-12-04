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
      Classroom classroom, List<NewStudent> students, NewDaily daily) async {
    try {
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      // 반에 일상 원형 데이터 생성
      batch.set(_classroomCollection.doc(), daily.toJson());

      // 학생들 개개인에 일상 추가
      for (final NewStudent student in students) {
        final CollectionReference studentDailysCollection =
            FirebaseFirestore.instance
                .collection('newClassrooms')
                .doc(classroom.id)
                .collection('students')
                .doc(student.id) // 학생의 고유 ID를 사용
                .collection('dailys');

        batch.set(studentDailysCollection.doc(), daily.toJson());
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
}
