import 'package:flutter/cupertino.dart';
import 'package:teacherhelper/datamodels/classes.dart';
import 'package:teacherhelper/services/classes_service.dart';

class ClassesProvider with ChangeNotifier {
  final ClassesService _classesService;

  ClassesProvider() : _classesService = ClassesService();

  final List<Classes> _classes = [];
  List<Classes> get classes => _classes;
}
