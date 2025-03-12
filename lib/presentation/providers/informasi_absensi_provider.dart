
  import 'package:flutter/material.dart';
  import '../../data/datasource/network/service/informasi_absensi_service.dart';
  
  class InformasiAbsensiProvider with ChangeNotifier {
    late BuildContext context;
    InformasiAbsensiService informasiAbsensiService = InformasiAbsensiService();
    int _count = 0;
  
    int get count => _count;
  
    void incrementCount() {
      _count++;
      notifyListeners();
    }
  }
    