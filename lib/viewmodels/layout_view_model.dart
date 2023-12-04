import 'package:flutter/material.dart';
import 'package:teacherhelper/providers/new_classroom_provider.dart';
import 'package:teacherhelper/providers/new_student_provider.dart';

import '../datamodels/classroom.dart';
import '../datamodels/new_student.dart';
import '../providers/new_daily_provider.dart';
import '../providers/new_lesson_provider.dart';

class LayoutViewModel with ChangeNotifier {
  late NewClassroomProvider _classroomProvider;
  late NewStudentProvider _studentProvider;
  late NewDailyProvider _dailyProvider;
  late NewLessonProvider _lessonProvider;

  LayoutViewModel({
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

  // UI에서 사용할 데이터들
  Classroom get classroom => _classroomProvider.classroom;
  List<NewStudent> get students => _studentProvider.students;
  // List<NewDaily> get dailys => _dailyProvider.dailys;
  // List<Lesson> get lessons => _lessonProvider.lessons;

  // Provider 변경 감지 메서드들
  void _handleClassroomProviderChange() {
    notifyListeners();
  }

  void _handleStudentProviderChange() {
    notifyListeners();
  }

  void _handleDailyProviderChange() {
    notifyListeners();
  }

  void _handleLessonProviderChange() {
    notifyListeners();
  }
}
