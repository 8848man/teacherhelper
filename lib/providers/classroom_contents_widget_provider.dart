import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/classes.dart';
import 'package:teacherhelper/datamodels/daily.dart';
import 'package:teacherhelper/datamodels/student.dart';

class ClassroomContentsWidgetProvider with ChangeNotifier {
  List<Daily> _dailyData = [];
  List<Classes> _classesData = [];
  List<Student> _studentData = [];

  List<Daily> get dailyData => _dailyData;
  List<Classes> get classesData => _classesData;
  List<Student> get studentData => _studentData;

  void updateData(List<Daily> newDailyData, List<Classes> newClassesData,
      List<Student> newStudentData) {
    _dailyData = newDailyData;
    _classesData = newClassesData;
    _studentData = newStudentData;
    notifyListeners();
  }
}
