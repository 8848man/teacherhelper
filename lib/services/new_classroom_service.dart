import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacherhelper/datamodels/classroom.dart';
import 'package:teacherhelper/datamodels/new_student.dart';

class NewClassroomService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _classroomCollection =
      FirebaseFirestore.instance.collection('newClassrooms');

  // 반 등록
  Future<void> createClassroom(
    Classroom classroom,
    List<NewStudent> students,
  ) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Add classroom to 'classrooms' collection
      DocumentReference classroomRef = _classroomCollection.doc();
      batch.set(classroomRef, classroom.toJson());

      // Add students to 'students' subcollection of the created classroom
      CollectionReference studentsCollection =
          classroomRef.collection('students');
      for (NewStudent student in students) {
        student.classroomId = classroomRef.id;
        batch.set(studentsCollection.doc(), student.toJson());
      }

      // Commit the batch
      await batch.commit();

      // Additional logic if needed...
    } catch (e) {
      print('Error creating classroom: $e');
      // Handle error
    }
  }

  Future<List<Classroom>> getClassroomsByTeacherId(String teacherUid) async {
    try {
      final querySnapshot = await _firestore
          .collection('newClassrooms')
          .where('teacherUid', isEqualTo: teacherUid)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Classroom(
          id: data['id'],
          uid: doc.id,
          name: data['name'],
          teacherUid: data['teacherUid'],
          isDeleted: data['isDeleted'],
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch classrooms: $e');
    }
  }

  Future<void> updateClassroom() async {}

  Future<void> deleteClassroom() async {}
}
