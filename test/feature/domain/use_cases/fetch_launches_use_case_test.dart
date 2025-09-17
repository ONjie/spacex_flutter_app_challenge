import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacex_flutter_app/core/failures/failures.dart';
import 'package:spacex_flutter_app/domain/entities/launch_entity.dart';
import 'package:spacex_flutter_app/domain/repositories/space_x_repository.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_launches_use_case.dart';

class MockSpaceXRepository extends Mock implements SpaceXRepository {}

void main() {
  late FetchLaunchesUseCase fetchLaunchesUseCase;
  late MockSpaceXRepository mockSpaceXRepository;

  setUp(() {
    mockSpaceXRepository = MockSpaceXRepository();
    fetchLaunchesUseCase =
        FetchLaunchesUseCase(spaceXRepository: mockSpaceXRepository);
  });

  final testLaunch = LaunchEntity(
    id: 'id',
    details: 'details',
    launchDateLocal: DateTime.parse('2025-09-15T13:40:44.563985'),
    launchYear: 'launchYear',
    missionName: 'missionName',
    rocketType: 'rocketType',
    rocketName: 'rocketName',
    upcoming: false,
  );

  test("should return a Right([LaunchEntity]) when call is successful", () async {
    //arrange
    when(() => mockSpaceXRepository.fetchLaunches())
        .thenAnswer((_) async => Right([testLaunch]));

    //act
    final results = await fetchLaunchesUseCase.call();

    //assert
    expect(results, isA<Right<Failure, List<LaunchEntity>>>());
    expect(results.right, equals([testLaunch]));
    verify(() => mockSpaceXRepository.fetchLaunches()).called(1);
    verifyNoMoreInteractions(mockSpaceXRepository);
  });
}
