import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/loading_provider.dart';
import '../providers/new_layout_provider.dart';

// 바텀 네비게이션
class LayoutBottomNavigation extends StatefulWidget {
  const LayoutBottomNavigation({super.key});

  @override
  State<StatefulWidget> createState() => _LayoutBottomNavigationState();
}

class _LayoutBottomNavigationState extends State<LayoutBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewLayoutProvider>(
        builder: (context, layoutProvider, child) {
      List<String> navbarImages = layoutProvider.getNavbarImages();
      return Container(
        width: double.infinity,
        height: 90,
        color: const Color(0xFF344054),
        child: Row(
          children: [
            const SizedBox(
              width: 90,
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Center(
                          child: GestureDetector(
                            child: Image.asset(navbarImages[0]),
                            onTap: () {
                              layoutProvider.setSelectedBottomNav(0);
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Center(
                          child: GestureDetector(
                            child: Image.asset(navbarImages[1]),
                            onTap: () {
                              layoutProvider.setSelectedBottomNav(1);
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Center(
                          child: GestureDetector(
                            child: Image.asset(navbarImages[2]),
                            onTap: () {
                              layoutProvider.setSelectedBottomNav(2);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                // 수업 추가 버튼
                child: GestureDetector(
                  child: Image.asset(
                      'assets/icons_for_bottomnav/dailys/plus_button.png'),
                  onTap: () async {
                    if (layoutProvider.selectedIndices[2] == 1) {
                      setState(() {
                        Provider.of<LoadingProvider>(context, listen: false)
                            .setLoading(true);
                      });
                      // await layoutProvider.createDailyLayout(thisDate,
                      //     layoutProvider.classroom, studentProvider.students);
                      setState(() {
                        Provider.of<LoadingProvider>(context, listen: false)
                            .setLoading(false);
                      });
                    } else if (layoutProvider.selectedIndices[3] == 1) {
                      // setState(() {
                      //   isLoading = true;
                      // });

                      print('수업 추가');
                    }
                  },
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Center(
                          child: GestureDetector(
                            child: Image.asset(navbarImages[3]),
                            onTap: () {
                              layoutProvider.setSelectedBottomNav(3);
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Center(
                          child: GestureDetector(
                            child: Image.asset(navbarImages[4]),
                            onTap: () {
                              layoutProvider.setSelectedBottomNav(4);
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Center(
                          child: GestureDetector(
                            child: Image.asset(navbarImages[5]),
                            onTap: () {
                              layoutProvider.setSelectedBottomNav(5);
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 90),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 90,
              child: Image.asset(navbarImages[6]),
            ),
          ],
        ),
      );
    });
  }
}
