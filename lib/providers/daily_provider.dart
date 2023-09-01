import 'package:flutter/cupertino.dart';
import 'package:teacherhelper/datamodels/daily.dart';
import 'package:teacherhelper/services/classroom_service.dart';
import 'package:teacherhelper/services/daily_service.dart';

class DailyProvider with ChangeNotifier {
  final DailyService _dailyService;
  final ClassroomService _classroomService = ClassroomService();

  DailyProvider() : _dailyService = DailyService();

  List<Daily> _dailys = [];
  List<Daily> get dailys => _dailys;

  Future<List<Daily>> fetchDailysByClassroomId(String classroomId) async {
    try {
      _dailys = await _dailyService.fetchDailysByClassroomId(classroomId);
      return _dailys;
    } catch (e) {
      throw Exception('Failed to get daily to dailys : $e');
    }
  }

  Future<void> addDaily(Daily daily, String classroomId) async {
    try {
      await _dailyService.addDailyToStudents(daily, classroomId);
      await _dailyService.addDailyToClassroom(daily, classroomId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add assignment: $e');
    }
  }

  // ClassroomId로 Daily 가져오기.
  Future<List<Daily>> getDailysByClassroom(String classroomId) async {
    try {
      return await _dailyService.getDailysByClassroom(classroomId);
    } catch (e) {
      throw Exception('Failed to fetch assignments by classroom: $e');
    }
  }

  // ClassroomId, StudentId로 학생에 Daily 입력하기.
  Future<void> addDailysToStudent(
      String classroomId, String studentId, Daily daily) async {
    try {
      print('test002');
      if (studentId != null && studentId != '') {
        _dailyService.addDailysToStudent(classroomId, studentId, daily);
        print('test003');
      } else
        () {
          print('studentId exeption');
        };
    } catch (e) {
      throw Exception('Failed to add assignment to student: $e');
    }
  }

  // 데일리 체크 메소드
  Future<void> checkDaily(
      String classroomId, String studentId, String dailyId) async {
    _dailyService.checkDaily(classroomId, studentId, dailyId);
  }
}
