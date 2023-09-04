class DailyHistory {
  String? id;
  String name;
  bool? isComplete;
  DateTime? startDate;
  DateTime? dueDate;
  DateTime? checkDate;
  int? order;
  String? classroomId;
  String? studentName;
  String? dailyId;

  DailyHistory({
    this.id,
    required this.name,
    this.isComplete,
    this.startDate,
    this.dueDate,
    this.checkDate,
    this.order,
    this.classroomId,
    this.studentName,
    this.dailyId,
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
      'studentName': studentName,
      'dailyId': dailyId,
    };
  }

  factory DailyHistory.fromJson(Map<String, dynamic> json, String? id) {
    return DailyHistory(
      id: json['id'],
      name: json['name'],
      isComplete: json['isComplete'],
      startDate: json['startDate'] == null ? null : json['startDate'].toDate(),
      dueDate: json['dueDate'] == null ? null : json['dueDate'].toDate(),
      checkDate: json['checkDate'] == null ? null : json['checkDate'].toDate(),
      order: json['order'],
      classroomId: json['classroomId'],
      studentName: json['studentName'],
      dailyId: json['dailyId'],
    );
  }
}
