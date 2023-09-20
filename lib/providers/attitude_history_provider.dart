import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:teacherhelper/datamodels/attitudeHistory.dart';
import 'package:teacherhelper/services/attitude_history_service.dart';

class AttitudeHistoryProvider extends ChangeNotifier {
  final AttitudeHistoryService _attitudeHistoryService;

  AttitudeHistoryProvider()
      : _attitudeHistoryService = AttitudeHistoryService();

  List<AttitudeHistory> _attitudeHistorys = [];
  List<AttitudeHistory> get attitudeHistorys => _attitudeHistorys;
  List<AttitudeHistory> _latestAttitudeHistorys = [];
  List<AttitudeHistory> get latestAttitudeHistorys => _latestAttitudeHistorys;
  final int _attitudeCount = 0;
  int get attitudeCount => _attitudeCount;
  //
  // List<List<AttitudeHistory>> _latestAttitudeHsitroysWithOrder = [];
  // List<List<AttitudeHistory>> get _latestAttitudeHistorysWithOrder =>
  //     _latestAttitudeHsitroysWithOrder;

  // 데일리 체크 메소드
  Future<void> checkAttitude(
      String classroomId, AttitudeHistory attitudeHistory) async {
    _attitudeHistoryService.checkAttitude(classroomId, attitudeHistory);

    notifyListeners();
  }

  // 학반에 태도 불러오기
  Future<void> fetchAttitudesByClassroomIdAndAttitudeOrder(
      String classroomId, int? order) async {
    try {
      List<QueryDocumentSnapshot<Map<String, dynamic>>>? snapshot =
          await _attitudeHistoryService
              .fetchAttitudesByClassroomIdAndAttitudeOrder(classroomId, order);

      _latestAttitudeHistorys = [];

      if (snapshot != null) {
        // AttitudeHistory 객체를 만들어서 필요한 필드로 초기화합니다.
        _attitudeHistorys = snapshot.map((doc) {
          return AttitudeHistory(
            attitudeName: doc['attitudeName'],
            checkDate: (doc['checkDate'] as Timestamp).toDate(),
            order: doc['order'],
            studentName: doc['studentName'],
            studentNumber: doc['studentNumber'],
            isAdd: doc['isAdd'],
            isBad: doc['isBad'],
          );
        }).toList();

        // order와 studentNumber로 그룹화
        Map<String, List<AttitudeHistory>> groupedData = groupBy(
          attitudeHistorys,
          (AttitudeHistory history) => '${history.studentNumber}',
        );
        print(groupedData.containsKey(1));

        notifyListeners(); // 변경 사항 알림
      } else {
        print('snapshot is null');
      }
    } catch (e) {
      print(e);
    }
  }
}
