import 'package:get_it/get_it.dart';

// Import modul-modul
import 'modules/core_module.dart';
import 'modules/network_module.dart';
import 'modules/repository_module.dart';
import 'modules/service_module.dart';

final serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  await setupCoreModule(serviceLocator);
  await setupNetworkModule(serviceLocator);
  await setupRepositoryModule(serviceLocator);
  await setupServiceModule(serviceLocator);
}
