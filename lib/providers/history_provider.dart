import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teacherhelper/datamodels/attitude.dart';
import 'package:teacherhelper/datamodels/daily_history.dart';
import 'package:teacherhelper/datamodels/date_for_history.dart';
import 'package:teacherhelper/datamodels/history_date.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/services/history_service.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;
import 'package:teacherhelper/functions/save_excel_mobile.dart'
    if (dart.library.html) 'package:teacherhelper/functions/save_excel_web.dart';

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

  // history 엑셀 출력
  Future<void> generateExcel(String classroomName, List<Student> students,
      DateForHistory dateForHistory) async {
    int orderCount = 3; // 각 항목의 order 갯수. 추후에는 함수를 호출할 때 받아오는 변수
    List<String> orderNames = ['출석', '가정통신문', '테스트'];
    //Create a Excel document.

    //Creating a workbook.
    final Workbook workbook = Workbook();
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = false;

    final Style globalStyle = workbook.styles.add('globalStyle');

    globalStyle.borders.all.lineStyle = LineStyle.thick;
    globalStyle.borders.all.color = '#9954CC';

    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();

    // 학생 리스트 입력
    for (var student in students) {
      int index = students.indexOf(student);
      sheet.getRangeByName('A${6 + index}').setText(student.studentNumber);

      sheet.getRangeByName('B${6 + index}').setText(student.name);
    }

    // History 데이터
    List<dynamic> filteredHistory =
        _allHistory.whereType<DailyHistory>().toList();

    // 2022년 10월 5일부터 2023년 1월 15일까지 각 날짜를 문자열로 표기하는 코드 -> 가공해서 쓸 예정
    int startYear = 2023;
    int endYear = 2023;

    DateTime startDate = DateTime(startYear, 10, 5);
    DateTime endDate = DateTime(endYear, 10, 20);

    int index = 0;
    for (DateTime date = startDate;
        date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
        date = date.add(const Duration(days: 1))) {
      // print("Date: ${date.toLocal().toString().substring(0, 10)}");

      String nowRow = getColumnLetter(index, orderCount, 0);
      List<String> rowForRowOrders = []; // 날짜 끝부분 저장을 위한 변수
      List<String> rowForOrders = []; // order(항목)을 나열하기 위한 변수

      // 리스트에 값 할당
      for (int i = 0; i <= orderCount - 1; i++) {
        rowForRowOrders.add(getColumnLetter(index + i, orderCount - 1, 0));
        rowForOrders.add(getColumnLetter(index, orderCount, i));
      }

      // print('nowRow is ${nowRow}');
      // print('rowForRowOrders.lase is ${rowForRowOrders.last}');
      // 년도(열) 세팅
      sheet.getRangeByName('${nowRow}4:${rowForOrders.last}4').merge();
      sheet
          .getRangeByName('${nowRow}4')
          .setText('${date.year}년 ${date.month}월 ${date.day}일');
      sheet.getRangeByName('${nowRow}4').cellStyle.fontSize = 11;
      sheet.getRangeByName('${nowRow}4').columnWidth = 10;
      sheet.getRangeByName('${nowRow}4').rowHeight = 15;

      // order 항목들 입력
      for (int i = 0; i <= orderCount - 1; i++) {
        sheet.getRangeByName('${rowForOrders[i]}5').setText(orderNames[i]);
      }

      // 학생들의 History 내역을 표시
      for (var student in students) {
        int index = students.indexOf(student);

        // 빈 칸들 X로 초기화
        for (int i = 0; i <= orderCount - 1; i++) {
          sheet.getRangeByName('${rowForOrders[i]}${index + 6}').setText('X');
        }

        // 학생마다 History 내역 값 입력
        for (var historyItem in filteredHistory) {
          if (historyItem is DailyHistory) {
            if (historyItem.checkDate != null &&
                historyItem.checkDate!.year == date.year &&
                historyItem.checkDate!.month == date.month &&
                historyItem.checkDate!.day == date.day) {
              for (int i = 1; i <= orderCount; i++) {
                if (historyItem.order == i &&
                    int.parse(student.studentNumber!) ==
                        historyItem.studentNumber) {
                  sheet
                      .getRangeByName('${rowForOrders[i - 1]}${index + 6}')
                      .setText('O');
                }
              }
            }
          }
        }
      }

      index++;
    }

    sheet.getRangeByName('A1').cellStyle.borders.all;

    sheet.getRangeByName('A1:AA1').columnWidth = 10;

    sheet.getRangeByName('A5').rowHeight = 15;
    // 반 이름 셀 병합
    sheet.getRangeByName('A1:B3').merge();

    // 반 이름
    sheet.getRangeByName('A1').setText(classroomName);
    sheet.getRangeByName('A1').cellStyle.hAlign = HAlignType.center;
    sheet.getRangeByName('A1').cellStyle.vAlign = VAlignType.center;
    sheet.getRangeByName('A1').cellStyle.fontSize = 12;

    // 항목 제목 셀 병합
    sheet.getRangeByName('C1:N3').merge();

    // 항목 제목
    sheet.getRangeByName('C1').setText('시간별 기록(Daily)');
    sheet.getRangeByName('C1').cellStyle.hAlign = HAlignType.center;
    sheet.getRangeByName('C1').cellStyle.vAlign = VAlignType.center;
    sheet.getRangeByName('C1').cellStyle.fontSize = 12;

    // 학생 학번 및 이름
    sheet.getRangeByName('A5').setText('학번');
    sheet.getRangeByName('B5').setText('이름');

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();

    //Save and launch the file.
    await saveAndLaunchFile(bytes, 'Invoice.xlsx');
  }

  String getColumnLetter(int index, int totalOrderCount, int nowOrderCount) {
    int skip = totalOrderCount; // order의 개수만큼 알파벳을 건너뛰도록 설정
    int codePlus = nowOrderCount; // 현재 당장의 order
    String result = ""; // 리턴되는 결과값 저장
    String tempResult = ""; // 알파벳 Z가 넘어갈 시에 AA ~ ZZ까지 표현할 임시 String값
    int code =
        index * skip + 67 + codePlus; // 인덱스를 String으로 변환하기 위한 ASCII 코드 저장
    int charCodeOverFlow = 0; // code가 90(Z의 ASCII Code)을 넘어갈 경우를 카운트하는 값
    if (code <= 90) {
      result = String.fromCharCode(code);
    } else {
      while (code >= 90) {
        charCodeOverFlow++;
        code = code - 25;
      }

      tempResult = String.fromCharCode(charCodeOverFlow + 64);

      result = tempResult + String.fromCharCode(code);
    }

    return result;
  }
}
