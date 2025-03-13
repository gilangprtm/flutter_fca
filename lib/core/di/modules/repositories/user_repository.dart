import 'package:get_it/get_it.dart';

import '../../../../data/datasource/network/db/dio_service.dart';
import '../../../../data/datasource/network/repository/user_repository.dart';
import '../../../mahas/services/logger_service.dart';

Future<void> userRepository(GetIt serviceLocator) async {
  // User repository
  serviceLocator.registerLazySingleton<UserRepository>(() => UserRepository(
        dioService: serviceLocator<DioService>(),
        logger: serviceLocator<LoggerService>(),
      ));
}
