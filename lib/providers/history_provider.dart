import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teacherhelper/datamodels/attitude.dart';
import 'package:teacherhelper/datamodels/classroom.dart';
import 'package:teacherhelper/datamodels/daily_history.dart';
import 'package:teacherhelper/datamodels/date_for_history.dart';
import 'package:teacherhelper/datamodels/history_date.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';
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

  Future<void> generateExcel(String classroomName, List<Student> students,
      DateForHistory dateForHistory) async {
    print(_allHistory);

    //Create a Excel document.

    //Creating a workbook.
    final Workbook workbook = Workbook();
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = false;

    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();

    // 학생 리스트 입력
    for (var student in students) {
      int index = students.indexOf(student);
      sheet.getRangeByName('A${6 + index}').setText(student.studentNumber);

      sheet.getRangeByName('B${6 + index}').setText(student.name);
    }

    // 2022년 10월 5일부터 2023년 1월 15일까지 각 날짜를 문자열로 표기하는 코드 -> 가공해서 쓸 예정
    int startYear = 2022;
    int endYear = 2023;

    DateTime startDate = DateTime(startYear, 12, 5);
    DateTime endDate = DateTime(endYear, 1, 15);

    for (DateTime date = startDate;
        date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
        date = date.add(Duration(days: 1))) {
      print(date.toLocal().toString().substring(0, 10)); // 날짜를 문자열로 출력
    }

    // dateForHistory.startDateTime
    // for (DateTime date = dateForHistory.startDateTime;
    //     date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
    //     date = date.add(Duration(days: 1))) {
    //   print(date.toLocal().toString().substring(0, 10)); // 날짜를 문자열로 출력
    // }

    //Set data in the worksheet.
    // sheet.getRangeByName('A1').columnWidth = 4.82;
    // sheet.getRangeByName('B1:C1').columnWidth = 13.82;
    // sheet.getRangeByName('D1').columnWidth = 13.20;
    // sheet.getRangeByName('E1').columnWidth = 7.50;
    // sheet.getRangeByName('F1').columnWidth = 9.73;
    // sheet.getRangeByName('G1').columnWidth = 8.82;
    // sheet.getRangeByName('H1').columnWidth = 4.46;

    // sheet.getRangeByName('A1:H1').cellStyle.backColor = '#333F4F';

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

    // // 학생 학번 데이터
    // sheet.getRangeByName('A6').setText('1');
    // sheet.getRangeByName('A7').setText('2');
    // sheet.getRangeByName('A8').setText('3');

    // // 학생 이름 데이터
    // sheet.getRangeByName('B6').setText('정한길');
    // sheet.getRangeByName('B7').setText('상상만');
    // sheet.getRangeByName('B8').setText('무환혹');

    // 날짜 병합
    sheet.getRangeByName('C4:E4').merge();
    sheet.getRangeByName('F4:H4').merge();
    sheet.getRangeByName('I4:K4').merge();
    sheet.getRangeByName('L4:N4').merge();

    // 날짜 텍스트
    sheet.getRangeByName('C4').setText('2023년 09월 01일');
    sheet.getRangeByName('C4').cellStyle.fontSize = 11;

    // 날짜에 해당하는 항목 리스트
    sheet.getRangeByName('C5').setText('출석');
    sheet.getRangeByName('D5').setText('가정통신문');
    sheet.getRangeByName('E5').setText('@');

    // 학생별 항목 체크 리스트
    sheet.getRangeByName('C6').setText('O');
    sheet.getRangeByName('D6').setText('X');
    sheet.getRangeByName('E6').setText('');

    sheet.getRangeByName('C7').setText('O');
    sheet.getRangeByName('D7').setText('X');
    sheet.getRangeByName('E7').setText('');

    sheet.getRangeByName('C8').setText('O');
    sheet.getRangeByName('D8').setText('X');
    sheet.getRangeByName('E8').setText('');

    sheet.getRangeByName('C9').setText('O');
    sheet.getRangeByName('D9').setText('X');
    sheet.getRangeByName('E9').setText('');

    sheet.getRangeByName('C10').setText('O');
    sheet.getRangeByName('D10').setText('X');
    sheet.getRangeByName('E10').setText('');

    // 학생별 항목 체크 리스트 끝

    // 날짜 추가
    sheet.getRangeByName('F4').setText('2023년 09월 02일');
    sheet.getRangeByName('F4').cellStyle.fontSize = 11;

    sheet.getRangeByName('I4').setText('2023년 09월 03일');
    sheet.getRangeByName('I4').cellStyle.fontSize = 11;
    sheet.getRangeByName('L4').setText('2023년 09월 04일');
    sheet.getRangeByName('L4').cellStyle.fontSize = 11;

    // sheet.getRangeByName('C5').setText('출석');
    // sheet.getRangeByName('C5').setText('출석');
    // sheet.getRangeByName('C5').setText('출석');

    // sheet
    //     .getRangeByName('B10')
    //     .setText('United States, California, San Mateo,');
    // sheet.getRangeByName('B10').cellStyle.fontSize = 9;

    // sheet.getRangeByName('B11').setText('9920 BridgePointe Parkway,');
    // sheet.getRangeByName('B11').cellStyle.fontSize = 9;

    // sheet.getRangeByName('B12').setNumber(9365550136);
    // sheet.getRangeByName('B12').cellStyle.fontSize = 9;
    // sheet.getRangeByName('B12').cellStyle.hAlign = HAlignType.left;

    // final Range range1 = sheet.getRangeByName('F8:G8');
    // final Range range2 = sheet.getRangeByName('F9:G9');
    // final Range range3 = sheet.getRangeByName('F10:G10');
    // final Range range4 = sheet.getRangeByName('F11:G11');
    // final Range range5 = sheet.getRangeByName('F12:G12');

    // range1.merge();
    // range2.merge();
    // range3.merge();
    // range4.merge();
    // range5.merge();

    // sheet.getRangeByName('F8').setText('INVOICE#');
    // range1.cellStyle.fontSize = 8;
    // range1.cellStyle.bold = true;
    // range1.cellStyle.hAlign = HAlignType.right;

    // sheet.getRangeByName('F9').setNumber(2058557939);
    // range2.cellStyle.fontSize = 9;
    // range2.cellStyle.hAlign = HAlignType.right;

    // sheet.getRangeByName('F10').setText('DATE');
    // range3.cellStyle.fontSize = 8;
    // range3.cellStyle.bold = true;
    // range3.cellStyle.hAlign = HAlignType.right;

    // sheet.getRangeByName('F11').dateTime = DateTime(2020, 08, 31);
    // sheet.getRangeByName('F11').numberFormat =
    //     r'[$-x-sysdate]dddd, mmmm dd, yyyy';
    // range4.cellStyle.fontSize = 9;
    // range4.cellStyle.hAlign = HAlignType.right;

    // range5.cellStyle.fontSize = 8;
    // range5.cellStyle.bold = true;
    // range5.cellStyle.hAlign = HAlignType.right;

    // final Range range6 = sheet.getRangeByName('B15:G15');
    // range6.cellStyle.fontSize = 10;
    // range6.cellStyle.bold = true;

    // sheet.getRangeByIndex(15, 2).setText('Code');
    // sheet.getRangeByIndex(16, 2).setText('CA-1098');
    // sheet.getRangeByIndex(17, 2).setText('LJ-0192');
    // sheet.getRangeByIndex(18, 2).setText('So-B909-M');
    // sheet.getRangeByIndex(19, 2).setText('FK-5136');
    // sheet.getRangeByIndex(20, 2).setText('HL-U509');

    // sheet.getRangeByIndex(15, 3).setText('Description');
    // sheet.getRangeByIndex(16, 3).setText('AWC Logo Cap');
    // sheet.getRangeByIndex(17, 3).setText('Long-Sleeve Logo Jersey, M');
    // sheet.getRangeByIndex(18, 3).setText('Mountain Bike Socks, M');
    // sheet.getRangeByIndex(19, 3).setText('ML Fork');
    // sheet.getRangeByIndex(20, 3).setText('Sports-100 Helmet, Black');

    // sheet.getRangeByIndex(15, 3, 15, 4).merge();
    // sheet.getRangeByIndex(16, 3, 16, 4).merge();
    // sheet.getRangeByIndex(17, 3, 17, 4).merge();
    // sheet.getRangeByIndex(18, 3, 18, 4).merge();
    // sheet.getRangeByIndex(19, 3, 19, 4).merge();
    // sheet.getRangeByIndex(20, 3, 20, 4).merge();

    // sheet.getRangeByIndex(15, 5).setText('Quantity');
    // sheet.getRangeByIndex(16, 5).setNumber(2);
    // sheet.getRangeByIndex(17, 5).setNumber(3);
    // sheet.getRangeByIndex(18, 5).setNumber(2);
    // sheet.getRangeByIndex(19, 5).setNumber(6);
    // sheet.getRangeByIndex(20, 5).setNumber(1);

    // sheet.getRangeByIndex(15, 6).setText('Price');
    // sheet.getRangeByIndex(16, 6).setNumber(8.99);
    // sheet.getRangeByIndex(17, 6).setNumber(49.99);
    // sheet.getRangeByIndex(18, 6).setNumber(9.50);
    // sheet.getRangeByIndex(19, 6).setNumber(175.49);
    // sheet.getRangeByIndex(20, 6).setNumber(34.99);

    // sheet.getRangeByIndex(15, 7).setText('Total');
    // sheet.getRangeByIndex(16, 7).setFormula('=E16*F16+(E16*F16)');
    // sheet.getRangeByIndex(17, 7).setFormula('=E17*F17+(E17*F17)');
    // sheet.getRangeByIndex(18, 7).setFormula('=E18*F18+(E18*F18)');
    // sheet.getRangeByIndex(19, 7).setFormula('=E19*F19+(E19*F19)');
    // sheet.getRangeByIndex(20, 7).setFormula('=E20*F20+(E20*F20)');
    // sheet.getRangeByIndex(15, 6, 20, 7).numberFormat = r'$#,##0.00';

    // sheet.getRangeByName('E15:G15').cellStyle.hAlign = HAlignType.right;
    // sheet.getRangeByName('B15:G15').cellStyle.fontSize = 10;
    // sheet.getRangeByName('B15:G15').cellStyle.bold = true;
    // sheet.getRangeByName('B16:G20').cellStyle.fontSize = 9;

    // sheet.getRangeByName('E22:G22').merge();
    // sheet.getRangeByName('E22:G22').cellStyle.hAlign = HAlignType.right;
    // sheet.getRangeByName('E23:G24').merge();

    // final Range range7 = sheet.getRangeByName('E22');
    // final Range range8 = sheet.getRangeByName('E23');
    // range7.setText('TOTAL');
    // range7.cellStyle.fontSize = 8;
    // range8.setFormula('=SUM(G16:G20)');
    // range8.numberFormat = r'$#,##0.00';
    // range8.cellStyle.fontSize = 24;
    // range8.cellStyle.hAlign = HAlignType.right;
    // range8.cellStyle.bold = true;

    // sheet.getRangeByIndex(26, 1).text =
    //     '800 Interchange Blvd, Suite 2501, Austin, TX 78721 | support@adventure-works.com';
    // sheet.getRangeByIndex(26, 1).cellStyle.fontSize = 8;

    // final Range range9 = sheet.getRangeByName('A26:H27');
    // range9.cellStyle.backColor = '#ACB9CA';
    // range9.merge();
    // range9.cellStyle.hAlign = HAlignType.center;
    // range9.cellStyle.vAlign = VAlignType.center;

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();

    //Save and launch the file.
    await saveAndLaunchFile(bytes, 'Invoice.xlsx');
  }
}
