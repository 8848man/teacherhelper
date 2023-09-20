// class AttitudeHistory {
//   String? id;
//   DateTime? checkDate;
//   int? order;
//   String? classroomId;
//   String? studentName;
//   String? attitudeName;
//   int? studentNumber;
//   int? checkedPoint;
//   bool isAdd = false;

//   // @override
//   // String toString() {
//   //   return 'AttitudeHistory: {attitudeName: $attitudeName, checkDate: $checkDate, isChecked: $isChecked, order: $order, studentName: $studentName, studentNumber: $studentNumber}';
//   // }

//   AttitudeHistory({
//     this.id,
//     this.checkDate,
//     this.order,
//     this.classroomId,
//     this.studentName,
//     this.attitudeName,
//     this.studentNumber,
//     required this.isAdd,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'checkDate': checkDate,
//       'order': order,
//       'classroomId': classroomId,
//       'studentName': studentName,
//       'attitudeName': attitudeName,
//       'studentNumber': studentNumber,
//       'isAdd': isAdd,
//     };
//   }

//   factory AttitudeHistory.fromJson(Map<String, dynamic> json, String? id) {
//     return AttitudeHistory(
//       id: json['id'],
//       checkDate: json['checkDate'] == null ? null : json['checkDate'].toDate(),
//       order: json['order'],
//       classroomId: json['classroomId'],
//       studentName: json['studentName'],
//       attitudeName: json['attitudeName'],
//       studentNumber: json['studentNumber'],
//       isAdd: json['isAdd'],
//     );
//   }
// }
