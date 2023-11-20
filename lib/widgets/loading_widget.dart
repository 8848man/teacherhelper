import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacherhelper/providers/loading_provider.dart';

class MyLoadingWidget extends StatelessWidget {
  const MyLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Consumer<LoadingProvider>(
        builder: (context, loadingProvider, child) {
      return Visibility(
        visible: loadingProvider.isLoading,
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    });
  }
}
