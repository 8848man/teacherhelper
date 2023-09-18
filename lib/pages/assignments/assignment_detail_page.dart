import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/datamodels/assignmentHistory.dart';
import 'package:teacherhelper/providers/assignment_provider.dart';

class AssignmentDetailPage extends StatelessWidget {
  final String classroomId;
  final String studentId;
  final String assignmentId;

  const AssignmentDetailPage({super.key, 
    required this.classroomId,
    required this.studentId,
    required this.assignmentId,
  });

  @override
  Widget build(BuildContext context) {
    final assignmentProvider = Provider.of<AssignmentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment Detail'),
      ),
      body: FutureBuilder<List<AssignmentHistory>>(
        future: assignmentProvider.getAssignmentHistory(
            classroomId, studentId, assignmentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No history available.'));
          } else {
            final historyList = snapshot.data!;
            return ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final history = historyList[index];
                return ListTile(
                    title: Text('Date: ${history.checkDate}'),
                    subtitle: history.isAdd ? const Text('벌점') : const Text('상점')
                    // Display other history details
                    );
              },
            );
          }
        },
      ),
    );
  }
}
