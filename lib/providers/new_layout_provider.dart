import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/classroom.dart';
import 'package:teacherhelper/datamodels/new_student.dart';
import '../datamodels/image_urls.dart';

// 개편된 LayoutProvider
class NewLayoutProvider with ChangeNotifier {
  // 사이드바, 바텀네비를 위한 코드
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

  // 현재 선택된 인덱스 저장 문자열
  String _nowIndex = '';
  String get nowIndex => _nowIndex;

  // 반 정보 가져오기
  // Classroom get classroom => classroomProvider.classroom;

  // 바텀 네비 인덱스
  final List<int> _selectedBottomNavIndices = [1, 0, 0, 0, 0, 0, 0];
  List<int> get selectedBottomNavIndices => _selectedBottomNavIndices;

  String _nowBottomIndex = '';
  String get nowBottomIndex => _nowBottomIndex;

  // 바텀 네비 인덱스 명칭
  List<String> dailyBottomIndexNames = [
    '등교시간',
    '통신문',
    '숙제',
    '준비물',
    '우유',
    '1인1역'
  ];
  List<String> lessonBottomIndexNames = ['평가', '태도', '완료', '숙제', '준비물', '자리비움'];

  ImageUrls imageUrls = ImageUrls();

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
      // 지금 인덱스 이름 세팅
      getNowIndex();
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

  // 지금 선택된 인덱스 세팅
  void getNowIndex() {
    for (int i = 0; i < selectedIndices.length; i++) {
      if (_selectedIndices[i] == 1) {
        // 해당 인덱스에 해당하는 indexNames의 값을 출력
        _nowIndex = indexNames[i];
      }
    }
    notifyListeners();
  }

  // 수업 bottomNav 이름 가져오기
  void getNowBottomLessonIndex() {
    for (int i = 0; i < _selectedBottomNavIndices.length; i++) {
      if (_selectedBottomNavIndices[i] == 1) {
        // 해당 인덱스에 해당하는 indexNames의 값을 출력
        _nowBottomIndex = lessonBottomIndexNames[i];
      }
    }
  }

  // 수업 _nowBottomIndex 이름 가져오기
  void getNowBottomDailyIndex() {
    for (int i = 0; i < _selectedBottomNavIndices.length; i++) {
      print('now index is $i');
      if (_selectedBottomNavIndices[i] == 1) {
        // 해당 인덱스에 해당하는 _nowBottomIndex의 값을 출력
        _nowBottomIndex = dailyBottomIndexNames[i];
      }
    }
  }

  // 일상 추가
  Future<void> createDailyLayout(
      Classroom classroom, List<NewStudent> students) async {
    getNowBottomDailyIndex();
  }
}
