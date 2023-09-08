import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/pages/main_page.dart';
import 'package:teacherhelper/services/auth_service.dart';

class RegisterPage1 extends StatefulWidget {
  @override
  _RegisterPage1State createState() => _RegisterPage1State();
}

class _RegisterPage1State extends State<RegisterPage1> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;

  // Firebase 인증을 이용한 회원가입
  Future<void> _registerUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Firebase Authentication을 이용하여 사용자 등록
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text);

      // Firestore에 선생님 정보 저장
      await FirebaseFirestore.instance
          .collection('teachers')
          .doc(userCredential.user!.uid)
          .set({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'created_at': FieldValue.serverTimestamp() // 등록일자
      });

      setState(() {
        _isLoading = false;
      });

      // 회원가입 완료 후 로그인 화면으로 이동
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("비밀번호를 더 복잡하게 설정해주세요.")));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("이미 등록된 이메일입니다.")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("회원가입에 실패했습니다. 다시 시도해주세요.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("회원가입")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "이메일"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력해주세요.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "비밀번호"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해주세요.';
                  }
                  if (value.length < 6) {
                    return '비밀번호는 6자리 이상으로 설정해주세요.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "선생님 이름"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '선생님 이름을 입력해주세요.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "휴대폰번호"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '휴대폰번호를 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _registerUser();
                        }
                      },
                      child: Text("회원가입")),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
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

  bool _isLoading = false;

  // Firebase 인증을 이용한 회원가입
  Future<void> _registerUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Firebase Authentication을 이용하여 사용자 등록
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text);

      // Firestore에 선생님 정보 저장
      await FirebaseFirestore.instance
          .collection('teachers')
          .doc(userCredential.user!.uid)
          .set({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'created_at': FieldValue.serverTimestamp() // 등록일자
      });

      setState(() {
        _isLoading = false;
      });

      // 회원가입 완료 후 로그인 화면으로 이동
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("비밀번호를 더 복잡하게 설정해주세요.")));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("이미 등록된 이메일입니다.")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("회원가입에 실패했습니다. 다시 시도해주세요.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, authService, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
            key: _formKey,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.height * 0.88,
                  child: Image.asset('assets/images/register_page.jpg'),
                  height: MediaQuery.of(context).size.height * 1,
                ),
                Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.08),
                  child: Column(
                    children: <Widget>[
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
                        height: MediaQuery.of(context).size.height * 0.07,
                      ),
                      SizedBox(
                        width:
                            MediaQuery.of(context).size.width * 0.25, // 원하는 너비
                        height:
                            MediaQuery.of(context).size.height * 0.06, // 원하는 높이
                        child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '이메일 주소',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      SizedBox(
                        width:
                            MediaQuery.of(context).size.width * 0.25, // 원하는 너비
                        height:
                            MediaQuery.of(context).size.height * 0.06, // 원하는 높이
                        child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '이름',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      SizedBox(
                        width:
                            MediaQuery.of(context).size.width * 0.25, // 원하는 너비
                        height:
                            MediaQuery.of(context).size.height * 0.06, // 원하는 높이
                        child: TextField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '비밀번호',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      SizedBox(
                        width:
                            MediaQuery.of(context).size.width * 0.25, // 원하는 너비
                        height:
                            MediaQuery.of(context).size.height * 0.06, // 원하는 높이
                        child: TextField(
                          controller: _passwordCheckController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '비밀번호 확인',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      SizedBox(
                        width:
                            MediaQuery.of(context).size.width * 0.25, // 원하는 너비
                        height:
                            MediaQuery.of(context).size.height * 0.06, // 원하는 높이
                        child: TextField(
                          controller: _schoolController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '학교이름',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      // TextFormField(),
                      SizedBox(
                        width:
                            MediaQuery.of(context).size.width * 0.25, // 원하는 너비,
                        height: MediaQuery.of(context).size.height * 0.05,
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
                            authService.signIn(
                              email: _emailController.text,
                              password: _passwordController.text,
                              onSuccess: () {
                                // 로그인 성공
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("로그인 성공"),
                                ));
                                // HomePage로 이동
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainPage()),
                                );
                              },
                              onError: (err) {
                                // 에러 발생
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(err),
                                ));
                              },
                            );
                          },
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: const Row(
                          children: [
                            Divider(
                              height: 20,
                              indent: 20,
                              endIndent: 0,
                              color: Colors.black,
                            ),
                            Text('OTHERS'),
                            Divider(
                              height: 20,
                              indent: 20,
                              endIndent: 0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        child: Image.asset(
                          'assets/buttons/google_button.png',
                          width: MediaQuery.of(context).size.width * 0.25,
                        ),
                        onTap: () {
                          // 구글 로그인 버튼
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )),
      );
    });
  }
}
