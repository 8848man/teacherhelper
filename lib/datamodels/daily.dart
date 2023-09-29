class Daily {
  String? id;
  String name;
  bool? isComplete;
  DateTime? startDate;
  DateTime? dueDate;
  DateTime? checkDate;
  int? order;
  String? classroomId;
  String? studentId;

  Daily({
    this.id,
    required this.name,
    this.isComplete,
    this.startDate,
    this.dueDate,
    this.checkDate,
    this.order,
    this.classroomId,
    this.studentId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isComplete': isComplete,
      'startDate': startDate,
      'dueDate': dueDate,
      'checkDate': checkDate,
      'order': order,
      'classroomId': classroomId,
      'studentId': studentId,
    };
  }

  factory Daily.fromJson(Map<String, dynamic> json, String? id) {
    return Daily(
      id: json['id'],
      name: json['name'],
      isComplete: json['isComplete'],
      startDate: json['startDate'] == null ? null : json['startDate'].toDate(),
      dueDate: json['dueDate'] == null ? null : json['dueDate'].toDate(),
      checkDate: json['checkDate'] == null ? null : json['checkDate'].toDate(),
      order: json['order'],
      classroomId: json['classroomId'],
      studentId: json['studentId'],
    );
  }
}
