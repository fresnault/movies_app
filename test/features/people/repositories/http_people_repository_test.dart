import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies_app/core/models/paginated_response.dart';
import 'package:movies_app/core/services/http/http_service.dart';
import 'package:movies_app/features/people/models/person.dart';
import 'package:movies_app/features/people/models/person_image.dart';
import 'package:movies_app/features/people/repositories/http_people_repository.dart';

import '../../../test-utils/dummy-data/dummy_configs.dart';
import '../../../test-utils/dummy-data/dummy_people.dart';
import '../../../test-utils/mocks.dart';

void main() {
  final HttpService mockHttpService = MockHttpService();
  final HttpPeopleRepository httpPeopleRepository = HttpPeopleRepository(
    mockHttpService,
  );

  test('fetches paginated popular people', () async {
    int page = 1;
    when(
      () => mockHttpService.get(
        '${httpPeopleRepository.path}/popular',
        queryParameters: {
          'page': page,
          'api_key': '',
        },
      ),
    ).thenAnswer(
      (_) async => {
        'page': page,
        'results': DummyPeople.rawPopularPeople1,
        'total_pages': 1,
        'total_results': 10,
      },
    );

    PaginatedResponse<Person> paginatedPopularPeople =
        await httpPeopleRepository.getPopularPeople(
      page: 1,
      imageConfigs: DummyConfigs.imageConfigs,
    );

    expect(
      paginatedPopularPeople.results,
      equals(DummyPeople.popularPeople1),
    );
  });

  test('fetches person details', () async {
    when(
      () => mockHttpService.get(
        '${httpPeopleRepository.path}/${DummyPeople.person1.id}',
        queryParameters: {
          'api_key': '',
        },
      ),
    ).thenAnswer(
      (_) async => DummyPeople.rawPerson1,
    );

    final Person person = await httpPeopleRepository.getPersonDetails(
      DummyPeople.person1.id!,
      imageConfigs: DummyConfigs.imageConfigs,
    );
    expect(person, equals(DummyPeople.person1));
  });

  test('fetches person images', () async {
    when(
      () => mockHttpService.get(
        '${httpPeopleRepository.path}/${DummyPeople.person1.id}/images',
        queryParameters: {
          'api_key': '',
        },
      ),
    ).thenAnswer(
      (_) async => {
        'profiles': [
          DummyPeople.rawDummyPersonImage1,
          DummyPeople.rawDummyPersonImage2,
        ],
      },
    );

    final List<PersonImage> personImages =
        await httpPeopleRepository.getPersonImages(
      DummyPeople.person1.id!,
      imageConfigs: DummyConfigs.imageConfigs,
    );

    expect(
      personImages,
      equals([
        DummyPeople.dummyPersonImage1,
        DummyPeople.dummyPersonImage2,
      ]),
    );
  });
}
