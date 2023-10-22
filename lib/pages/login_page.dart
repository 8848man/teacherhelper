import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/pages/register_page.dart';
import 'package:teacherhelper/services/auth_service.dart';

import 'main_page.dart';

// class LoginPage1 extends StatefulWidget {
//   @override
//   _LoginPage1State createState() => _LoginPage1State();
// }

// class _LoginPage1State extends State<LoginPage1> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AuthService>(builder: (context, authService, child) {
//       return Scaffold(
//         appBar: AppBar(title: Text("로그인")),
//         body: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: InputDecoration(labelText: "이메일"),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return '이메일을 입력해주세요.';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16.0),
//                 TextFormField(
//                   controller: _passwordController,
//                   decoration: InputDecoration(labelText: "비밀번호"),
//                   obscureText: true,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return '비밀번호를 입력해주세요.';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16.0),
//                 Center(
//                   child: Row(
//                     children: [
//                       ElevatedButton(
//                         child: authService.isLoading
//                             ? CircularProgressIndicator()
//                             : Text("로그인"),
//                         onPressed: () {
//                           // 로그인
//                           authService.signIn(
//                             email: _emailController.text,
//                             password: _passwordController.text,
//                             onSuccess: () {
//                               // 로그인 성공
//                               ScaffoldMessenger.of(context)
//                                   .showSnackBar(SnackBar(
//                                 content: Text("로그인 성공"),
//                               ));
//                               // HomePage로 이동
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => MainPage()),
//                               );
//                             },
//                             onError: (err) {
//                               // 에러 발생
//                               ScaffoldMessenger.of(context)
//                                   .showSnackBar(SnackBar(
//                                 content: Text(err),
//                               ));
//                             },
//                           );
//                         },
//                       ),
//                       Spacer(),
//                       ElevatedButton(
//                         child: authService.isLoading
//                             ? CircularProgressIndicator()
//                             : Text("계정 등록"),
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => RegisterPage()),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }

class LoginPage extends StatefulWidget {
  final Size screenSize;
  const LoginPage({super.key, required this.screenSize});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, authService, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.height * 0.88,
                height: MediaQuery.of(context).size.height * 1,
                child: Image.asset('assets/images/login_page.jpg'),
              ),
              SingleChildScrollView(
                child: Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.08),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      const Text(
                        'WELCOME',
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
                            MediaQuery.of(context).size.height * 0.07, // 원하는 높이
                        child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '이메일을 입력해주세요',
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
                            MediaQuery.of(context).size.height * 0.07, // 원하는 높이
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '비밀번호를 입력해주세요',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      // TextFormField(),
                      SizedBox(
                        width:
                            MediaQuery.of(context).size.width * 0.25, // 원하는 너비,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: ElevatedButton(
                          child: const Text(
                            'LOG IN',
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
                                    .showSnackBar(const SnackBar(
                                  content: Text("로그인 성공"),
                                ));
                                // HomePage로 이동
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MainPage_reform()),
                                );
                              },
                              onError: (err) {
                                // 에러 발생
                                FocusScope.of(context).unfocus();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(err),
                                ));
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(
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
                      // GestureDetector(
                      //   child: Image.asset(
                      //     'assets/buttons/google_button.png',
                      //     width: MediaQuery.of(context).size.width * 0.25,
                      //   ),
                      //   onTap: () {
                      //     // 구글 로그인 버튼
                      //   },
                      // ),
                      Row(
                        children: [
                          const Text('아직 계정이 없으시다면 '),
                          GestureDetector(
                            child: const Text(
                              '회원가입',
                              style: TextStyle(color: Colors.blue),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage(
                                        screenSize: widget.screenSize)),
                              );
                            },
                          ),
                          const Text('을 눌러주세요'),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
