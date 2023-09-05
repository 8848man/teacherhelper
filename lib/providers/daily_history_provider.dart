import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:teacherhelper/datamodels/daily_history.dart';
import 'package:teacherhelper/services/daily_history_service.dart';

class DailyHistoryProvider extends ChangeNotifier {
  final DailyHistoryService _dailyHistoryService;

  DailyHistoryProvider() : _dailyHistoryService = DailyHistoryService();

  List<DailyHistory> _dailyHistorys = [];
  List<DailyHistory> get dailyHistorys => _dailyHistorys;
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

  fetchDailysByClassroomIdAndDailyOrder(String classroomId, int? order) async {
    try {
      List<QueryDocumentSnapshot<Map<String, dynamic>>>? snapshot =
          await _dailyHistoryService.fetchDailysByClassroomIdAndDailyOrder(
              classroomId, order);

      if (snapshot != null) {
        // DailyHistory 객체를 만들어서 필요한 필드로 초기화합니다.

        _dailyHistorys = snapshot.map((doc) {
          return DailyHistory(
            // DailyHistory 모델에 필드와 매핑할 Firestore 필드를 지정하세요.
            // id: doc.id,
            dailyName: doc['dailyName'], //
            // classroomId: doc['classroomId'], //
            checkDate: doc['checkDate'], //
            isChecked: doc['isChecked'], //
            order: doc['order'], //
            studentName: doc['studentName'], //
            studentNumber: doc['studentNumber'], //
          );
        }).toList();

        notifyListeners(); // 변경 사항 알림
      } else {
        print('querySnapshot is null');
      }
    } catch (e) {
      print(e);
    }
  }
}
