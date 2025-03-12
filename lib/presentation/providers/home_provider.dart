import 'package:flutter/material.dart';

import '../../data/datasource/network/service/home_service.dart';

class HomeProvider with ChangeNotifier {
  late BuildContext context;
  HomeService homeService = HomeService();
  final int _count = 0;

  int get count => _count;

  void incrementCount() {
    // _count++;
    // notifyListeners();
    homeService.getData();
  }
}
