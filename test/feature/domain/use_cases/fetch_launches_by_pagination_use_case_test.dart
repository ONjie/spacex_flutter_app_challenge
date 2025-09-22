import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacex_flutter_app/core/failures/failures.dart';
import 'package:spacex_flutter_app/domain/entities/launch_entity.dart';
import 'package:spacex_flutter_app/domain/repositories/space_x_repository.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_launches_by_pagination_use_case.dart';

class MockSpaceXRepository extends Mock implements SpaceXRepository {}

void main() {
  late FetchLaunchesByPaginationUseCase fetchLaunchesByPaginationUseCase;
  late MockSpaceXRepository mockSpaceXRepository;

  setUp(() {
    mockSpaceXRepository = MockSpaceXRepository();
    fetchLaunchesByPaginationUseCase = FetchLaunchesByPaginationUseCase(
        spaceXRepository: mockSpaceXRepository);
  });

  final testLaunch = LaunchEntity(
    id: 'id',
    details: 'details',
    launchDateLocal: DateTime.parse('2025-09-15T13:40:44.563985'),
    missionName: 'missionName',
    rocketName: 'rocketName',
    upcoming: false,
  );

  const testOffset = 0;
  const testLimit = 0;

  test("should return a Right([LaunchEntity]) when call is successful",
      () async {
    //arrange
    when(() => mockSpaceXRepository.fetchLaunchesByPagination(
          offset: testOffset,
          limit: testLimit,
        )).thenAnswer((_) async => Right([testLaunch]));

    //act
    final results = await fetchLaunchesByPaginationUseCase.call(
      offset: testOffset,
      limit: testLimit,
    );

    //assert
    expect(results, isA<Right<Failure, List<LaunchEntity>>>());
    expect(results.right, equals([testLaunch]));
    verify(() => mockSpaceXRepository.fetchLaunchesByPagination(
          offset: testOffset,
          limit: testLimit,
        )).called(1);
    verifyNoMoreInteractions(mockSpaceXRepository);
  });
}
