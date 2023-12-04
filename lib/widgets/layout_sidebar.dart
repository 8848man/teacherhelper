import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/new_layout_provider.dart';

// 사이드바
Widget layoutSideBar() {
  return Consumer<NewLayoutProvider>(builder: (context, layoutProvider, child) {
    List<String> sidebarImages = layoutProvider.getSidebarImages();
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Color(0xFFC4C4C4), // Border 색상 설정
            width: 1.0, // Border 너비 설정
          ),
        ),
      ),
      width: 90,
      child: Column(
        children: [
          // 내 정보
          Container(
            width: 70,
            padding: const EdgeInsets.all(10),
            height: MediaQuery.sizeOf(context).height * 0.1,
            color: Colors.white,
            child: GestureDetector(
              child: Image.asset(sidebarImages[0]),
              onTap: () {
                layoutProvider.setSelected(0);
              },
            ),
          ),
          const Divider(
            height: 20,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Color(0xFFC4C4C4),
          ),
          // 전체 메뉴
          Container(
            width: 70,
            padding: const EdgeInsets.all(10),
            height: MediaQuery.sizeOf(context).height * 0.1,
            color: Colors.white,
            child: GestureDetector(
              child: Image.asset(sidebarImages[1]),
              onTap: () {
                layoutProvider.setSelected(1);
              },
            ),
          ),
          const Divider(
            height: 20,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Color(0xFFC4C4C4),
          ),
          Expanded(
            child: Column(
              children: [
                // 일상
                Container(
                  width: 70,
                  padding: const EdgeInsets.all(10),
                  height: MediaQuery.sizeOf(context).height * 0.1,
                  color: Colors.white,
                  child: GestureDetector(
                    child: Image.asset(sidebarImages[2]),
                    onTap: () {
                      layoutProvider.setSelected(2);
                    },
                  ),
                ),
                // 수업
                Container(
                  width: 70,
                  padding: const EdgeInsets.all(10),
                  height: MediaQuery.sizeOf(context).height * 0.1,
                  color: Colors.white,
                  child: GestureDetector(
                    child: Image.asset(sidebarImages[3]),
                    onTap: () {
                      // generateTabs(dailys, classes, selectedIndex);
                      layoutProvider.setSelected(3);
                    },
                  ),
                ),
                // 통계
                Container(
                  width: 70,
                  padding: const EdgeInsets.all(10),
                  height: MediaQuery.sizeOf(context).height * 0.1,
                  color: Colors.white,
                  child: GestureDetector(
                    child: Image.asset(sidebarImages[4]),
                    onTap: () {
                      layoutProvider.setSelected(4);
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 20,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Color(0xFFC4C4C4),
          ),
          // 앱 옵션 버튼
          Container(
            width: 70,
            padding: const EdgeInsets.all(10),
            height: MediaQuery.sizeOf(context).height * 0.1,
            color: Colors.white,
            child: GestureDetector(
              child: Image.asset(sidebarImages[5]),
              onTap: () {
                layoutProvider.setSelected(5);
              },
            ),
          ),
          // 로그아웃 버튼
          Container(
            width: 70,
            padding: const EdgeInsets.all(10),
            height: MediaQuery.sizeOf(context).height * 0.1,
            color: Colors.white,
            child: Image.asset(sidebarImages[6]),
          ),
        ],
      ),
    );
  });
}
