import 'package:cloud_firestore/cloud_firestore.dart';

import '../datamodels/new_student.dart';

class NewStudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _classroomCollection =
      FirebaseFirestore.instance.collection('newClassrooms');

  // classroom에 등록되어있는 Students 가져오기
  Future<List<NewStudent>> getStudentsByClassroomId(String classroomId) async {
    final querySnapshot = await _classroomCollection
        .doc(classroomId)
        .collection('students')
        .get();

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
  }

  Future<void> updateStudents() async {}

  Future<void> deleteStudent() async {}
}
