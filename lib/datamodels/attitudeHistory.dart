class AttitudeHistory {
  String? id;
  DateTime? checkDate;
  int? order;
  String? studentName;
  String? attitudeName;
  int? studentNumber;
  int? checkedPoint;
  bool isAdd = false;
  bool isBad = false;
  int? attitudeCount;

  // @override
  // String toString() {
  //   return 'AttitudeHistory: {attitudeName: $attitudeName, checkDate: $checkDate, isChecked: $isChecked, order: $order, studentName: $studentName, studentNumber: $studentNumber}';
  // }

  AttitudeHistory({
    this.id,
    this.checkDate,
    this.order,
    this.studentName,
    this.attitudeName,
    this.studentNumber,
    required this.isAdd,
    required this.isBad,
    this.attitudeCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'checkDate': checkDate,
      'order': order,
      'studentName': studentName,
      'attitudeName': attitudeName,
      'studentNumber': studentNumber,
      'isAdd': isAdd,
      'isBad': isBad,
    };
  }

  factory AttitudeHistory.fromJson(Map<String, dynamic> json, String? id) {
    return AttitudeHistory(
      id: json['id'],
      checkDate: json['checkDate'] == null ? null : json['checkDate'].toDate(),
      order: json['order'],
      studentName: json['studentName'],
      attitudeName: json['attitudeName'],
      studentNumber: json['studentNumber'],
      isAdd: json['isAdd'],
      isBad: json['isBad'],
    );
  }
}
