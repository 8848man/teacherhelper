import 'package:teacherhelper/datamodels/daily.dart';
import 'package:teacherhelper/datamodels/student.dart';

/**
 * 생활 탭에서 사용할 Student 객체
 */
class StudentWithDaily {
  Student student;
  Daily daily;

  StudentWithDaily({
    required this.student,
    required this.daily,
  });

  Map<String, dynamic> toJson() {
    return {
      'student': student,
      'daily': daily,
    };
  }

  factory StudentWithDaily.fromJson(Map<String, dynamic> json, String? id) {
    return StudentWithDaily(
      student: json['student'],
      daily: json['daily'],
    );
  }
}
