class Classroom {
  String? id;
  String name;
  String teacherUid;
  int? grade;
  String? uid;
  DateTime? createdDate;
  DateTime? updatedDate;
  DateTime? deletedDate;

  Classroom({
    required this.name,
    required this.teacherUid,
    this.grade,
    id,
    this.uid,
    this.createdDate,
    this.deletedDate,
  });

  get teacher => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? '',
      'name': name,
      'teacherUid': teacherUid,
      'grade': grade,
      'uid': uid,
      'createdDate': createdDate,
    };
  }

  // factory Classroom.fromJson(Map<String, dynamic> json) {
  //   return Classroom(
  //     id: json.containsKey('id') ? json['id'] : '', // id 필드가 없는 경우에는 빈 문자열로 초기화
  //     name: json['name'],
  //     teacherUid: json['teacherUid'],
  //     grade: json['grade'],
  //     uid: json['uid'],
  //   );
  // }

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      id: json['id'] ?? '',
      name: json['name'],
      teacherUid: json['teacherUid'],
      grade: json['grade'],
      uid: json['uid'],
      createdDate: json['createdDate'],
    );
  }
}
