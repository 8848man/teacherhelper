import 'package:flutter/material.dart';
import 'package:teacherhelper/pages/login_page.dart';
import 'package:teacherhelper/pages/register_page.dart';
import 'package:teacherhelper/veiw_model/cover_page_view_model.dart';

class CoverPage extends StatelessWidget {
  CoverPage({super.key});

  var data = CoverPageViewModel();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
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
                  // 앱 이름 텍스트
                  Text(
                    data.appName,
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
                      // 로그인 페이지 버튼
                      GestureDetector(
                        child: Image.asset('assets/buttons/login_button.jpg',
                            height: MediaQuery.of(context).size.height * 0.06),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LoginPage(screenSize: screenSize),
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      // 회원가입 페이지 버튼
                      GestureDetector(
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/buttons/orange_rounded_button.png',
                              height: MediaQuery.of(context).size.height * 0.06,
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Text(
                                  data.signIn,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.025,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(
                                screenSize: screenSize,
                              ),
                            ),
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
            // 우측 커버페이지 이미지
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
