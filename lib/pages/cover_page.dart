import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CoverPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.07),
        child: Row(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width * 0.43,
              color: Colors.blue,
              child: Column(
                children: [
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
                  Spacer(),
                  Row(
                    children: [],
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              'assets/images/cover_page.svg',
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width * 0.43,
            ),
          ],
        ),
      ),
    );
  }
}
