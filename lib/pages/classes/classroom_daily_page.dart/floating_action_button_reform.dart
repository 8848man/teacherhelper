// 과제나 데일리 추가 버튼을 위한 참고 코드
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('버튼 그룹 슬라이드 예제'),
        ),
        body: const MyButtonGroup(),
        floatingActionButton: const ExpandButton(),
      ),
    );
  }
}

class MyButtonGroup extends StatefulWidget {
  const MyButtonGroup({super.key});

  @override
  _MyButtonGroupState createState() => _MyButtonGroupState();
}

class _MyButtonGroupState extends State<MyButtonGroup> {
  final bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _isExpanded ? 200 : 0, // 버튼 그룹 높이 조절
          child: SingleChildScrollView(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle first button's action
                  },
                  child: const Text('버튼 1'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle second button's action
                  },
                  child: const Text('버튼 2'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle third button's action
                  },
                  child: const Text('버튼 3'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ExpandButton extends StatelessWidget {
  const ExpandButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // 버튼 그룹 확장/축소 토글
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('버튼 그룹 토글'),
        ));
      },
      child: const Icon(Icons.keyboard_arrow_up), // 화살표 아이콘
    );
  }
}
