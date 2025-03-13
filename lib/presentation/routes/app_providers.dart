import '../providers/informasi_absensi_provider.dart';
import '../providers/home_provider.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../core/di/service_locator.dart';
import '../../core/mahas/services/logger_service.dart';
import '../../core/mahas/services/error_handler_service.dart';

class AppProviders {
  static List<SingleChildWidget> getProviders() {
    return [
      ChangeNotifierProvider(
        create: (_) => HomeProvider(
          homeService: serviceLocator(),
          logger: serviceLocator<LoggerService>(),
          errorHandler: serviceLocator<ErrorHandlerService>(),
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => InformasiAbsensiProvider(
          informasiAbsensiService: serviceLocator(),
        ),
      ),
    ];
  }
}
