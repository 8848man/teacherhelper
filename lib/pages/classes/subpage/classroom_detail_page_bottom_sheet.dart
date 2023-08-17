import 'package:flutter/material.dart';
import 'package:teacherhelper/datamodels/assignment.dart';
import 'package:teacherhelper/datamodels/classroom.dart';
import 'package:teacherhelper/datamodels/student.dart';
import 'package:teacherhelper/providers/assignment_provider.dart';
import 'package:teacherhelper/providers/classroom_provider.dart';

class StudentAssignmentBottomSheet extends StatefulWidget {
  final String? studentId;
  final String classroomId;

  StudentAssignmentBottomSheet(
      {required this.studentId, required this.classroomId});

  @override
  State<StudentAssignmentBottomSheet> createState() =>
      _StudentAssignmentBottomSheetState();
}

class _StudentAssignmentBottomSheetState
    extends State<StudentAssignmentBottomSheet> {
  AssignmentProvider _assignmentProvider = AssignmentProvider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        children: [
          // Text('Assignments for ${student.name}'),
          Expanded(
            child: FutureBuilder<List<Assignment>>(
              future: _assignmentProvider.getAssignmentsForStudent(
                  widget.classroomId, widget.studentId),
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

                return ListView(
                  scrollDirection: Axis.horizontal, // 가로 스크롤 방향
                  children: assignments.map((assignment) {
                    return Container(
                      width: 200, // 가로 길이 조정
                      margin: EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(assignment.name),
                              subtitle: Text(assignment.point.toString()),
                              // Display other assignment details
                              onTap: () {
                                setState(() {
                                  _assignmentProvider.addPoint(
                                      widget.classroomId,
                                      widget.studentId,
                                      assignment);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
