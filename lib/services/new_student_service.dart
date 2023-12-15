import 'package:cloud_firestore/cloud_firestore.dart';

import '../datamodels/new_student.dart';

class NewStudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _classroomCollection =
      FirebaseFirestore.instance.collection('newClassrooms');

  // classroom에 등록되어있는 Students 가져오기
  Future<List<NewStudent>> getStudentsByClassroomId(String classroomId) async {
    try {
      print('getStudentsByClassroomId_service');
      final querySnapshot = await _classroomCollection
          .doc(classroomId)
          .collection('students')
          .get();
      print('test005');

      if (querySnapshot.docs.isNotEmpty) {
        // 데이터가 있는 경우 처리
        print('doc isNotEmpty');
        print(querySnapshot.docs[0]);
      } else {
        // 데이터가 없는 경우 처리
        print('doc isEmpty');
      }

      return querySnapshot.docs.map((doc) {
        final data = doc.data();

        DateTime createdDate = DateTime.parse(data['createdDate']);

        return NewStudent(
          classroomId: classroomId,
          id: doc.id,
          name: data['name'],
          number: data['number'],
          gender: data['gender'],
          createdDate: createdDate,
        );
      }).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateStudents() async {}

  Future<void> deleteStudent() async {}
}
