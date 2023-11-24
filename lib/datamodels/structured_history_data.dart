import 'package:teacherhelper/datamodels/classroom.dart';
import 'package:teacherhelper/datamodels/lesson.dart';
import 'package:teacherhelper/datamodels/new_daily.dart';
import 'package:teacherhelper/datamodels/student_with_data.dart';

class StructuredHistoryData {
  Classroom classroom;
  List<StudentWithData> students;
  List<NewDaily>? dailys;
  List<Lesson>? lessons;
  DateTime? createdDate;
  DateTime? updatedDate;

  StructuredHistoryData({
    required this.classroom,
    required this.students,
    this.dailys,
    this.lessons,
  });

  Map<String, dynamic> toJson() {
    return {
      'classroom': classroom.toJson(),
      'students': students.map((student) => student.toJson()).toList(),
      'dailys': dailys?.map((daily) => daily.toJson()).toList(),
      'lessons': lessons?.map((lesson) => lesson.toJson()).toList(),
    };
  }

  factory StructuredHistoryData.fromJson(Map<String, dynamic> json) {
    return StructuredHistoryData(
      classroom: Classroom.fromJson(json['classroom']),
      students: (json['students'] as List<dynamic>?)
              ?.map((studentJson) =>
                  StudentWithData.fromJson(studentJson as Map<String, dynamic>))
              .toList() ??
          [],
      dailys: (json['dailys'] as List<dynamic>?)
          ?.map((dailyJson) =>
              NewDaily.fromJson(dailyJson as Map<String, dynamic>))
          .toList(),
      lessons: (json['lessons'] as List<dynamic>?)
          ?.map((lessonJson) =>
              Lesson.fromJson(lessonJson as Map<String, dynamic>))
          .toList(),
    );
  }
}
