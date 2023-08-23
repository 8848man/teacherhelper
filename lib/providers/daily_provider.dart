import 'package:flutter/cupertino.dart';
import 'package:teacherhelper/datamodels/daily.dart';
import 'package:teacherhelper/services/classroom_service.dart';
import 'package:teacherhelper/services/daily_service.dart';

class DailyProvider with ChangeNotifier {
  final DailyService _dailyService;
  final ClassroomService _classroomService = ClassroomService();

  DailyProvider() : _dailyService = DailyService();

  // Future<String> getDaily() {
  //   return '';
  // }

  Future<void> addDaily(Daily daily, String classroomId) async {
    try {
      await _dailyService.addDailyToStudents(daily, classroomId);
      await _dailyService.addDailyToClassroom(daily, classroomId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add assignment: $e');
    }
  }
}
