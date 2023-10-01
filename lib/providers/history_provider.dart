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

  // 모든 History 가져오기
  void getAllHistorys(String classroomId) async {
    _attitudes = await _historyService.getAttitudesByClassroom(classroomId);
    _attitudes.sort((a, b) => a.checkDate!.compareTo(b.checkDate!));

    _dailys = await _historyService.getDailysByClassroom(classroomId);
    _dailys.sort((a, b) => a.checkDate!.compareTo(b.checkDate!));
    List<dynamic> combinedList = [..._attitudes, ..._dailys];
  }

  // History 정렬
  void sortHistory() {
    _dailys.sort((a, b) => a.checkDate!.compareTo(b.checkDate!));
    _attitudes.sort((a, b) => a.checkDate!.compareTo(b.checkDate!));
  }
}
