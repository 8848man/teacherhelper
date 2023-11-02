import 'package:flutter/cupertino.dart';
import 'package:teacherhelper/services/classes_service.dart';

class ClassesProvider with ChangeNotifier {
  final ClassesService _classesService;

  ClassesProvider() : _classesService = ClassesService();
}
