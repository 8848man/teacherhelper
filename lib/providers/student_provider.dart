import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/services/auth_service.dart';
import 'package:teacherhelper/services/student_service.dart';

class StudentProvider with ChangeNotifier {
  final StudentService _studentService = StudentService();
  final currentUserUid = AuthService().currentUser()?.uid;

  // 앱에 실제로 사용되는 학생들 데이터를 위한 변수
  List<Student> _students = [];
  List<Student> get students => _students;

  // 학생을 수정할 때 DB에 저장되어있던 학생들을 저장하는 변수.
  List<Student> _loadedStudents = [];
  List<Student> get loadedStudent => _loadedStudents;

  set students(List<Student> students) {
    _students = students;
    notifyListeners();
  }

  // 학생 불러오기
  Future<QuerySnapshot> read(String uid) {
    return _studentService.read(uid);
  }

  // studentId로 학생 가져오기
  Future<Student> fetchStudentById(String studentId) {
    return _studentService.getStudentById(studentId);
  }

  // 현재 로그인한 teacherUid로 학생 가져오기
  Future<List<Student>> getStudentsByTeacher() async {
    final currentUserUid = AuthService().currentUser()?.uid;
    try {
      // final List<Student> students =
      //     await _studentService.getStudentsByTeacher(currentUserUid!);
      return students;
    } catch (e) {
      throw Exception('Failed to fetch students: $e');
    }
  }

  // classroomId로 학생 가져오기
  Future<void> fetchStudentsByClassroom(String classroomId) async {
    try {
      _students = [];
      _students = await _studentService.fetchStudentsByClassroom(classroomId);
      _loadedStudents = _students;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch students: $e');
    }
  }

  // 학생을 반에서 삭제하기
  Future<void> unregisterStudentFromClassroom(
      String studentId, String classroomId) async {
    await _studentService.unregisterStudentFromClassroom(
        studentId, classroomId);
    ChangeNotifier();
  }

  // 학생 추가
  Future<String?> create(
    Student student,
    String classroomId,
  ) async {
    return _studentService.create(student, classroomId);
    // notifyListeners();
  }

  // 학생 삭제
  void delete(String uid) {
    _studentService.delete(uid);
    notifyListeners();
  }

  void update(Student student) {
    _studentService.update(student);
    notifyListeners();
  }

  // 학생 리스트 저장
  // void setStudents(List<Student> students) {
  //   _students = students;
  //   notifyListeners();
  // }

  // after 0806
  // classroomId로 학생 가져오기.
  Future<List<Student>> getStudentsByClassroom(String classroomId) async {
    try {
      final List<Student> students =
          await _studentService.getStudentsByClassroom(classroomId);
      return students;
    } catch (e) {
      throw Exception('Failed to fetch students: $e');
    }
  }

  // provider에 저장된 학생들 리셋
  void resetStudents() {
    _students = [];
    notifyListeners();
  }

  // classroom regist / modify 페이지에서 provider students에 학생 추가(DB에 저장 X)
  void addStudent({
    required int studentNumber,
    required String studentName,
    required String studentGender,
    required Function(String message) onSuccess, // 로그인 성공시 호출되는 함수
    required Function(String err) onError, // 에러 발생시 호출되는 함수
  }) {
    try {
      // 학생 이름이 빈 값일 경우 바로 리턴.
      if (studentName != '') {
        for (Student student in students) {
          if (student.studentNumber == studentNumber.toString()) {
            onError('학번이 중복되었습니다. 이전 학생을 삭제하고 등록하시겠습니까?');
            return null;
          }
        }

        _students.add(
          Student(
            name: studentName,
            studentNumber: studentNumber.toString(),
            gender: studentGender,
            createdDate: DateTime.now(),
          ),
        );

        onSuccess('$studentNumber 학번 $studentName 학생이 추가되었습니다.');
        notifyListeners();
      } else {
        onSuccess('학생 이름을 입력해주세요.');
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

  // 학번이 같은 학생 덮어쓰기.
  void setStudent(
      String studentNumber, String studentName, String studentGender) {
    // 학번이 같은 학생을 찾아서 인덱스를 구합니다.
    int indexToReplace = _students
        .indexWhere((student) => student.studentNumber == studentNumber);

    if (indexToReplace != -1) {
      // 학번이 같은 학생을 찾았을 때
      _students.removeAt(indexToReplace); // 해당 인덱스의 학생 객체 삭제
    }

    // 새로운 학생 정보를 생성하여 해당 인덱스에 삽입
    Student newStudent = Student(
        studentNumber: studentNumber, name: studentName, gender: studentGender);
    _students.insert(
        indexToReplace != -1 ? indexToReplace : _students.length, newStudent);

    notifyListeners();
  }

  // 학생을 번호로 정렬하는 기능
  void sortStudentsByNumber(isAscending) {
    if (isAscending) {
      _students.sort((a, b) =>
          int.parse(b.studentNumber!).compareTo(int.parse(a.studentNumber!)));
    } else {
      _students.sort((a, b) =>
          int.parse(a.studentNumber!).compareTo(int.parse(b.studentNumber!)));
    }
    notifyListeners();
  }

  // 학생을 이름으로 정렬하는 기능
  void sortStudentsByName(isAscending) {
    if (isAscending) {
      _students.sort((a, b) => b.name.compareTo(a.name));
    } else {
      _students.sort((a, b) => a.name.compareTo(b.name));
    }
    notifyListeners();
  }

  // 학생을 성별로 정렬하는 기능
  void sortStudentsByGender(isAscending) {
    if (isAscending) {
      _students.sort((a, b) => b.gender.compareTo(a.gender));
    } else {
      _students.sort((a, b) => a.gender.compareTo(b.gender));
    }
    notifyListeners();
  }

  // classroom regist / modify 페이지에서의 학생 체크 로직
  void checkStudent(String studentNumber) {
    Student selectedStudent = _students
        .firstWhere((student) => student.studentNumber == studentNumber);
    // isChecked 토큰 반전
    if (selectedStudent.isChecked != null) {
      selectedStudent.isChecked = !selectedStudent.isChecked!;
    } else {
      selectedStudent.isChecked = true;
    }

    notifyListeners();
  }
}
