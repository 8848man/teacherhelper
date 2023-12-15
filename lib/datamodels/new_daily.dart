class NewDaily {
  String classroomId;
  String studentId;
  String? id;
  String name;
  String kind;
  bool isChecked;
  DateTime? createdDate;
  DateTime? checkDate;

  NewDaily({
    required this.classroomId,
    required this.studentId,
    this.id,
    required this.name,
    required this.kind,
    required this.isChecked,
    this.createdDate,
    this.checkDate,
  });

  // toJson 메서드: 객체를 JSON 형식으로 직렬화
  Map<String, dynamic> toJson() {
    return {
      'classroomId': classroomId,
      'studentId': studentId,
      'id': id,
      'name': name,
      'kind': kind,
      'isChecked': isChecked,
      'createdDate': createdDate?.toIso8601String(), // DateTime을 문자열로 변환
      'checkDate': checkDate?.toIso8601String(),
    };
  }

  // fromJson 메서드: JSON을 객체로 역직렬화
  factory NewDaily.fromJson(Map<String, dynamic> json) {
    return NewDaily(
      classroomId: json['classroomId'],
      studentId: json['studentId'],
      id: json['id'] ?? '',
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
