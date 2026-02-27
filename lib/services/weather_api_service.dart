import 'package:dio/dio.dart';

class WeatherApiService {
  final Dio _dio = Dio();

  Future<double> fetchAverageRainfall() async {
    try {
      final response = await _dio.get(
        'https://data.weather.gov.hk/weatherAPI/opendata/hourlyRainfall.php?lang=en',
      );
      final data = response.data;
      if (data != null && data['hourlyRainfall'] != null) {
        final List rainfallList = data['hourlyRainfall'];
        double total = 0;
        int count = 0;
        for (var item in rainfallList) {
          final valueStr = item['value'];
          final value = double.tryParse(valueStr.toString());
          if (value != null) {
            total += value;
            count++;
          }
        }
        if (count > 0) {
          return total / count;
        }
      }
      return 0.0;
    } catch (e) {
      throw Exception('Failed to load rainfall data: $e');
    }
  }
}
