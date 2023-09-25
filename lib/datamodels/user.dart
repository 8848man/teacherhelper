class AppUser {
  String uid;
  String name;
  String email;
  String phoneNum;
  String schoolName;
  // 유저 유형. T = 선생님, S = 학생, P = 학부모
  String userType;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNum,
    required this.schoolName,
    required this.userType,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      phoneNum: json['phoneNum'],
      schoolName: json['schoolName'],
      userType: json['userType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNum': phoneNum,
      'schoolName': schoolName,
      'userType': userType,
    };
  }
}
