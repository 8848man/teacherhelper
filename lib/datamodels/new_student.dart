class NewStudent {
  String classroomId;
  String id;
  String name;
  int number;
  String gender;
  DateTime createdDate;
  bool? isDeleted;
  DateTime? deletedDate;
  bool? isCheked = false;

  NewStudent({
    required this.classroomId,
    required this.id,
    required this.name,
    required this.number,
    required this.gender,
    required this.createdDate,
    this.isDeleted,
    this.deletedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'classroomId': classroomId,
      'id': id,
      'name': name,
      'number': number,
      'gender': gender,
      'createdDate': createdDate.toIso8601String(),
      'isDeleted': isDeleted ?? false,
      'deletedDate': deletedDate?.toIso8601String(),
    };
  }

  factory NewStudent.fromJson(Map<String, dynamic> json) {
    return NewStudent(
      classroomId: json['classroomId'],
      id: json['id'],
      name: json['name'],
      number: json['number'],
      gender: json['gender'],
      createdDate: DateTime.parse(json['createdDate']),
      isDeleted: json['isDeleted'],
      deletedDate: json['deletedDate'] != null
          ? DateTime.parse(json['deletedDate'])
          : null,
    );
  }
}
