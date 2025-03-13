import 'package:get_it/get_it.dart';
import '../../../data/datasource/network/db/dio_service.dart';
import '../../mahas/services/logger_service.dart';

/// Mendaftarkan semua layanan network seperti DioService
Future<void> setupNetworkModule(GetIt serviceLocator) async {
  // Register DioService - Tidak perlu menerima dependencies karena
  // DioService menangani konfigurasi Dio internal termasuk endpoint yang berbeda
  serviceLocator.registerLazySingleton<DioService>(() => DioService(
        logger: serviceLocator<LoggerService>(),
      ));
}
