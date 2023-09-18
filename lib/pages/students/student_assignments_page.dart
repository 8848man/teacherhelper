import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/pages/assignments/assignment_detail_page.dart';
import 'package:teacherhelper/providers/assignment_provider.dart';

import '../../datamodels/assignment.dart';

class StudentAssignmentPage extends StatelessWidget {
  final String? studentId;
  final String classroomId;

  const StudentAssignmentPage({super.key, required this.classroomId, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Assignments'),
      ),
      body:
          StudentAssignmentView(classroomId: classroomId, studentId: studentId),
    );
  }
}

class StudentAssignmentView extends StatelessWidget {
  final String? studentId;
  final String classroomId;
  const StudentAssignmentView({super.key, required this.classroomId, required this.studentId});

  @override
  Widget build(BuildContext context) {
    final assignmentProvider = Provider.of<AssignmentProvider>(context);

    return FutureBuilder<List<Assignment>>(
      future:
          assignmentProvider.getAssignmentsForStudent(classroomId, studentId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No assignments found for this student.');
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
