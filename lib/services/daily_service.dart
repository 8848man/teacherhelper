import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacherhelper/datamodels/daily.dart';
import 'package:teacherhelper/datamodels/daily_history.dart';

class DailyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _classroomsCollection =
      FirebaseFirestore.instance.collection('classrooms');

  // 일상 가져오기
  Future<List<Daily>> fetchDailysByClassroomId(String classroomId) async {
    final querySnapshot =
        await _classroomsCollection.doc(classroomId).collection('Daily').get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      final id = doc.id; // 문서의 ID를 가져옵니다.

      return Daily(name: data['name'], order: data['order'], id: id);
    }).toList()
      ..sort((a, b) => a.order!.compareTo(b.order!));
  }

  // 일상을 학생에 추가
  Future<void> addDailyToStudents(Daily daily, String classroomId) async {
    try {
      final studentsSnapshot = await _classroomsCollection
          .doc(classroomId)
          .collection('Students')
          .get();

      for (var studentDoc in studentsSnapshot.docs) {
        daily.studentId = studentDoc.id;
        print(daily.studentId);
        await studentDoc.reference.collection('daily').add(daily.toJson());
      }
    } catch (e) {
      throw Exception('Failed to add assignment: $e');
    }
  }

  // 반 생성시 기본 일상을 추가.
  Future<void> addDefaultDaily(
      String? classroomId, List<String> studentIds) async {
    try {
      List<Daily> dailyList = [];
      Daily attendanceDaily = Daily(
        name: '출석',
        order: 1,
        classroomId: classroomId,
      );
      Daily noticeDaily = Daily(
        name: '가정통신문',
        order: 2,
        classroomId: classroomId,
      );
      dailyList.add(attendanceDaily);
      dailyList.add(noticeDaily);

      // Firestore 배치 생성
      var batch = FirebaseFirestore.instance.batch();

      // 반에 daily 등록
      for (var daily in dailyList) {
        // 배치에 쓰기 작업 추가
        var dailyRef = _classroomsCollection
            .doc(classroomId)
            .collection('Daily')
            .doc(); // 랜덤한 문서 ID 생성
        // var studentRef = _classroomsCollection.doc(classroomId).collection(collectionPath)
        batch.set(dailyRef, daily.toJson());
      }

      // 학생에 daily 등록
      for (var studentId in studentIds) {
        for (var daily in dailyList) {
          Map<String, dynamic> dailyData = daily.toJson();
          dailyData['studentId'] = studentId;

          // Daily 컬렉션의 참조 생성
          var dailyRef = _classroomsCollection
              .doc(classroomId)
              .collection('Students')
              .doc(studentId)
              .collection('daily')
              .doc();

          // 배치에 쓰기 작업 추가
          batch.set(dailyRef, dailyData);
        }
      }

// 배치 실행
      await batch.commit();
    } catch (e) {
      print(e);
    }
  }

  // 반에 일상 추가
  Future<void> addDailyToClassroom(Daily daily, String classroomId) async {
    try {
      // daily를 정렬하기 위한 숫자를 가져오는 쿼리 추후 데일리 추가 기능 구현시 필요
      // Future<QuerySnapshot<Map<String, dynamic>>> dailyOrder =
      //     _classroomsCollection
      //         .doc(classroomId)
      //         .collection('Daily')
      //         .orderBy('order', descending: true)
      //         .limit(1)
      //         .get();

      // // 마지막 order를 저장하기 위한 변수
      // final querySnapshot = await _classroomsCollection
      //     .doc(classroomId)
      //     .collection('Daily')
      //     .orderBy('order', descending: true)
      //     .limit(1)
      //     .get();

      // int lastOrder = querySnapshot.docs.first.data()['order'] + 1;

      // daily.order = lastOrder;

      await _classroomsCollection
          .doc(classroomId)
          .collection('Daily')
          .add(daily.toJson());
    } catch (e) {
      throw Exception('Failed to add daily to classroom: $e');
    }
  }

  // classroomId로 데일리 가져오기
  Future<List<Daily>> getDailysByClassroom(String classroomId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('classrooms')
          .doc(classroomId)
          .collection('Daily')
          .get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Daily.fromJson(data, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch assignments by classroom: $e');
    }
  }

  // 학생 등록시 일상도 등록하게 만드는 메소드
  Future<void> addDailysToStudent(
      String classroomId, String studentId, Daily daily) async {
    try {
      final studentRef = _classroomsCollection
          .doc(classroomId)
          .collection('Students')
          .doc(studentId);
      await studentRef.collection('daily').add(daily.toJson());
    } catch (e) {
      throw Exception('Failed to add assignment to student: $e');
    }
  }

  // 학생 데이터에 Daily 데이터를 넣기 위한 get 함수
  Future<List<Daily>> getDailysByClassroomAndOrder(String classroomId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collectionGroup('daily')
        .where('classroomId', isEqualTo: classroomId)
        .where('studentId', isNotEqualTo: '')
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      final id = doc.id; // 문서의 ID를 가져옵니다.

      return Daily(
        name: data?['name'],
        order: data?['order'],
        id: id,
        studentId: data?['studentId'],
        classroomId: data?['classroomId'],
      );
    }).toList();
  }

  // 테스트
  Future<List<DailyHistory>> getDailysByClassroomAndOrder2(
      String classroomId, order, DateTime nowDate) async {
    DateTime thisDate = DateTime(nowDate.year, nowDate.month, nowDate.day);
    QuerySnapshot querySnapshot = await _firestore
        .collectionGroup('dailyHistory')
        .where('classroomId', isEqualTo: classroomId)
        .where('order', isEqualTo: order)
        .where('checkDate', isGreaterThan: thisDate)
        .where('checkDate', isLessThan: thisDate.add(const Duration(days: 1)))
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      final id = doc.id; // 문서의 ID를 가져옵니다.

      return DailyHistory(
        dailyName: data?['dailyName'],
        order: data?['order'],
        id: id,
        studentId: data?['studentId'],
        classroomId: data?['classroomId'],
        isChecked: data?['isChecked'],
        checkDate: data?['checkDate'].toDate(),
        dailyId: data?['dailyId'],
      );
    }).toList();
  }

  getLastOrder(String classroomId) async {
    try {
      final querySnapshot = await _classroomsCollection
          .doc(classroomId)
          .collection('Daily')
          .orderBy('order', descending: true)
          .limit(1)
          .get();
      return querySnapshot;
    } catch (e) {
      throw Exception('Error fetching Attitude data: $e');
    }
  }

  // layout 컨텐츠에서 사용할 Daily CRUD
  Future<void> createDailyLayout(
    Daily daily,
    DateTime thisDate,
  ) async {
    try {
      _classroomsCollection
          .doc(daily.classroomId)
          .collection('NewDaily')
          .add(daily.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<List<Daily>> getDailyLayout(
      String classroomId, DateTime thisDate) async {
    try {
      // 당일 시작시간과 마지막시간 변수 할당
      DateTime thisDateStart =
          DateTime(thisDate.year, thisDate.month, thisDate.day, 0, 0, 0, 0);
      DateTime thisDateEnd = DateTime(
          thisDate.year, thisDate.month, thisDate.day, 23, 59, 59, 999);

      final querySnapshot = await FirebaseFirestore.instance
          .collection('classrooms')
          .doc(classroomId)
          .collection('NewDaily')
          .where('startDate', isGreaterThanOrEqualTo: thisDateStart)
          .where('startDate', isLessThan: thisDateEnd)
          .get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Daily.fromJson(data, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch assignments by classroom: $e');
    }
  }

  Future<void> updateDailyLayout() async {}
  Future<void> deleteDailyLayout() async {}
}
