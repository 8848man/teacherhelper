import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/providers/student_provider.dart';
import 'package:teacherhelper/services/auth_service.dart';

class StudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 반 컬랙션
  final CollectionReference _classroomCollection =
      FirebaseFirestore.instance.collection('classrooms');

  // 학생 컬랙션
  final CollectionReference _studentsCollection =
      FirebaseFirestore.instance.collection('students');

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

  // Classroom에서 학생 가져오기
  Future<List<Student>> fetchStudentsByClassroom(String classroomId) async {
    try {
      final querySnapshot = await _classroomCollection
          .doc(classroomId)
          .collection('Students')
          .orderBy('studentNumber')
          .get();

      // studentNumber가 String으로 들어가있는데 다른 코드들이 String으로 작성되어있어 Int를 기준으로 정렬. 추후 수정 필요
      final studentList = querySnapshot.docs.map((doc) {
        final data = doc.data();
        final studentNumber =
            int.parse(data['studentNumber']); // String을 Int로 변환
        return {
          'id': doc.id,
          'name': data['name'],
          'gender': data['gender'],
          'birthdate': data['birthdate'],
          'studentNumber': studentNumber, // Int로 변환한 값 사용
        };
      }).toList();

      studentList.sort(
          (a, b) => a['studentNumber'].compareTo(b['studentNumber'])); // 정렬

      final sortedStudentList = studentList.map((studentData) {
        // studentNumber를 다시 String으로 변환
        return Student(
          id: studentData['id'],
          name: studentData['name'],
          gender: studentData['gender'],
          birthdate: studentData['birthdate'],
          studentNumber: studentData['studentNumber'].toString(),
          // Additional student fields
        );
      }).toList();

      return sortedStudentList;
    } catch (e) {
      throw Exception('Failed to fetch students: $e');
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
          .orderBy('studentNumber')
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Student(
          id: doc.id,
          name: data['name'],
          gender: data['gender'],
          birthdate: data['birthdate'],
          studentNumber: data['studentNumber'],
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

  // 학생 등록
  Future<String?> create(Student student, String classroomId) async {
    String? studentId;

    try {
      CollectionReference studentsCollection =
          _classroomCollection.doc(classroomId).collection('Students');

      QuerySnapshot existingStudent = await studentsCollection
          .where('studentNumber', isEqualTo: student.studentNumber)
          .get();

      if (existingStudent.docs.isEmpty) {
        final documentRef = await studentsCollection.add(student.toJson());
        studentId = documentRef.id;
      } else {
        return null;
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
      _classroomCollection
          .doc(classroomId)
          .collection('Students')
          .doc(studentId)
          .delete();
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

  Future<void> registStudents(
      List<String?> checkedStudents, String classroomId) async {
    print('test002');
    print(checkedStudents);
    try {
      _classroomCollection
          .doc(classroomId)
          .collection('students')
          .doc()
          .set(checkedStudents as Map<String, dynamic>);
    } catch (e) {
      print(e);
    }
  }
}
