import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/daily.dart';
import 'package:teacherhelper/datamodels/image_urls.dart';
import 'package:teacherhelper/providers/classes_provider.dart';
import 'package:teacherhelper/providers/daily_provider.dart';

// 레이아웃 프로바이더
class LayoutProvider with ChangeNotifier {
  // 생활, 수업 제어를 위한 프로바이더 변수 할당
  DailyProvider dailyProvider = DailyProvider();
  ClassesProvider classesProvider = ClassesProvider();

  // 사이드바 인덱스
  final List<int> _selectedIndices = [0, 0, 0, 0, 0, 0, 0];
  List<int> get selectedIndices => _selectedIndices;

  // 바텀 네비 인덱스
  final List<int> _selectedBottomNavIndices = [0, 0, 0, 0, 0, 0, 0];
  List<int> get selectedBottomNavIndices => _selectedBottomNavIndices;

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
  Future<void> createDailyLayout() async {
    dailyProvider.createDailyLayout();
  }

  Future<List<Daily>> getDailyLayout() async {
    return dailyProvider.getDailyLayout();
  }

  Future<void> updateDailyLayout() async {
    dailyProvider.updateDailyLayout();
  }

  Future<void> deleteDailyLayout() async {
    dailyProvider.deleteDailyLayout();
  }
}
