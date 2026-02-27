import 'package:dio/dio.dart';
import '../features/random_plant_entity.dart';
import '../features/plant_details_entity.dart';
import '../features/pest_disease_entity.dart';
import 'dio_client.dart';
import 'exceptions.dart';

class PlantApiService {
  final DioClient _dioClient;

  PlantApiService({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

  Future<List<RandomPlantEntity>> fetchSpeciesList({String? query}) async {
    try {
      final Map<String, dynamic>? queryParameters =
          (query != null && query.isNotEmpty) ? {'q': query} : null;
      final response = await _dioClient.dio.get(
        'species-list',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        // Parse the 'data' array from the JSON response into a list of entities
        final List<dynamic> rawData = response.data['data'] ?? [];
        return rawData
            .map(
              (json) =>
                  RandomPlantEntity.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw ServerException(
          response.statusMessage ?? 'Failed to load species list.',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(
          e.response?.statusMessage ?? 'Server returned an error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('Failed to connect to the server: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<PlantDetailsEntity> fetchSpeciesDetails(int id) async {
    try {
      final response = await _dioClient.dio.get('species/details/$id');

      if (response.statusCode == 200) {
        return PlantDetailsEntity.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          response.statusMessage ?? 'Failed to load species details.',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(
          e.response?.statusMessage ?? 'Server returned an error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('Failed to connect to the server: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<List<PestDiseaseEntity>> fetchPestDiseaseList({
    int? id,
    int? page,
    String? query,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {};
      if (id != null) queryParameters['id'] = id;
      if (page != null) queryParameters['page'] = page;
      if (query != null && query.isNotEmpty) queryParameters['q'] = query;

      // Note: Endpoint lives at root /api/ but DioClient defaults to /api/v2/
      // So we prefix with full domain to override the base URL if needed, 
      // but actually it's fine if we just pass the full URL string to get().
      final requestUrl = 'https://perenual.com/api/pest-disease-list';

      final response = await _dioClient.dio.get(
        requestUrl,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final List<dynamic> rawData = response.data['data'] ?? [];
        return rawData
            .map(
              (json) => PestDiseaseEntity.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw ServerException(
          response.statusMessage ?? 'Failed to load pest/disease list.',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(
          e.response?.statusMessage ?? 'Server returned an error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('Failed to connect to the server: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
