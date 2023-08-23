import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/classroom.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/pages/assignments/assignment_detail_page.dart';
import 'package:teacherhelper/providers/assignment_provider.dart';
import 'package:teacherhelper/providers/student_provider.dart';

import '../../datamodels/assignment.dart';

class StudentAssignmentPage extends StatelessWidget {
  final String? studentId;
  final String classroomId;

  StudentAssignmentPage({required this.classroomId, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Assignments'),
      ),
      body:
          StudentAssignmentView(classroomId: classroomId, studentId: studentId),
    );
  }
}

class StudentAssignmentView extends StatelessWidget {
  final String? studentId;
  final String classroomId;
  StudentAssignmentView({required this.classroomId, required this.studentId});

  @override
  Widget build(BuildContext context) {
    final _assignmentProvider = Provider.of<AssignmentProvider>(context);

    return FutureBuilder<List<Assignment>>(
      future:
          _assignmentProvider.getAssignmentsForStudent(classroomId, studentId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No assignments found for this student.');
        }

        final assignments = snapshot.data!;

        return ListView.builder(
          itemCount: assignments.length,
          itemBuilder: (context, index) {
            final assignment = assignments[index];
            return ListTile(
                title: Text(assignment.name),
                subtitle: Text(assignment.point.toString()),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssignmentDetailPage(
                        studentId: studentId!,
                        classroomId: classroomId,
                        assignmentId: assignment.id!,
                      ),
                    ),
                  );
                }
                // Display other assignment details
                );
          },
        );
      },
    );
  }
}
