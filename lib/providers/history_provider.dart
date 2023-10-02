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
    _attitudes.sort((a, b) => a.checkDate!.compareTo(b.checkDate!));

    print('test004');
    _dailys = await _historyService.getDailysByClassroom(classroomId);
    _dailys.sort((a, b) => a.checkDate!.compareTo(b.checkDate!));
    List<dynamic> combinedList = [..._attitudes, ..._dailys];
    combinedList.sort((a, b) => a.checkDate!.compareTo(b.checkDate!));

    print(_attitudes);
  }
}
