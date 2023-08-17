import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/providers/student_provider.dart';
import 'package:teacherhelper/services/auth_service.dart';

class StudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 학생 컬랙션
  final CollectionReference _studentsCollection =
      FirebaseFirestore.instance.collection('students');
  // 반 컬랙션
  final CollectionReference _classroomCollection =
      FirebaseFirestore.instance.collection('classrooms');

  // 현재 사용자의 uid 가져오기
  final String? currentUserUid = AuthService().currentUser()?.uid.toString();

  // StudentService(this._studentProvider);

  // 학생 목록 가져오기
  Future<QuerySnapshot> read(String uid) async {
    return _studentsCollection.where('uid', isEqualTo: uid).get();
  }

  // StudentId로 학생 가져오기
  Future<Student> getStudentById(String studentId) async {
    try {
      final docSnapshot = await _studentsCollection.doc(studentId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return Student(
          id: studentId,
          name: data['name'],
          gender: data['gender'],
          birthdate: data['birthdate'],
          // Additional student fields
        );
      } else {
        throw Exception('Student not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch student: $e');
    }
  }

  // ClassroomId로 학생 목록 가져오기
  // Future<List<Student>> getStudentsByClassroom(String classroomId) async {
  //   try {
  //     final querySnapshot = await _studentsCollection
  //         .where('classrooms', arrayContains: classroomId)
  //         .get();

  //     return querySnapshot.docs.map((doc) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       return Student(
  //         id: doc.id,
  //         name: data['name'],
  //         gender: data['gender'],
  //         birthdate: data['birthdate'],
  //         // Additional student fields
  //       );
  //     }).toList();
  //   } catch (e) {
  //     throw Exception('Failed to fetch students: $e');
  //   }
  // }

  // ClassroomId로 학생 목록 가져오기
  Future<List<Student>> getStudentsByClassroom(String classroomId) async {
    try {
      final querySnapshot = await _classroomCollection
          .doc(classroomId)
          .collection('Students')
          .get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Student(
          id: doc.id,
          name: data['name'],
          gender: data['gender'],
          birthdate: data['birthdate'],
          // Additional student fields
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch students: $e');
    }
  }

  // teacherId로 학생 목록 가져오기
  Future<List<Student>> getStudentsByTeacher(String teacherUid) async {
    try {
      final querySnapshot = await _studentsCollection
          .where('teacherUid', isEqualTo: teacherUid)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Student(
          id: doc.id,
          name: data['name'],
          gender: data['gender'],
          birthdate: data['birthdate'],
          // Additional student fields
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch students: $e');
    }
  }

  // 학생 추가
  // void create(Student student, String? classroom) async {
  //   // 반 ID 얻기
  //   String? classroomId;
  //   if (classroom != null) {
  //     classroomId = await getClassroomIdByName(classroom);
  //   }
  //   await _studentsCollection.add({
  //     'name': student.name,
  //     'gender': student.gender,
  //     'birthdate': student.birthdate,
  //     'teacherUid': currentUserUid,
  //   }).then(
  //     (docRef) {
  //       if (classroom != null && classroom != '') {
  //         // 학생 컬랙션에 반 등록
  //         _studentsCollection.doc(docRef.id).update({
  //           'classrooms': FieldValue.arrayUnion([classroomId])
  //         });
  //         // 반 컬랙션에 학생 등록
  //         FirebaseFirestore.instance
  //             .collection('classrooms')
  //             .doc(classroomId)
  //             .update({
  //           'students': FieldValue.arrayUnion([docRef.id])
  //         });
  //       }
  //     },
  //   );
  // }

  // Future<String?> create(Student student, String classroomId) async {
  //   String studentId;
  //   //await _classroomCollection.where('teacherUid', isEqualTo: currentUserUid)
  //   await _classroomCollection
  //       .doc(classroomId)
  //       .get()
  //       .then((documentSnapshot) async {
  //     // 검색된 문서를 가져옵니다.
  //     if (documentSnapshot.exists) {
  //       // "Students" 서브컬렉션 참조를 얻습니다.
  //       CollectionReference studentsCollection =
  //           documentSnapshot.reference.collection('Students');

  //       CollectionReference assignmentCollection = documentSnapshot.reference
  //           .collection('classrooms')
  //           .doc(classroomId)
  //           .collection('Assignments');
  //       final assignmentsSnapshot = await assignmentCollection
  //           .doc(classroomId)
  //           .collection('Students')
  //           .get();

  //       // "student" 문서를 "Students" 서브컬렉션에 추가합니다.
  //       studentId =
  //           studentsCollection.add(student.toJson()).then((documentRef) async {
  //         // newDocumentRef.collection('assignments').add();

  //         // try {
  //         //   for (var studentDoc in assignmentsSnapshot.docs) {
  //         //     await studentDoc.reference
  //         //         .collection('assignments')
  //         //         .add(assignment.toJson());
  //         //   }
  //         //   return documentRef.id;
  //         // } catch (e) {
  //         //   throw Exception('Failed to add assignment: $e');
  //         // }

  //         print('Student document added successfully!');

  //         return documentRef.id;
  //       }).catchError((error) {
  //         print('Error adding student document: $error');
  //         return null;
  //       }).toString();
  //     } else {
  //       print('Document with ID $classroomId not found.');
  //       return null;
  //     }
  //   }).catchError((error) {
  //     print('Error searching document: $error');
  //     return null;
  //   });
  //   return 'test0606';
  // }

  Future<String?> create(Student student, String classroomId) async {
    String? studentId;

    try {
      final documentSnapshot =
          await _classroomCollection.doc(classroomId).get();
      if (documentSnapshot.exists) {
        final studentsCollection =
            documentSnapshot.reference.collection('Students');

        final assignmentCollection =
            documentSnapshot.reference.collection('Assignments');
        final assignmentsSnapshot = await assignmentCollection.get();

        final documentRef = await studentsCollection.add(student.toJson());
        studentId = documentRef.id;

        // 다음부터는 과제 컬렉션에 과제 추가 등의 로직을 수행할 수 있습니다.
        for (var studentDoc in assignmentsSnapshot.docs) {
          // studentDoc.reference.collection('assignments').add(assignment.toJson());
        }

        print('Student document added successfully with ID: $studentId');
      } else {
        print('Document with ID $classroomId not found.');
      }
    } catch (error) {
      print('Error: $error');
    }

    return studentId;
  }

  // 학생 삭제
  void delete(String uid) {
    _studentsCollection.doc(uid).delete();
  }

  // 학생 수정
  void update(Student student) async {
    // 이전 데이터를 가져오고 'student_history' 컬렉션에 추가
    DocumentSnapshot previousData =
        await _studentsCollection.doc(student.id).get();
    Map<String, dynamic>? previousDataMap =
        previousData.data() as Map<String, dynamic>?;
    await addToStudentHistory(student.id ?? "", previousDataMap ?? {});

    await _studentsCollection.doc(student.id).update(
      {'name': student.name, 'birthdate': student.birthdate},
    );
  }

  // 학생 수정시 수정 이전 데이터 저장
  Future<void> addToStudentHistory(
      String uid, Map<String, dynamic> data) async {
    // 'student_history' 컬렉션의 참조
    CollectionReference historyCollection = FirebaseFirestore.instance
        .collection('students')
        .doc(uid)
        .collection('student_history');

    // 'student_history' 컬렉션에 데이터 추가
    await historyCollection.doc().set(data);
  }

  Future<void> fetchStudents() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('students')
          .where('teacherUid', isEqualTo: currentUserUid)
          .get();
      final List<Student> students = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Student(
          id: doc.id,
          name: data['name'],
          gender: data['gender'],
          birthdate: data['birthdate'],
          teacherUid: currentUserUid,
          classroomUids: [],
        );
      }).toList();
      // _studentProvider.setStudents(students);
    } catch (e) {
      print('Failed to fetch students: $e');
    }
  }

  // 학생 등록
  Future<void> createStudent(
      String name, String gender, String birthdate, String teacherUid,
      {List<String>? classroomUids}) async {
    try {
      final studentData = {
        'name': name,
        'gender': gender,
        'birthdate': birthdate,
        'teacherUid': teacherUid,
      };

      if (classroomUids != null && classroomUids.isNotEmpty) {
        studentData['classroomUids'] = classroomUids as String;
      }

      await _studentsCollection.add(studentData);
    } catch (e) {
      throw Exception('Failed to create student: $e');
    }
  }

  // 학생의 반 등록
  Future<void> registerStudentToClassroom(
      String studentId, String classroomId) async {
    try {
      final studentDoc = _studentsCollection.doc(studentId);
      await studentDoc.update({
        'classrooms': FieldValue.arrayUnion([classroomId])
      });
    } catch (e) {
      throw Exception('Failed to register student to classroom: $e');
    }
  }

  // 학생의 반 등록 해제
  Future<void> unregisterStudentFromClassroom(
      String studentId, String classroomId) async {
    try {
      final studentDoc = _studentsCollection.doc(studentId);
      await studentDoc.update({
        'classrooms': FieldValue.arrayRemove([classroomId])
      });
    } catch (e) {
      throw Exception('Failed to unregister student from classroom: $e');
    }
  }

  // 반 이름으로 반 Id를 조회해주는 함수
  Future<String?> getClassroomIdByName(String className) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('classrooms')
        .where('name', isEqualTo: className)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final String classroomId = snapshot.docs.first.id;
      return classroomId;
    } else {
      return null; // 해당 이름의 반을 찾지 못한 경우
    }
  }

  // 반 Id로 학생들을 조회
  // Future<List<Map<String, dynamic>>> fetchStudentsByClassroom(
  //     String targetId) async {
  //   List<Map<String, dynamic>> dataList = [];

  //   try {
  //     DocumentSnapshot documentSnapshot =
  //         await _firestore.collection('classrooms').doc(targetId).get();

  //     if (documentSnapshot.exists) {
  //       CollectionReference studentsCollection =
  //           documentSnapshot.reference.collection('Students');

  //       QuerySnapshot querySnapshot = await studentsCollection.get();

  //       dataList = querySnapshot.docs
  //           .map((doc) => doc.data())
  //           .cast<Map<String, dynamic>>()
  //           .toList();
  //     }
  //   } catch (error) {
  //     print('Error fetching data: $error');
  //   }

  //   return dataList;
  // }
}
