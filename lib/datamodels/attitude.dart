class Attitude {
  String? id;
  String name;
  DateTime? startDate;
  String? point;
  String? checkDate;
  int? order;

  Attitude({
    this.id,
    required this.name,
    this.startDate,
    this.checkDate,
    this.point,
    this.order,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'startDate': startDate,
      'checkDate': checkDate,
      'point': point ?? '0',
      'order': order ?? '0',
    };
  }

  factory Attitude.fromJson(Map<String, dynamic> json, String? id) {
    return Attitude(
      id: id,
      name: json['name'],
      startDate: json['startDate'].toDate(),
      checkDate: json['checkDate'].toDate(),
      point: json['point'] ?? '0',
      order: json['order'],
    );
  }
}
