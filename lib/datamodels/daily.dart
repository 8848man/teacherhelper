class Daily {
  String? id;
  String name;
  bool isComplete;
  DateTime startDate;
  DateTime? dueDate;
  DateTime? checkDate;
  int? seqNumber;

  Daily({
    this.id,
    required this.name,
    required this.isComplete,
    required this.startDate,
    this.dueDate,
    this.checkDate,
    this.seqNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isComplete': isComplete,
      'startDate': startDate,
      'dueDate': dueDate,
      'checkDate': checkDate,
      'seqNumber': seqNumber,
    };
  }

  factory Daily.fromJson(Map<String, dynamic> json, String? id) {
    return Daily(
      id: id,
      name: json['name'],
      isComplete: json['isComplete'],
      startDate: json['startDate'].toDate(),
      dueDate: json['dueDate'].toDate(),
      checkDate: json['checkDate'].toDate(),
      seqNumber: json['seqNumber'],
    );
  }
}
