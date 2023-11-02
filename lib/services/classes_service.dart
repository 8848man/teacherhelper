import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacherhelper/datamodels/classes.dart';

class ClassesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _classroomsCollection =
      FirebaseFirestore.instance.collection('classrooms');

  // layout 컨텐츠에서 사용할 Classes CRUD
  Future<void> createClassesLayout() async {}
  Future<List<Classes>> getClassesLayout() async {
    return List<Classes>.empty();
  }

  Future<void> updateClassesLayout() async {}
  Future<void> deleteClassesLayout() async {}
}
