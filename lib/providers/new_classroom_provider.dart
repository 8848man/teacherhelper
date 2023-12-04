import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/classroom.dart';
import 'package:teacherhelper/datamodels/new_student.dart';
import 'package:teacherhelper/services/new_classroom_service.dart';

class NewClassroomProvider with ChangeNotifier {
  final NewClassroomService _newclassroomService;

  NewClassroomProvider() : _newclassroomService = NewClassroomService();

  List<Classroom> _classrooms = [];
  List<Classroom> get classrooms => _classrooms;

  Classroom _classroom = Classroom(name: '', teacherUid: '');
  Classroom get classroom => _classroom;

  // 반 생성
  Future<void> createClassroom(
    Classroom classroom,
    List<NewStudent> students,
  ) async {
    classroom.createdDate = DateTime.now();

    classroom.name = '${classroom.name} test';
    // 해당 코드로 생성된 classroom 드러나지 않도록 isDeleted = true
    classroom.isDeleted = false;
    try {
      await _newclassroomService.createClassroom(classroom, students);
    } catch (e) {
      print('Error creating classroom: $e');
      // Handle error
    }
  }

  // 선생님 Uid로 반 가져오기
  Future<void> getClassroomsByTeacherId(String teacherId) async {
    _classrooms =
        await _newclassroomService.getClassroomsByTeacherId(teacherId);
    notifyListeners();
  }

  // Classroom에 현재 Classroom 할당
  Future<void> fetchClassroomByClassroomId(String classroomId) async {
    print('fetchClassroomByClassroomId');
    _classroom =
        _classrooms.firstWhere((classroom) => classroom.uid == classroomId);
    notifyListeners();
  }

  Future<void> updateClassroom() async {}

  Future<void> deleteClassroom() async {}
}
