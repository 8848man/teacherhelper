class Lesson {
  String classroomId;
  String id;
  String name;
  String kind;
  DateTime? createdDate;
  DateTime? checkDate;

  Lesson({
    required this.classroomId,
    required this.id,
    required this.name,
    required this.kind,
    this.createdDate,
    this.checkDate,
  });

  // toJson 메서드
  Map<String, dynamic> toJson() {
    return {
      'classroomId': classroomId,
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
      id: json['id'],
      name: json['name'],
      kind: json['kind'],
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : null,
      checkDate:
          json['checkDate'] != null ? DateTime.parse(json['checkDate']) : null,
    );
  }
}
