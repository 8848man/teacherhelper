import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/user.dart';
import 'package:teacherhelper/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;

  AuthProvider() : _authService = AuthService();

  late AppUser _appUser;
  AppUser get appUser => _appUser;

  // 회원가입.
  void signUp({
    required AppUser appUser, // 이메일
    required String password, // 비밀번호
    required Function onSuccess, // 가입 성공시 호출되는 함수
    required Function(String err) onError, // 에러 발생시 호출되는 함수
  }) async {
    // 이메일 및 비밀번호 입력 여부 확인
    if (appUser.email.isEmpty) {
      onError("이메일을 입력해 주세요.");
      return;
    } else if (password.isEmpty) {
      onError("비밀번호를 입력해 주세요.");
      return;
    } else if (appUser.name.isEmpty) {
      onError("이름을 입력해 주세요.");
      return;
    } else if (appUser.phoneNum.isEmpty) {
      onError("휴대폰 번호를 입력해 주세요.");
      return;
    }

    // firebase auth 회원 가입
    try {
      String? signUpMessage =
          await _authService.signUp(appUser: appUser, password: password);
      // 성공 함수 호출
      if (signUpMessage == 'success') {
        onSuccess();
      } else {
        onError(signUpMessage!);
      }
    } catch (e) {
      // Firebase auth 이외의 에러 발생
      onError(e.toString());
    }
  }
}
