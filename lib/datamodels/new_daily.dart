class NewDaily {
  String classroomId;
  String id;
  String name;
  String kind;
  DateTime? createdDate;
  DateTime? checkDate;

  NewDaily({
    required this.classroomId,
    required this.id,
    required this.name,
    required this.kind,
    this.createdDate,
    this.checkDate,
  });

  // toJson 메서드: 객체를 JSON 형식으로 직렬화
  Map<String, dynamic> toJson() {
    return {
      'classroomId': classroomId,
      'id': id,
      'name': name,
      'kind': kind,
      'createdDate': createdDate?.toIso8601String(), // DateTime을 문자열로 변환
      'checkDate': checkDate?.toIso8601String(),
    };
  }

  // fromJson 메서드: JSON을 객체로 역직렬화
  factory NewDaily.fromJson(Map<String, dynamic> json) {
    return NewDaily(
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
