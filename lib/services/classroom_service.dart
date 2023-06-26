import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClassroomService extends ChangeNotifier {
  final classroomCollection =
      FirebaseFirestore.instance.collection('classroom');

  Future<QuerySnapshot> read(String uid) async {
    // 내 bucketList 가져오기
    return classroomCollection.where('uid', isEqualTo: uid).get();
  }

  void createStudent(String name, int number, String uid) async {
    // bucket 만들기
    await classroomCollection.add({
      'uid': uid, // 유저 식별자
      'name': name, // 하고싶은 일
      'number': number, // 학번
    });
    notifyListeners(); // 화면 갱신
  }
}
