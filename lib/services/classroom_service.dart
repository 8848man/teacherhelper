import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacherhelper/datamodels/assignment.dart';
import 'package:teacherhelper/datamodels/classroom.dart';

class ClassroomService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _classroomCollection =
      FirebaseFirestore.instance.collection('classrooms');

  Future<QuerySnapshot> read(String uid) async {
    return _classroomCollection.where('uid', isEqualTo: uid).get();
  }

  // 반 생성
  Future<String?> createClassroom(Classroom classroom) async {
    final documentRef = _firestore.collection('classrooms').doc();
    classroom.id = documentRef.id;

    try {
      await documentRef.set(classroom.toJson());
      print('Document ID: ${documentRef.id}');
      return documentRef.id;
    } catch (error) {
      print('Error adding document: $error');
      return null;
    }
  }

  // 반 불러올 때 필요한 uid
  Future<List<Classroom>> getClassroomsByTeacher(String teacherUid) async {
    try {
      final querySnapshot = await _firestore
          .collection('classrooms')
          .where('teacherUid', isEqualTo: teacherUid)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Classroom(
          id: data['id'],
          uid: doc.id,
          name: data['name'],
          grade: data['grade'],
          teacherUid: data['teacherUid'],
          isDeleted: data['isDeleted'],
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch classrooms: $e');
    }
  }

  Future<List<String>> getClassroomNames(List<String> classroomIds) async {
    try {
      final snapshot = await _classroomCollection
          .where(FieldPath.documentId, whereIn: classroomIds)
          .get();

      final classroomNames = snapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['name'] as String)
          .toList();

      return classroomNames;
    } catch (e) {
      throw Exception('Failed to fetch classroom names: $e');
    }
  }

  // 학생을 반에 등록
  Future<void> registerStudentToClassroom(
      String studentId, String classroomId) async {
    try {
      final classroomDoc = _classroomCollection.doc(classroomId);
      await classroomDoc.update({
        'students': FieldValue.arrayUnion([studentId])
      });
    } catch (e) {
      throw Exception('Failed to register student to classroom: $e');
    }
  }

  // 반에서 학생 등록 해제
  Future<void> unregisterStudentFromClassroom(
      String studentId, String classroomId) async {
    try {
      final classroomDoc = _classroomCollection.doc(classroomId);
      await classroomDoc.update({
        'students': FieldValue.arrayRemove([studentId])
      });
    } catch (e) {
      throw Exception('Failed to unregister student from classroom: $e');
    }
  }

  // 반에 과제 id 등록
  Future<void> addAssignmentToClassroom(
      String classroomId, Assignment assignment) async {
    try {
      _classroomCollection
          .doc(classroomId)
          .collection('Assignments')
          .add(assignment.toJson());
    } catch (e) {
      throw Exception('Failed to add assignment to classroom: $e');
    }
  }

  Future<bool> deleteClassroom(String classroomId) async {
    try {
      // 현재 시간을 얻습니다.
      DateTime currentTime = DateTime.now();

      // Firestore에 업데이트할 데이터를 Map 형태로 생성합니다.
      Map<String, dynamic> updateData = {
        'deletedDate': currentTime,
        'isDeleted': true,
      };

      // 해당 Classroom 문서에 업데이트를 수행합니다.
      await _firestore
          .collection('classrooms')
          .doc(classroomId)
          .update(updateData);

      return true;
    } catch (error) {
      print('반 삭제가 실패했습니다.$error');
      return false;
    }
  }
}
