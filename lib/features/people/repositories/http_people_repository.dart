import 'package:movies_app/core/configs/configs.dart';
import 'package:movies_app/core/models/paginated_response.dart';
import 'package:movies_app/core/services/http/http_service.dart';
import 'package:movies_app/features/people/models/person.dart';
import 'package:movies_app/features/people/repositories/people_repository.dart';

class HttpPeopleRepository implements PeopleRepository {
  final HttpService httpService;

  HttpPeopleRepository(this.httpService);

  @override
  String get path => '/person';

  @override
  String get apiKey => Configs.tmdbAPIKey;

  @override
  Future<PaginatedResponse<Person>> getPopularPeople({
    int page = 1,
    bool forceRefresh = false,
  }) async {
    final responseData = await httpService.get(
      '$path/popular',
      forceRefresh: forceRefresh,
      queryParameters: {
        'page': page,
        'api_key': apiKey,
      },
    );

    return PaginatedResponse<Person>(
      page: page,
      results: List<Person>.from(
          responseData['results'].map((x) => Person.fromJson(x))),
      totalPages: responseData['total_pages'],
      totalResults: responseData['total_results'],
    );
  }

  @override
  Future<Person> getPersonDetails(
    int personId, {
    bool forceRefresh = false,
  }) async {
    final responseData = await httpService.get(
      '$path/$personId',
      forceRefresh: forceRefresh,
      queryParameters: {
        'api_key': apiKey,
      },
    );

    return Person.fromJson(responseData);
  }
}