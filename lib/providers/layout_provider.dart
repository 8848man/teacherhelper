import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/daily.dart';
import 'package:teacherhelper/datamodels/image_urls.dart';
import 'package:teacherhelper/datamodels/lesson.dart';
import 'package:teacherhelper/datamodels/new_daily.dart';
import 'package:teacherhelper/datamodels/new_student.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/providers/classes_provider.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';
import 'package:teacherhelper/providers/daily_provider.dart';
import 'package:teacherhelper/services/daily_service.dart';
import 'package:teacherhelper/services/student_service.dart';

// 레이아웃 프로바이더
class LayoutProvider with ChangeNotifier {
  final StudentService _studentService;
  final DailyService _dailyService;
  LayoutProvider()
      : _studentService = StudentService(),
        _dailyService = DailyService();

  // 생활, 수업 제어를 위한 프로바이더 변수 할당
  DailyProvider dailyProvider = DailyProvider();
  ClassesProvider classesProvider = ClassesProvider();

  ClassroomProvider classroomProvider = ClassroomProvider();
  // 사이드바 인덱스
  final List<int> _selectedIndices = [0, 0, 1, 0, 0, 0, 0];
  List<int> get selectedIndices => _selectedIndices;
  // 사이드바 인덱스 명칭
  List<String> indexNames = ['내 정보', '전체 목록', '생활', '수업', '통계', '옵션', '로그아웃'];

  // daily / classes 등의 데이터 선택 리스트
  final List<int> _selectedData = [];
  List<int> get selectedData => _selectedData;
  // daily / classes 등의 실제 데이터 저장 리스트
  final List<Map<String, dynamic>> _storedData = [];
  List<Map<String, dynamic>> get storedData => _storedData;

  // 반 정보 가져오기
  // Classroom get classroom => classroomProvider.classroom;

  // 바텀 네비 인덱스
  final List<int> _selectedBottomNavIndices = [1, 0, 0, 0, 0, 0, 0];
  List<int> get selectedBottomNavIndices => _selectedBottomNavIndices;

  // 바텀 네비 인덱스 명칭
  List<String> dailyBottomIndexNames = [
    '등교시간',
    '통신문',
    '숙제',
    '준비물',
    '우유',
    '1인1역'
  ];
  List<String> classesBottomIndexNames = [
    '평가',
    '태도',
    '완료',
    '숙제',
    '준비물',
    '자리비움'
  ];

  ImageUrls imageUrls = ImageUrls();

  List<NewStudent> _newStudents = [];
  List<NewStudent> get newStudents => _newStudents;

  // 사이드바 버튼 인덱스 선택 함수
  void setSelected(int index) {
    for (var i = 0; i < imageUrls.unselectedSidebar.length; i++) {
      selectedIndices[i] = (i == index) ? 1 : 0;
    }
    notifyListeners();
  }

  // 사이드바 버튼 이미지 불러오기
  List<String> getSidebarImages() {
    List<String> result =
        List<String>.generate(imageUrls.unselectedSidebar.length, (index) {
      if (_selectedIndices[index] == 1) {
        notifyListeners();
        return imageUrls.selectedSidebar[index];
      } else {
        notifyListeners();
        return imageUrls.unselectedSidebar[index];
      }
    });

    return result;
  }

  // 바텀 네비바 인덱스 선택 함수
  void setSelectedBottomNav(int index) {
    for (var i = 0; i < imageUrls.dailyBottomNav.length; i++) {
      selectedBottomNavIndices[i] = (i == index) ? 1 : 0;
    }
    notifyListeners();
  }

  // 바텀 데일리 네비바 이미지 불러오기
  List<String> getNavbarImages() {
    List<String> result =
        List<String>.generate(imageUrls.dailyBottomNav.length, (index) {
      // 생활일 경우, daily 항목들 표시
      if (selectedIndices[2] == 1) {
        if (selectedBottomNavIndices[index] == 1) {
          notifyListeners();
          return imageUrls.selectedDailyBottomNav[index];
        } else {
          notifyListeners();
          return imageUrls.dailyBottomNav[index];
        }
      }
      // 수업일 경우, classes 항목들 표시
      else if (selectedIndices[3] == 1) {
        if (selectedBottomNavIndices[index] == 1) {
          notifyListeners();
          return imageUrls.selectedClassesBottomNav[index];
        } else {
          notifyListeners();
          return imageUrls.classesBottomNav[index];
        }
      } else {
        notifyListeners();
        return imageUrls.dailyBottomNav[index];
      }
    });
    notifyListeners();
    return result;
  }

  // Daily CRUD
  Future<void> createDailyLayout(
      DateTime thisDate, String classroomId, List<Student> students) async {
    Daily daily = Daily(
      name: '',
      isComplete: false,
      classroomId: classroomId,
      startDate: thisDate,
    );
    // 데일리 종류 설정
    for (int index = 0; index < selectedBottomNavIndices.length; index++) {
      if (selectedBottomNavIndices[index] == 1) {
        daily.name = dailyBottomIndexNames[index];
        daily.kind = dailyBottomIndexNames[index];
      }
    }
    dailyProvider.createDailyLayout(daily, thisDate, students);
    getDailyLayout(classroomId, thisDate);
    notifyListeners();
  }

  Future<List<Daily>> getDailyLayout(
      String classroomId, DateTime thisDate) async {
    return dailyProvider.getDailyLayout(classroomId, thisDate);
  }

  Future<void> updateDailyLayout() async {
    dailyProvider.updateDailyLayout();
  }

  Future<void> deleteDailyLayout() async {
    dailyProvider.deleteDailyLayout();
  }

  // 학생 데이터 가져오기
  Future<List<NewStudent>> getNewStudentsByClassroomId(
      String classroomId) async {
    _newStudents =
        await _studentService.getNewStudentsByClassroomId(classroomId);
    return _newStudents;
  }

  // Future<List<NewDaily>> getNewDailysbyClassroomId(String )

  // 수업 데이터 가져오기
  // Future<List<NewDaily>> getLessonByClassroomId(String classroomId){}
}
