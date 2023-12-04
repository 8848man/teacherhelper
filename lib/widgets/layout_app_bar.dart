// 앱바
import 'package:flutter/material.dart';

AppBar layoutAppBar(String currentDate, BuildContext context) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
    title: Row(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.03,
          child: Image.asset('assets/checkmark_circle.png'),
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.3,
          child: const Text(
            'SchoolCheck',
            style: TextStyle(color: Colors.orange),
          ),
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 1 / 3,
          child: Center(
            child:
                Text(currentDate, style: const TextStyle(color: Colors.orange)),
          ),
        ),
        Expanded(
          child: Container(
            child: const Align(
              alignment: Alignment.centerRight, // Text를 오른쪽에 정렬
              // child: Text(classroom.name,
              //     style: const TextStyle(color: Colors.orange)),
              child: Text('Test'),
            ),
          ),
        )
      ],
    ),
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(2.0),
      child: Container(
        color: Colors.orange,
        height: 2.0,
      ),
    ),
    elevation: 0, // 그림자를 없애는 부분
  );
}
