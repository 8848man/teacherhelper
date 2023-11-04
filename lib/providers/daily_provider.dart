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

  // 일상 가져오기
  Future<List<Daily>> fetchDailysByClassroomId(String classroomId) async {
    try {
      _dailys = await _dailyService.fetchDailysByClassroomId(classroomId);
      return _dailys;
    } catch (e) {
      throw Exception('Failed to get daily to dailys : $e');
    }
  }

  // 일상 추가하기
  Future<void> addDaily(Daily daily, String classroomId) async {
    try {
      final querySnapshot = await _dailyService.getLastOrder(classroomId);

      Map<String, dynamic> dataMap =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      int lastOrder = dataMap['order'] + 1;

      daily.order = lastOrder;

      daily.classroomId = classroomId;

      await _dailyService.addDailyToStudents(daily, classroomId);
      await _dailyService.addDailyToClassroom(daily, classroomId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add assignment: $e');
    }
  }

  // ClassroomId로 Daily 가져오기. 개개인 학생 등록시 필요
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
      if (studentId != '') {
        _dailyService.addDailysToStudent(classroomId, studentId, daily);
      } else {
        () {
          print('studentId exeption');
        };
      }
    } catch (e) {
      throw Exception('Failed to add assignment to student: $e');
    }
  }

  // layout 컨텐츠에서 사용할 Daily CRUD
  Future<void> createDailyLayout(Daily daily, DateTime thisDate) async {
    print('dailyProvider complete');
    _dailyService.createDailyLayout(daily, thisDate);
  }

  Future<List<Daily>> getDailyLayout(
      String classroomId, DateTime thisDate) async {
    try {
      _dailys = [];
      _dailys = await _dailyService.getDailyLayout(classroomId, thisDate);
      print('getDailyLayout');
      print(_dailys);
      notifyListeners();
      return dailys;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateDailyLayout() async {
    _dailyService.updateDailyLayout();
  }

  Future<void> deleteDailyLayout() async {
    _dailyService.deleteDailyLayout();
  }
}
