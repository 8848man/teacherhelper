import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacherhelper/datamodels/daily.dart';

class DailyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _classroomsCollection =
      FirebaseFirestore.instance.collection('classrooms');

  // 일상을 학생에 추가
  Future<void> addDailyToStudents(Daily daily, String classroomId) async {
    try {
      final studentsSnapshot = await _classroomsCollection
          .doc(classroomId)
          .collection('Students')
          .get();

      for (var studentDoc in studentsSnapshot.docs) {
        await studentDoc.reference.collection('daily').add(daily.toJson());
      }
    } catch (e) {
      throw Exception('Failed to add assignment: $e');
    }
  }

  Future<void> addDailyToClassroom(Daily daily, String classroomId) async {
    try {
      _classroomsCollection
          .doc(classroomId)
          .collection('Daily')
          .add(daily.toJson());
    } catch (e) {
      throw Exception('Failed to add assignment to classroom: $e');
    }
  }
}
