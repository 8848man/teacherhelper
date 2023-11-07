import 'package:flutter/material.dart';

class LayoutContents extends StatefulWidget {
  final Map<String, dynamic> data;
  bool dataFetched = false;
  LayoutContents({
    super.key,
    required this.data,
  });
  @override
  State<StatefulWidget> createState() => _LayoutContentsState();
}

class _LayoutContentsState extends State<LayoutContents> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
