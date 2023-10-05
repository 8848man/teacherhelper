import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teacherhelper/datamodels/attitude.dart';
import 'package:teacherhelper/datamodels/daily_history.dart';
import 'package:teacherhelper/datamodels/history_date.dart';
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

  List<dynamic> _searchedHistory = [];
  List<dynamic> get searchedHistory => _searchedHistory;

  // 모든 History 가져오기
  getAllHistorys(String classroomId) async {
    // 기록 초기화
    _allHistory = [];

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

    processHistoryData(classroomId, combinedList);
    return true;
  }

  // HistoryList에 날짜 추가
  void processHistoryData(
      String classroomId, List<dynamic> combinedList) async {
    // 이전 코드 ...

    List<HistoryDate> historyDates = [];
    List<DateTime> dateTimes = [];

    // 모든 Attitude와 DailyHistory를 돌면서 날짜를 추가
    for (var item in combinedList) {
      if (item is Attitude) {
        // Attitude 데이터 처리
        _allHistory.add(item);
        dateTimes.add(item.checkDate!);
        historyDates.add(HistoryDate(checkDate: item.checkDate!));
      } else if (item is DailyHistory) {
        // DailyHistory 데이터 처리
        _allHistory.add(item);
        dateTimes.add(item.checkDate!);
        historyDates.add(HistoryDate(checkDate: item.checkDate!));
      }
    }

    // 중복되지 않은 날짜만 남김
    Set<HistoryDate> uniqueDates = Set<HistoryDate>.from(historyDates);

    // 중복을 제거한 날짜를 _allHistory에 추가
    _allHistory.addAll(uniqueDates);

    _allHistory.sort((a, b) => a.checkDate!.compareTo(b.checkDate!));
    notifyListeners();
  }

  // 날짜를 원하는 형식의 문자열로 포맷하는 메서드
  String formatDateString(DateTime? date) {
    if (date != null) {
      // 날짜를 여기서 원하는 형식으로 포맷
      return DateFormat('MM월 dd일').format(date);
    }
    return '';
  }

  void getHistorysByCondition(int studentNumber) {
    _searchedHistory = [];
    List<HistoryDate> historyDates = [];
    List<DateTime> dateTimes = [];

    // 학번을 위한 조건
    List<dynamic> tempHistory = allHistory.where((item) {
      if (item is Attitude && item.studentNumber == studentNumber) {
        return true;
      } else if (item is DailyHistory && item.studentNumber == studentNumber) {
        return true;
      }
      return false;
    }).toList();

    for (var item in tempHistory) {
      if (item is Attitude) {
        // Attitude 데이터 처리
        _searchedHistory.add(item);
        dateTimes.add(item.checkDate!);
        historyDates.add(HistoryDate(checkDate: item.checkDate!));
      } else if (item is DailyHistory) {
        // DailyHistory 데이터 처리
        _searchedHistory.add(item);
        dateTimes.add(item.checkDate!);
        historyDates.add(HistoryDate(checkDate: item.checkDate!));
      }
    }

    // 중복되지 않은 날짜만 남김
    Set<HistoryDate> uniqueDates = Set<HistoryDate>.from(historyDates);

    // 중복을 제거한 날짜를 _allHistory에 추가
    _searchedHistory.addAll(uniqueDates);

    _searchedHistory.sort((a, b) => a.checkDate!.compareTo(b.checkDate!));
    notifyListeners();
  }
}
