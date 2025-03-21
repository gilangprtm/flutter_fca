import '../../core/base/base_provider.dart';
import '../../data/datasource/network/service/home_service.dart';

class HomeProvider extends BaseProvider {
  final HomeService homeService = HomeService();

  int _count = 0;

  int get count => _count;

  @override
  String get logTag => 'HOME';

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
    //fetchInitialData();
  }

  @override
  void onClose() {
    // Clean up resources when this provider is no longer needed
    // For example, cancel timers, listeners, or subscriptions
    super.onClose();
  }

  void incrementCount() {
    function(() async {
      _count++;
      await fetchInitialData();
    }, operationName: 'incrementCount');
  }

  Future<void> fetchInitialData() async {
    return functionAsync(() async {
      logger.i('Fetching initial data', tag: logTag);
      await homeService.getHomeScreenData();
      logger.i('Initial data fetched successfully', tag: logTag);
      return;
    }, operationName: 'fetchInitialData');
  }
}
