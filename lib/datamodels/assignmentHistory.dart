class AssignmentHistory {
  String? id;
  DateTime checkDate; // 체크 일시
  bool isAdd; // 점수 더하기 or 빼기 여부 isAdd = True -> 점수 더하기.
  String? checkReason; // 체크한 이유(없어도 됨)

  AssignmentHistory({
    this.id,
    required this.checkDate,
    this.checkReason,
    required this.isAdd,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'checkDate': checkDate,
      'isAdd': isAdd,
      'checkReason': checkReason,
    };
  }

  factory AssignmentHistory.fromJson(Map<String, dynamic> json, String? id) {
    return AssignmentHistory(
        id: id,
        checkDate: json['checkDate'].toDate(),
        isAdd: json['isAdd'],
        checkReason: json['checkReason']);
  }
}
