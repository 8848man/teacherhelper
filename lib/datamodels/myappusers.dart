import 'package:teacherhelper/datamodels/user.dart';

class MyAppUser {
  final String? uid;
  final String? email;
  final String? displayName;

  MyAppUser({this.uid, this.email, this.displayName});

  factory MyAppUser.fromJson(Map<String, dynamic> json) {
    return MyAppUser(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
    );
  }

  static MyAppUser fromUser(User user) {
    return MyAppUser(
      uid: user.uid,
      email: user.email,
      displayName: user.name,
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
      };

  User toUser() {
    return User.fromJson({
      'uid': uid!,
      'email': email!,
      'displayName': displayName!,
    });
  }
}
