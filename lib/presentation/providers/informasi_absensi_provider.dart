import '../../core/base/base_provider.dart';
import '../../data/datasource/network/service/informasi_absensi_service.dart';

class InformasiAbsensiProvider extends BaseProvider {
  final InformasiAbsensiService informasiAbsensiService =
      InformasiAbsensiService();
  int _count = 0;

  int get count => _count;

  @override
  String get logTag => 'INFORMASI_ABSENSI'; // Custom tag for logging

  @override
  void onInit() {
    super.onInit();
    // Initialize data or setup listeners here
  }

  @override
  void onReady() {
    super.onReady();
    // Perform tasks after the UI is built
    // For example, fetch initial data
    fetchInformasiAbsensi();
  }

  @override
  void onClose() {
    // Clean up resources when this provider is no longer needed
    super.onClose();
  }

  void incrementCount() {
    function(() {
      _count++;
    }, operationName: 'incrementCount');
  }

  Future<void> fetchInformasiAbsensi() async {
    await functionAsync(() async {
      // Implementasi fetch data dari service
      logger.d('Fetching informasi absensi data...', tag: logTag);
      // Add actual implementation here
    }, operationName: 'fetchInformasiAbsensi');
  }
}
