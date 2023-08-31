class Assignment {
  String? id;
  String name;
  bool? isComplete;
  DateTime? startDate;
  DateTime? deadline;
  DateTime? completeDate;
  String? assignmentFile;
  String? point;
  String? checkDate;
  int? order;

  Assignment({
    this.id,
    required this.name,
    this.isComplete,
    this.startDate,
    this.deadline,
    this.completeDate,
    this.assignmentFile,
    this.point,
    this.order,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isComplete': isComplete,
      'startDate': startDate,
      'deadline': deadline,
      'completeDate': completeDate,
      'assignmentFile': assignmentFile,
      'point': point ?? '0',
      'order': order ?? '0',
    };
  }

  factory Assignment.fromJson(Map<String, dynamic> json, String? id) {
    return Assignment(
      id: id,
      name: json['name'],
      isComplete: json['isComplete'],
      startDate: json['startDate'].toDate(),
      deadline: json['deadline'].toDate(),
      completeDate: json['completeDate'] != null
          ? DateTime.parse(json['completeDate'])
          : null,
      assignmentFile: json['assignmentFile'],
      point: json['point'] ?? '0',
      order: json['order'],
    );
  }
}
