import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/user.dart';
import 'package:teacherhelper/formatter/password_inpot.dart';
import 'package:teacherhelper/formatter/phone_number_input.dart';
import 'package:teacherhelper/pages/main_page.dart';
import 'package:teacherhelper/providers/auth_provider.dart';
import 'package:teacherhelper/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Size screenSize;
  const RegisterPage({super.key, required this.screenSize});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordCheckController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _schoolController = TextEditingController();

  bool isObscure1 = true;
  bool isObscure2 = true;
  bool _isLoading = false;

  // Firebase 인증을 이용한 회원가입
  Future<void> _registerUser() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      _isLoading = true;
    });

    if (_passwordController.text != _passwordCheckController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("입력하신 비밀번호가 다릅니다."),
      ));
      FocusScope.of(context).unfocus();
      return;
    }
    try {
      AppUser appUser = AppUser(
        userType: 'T',
        name: _nameController.text,
        schoolName: _schoolController.text,
        email: _emailController.text,
        phoneNum: _phoneController.text,
        uid: '',
      );
      // Firebase Authentication을 이용하여 사용자 등록
      authProvider.signUp(
        appUser: appUser,
        password: _passwordController.text,
        onSuccess: () {
          // 회원가입 성공
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("회원가입 성공"),
          ));
          // HomePage로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainPage_reform()),
          );
        },
        onError: (err) {
          // 에러 발생
          FocusScope.of(context).unfocus();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(err),
          ));
        },
      );
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("비밀번호를 더 복잡하게 설정해주세요.")));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("이미 등록된 이메일입니다.")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("회원가입에 실패했습니다. 다시 시도해주세요.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 화면 조정을 위한 변수
    final screenSize = MediaQuery.of(context).size;
    return Consumer<AuthService>(builder: (context, authService, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
            key: _formKey,
            child: Row(
              children: [
                // 회원가입 페이지 메인 이미지
                SizedBox(
                  width: screenSize.height * 0.88,
                  height: screenSize.height * 1,
                  child: Image.asset('assets/images/register_page.jpg'),
                ),
                // 회원가입 폼
                SizedBox(
                  height: screenSize.height * 1,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(screenSize.width * 0.08),
                      child: Column(
                        children: <Widget>[
                          // 회원가입
                          const Text(
                            '회원가입',
                            // TextStyle를 정의하여 텍스트 스타일을 설정합니다.
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 40.0,
                              fontWeight: FontWeight.w600,
                              height: 1.35, // line-height을 설정합니다.
                              letterSpacing: 0.04,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: screenSize.height * 0.07,
                          ),
                          SizedBox(
                            width: screenSize.width * 0.25, // 원하는 너비
                            height: screenSize.height * 0.06, // 원하는 높이
                            child: TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '이메일 주소',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.015,
                          ),
                          SizedBox(
                            width: screenSize.width * 0.25, // 원하는 너비
                            height: screenSize.height * 0.06, // 원하는 높이
                            child: TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '이름',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.015,
                          ),
                          SizedBox(
                            width: screenSize.width * 0.25, // 원하는 너비
                            height: screenSize.height * 0.06, // 원하는 높이
                            child: TextField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '휴대폰 번호',
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly, // 숫자만 허용
                                PhoneNumberTextInputFormatter(), // 휴대폰 번호 형식 제한
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.015,
                          ),
                          SizedBox(
                            width: screenSize.width * 0.25, // 원하는 너비
                            height: screenSize.height * 0.06, // 원하는 높이
                            child: Stack(
                              children: [
                                TextField(
                                  controller: _passwordController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: '비밀번호(영어 대소문자와 숫자만 입력하세요.)',
                                  ),
                                  inputFormatters: [
                                    AlphanumericTextInputFormatter()
                                  ],
                                  obscureText: isObscure1,
                                ),
                                Row(
                                  children: [
                                    const Spacer(),
                                    GestureDetector(
                                      child: Image.asset(
                                          'assets/images/password_icon.png'),
                                      onTap: () {
                                        setState(() {
                                          isObscure1 = !isObscure1;
                                        });
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.015,
                          ),
                          SizedBox(
                            width: screenSize.width * 0.25, // 원하는 너비
                            height: screenSize.height * 0.06, // 원하는 높이
                            child: Stack(
                              children: [
                                TextField(
                                  controller: _passwordCheckController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: '비밀번호 확인',
                                  ),
                                  inputFormatters: [
                                    AlphanumericTextInputFormatter()
                                  ],
                                  obscureText: isObscure2,
                                ),
                                Row(
                                  children: [
                                    const Spacer(),
                                    GestureDetector(
                                      child: Image.asset(
                                          'assets/images/password_icon.png'),
                                      onTap: () {
                                        setState(() {
                                          isObscure2 = !isObscure2;
                                        });
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.015,
                          ),
                          SizedBox(
                            width: screenSize.width * 0.25, // 원하는 너비
                            height: screenSize.height * 0.06, // 원하는 높이
                            child: TextField(
                              controller: _schoolController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '학교이름',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.015,
                          ),
                          // TextFormField(),
                          SizedBox(
                            width: screenSize.width * 0.25, // 원하는 너비,
                            height: screenSize.height * 0.05,
                            child: ElevatedButton(
                              child: const Text(
                                '회원가입',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  height: 1.375, // line-height
                                  letterSpacing: 0.5,
                                ),
                              ),
                              onPressed: () {
                                _registerUser();
                              },
                            ),
                          ),
                          // SizedBox(
                          //   height: screenSize.height * 0.05,
                          //   child: const Row(
                          //     children: [
                          //       Divider(
                          //         height: 20,
                          //         indent: 20,
                          //         endIndent: 0,
                          //         color: Colors.black,
                          //       ),
                          //       Text('OTHERS'),
                          //       Divider(
                          //         height: 20,
                          //         indent: 20,
                          //         endIndent: 0,
                          //         color: Colors.black,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // GestureDetector(
                          //   child: Image.asset(
                          //     'assets/buttons/google_button.png',
                          //     width: screenSize.width * 0.25,
                          //   ),
                          //   onTap: () {
                          //     // 구글 로그인 버튼
                          //   },
                          // ),

                          SizedBox(
                            height: screenSize.height * 0.4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
      );
    });
  }
}
