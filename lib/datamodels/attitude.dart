class Attitude {
  String? id;
  String? classroomId;
  String? studentId;
  String name;
  DateTime? startDate;
  String? point;
  DateTime? checkDate;
  int? order;
  bool isBad = false;

  Attitude({
    this.id,
    this.classroomId,
    this.studentId,
    required this.name,
    this.startDate,
    this.checkDate,
    this.point,
    this.order,
    required this.isBad,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'classroomId': classroomId,
      'studentId': studentId,
      'name': name,
      'startDate': startDate,
      'checkDate': checkDate,
      'point': point ?? '0',
      'order': order ?? '0',
      'isBad': isBad,
    };
  }

  factory Attitude.fromJson(Map<String, dynamic> json, String? id) {
    return Attitude(
      id: id,
      classroomId: json['classroomId'],
      studentId: json['studentId'],
      name: json['name'],
      startDate: json['startDate'].toDate(),
      checkDate: json['checkDate'].toDate(),
      point: json['point'] ?? '0',
      order: json['order'],
      isBad: json['isBad'],
    );
  }
}
