import 'package:teacherhelper/datamodels/classes.dart';
import 'package:teacherhelper/datamodels/student.dart';

/**
 * 수업 탭에서 사용할 Student 데이터
 */
class StudentWithClasses {
  Student student;
  Classes classes;

  StudentWithClasses({
    required this.student,
    required this.classes,
  });

  Map<String, dynamic> toJson() {
    return {
      'student': student,
      'classes': classes,
    };
  }

  factory StudentWithClasses.fromJson(Map<String, dynamic> json, String? id) {
    return StudentWithClasses(
      student: json['student'],
      classes: json['classes'],
    );
  }
}
