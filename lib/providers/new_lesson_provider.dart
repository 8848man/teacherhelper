import 'package:flutter/cupertino.dart';

import '../datamodels/lesson.dart';

class NewLessonProvider extends ChangeNotifier {
  final List<Lesson> _lessons = [];
  List<Lesson> get lessons => _lessons;

  Future<void> createLessonsByClassroomId() async {}

  Future<void> getLessonsByClassroomId() async {
    print(getLessonsByClassroomId);
  }

  Future<void> updateLessonsByClassroomId() async {}

  Future<void> deleteLessonsByClassroomId() async {}
}
