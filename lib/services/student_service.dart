// import 'package:cloud_firestore/cloud_firestore.dart';

// class Class {
//   final String id;
//   final String name;
//   final List<String> students;

//   Class({
//     required this.id,
//     required this.name,
//     required this.students,
//   });

//   factory Class.fromSnapshot(DocumentSnapshot snapshot) {
//     final data = snapshot.data() as Map<String, dynamic>?;

//     return Class(
//       id: snapshot.id,
//       name: data?['name'] ?? '',
//       students: List<String>.from(data?['students'] ?? []),
//     );
//   }

//   static Future<Class> createClass(String name) async {
//     CollectionReference classes =
//         FirebaseFirestore.instance.collection('classes');
//     DocumentReference docRef = await classes.add({
//       'name': name,
//       'students': [],
//     });
//     return Class(
//       id: docRef.id,
//       name: name,
//       students: [],
//     );
//   }

//   Future<void> addStudent(String studentId) async {
//     DocumentReference classDoc =
//         FirebaseFirestore.instance.collection('classes').doc(id);
//     return classDoc.update({
//       'students': FieldValue.arrayUnion([studentId]),
//     });
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/providers/student_provider.dart';

class StudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StudentProvider _studentProvider;

  StudentService(this._studentProvider);

  Future<void> fetchStudents() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('students').get();
      final List<Student> students = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Student(
          id: doc.id,
          name: data['name'],
          gender: data['gender'],
          birthdate: data['birthdate'],
        );
      }).toList();
      _studentProvider.setStudents(students);
    } catch (e) {
      print('Failed to fetch students: $e');
    }
  }
}
