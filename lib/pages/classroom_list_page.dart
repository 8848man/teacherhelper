import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacherhelper/pages/student_list_page.dart';
import 'package:teacherhelper/pages/student_register_page.dart';

class ClassroomListPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('반 목록'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('classrooms').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<DocumentSnapshot> classrooms = snapshot.data!.docs;
          return ListView.builder(
            itemCount: classrooms.length,
            itemBuilder: (BuildContext context, int index) {
              final classroom =
                  classrooms[index].data() as Map<String, dynamic>;
              final studentCount = classroom['students']?.length ?? 0;
              final students = classroom['students'] as List<dynamic>?;

              return Column(
                children: [
                  ListTile(
                    title: Text(classroom['name'] ?? 'Unnamed classroom'),
                    subtitle: Text('학생 수: $studentCount'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentListPage(
                              // classroomId: classrooms[index].id,
                              ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
