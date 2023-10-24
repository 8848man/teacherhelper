class DailyHistory {
  String? id;
  bool? isChecked;
  DateTime? startDate;
  DateTime? dueDate;
  DateTime? checkDate;
  int? order;
  String? classroomId;
  String? studentName;
  String? dailyName;
  int? studentNumber;
  String? studentId;
  String? dailyId;

  @override
  String toString() {
    return 'DailyHistory: {dailyName: $dailyName, checkDate: $checkDate, isChecked: $isChecked, order: $order, studentName: $studentName, studentNumber: $studentNumber, id: $id}';
  }

  DailyHistory({
    this.id,
    this.isChecked,
    this.startDate,
    this.dueDate,
    this.checkDate,
    this.order,
    this.classroomId,
    this.studentName,
    this.dailyName,
    this.studentNumber,
    this.studentId,
    this.dailyId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isChecked': isChecked,
      'startDate': startDate,
      'dueDate': dueDate,
      'checkDate': checkDate,
      'order': order,
      'classroomId': classroomId,
      'studentName': studentName,
      'dailyName': dailyName,
      'studentNumber': studentNumber,
      'studentId': studentId,
      'dailyId': dailyId,
    };
  }

  factory DailyHistory.fromJson(Map<String, dynamic> json, String? id) {
    return DailyHistory(
      id: json['id'],
      isChecked: json['isChecked'],
      startDate: json['startDate'] == null ? null : json['startDate'].toDate(),
      dueDate: json['dueDate'] == null ? null : json['dueDate'].toDate(),
      checkDate: json['checkDate'] == null ? null : json['checkDate'].toDate(),
      order: json['order'],
      classroomId: json['classroomId'],
      studentName: json['studentName'],
      dailyName: json['dailyName'],
      studentNumber: json['studentNumber'],
      studentId: json['sutdentId'],
      dailyId: json['dailyId'],
    );
  }
}
