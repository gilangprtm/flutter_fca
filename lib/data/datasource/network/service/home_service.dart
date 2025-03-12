import '../db/dio_service.dart';

class HomeService {
  final DioService _dioService = DioService();
  Future<void> getData() async {
    try {
      await _dioService.get('/users/2');
    } catch (e) {
      //print(e);
    }
  }
}
