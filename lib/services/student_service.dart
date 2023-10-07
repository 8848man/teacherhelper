import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacherhelper/datamodels/student.dart';
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
          .where('isDeleted', isNotEqualTo: true)
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
          // 'birthdate': data['birthdate'],
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
          // birthdate: studentData['birthdate'],
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

  Future<List<String>> registStudents(
      List<Student> checkedStudents, String classroomId) async {
    try {
      final CollectionReference studentsCollection =
          _classroomCollection.doc(classroomId).collection('Students');

      DateTime nowDate = DateTime.now();

      // Firestore 배치 생성
      var batch = FirebaseFirestore.instance.batch();

      List<String> studentIds = [];

      for (var student in checkedStudents) {
        // Student 객체를 Firestore 문서로 변환
        Map<String, dynamic> studentData = {
          'classroomId': classroomId,
          'name': student.name,
          'studentNumber': student.studentNumber,
          'isChecked': student.isChecked,
          'createDate': nowDate,
          'gender': student.gender,
          // 날짜를 저장할 필드를 추가하려면 여기에 추가
        };

        // Students 컬렉션의 참조 생성
        var studentRef = studentsCollection.doc(); // Firestore에서 자동 생성된 ID 사용

        // 배치에 쓰기 작업 추가
        batch.set(studentRef, studentData);

        // 생성한 문서의 ID 가져오기
        var studentId = studentRef.id;

        studentIds.add(studentId);
      }

      // 배치 실행
      await batch.commit();

      return studentIds;
    } catch (e) {
      throw Exception('학생 등록 도중 에러가 발생했습니다.');
    }
  }

  // 학생 변경 로직
  void updateStudents(String classroomId, List<Student> students,
      List<Student> loadedStudents) {
    for (final student in students) {
      // 기존에 등록되어있던 학생 업데이트하기 위한 변수
      final deletedStudent = loadedStudents.firstWhere(
        (loaded) =>
            loaded.studentNumber == student.studentNumber &&
            loaded.name != student.name,
        orElse: () => Student(name: '', gender: ''),
      );

      // 업데이트할 학생(학번, 이름이 같은 학생들) 저장 변수
      final updateStudent = loadedStudents.firstWhere(
        (loaded) =>
            loaded.studentNumber == student.studentNumber &&
            loaded.name == student.name,
        orElse: () => Student(name: '', gender: ''),
      );

      if (deletedStudent != Student(name: '', gender: '')) {
        // 수정된 학생 데이터 처리
        if (student.isDeleted == true) {
          // 이미 삭제된 경우, 넘어감
          continue;
        }
        deletedStudent.isDeleted = true;
        deletedStudent.updatedDate = DateTime.now();

        // 삭제할 학생 삭제 체크
        try {
          _classroomCollection
              .doc(classroomId)
              .collection('students')
              .doc(deletedStudent.id)
              .update(deletedStudent.toJson());

          // 등록할 학생 등록
          _classroomCollection
              .doc(classroomId)
              .collection('students')
              .add(student.toJson());
        } catch (e) {
          print(e);
        }

        // 여기에서 필요한 로직 추가 가능
      }
      // 업데이트할 학생 업데이트
      if (updateStudent != Student(name: '', gender: '')) {
        // 수정된 학생 데이터 처리
        if (student.isDeleted == true) {
          // 이미 삭제된 경우, 넘어감
          continue;
        }
        updateStudent.updatedDate = DateTime.now();

        // Firestore에 수정된 내용 업데이트
        _classroomCollection
            .doc(classroomId)
            .collection('students')
            .doc(updateStudent.id)
            .update(updateStudent.toJson());

        // 여기에서 필요한 로직 추가 가능
      } else {
        // 새로 추가된 학생 데이터 처리
        // Firestore에 추가 작업 수행
        _firestore.collection('students').add(student.toJson());
      }

      // 삭제할 학생들 로직
      for (final loadedStudent in loadedStudents) {
        print(loadedStudent);
        final matchingStudent = students.firstWhere(
          (student) =>
              student.studentNumber == loadedStudent.studentNumber &&
              student.name == loadedStudent.name,
          orElse: () => Student(name: '', gender: ''),
        );

        if (matchingStudent == Student(name: '', gender: '')) {
          print('test006');
          print(loadedStudent);
          _classroomCollection
              .doc(classroomId)
              .collection('students')
              .doc(loadedStudent.id)
              .delete();
        }
      }
    }
  }

  // 학생 삭제 - 반 수정 페이지
  void deleteStudents(String classroomId, Iterable<Student> students) {
    for (var student in students) {
      _classroomCollection
          .doc(classroomId)
          .collection('Students')
          .doc(student.id)
          .update(
        {
          'isDeleted': true,
        },
      );
    }
  }
}
