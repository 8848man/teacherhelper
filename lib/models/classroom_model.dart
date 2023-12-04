class ClassroomModel {
  String? id;
  String? name;
  String? teacherUid;
  DateTime? createdDate;
  bool? isDeleted;
  DateTime? deletedDate;

  ClassroomModel({
    required this.name,
    required this.teacherUid,
    this.id,
    this.createdDate,
    this.isDeleted,
    this.deletedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? '', // null이 아니라면 id, null이라면 빈 문자열
      'name': name,
      'teacherUid': teacherUid,
      'createdDate': createdDate?.toIso8601String(), // DateTime을 문자열로 변환
      'isDeleted': isDeleted,
      'deletedDate': deletedDate?.toIso8601String(), // DateTime을 문자열로 변환
    };
  }

  factory ClassroomModel.fromJson(Map<String, dynamic> json) {
    return ClassroomModel(
      id: json['id'] ?? '',
      name: json['name'],
      teacherUid: json['teacherUid'],
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : null, // 문자열을 DateTime으로 변환
      isDeleted: json['isDeleted'],
      deletedDate: json['deletedDate'] != null
          ? DateTime.parse(json['deletedDate'])
          : null, // 문자열을 DateTime으로 변환
    );
  }
}
