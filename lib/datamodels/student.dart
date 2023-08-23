class Student {
  final String? id;
  final String name;
  final String gender;
  final String birthdate;
  final String? teacherUid;
  final List? classroomUids;
  final List? assignments;
  final List? dailyToken;
  final List? classesToken;

  Student({
    this.id,
    required this.name,
    required this.gender,
    required this.birthdate,
    this.teacherUid,
    this.classroomUids,
    this.assignments,
    this.dailyToken,
    this.classesToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'birthdate': birthdate,
      'classroomUids': classroomUids,
      'dailyToken': dailyToken,
      'classesToken': classesToken,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      birthdate: json['birthdate'],
      teacherUid: json['teacherUid'],
      classroomUids: List<String>.from(json['classroomUids'] ?? []),
      dailyToken: json['dailyToken'],
      classesToken: json['classesToken'],
    );
  }
}
