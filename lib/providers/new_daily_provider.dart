import 'package:flutter/material.dart';

import '../datamodels/classroom.dart';
import '../datamodels/new_daily.dart';
import '../datamodels/new_student.dart';
import '../services/new_daily_service.dart';

class NewDailyProvider extends ChangeNotifier {
  final NewDailyService _newDailyService;

  NewDailyProvider() : _newDailyService = NewDailyService();

  List<NewDaily> _dailys = [];
  List<NewDaily> get dailys => _dailys;

  // daily 만들기
  Future<void> createDaily(
      String classroomId, List<NewStudent> students, NewDaily daily) async {
    _newDailyService.createDaily(classroomId, students, daily);
    notifyListeners();
  }

  // daily 가져오기
  Future<void> getDailysByClassroomId(
      String classroomId, DateTime thisDate) async {
    print('getDailysByClassroomId');

    List<NewDaily> tempDailys =
        await _newDailyService.getDailyByClassroomId(classroomId, thisDate);

    // for (NewDaily tempDaily in tempDailys) {
    //   print('tempDaily are ${tempDaily.toJson()}');
    // }
    List<NewDaily> filteredDailys = await filterDaily(tempDailys, thisDate);

    _dailys = filteredDailys;
    // print('_dailys are $filteredDailys');
    notifyListeners();
    Future.delayed(const Duration(seconds: 2));
  }

  // Daily 날짜에 따라 필터링
  Future<List<NewDaily>> filterDaily(
      List<NewDaily> dailys, DateTime thisDate) async {
    List<NewDaily> filteredDailys = dailys.where((daily) {
      // daily의 createdDate를 년/월/일까지의 문자열로 변환
      String dailyDate =
          "${daily.createdDate?.year}-${daily.createdDate?.month}-${daily.createdDate?.day}";

      return dailyDate == "${thisDate.year}-${thisDate.month}-${thisDate.day}";
    }).toList();
    return filteredDailys;
  }

  Future<void> checkDailys(NewDaily newDaily) async {
    await _newDailyService.checkDaily(newDaily);
  }

  Future<void> updateDailys() async {}

  Future<void> deleteDailys() async {}
}
