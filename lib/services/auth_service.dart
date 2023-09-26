import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/user.dart';
import 'package:teacherhelper/exeption_messages/treanslate_firebase_auth_exeception.dart';

class AuthService extends ChangeNotifier {
  User? currentUser() {
    // 현재 유저(로그인 되지 않은 경우 null 반환)
    return FirebaseAuth.instance.currentUser;
  }

  bool isLoading = false;

  // 회원가입 함수
  Future<String?> signUp({
    required AppUser appUser, // 이메일
    required String password, // 비밀번호
  }) async {
    // firebase auth 회원 가입
    try {
      // 파이어베이스 회원가입
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: appUser.email,
            password: password,
          )
          // 회원가입 후 상세정보 저장.
          .then(
            (value) async => {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(value.user!.uid)
                  .set(
                {
                  'email': appUser.email,
                  'name': appUser.name,
                  'phoneNum': appUser.phoneNum,
                  'schoolName': appUser.schoolName,
                  'uid': value.user!.uid,
                  'userType': appUser.userType,
                },
              ),
            },
          );
      return 'success';
    } on FirebaseAuthException catch (e) {
      return translateFirebaseAuthException(e);
    } catch (e) {
      // Firebase auth 이외의 에러 발생
      return e.toString();
    }
  }

  void signIn({
    required String email, // 이메일
    required String password, // 비밀번호
    required Function onSuccess, // 로그인 성공시 호출되는 함수
    required Function(String err) onError,
  }) async {
    // 로그인
    if (email.isEmpty) {
      onError('이메일을 입력해주세요.');
      return;
    } else if (password.isEmpty) {
      onError('비밀번호를 입력해주세요.');
      return;
    }

    isLoading = true;

    // 로그인 시도
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      onSuccess(); // 성공 함수 호출
      notifyListeners(); // 로그인 상태 변경 알림
    } on FirebaseAuthException catch (e) {
      // firebase auth 에러 발생
      onError(e.message!);
    } catch (e) {
      // Firebase auth 이외의 에러 발생
      onError(e.toString());
    }

    isLoading = false;
  }

  void signOut() async {
    // 로그아웃
    await FirebaseAuth.instance.signOut();
    notifyListeners(); // 로그인 상태 변경 알림
  }
}
