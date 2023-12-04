import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/classroom.dart';
import 'package:teacherhelper/datamodels/new_student.dart';
import 'package:teacherhelper/datamodels/student_with_data.dart';
import '../datamodels/image_urls.dart';
import '../datamodels/lesson.dart';
import '../datamodels/new_daily.dart';
import 'new_classroom_provider.dart';
import 'new_daily_provider.dart';
import 'new_lesson_provider.dart';
import 'new_student_provider.dart';

// 개편된 LayoutProvider
class NewLayoutProvider with ChangeNotifier {
  late NewClassroomProvider _classroomProvider;
  late NewStudentProvider _studentProvider;
  late NewDailyProvider _dailyProvider;
  late NewLessonProvider _lessonProvider;

  NewLayoutProvider({
    required NewClassroomProvider classroomProvider,
    required NewStudentProvider studentProvider,
    required NewDailyProvider dailyProvider,
    required NewLessonProvider lessonProvider,
  }) {
    _classroomProvider = classroomProvider;
    _studentProvider = studentProvider;
    _dailyProvider = dailyProvider;
    _lessonProvider = lessonProvider;

    // 각 Provider에 대한 리스너 등록
    _classroomProvider.addListener(_handleClassroomProviderChange);
    _studentProvider.addListener(_handleStudentProviderChange);
    _dailyProvider.addListener(_handleDailyProviderChange);
    _lessonProvider.addListener(_handleLessonProviderChange);
  }

  List<Classroom> _classrooms = [];
  List<Classroom> get classrooms => _classrooms;

  Classroom _classroom = Classroom(name: '', teacherUid: '');
  Classroom get classroom => _classroom;

  List<NewStudent> _students = [];
  List<NewStudent> get students => _students;

  final List<NewDaily> _dailys = [];
  List<NewDaily> get dailys => _dailys;

  final List<Lesson> _lessons = [];
  List<Lesson> get lessons => _lessons;

  final List<StudentWithData> _studentsWithData = [];
  List<StudentWithData> get studentsWithData => _studentsWithData;

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
      // nowIndex 세팅
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

  // 사이드바, 바텀네비를 위한 코드

  /// Provider Listeners
  void _handleClassroomProviderChange() {
    // ClassroomProvider가 변경되었을 때 처리할 내용
    print('classsroomProvider has changed');
    print(_classroomProvider.classrooms);
    _classrooms = _classroomProvider.classrooms;
    _classroom = _classroomProvider.classroom;

    print('_classroom is ${_classroom.toJson()}');
    notifyListeners(); // 변경을 감지한 경우 자신도 변경을 알림
  }

  void _handleStudentProviderChange() {
    // StudentProvider가 변경되었을 때 처리할 내용
    _students = _studentProvider.students;
    notifyListeners();
  }

  void _handleDailyProviderChange() {
    // DailyProvider가 변경되었을 때 처리할 내용

    notifyListeners();
  }

  void _handleLessonProviderChange() {
    // LessonProvider가 변경되었을 때 처리할 내용
    notifyListeners();
  }

  /// Provider Listeners

  /// Set Provider Datas
  Future<void> getClassroomData(String teacherId) async {
    _classroom = _classroomProvider.classroom;
    print(_classroom.toJson());
    notifyListeners();
  }

  Future<void> getStudentData(String classroomId) async {
    await _studentProvider.getStudentsByClassroomId(classroomId);
    notifyListeners();
  }

  Future<void> getDailyData() async {}
  Future<void> getLessonData() async {}

  /// Set Provider Datas

  // studentsWithData를 가공하는 메소드.
  Future<void> combineStudentsWithData() async {
    // 여기에서 필요한 데이터를 가공하여 반환
    // 예: classroomProvider.classrooms, studentProvider.students 등을 사용하여 가공

    for (int i = 0; i <= students.length;) {
      StudentWithData tempData = StudentWithData(
          student: students[i], dailys: dailys, lessons: lessons);
      _studentsWithData.add(tempData);
    }

    notifyListeners();
  }

  // studentsWithData를 가공하는 메소드.

  void getNowIndex() {
    for (int i = 0; i < selectedIndices.length; i++) {
      if (_selectedIndices[i] == 1) {
        // 해당 인덱스에 해당하는 indexNames의 값을 출력
        _nowIndex = indexNames[i];
      }
    }
    notifyListeners();
  }
}
