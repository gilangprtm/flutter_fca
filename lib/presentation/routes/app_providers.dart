import '../providers/informasi_absensi_provider.dart';
import '../providers/home_provider.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  static List<SingleChildWidget> getProviders() {
    return [
      ChangeNotifierProvider(
        create: (_) => HomeProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => InformasiAbsensiProvider(),
      ),
    ];
  }
}
