class Student {
  final String? id;
  final String name;
  final String gender;
  final String birthdate;
  final String? teacherUid;
  final List? classroomUids;
  final List? assignments;

  Student({
    this.id,
    required this.name,
    required this.gender,
    required this.birthdate,
    this.teacherUid,
    this.classroomUids,
    this.assignments,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'birthdate': birthdate,
      'classroomUids': classroomUids,
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
    );
  }
}
