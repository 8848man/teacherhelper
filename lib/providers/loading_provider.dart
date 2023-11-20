import 'package:flutter/material.dart';

/**
 * 로딩 변수를 관리하는 프로바이더
 * Provider.of<LoadingProvider>(context, listen: false).setLoading(true); 호출시 로딩화면으로 전환,
 * Provider.of<LoadingProvider>(context, listen: false).setLoading(false); 호출시 로딩화면 끝
 */
class LoadingProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
