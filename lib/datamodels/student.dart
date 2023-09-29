import 'package:teacherhelper/datamodels/attitude.dart';
import 'package:teacherhelper/datamodels/daily.dart';

class Student {
  final String? id;
  final String? classroomId;
  final String name;
  final String gender;
  final String? birthdate;
  final String? teacherUid;
  final String? studentNumber;
  final List? classroomUids;
  final List? assignments;
  final List? dailyToken;
  final List? classesToken;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final DateTime? deletedDate;
  bool? isChecked;
  // attitude등의 데이터를 저장할 변수
  int? order;
  int? point;
  bool? isBad;
  String? attitudeId;
  Attitude? attitudeData;
  Daily? dailyData;

  Student({
    this.id,
    this.classroomId,
    required this.name,
    required this.gender,
    this.birthdate,
    this.teacherUid,
    this.classroomUids,
    this.assignments,
    this.dailyToken,
    this.classesToken,
    this.studentNumber,
    this.isChecked,
    this.createdDate,
    this.deletedDate,
    this.updatedDate,
    this.order,
    this.point,
    this.isBad,
    this.attitudeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'classroomId': classroomId,
      'name': name,
      'gender': gender,
      'birthdate': birthdate,
      'classroomUids': classroomUids,
      'dailyToken': dailyToken,
      'classesToken': classesToken,
      'studentNumber': studentNumber,
      'isChecked': isChecked,
      'createdDate': createdDate,
      'updatedDate': updatedDate,
      'deletedDate': deletedDate,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      classroomId: json['classroomId'],
      name: json['name'],
      gender: json['gender'],
      birthdate: json['birthdate'],
      teacherUid: json['teacherUid'],
      classroomUids: List<String>.from(json['classroomUids'] ?? []),
      dailyToken: json['dailyToken'],
      classesToken: json['classesToken'],
      studentNumber: json['studentNumber'],
      isChecked: json['isChecked'],
      createdDate: json['createdDate'],
      updatedDate: json['updatedDate'],
      deletedDate: json['deletedDate'],
    );
  }
}
