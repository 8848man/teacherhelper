import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/classroom.dart';
import 'package:teacherhelper/datamodels/lesson.dart';
import 'package:teacherhelper/datamodels/new_daily.dart';
import 'package:teacherhelper/datamodels/new_student.dart';
import 'package:teacherhelper/datamodels/structured_classroom_data.dart';
import 'package:teacherhelper/datamodels/structured_history_data.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/providers/student_provider.dart';
import 'package:teacherhelper/services/assignment_service.dart';
import 'package:teacherhelper/services/attitude_service.dart';
import 'package:teacherhelper/services/auth_service.dart';
import 'package:teacherhelper/services/classroom_service.dart';
import 'package:teacherhelper/services/daily_service.dart';
import 'package:teacherhelper/services/student_service.dart';

class ClassroomProvider with ChangeNotifier {
  final ClassroomService _classroomService;
  final DailyService _dailyService;
  final AssignmentService _assignmentService;
  final StudentService _studentService;
  final AttitudeService _attitudeService;

  final StudentProvider _studentProvider = StudentProvider();

  StudentProvider get studentProvider => _studentProvider;

  final currentUserUid = AuthService().currentUser()?.uid;

  ClassroomProvider()
      : _classroomService = ClassroomService(),
        _dailyService = DailyService(),
        _assignmentService = AssignmentService(),
        _studentService = StudentService(),
        _attitudeService = AttitudeService();

  List<Classroom> _classrooms = [];
  List<Classroom> get classrooms => _classrooms;

  Classroom _classroom = Classroom(name: '', teacherUid: '');
  Classroom get classroom => _classroom;

  StructuredClassroomData _classroomData = StructuredClassroomData();
  StructuredClassroomData get classroomData => _classroomData;

  // 반 Id 세팅
  void setClassroom(Classroom classroom) {
    _classroom = classroom;
    notifyListeners();
  }

  void setClassroomData(Map<String, dynamic> classroomData) {
    Classroom classroom = classroomData['classroom'];
    List<NewStudent> students = classroomData['students'];
    List<NewDaily>? dailys = classroomData['dailys'];
    List<Lesson>? lessons = classroomData['lessons'];
    List<StructuredHistoryData>? structuredHistoryData =
        classroomData['historyData'];

    _classroomData = StructuredClassroomData(
      classroom: classroom,
      students: students,
      dailys: dailys,
      lessons: lessons,
      structuredHistoryData: structuredHistoryData,
    );
  }

  Future<QuerySnapshot> read(String? uid) async {
    return _classroomService.read(uid!);
  }

  // 반 등록
  Future<void> createClassroom(
      Classroom classroom, List<Student> students) async {
    try {
      classroom.createdDate = DateTime.now();
      String? classroomId = await _classroomService.createClassroom(classroom);

      // 학생 등록
      List<String> studentIds =
          await _studentService.registStudents(students, classroomId!);
      // 기본적으로 등록되어야 하는 일상 및 과제 등록
      await _dailyService.addDefaultDaily(classroom.id, studentIds);
      await _assignmentService.addDefaultAssignment(classroom.id);
      await _attitudeService.addDefaultAttitude(classroom.id, studentIds);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to create classroom: $e');
    }
  }

  // 반 수정 로직
  Future<void> modifyClassroom(Classroom classroom) async {
    try {
      // print(classroom);
      // checkedStudents 전처리
      studentProvider.updateStudents(classroom.uid!);

      // 학생 등록
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to create classroom: $e');
    }
  }

  // 선생님 ID로 반 불러오기
  Future<void> fetchClassrooms(String teacherUid) async {
    _classrooms = await _classroomService.getClassroomsByTeacher(teacherUid);
    notifyListeners();
  }

  // 반 ID로 반 객체 가져오기
  Classroom getClassroomById(String classroomId) {
    return _classrooms.firstWhere((classroom) => classroom.uid == classroomId);
  }

  // 반 ID로 반 객체 가져오기
  Future<List<String>> fetchClassroomNames(List<String> classroomIds) async {
    return await _classroomService.getClassroomNames(classroomIds);
  }

  Future<void> registerStudentToClassroom(
      String studentId, String classroomId) async {
    await _classroomService.registerStudentToClassroom(studentId, classroomId);
    await fetchClassrooms(currentUserUid!);
  }

  Future<void> unregisterStudentFromClassroom(
      String studentId, String classroomId) async {
    await _classroomService.unregisterStudentFromClassroom(
        studentId, classroomId);
    await fetchClassrooms(currentUserUid!);
  }

  // 학생 관련 함수 모음

  //Future<void>

  // 학생 관련 함수 모음 끝

  Future<void> deleteClassroom(
      {required String classroomId,
      required Function onSuccess,
      required Function onError}) async {
    try {
      bool isSuccess = await _classroomService.deleteClassroom(classroomId);

      if (isSuccess) {
        onSuccess();
      } else {
        onError('반 삭제에 실패했습니다. 계속 이런 에러가 발생한다면 관리자에게 문의하세요.');
      }
    } catch (e) {
      print(e);
    }
  }

  /// 11/22 data 구조 변경 후 코드
  /// 반 등록
  Future<void> createNewClassroom(
    Classroom classroom,
    List<NewStudent> students,
  ) async {
    classroom.createdDate = DateTime.now();

    classroom.name = '${classroom.name} test';
    // 해당 코드로 생성된 classroom 드러나지 않도록 isDeleted = true
    classroom.isDeleted = false;
    try {
      print('test002');
      await _classroomService.createNewClassroom(classroom, students);
    } catch (e) {
      print('Error creating classroom: $e');
      // Handle error
    }
  }
  // Future<List<Classroom>> getNewClassroom(String teacherUid) async {}

  Future<void> updateNewClassroom() async {}

  Future<void> deleteNewClassroom() async {}
}
