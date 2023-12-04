import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacherhelper/repository/classrooms/classrooms_repository.dart';

import '../../models/classroom_model.dart';

class ClassroomsAPI extends ClassroomsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Future<List<ClassroomModel>> getAllClassroomsByTeacherId(
      String teacherUid) async {
    try {
      final querySnapshot = await _firestore
          .collection('classrooms')
          .where('teacherUid', isEqualTo: teacherUid)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return ClassroomModel(
          id: doc.id,
          name: data['name'],
          teacherUid: data['teacherUid'],
          isDeleted: data['isDeleted'],
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch classrooms: $e');
    }
  }

  @override
  Future<ClassroomModel> getClassroomById(String classroomId) {
    // TODO: implement getClassroomById
    throw UnimplementedError();
  }
}
