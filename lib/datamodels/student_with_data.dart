import 'package:teacherhelper/datamodels/lesson.dart';
import 'package:teacherhelper/datamodels/new_daily.dart';
import 'package:teacherhelper/datamodels/new_student.dart';

class StudentWithData {
  NewStudent student;
  List<NewDaily>? dailys;
  List<Lesson>? lessons;

  StudentWithData({
    required this.student,
    this.dailys,
    this.lessons,
  });

  Map<String, dynamic> toJson() {
    return {
      'student': student.toJson(),
      'dailys': dailys?.map((daily) => daily.toJson()).toList(),
      'lessons': lessons?.map((lesson) => lesson.toJson()).toList(),
    };
  }

  factory StudentWithData.fromJson(Map<String, dynamic> json) {
    return StudentWithData(
      student: NewStudent.fromJson(json['student']),
      dailys: (json['dailys'] as List<dynamic>?)
          ?.map((daily) => NewDaily.fromJson(daily))
          .toList(),
      lessons: (json['lessons'] as List<dynamic>?)
          ?.map((lesson) => Lesson.fromJson(lesson))
          .toList(),
    );
  }
}
