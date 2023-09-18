import 'package:flutter/material.dart';
import 'package:teacherhelper/pages/login_page.dart';
import 'package:teacherhelper/pages/register_page.dart';

class CoverPage extends StatelessWidget {
  const CoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.07),
        child: Row(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width * 0.43,
              // color: Colors.blue,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                  ),
                  Text(
                    'SCHOOL CHECK',
                    style: TextStyle(
                      fontFamily: 'Mplus 1p Bold', // 폰트 패밀리
                      fontSize:
                          MediaQuery.of(context).size.width * 0.1, // 폰트 크기
                      fontWeight:
                          FontWeight.w700, // 폰트 웨이트 (700은 FontWeight.bold와 같음)
                      height: 1.25, // 라인 높이 (190px / 128px)
                      letterSpacing: 0, // 글자 간격 (0em)
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      GestureDetector(
                        child: Image.asset('assets/buttons/login_button.jpg',
                            height: MediaQuery.of(context).size.height * 0.06),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      GestureDetector(
                        child: Image.asset('assets/buttons/login_button.jpg',
                            height: MediaQuery.of(context).size.height * 0.06),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()),
                          );
                        },
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  )
                ],
              ),
            ),
            Image.asset(
              'assets/images/cover_image.jpg',
              // height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width * 0.43,
            ),
          ],
        ),
      ),
    );
  }
}
