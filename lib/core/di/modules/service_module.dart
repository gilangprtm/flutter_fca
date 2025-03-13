import 'package:get_it/get_it.dart';

import 'services/home_service.dart';

/// Mendaftarkan semua service
Future<void> setupServiceModule(GetIt serviceLocator) async {
  // Home service
  await homeService(serviceLocator);
}
