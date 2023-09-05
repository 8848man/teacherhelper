class DailyHistory {
  String? id;
  String? name;
  bool? isChecked;
  DateTime? startDate;
  DateTime? dueDate;
  DateTime? checkDate;
  int? order;
  String? classroomId;
  String? studentName;
  String? dailyName;
  int? studentNumber;

  DailyHistory({
    this.id,
    this.name,
    this.isChecked,
    this.startDate,
    this.dueDate,
    this.checkDate,
    this.order,
    this.classroomId,
    this.studentName,
    this.dailyName,
    this.studentNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isChecked': isChecked,
      'startDate': startDate,
      'dueDate': dueDate,
      'checkDate': checkDate,
      'order': order,
      'classroomId': classroomId,
      'studentName': studentName,
      'dailyName': dailyName,
      'studentNumber': studentNumber,
    };
  }

  factory DailyHistory.fromJson(Map<String, dynamic> json, String? id) {
    return DailyHistory(
      id: json['id'],
      name: json['name'],
      isChecked: json['isChecked'],
      startDate: json['startDate'] == null ? null : json['startDate'].toDate(),
      dueDate: json['dueDate'] == null ? null : json['dueDate'].toDate(),
      checkDate: json['checkDate'] == null ? null : json['checkDate'].toDate(),
      order: json['order'],
      classroomId: json['classroomId'],
      studentName: json['studentName'],
      dailyName: json['dailyName'],
      studentNumber: json['studentNumber'],
    );
  }
}
