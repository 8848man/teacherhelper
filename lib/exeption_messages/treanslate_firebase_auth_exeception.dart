import 'package:firebase_auth/firebase_auth.dart';

String translateFirebaseAuthException(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return '유효하지 않은 이메일 주소입니다.';
    case 'user-not-found':
      return '사용자를 찾을 수 없습니다.';
    case 'wrong-password':
      return '잘못된 비밀번호입니다.';
    // 여기에 필요한 다른 예외 코드에 대한 번역을 추가할 수 있습니다.
    default:
      return 'Firebase 인증 예외가 발생했습니다: ${e.code}';
  }
}
