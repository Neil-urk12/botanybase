import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlantApiService {
  final Dio _dio;

  PlantApiService({Dio? dio}) : _dio = dio ?? Dio();

  Future<void> fetchSpeciesList() async {
    final String apiKey = dotenv.env['API_KEY'] ?? '';
    const String url = 'https://perenual.com/api/v2/species-list';

    try {
      final response = await _dio.get(url, queryParameters: {'key': apiKey});

      if (response.statusCode == 200) {
        print(response.data); // data contains the parsed JSON map or string
      } else {
        print(response.statusMessage);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(
          'Error response: ${e.response?.statusCode} - ${e.response?.statusMessage}',
        );
      } else {
        print('Error request: ${e.message}');
      }
    } catch (e) {
      print('Unexpected error: $e');
    }
  }
}
