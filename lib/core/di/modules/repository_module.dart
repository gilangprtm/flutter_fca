import 'package:get_it/get_it.dart';

import 'repositories/user_repository.dart';

/// Mendaftarkan semua repository
Future<void> setupRepositoryModule(GetIt serviceLocator) async {
  // User repository
  await userRepository(serviceLocator);
}
