import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/attitude.dart';
import 'package:teacherhelper/datamodels/daily_history.dart';
import 'package:teacherhelper/services/history_service.dart';

class HistoryProvider with ChangeNotifier {
  final HistoryService _historyService;

  HistoryProvider() : _historyService = HistoryService();

  List<DailyHistory> _dailys = [];
  List<DailyHistory> get dailys => _dailys;

  List<Attitude> _attitudes = [];
  List<Attitude> get attitudes => _attitudes;

  List<dynamic> _allHistory = [];
  List<dynamic> get allHistory => _allHistory;

  // 모든 History 가져오기
  void getAllHistorys(String classroomId) async {
    _attitudes = await _historyService.getAttitudesByClassroom(classroomId);

    _dailys = await _historyService.getDailysByClassroom(classroomId);

    List<Attitude> nonNullCheckDateAttitudes =
        _attitudes.where((attitude) => attitude.checkDate != null).toList();
    nonNullCheckDateAttitudes
        .sort((a, b) => a.checkDate!.compareTo(b.checkDate!));

    List<DailyHistory> nonNullCheckDateDailys =
        _dailys.where((daily) => daily.checkDate != null).toList();
    nonNullCheckDateDailys.sort((a, b) => a.checkDate!.compareTo(b.checkDate!));

    List<dynamic> combinedList = [..._attitudes, ...nonNullCheckDateDailys];
    combinedList.sort((a, b) => a.checkDate!.compareTo(b.checkDate!));

    _allHistory = combinedList;
  }
}
