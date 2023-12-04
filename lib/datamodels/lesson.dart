class Lesson {
  String classroomId;
  String studentId;
  String id;
  String name;
  String kind;
  bool? isChecked = false;
  DateTime? createdDate;
  DateTime? checkDate;

  Lesson({
    required this.classroomId,
    required this.studentId,
    required this.id,
    required this.name,
    required this.kind,
    this.createdDate,
    this.checkDate,
    required bool isChecked,
  });

  // toJson 메서드
  Map<String, dynamic> toJson() {
    return {
      'classroomId': classroomId,
      'studentId': studentId,
      'id': id,
      'name': name,
      'kind': kind,
      'createdDate': createdDate?.toIso8601String(),
      'checkDate': checkDate?.toIso8601String(),
    };
  }

  // fromJson 메서드
  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      classroomId: json['classroomId'],
      studentId: json['studentId'],
      id: json['id'],
      name: json['name'],
      kind: json['kind'],
      isChecked: json['isChecked'],
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : null,
      checkDate:
          json['checkDate'] != null ? DateTime.parse(json['checkDate']) : null,
    );
  }
}
