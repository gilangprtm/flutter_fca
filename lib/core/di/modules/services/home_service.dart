import 'package:get_it/get_it.dart';
import '../../../../data/datasource/network/service/home_service.dart';
import '../../../../data/datasource/network/repository/home_repository.dart';
import '../../../mahas/services/logger_service.dart';
import '../../../mahas/services/performance_service.dart';

/// Mendaftarkan semua service
Future<void> homeService(GetIt serviceLocator) async {
  // Home service
  serviceLocator.registerLazySingleton<HomeService>(() => HomeService(
        homeRepository: serviceLocator<HomeRepository>(),
        logger: serviceLocator<LoggerService>(),
        performanceService: serviceLocator<PerformanceService>(),
      ));
}
