import '../pages/informasi_absensi/informasi_absensi_page.dart';
import '../pages/home/home_page.dart';

import 'package:flutter/material.dart';
import 'app_routes.dart';

class AppRoutesProvider {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.home: (context) => const HomePage(),
      AppRoutes.informasiAbsensi: (context) => const InformasiAbsensiPage(),
    };
  }
}
