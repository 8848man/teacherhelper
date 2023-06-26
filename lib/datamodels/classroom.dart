class Classroom {
  final String id; // 반 고유 id
  final String name; // 반 이름
  final String teacherUid; // 해당 반을 관리하는 선생님 uid
  final List<String> students = []; // 해당 반에 등록된 학생들의 uid 목록
  final List<String> assignments = []; // 해당 반에 등록된 과제 목록
  final int grade;

  Classroom(
      {required this.id,
      required this.name,
      required this.teacherUid,
      required this.grade});

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      id: json['id'],
      name: json['name'],
      teacherUid: json['teacherUid'],
      grade: json['grade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'teacherUid': teacherUid,
      'students': students,
      'assignments': assignments,
      'grade': grade,
    };
  }
}
