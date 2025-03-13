import 'package:flutter/material.dart';
import '../../core/base/base_provider.dart';
import '../../data/datasource/network/service/informasi_absensi_service.dart';

class InformasiAbsensiProvider extends BaseProvider {
  final InformasiAbsensiService informasiAbsensiService;
  int _count = 0;

  InformasiAbsensiProvider({required this.informasiAbsensiService});

  int get count => _count;

  @override
  void onInit() {
    super.onInit();
    debugPrint('InformasiAbsensiProvider: onInit called');
    // Initialize data or setup listeners here
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('InformasiAbsensiProvider: onReady called');
    // Perform tasks after the UI is built
    // For example, fetch initial data
    fetchInformasiAbsensi();
  }

  @override
  void onClose() {
    debugPrint(
        'InformasiAbsensiProvider: onClose called - cleaning up resources');
    // Clean up resources when this provider is no longer needed
    super.onClose();
  }

  void incrementCount() {
    _count++;
    notifyListeners();
  }

  Future<void> fetchInformasiAbsensi() async {
    // Fetch absensi data
    try {
      // Implementasi fetch data dari service
      debugPrint('Fetching informasi absensi data...');
    } catch (e) {
      debugPrint('Error fetching informasi absensi: $e');
    }
  }
}
