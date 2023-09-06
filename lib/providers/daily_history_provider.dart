import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:teacherhelper/datamodels/daily_history.dart';
import 'package:teacherhelper/services/daily_history_service.dart';

class DailyHistoryProvider extends ChangeNotifier {
  final DailyHistoryService _dailyHistoryService;

  DailyHistoryProvider() : _dailyHistoryService = DailyHistoryService();

  List<DailyHistory> _dailyHistorys = [];
  List<DailyHistory> get dailyHistorys => _dailyHistorys;
  List<DailyHistory> _latestDailyHistorys = [];
  List<DailyHistory> get latestDailyHistorys => _latestDailyHistorys;
  // 데일리 체크 메소드
  Future<void> checkDaily(
    String classroomId,
    String studentNumber,
    String dailyName,
    String? studentName,
    int? order,
    DateTime? checkDate,
  ) async {
    _dailyHistoryService.checkDaily(
        classroomId, studentNumber, dailyName, studentName, order, checkDate);
  }

  // fetchDailysByClassroomIdAndDailyOrder(String classroomId, int? order) async {
  //   try {
  //     List<QueryDocumentSnapshot<Map<String, dynamic>>>? snapshot =
  //         await _dailyHistoryService.fetchDailysByClassroomIdAndDailyOrder(
  //             classroomId, order);

  //     if (snapshot != null) {
  //       // DailyHistory 객체를 만들어서 필요한 필드로 초기화합니다.

  //       _dailyHistorys = snapshot.map((doc) {
  //         return DailyHistory(
  //           // DailyHistory 모델에 필드와 매핑할 Firestore 필드를 지정하세요.
  //           // id: doc.id,
  //           dailyName: doc['dailyName'], //
  //           // classroomId: doc['classroomId'], //
  //           checkDate: doc['checkDate'], //
  //           isChecked: doc['isChecked'], //
  //           order: doc['order'], //
  //           studentName: doc['studentName'], //
  //           studentNumber: doc['studentNumber'], //
  //         );
  //       }).toList();

  //       notifyListeners(); // 변경 사항 알림
  //     } else {
  //       print('querySnapshot is null');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> fetchDailysByClassroomIdAndDailyOrder(
      String classroomId, int? order) async {
    try {
      List<QueryDocumentSnapshot<Map<String, dynamic>>>? snapshot =
          await _dailyHistoryService.fetchDailysByClassroomIdAndDailyOrder(
              classroomId, order);

      if (snapshot != null) {
        // DailyHistory 객체를 만들어서 필요한 필드로 초기화합니다.
        _dailyHistorys = snapshot.map((doc) {
          return DailyHistory(
            dailyName: doc['dailyName'],
            checkDate: (doc['checkDate'] as Timestamp).toDate(),
            isChecked: doc['isChecked'],
            order: doc['order'],
            studentName: doc['studentName'],
            studentNumber: doc['studentNumber'],
          );
        }).toList();

        fetchLatestDailiesByStudent(_dailyHistorys) as List<DailyHistory>;
        notifyListeners(); // 변경 사항 알림
      } else {
        print('snapshot is null');
      }
    } catch (e) {
      print(e);
    }
  }

  // DailyHistoryList를 StudentNumber마다 가장 최신의 값들만 가져와주는 함수
  Future<void> fetchLatestDailiesByStudent(List<DailyHistory> rawData) async {
    // 중복된 studentNumber를 기준으로 그룹화
    final groupedData = groupDataByStudent(rawData);

    // 각 그룹에서 가장 최근 데이터 선택
    final latestDailies = selectLatestDailiesFromGroups(groupedData);

    _latestDailyHistorys = latestDailies;
    // latestDailies를 사용하거나 필요한 처리를 수행
  }

  List<List<DailyHistory>> groupDataByStudent(List<DailyHistory> data) {
    final groupedData = <List<DailyHistory>>[];
    final studentNumbers = <int>{};

    for (final entry in data) {
      final studentNumber = entry.studentNumber;

      if (!studentNumbers.contains(studentNumber)) {
        studentNumbers.add(studentNumber!);
        groupedData.add(<DailyHistory>[entry]);
      } else {
        final index = studentNumbers.toList().indexOf(studentNumber!);
        groupedData[index].add(entry);
      }
    }

    return groupedData;
  }

  List<DailyHistory> selectLatestDailiesFromGroups(
      List<List<DailyHistory>> groupedData) {
    final latestDailies = <DailyHistory>[];

    for (final group in groupedData) {
      // 그룹 내에서 checkDate가 가장 큰 데이터 선택
      group.sort((a, b) {
        final checkDateA = (a as DailyHistory).checkDate;
        final checkDateB = (b as DailyHistory).checkDate;
        return checkDateB!.compareTo(checkDateA!);
      });

      latestDailies.add(group.first);
    }

    return latestDailies;
  }
}
