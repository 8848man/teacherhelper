import 'package:flutter/material.dart';

import '../datamodels/classroom.dart';
import '../datamodels/new_daily.dart';
import '../datamodels/new_student.dart';
import '../services/new_daily_service.dart';

class NewDailyProvider extends ChangeNotifier {
  final NewDailyService _newclassroomService;

  NewDailyProvider() : _newclassroomService = NewDailyService();

  final List<NewDaily> _dailys = [];
  List<NewDaily> get dailys => _dailys;

  Future<void> createDaily(
      Classroom classroom, List<NewStudent> students, NewDaily daily) async {
    _newclassroomService.createDaily(classroom, students, daily);
  }

  Future<void> getDailysByClassroomId() async {
    print('getDailysByClassroomId');
    Future.delayed(const Duration(seconds: 2));
  }

  Future<void> updateDailys() async {}

  Future<void> deleteDailys() async {}
}
