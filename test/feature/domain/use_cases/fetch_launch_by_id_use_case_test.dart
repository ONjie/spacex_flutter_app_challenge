import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacex_flutter_app/core/failures/failures.dart';
import 'package:spacex_flutter_app/domain/entities/launch_entity.dart';
import 'package:spacex_flutter_app/domain/repositories/space_x_repository.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_launch_by_id_use_case.dart';

class MockSpaceXRepository extends Mock implements SpaceXRepository {}

void main() {
  late FetchLaunchByIdUseCase fetchLaunchByIdUseCase;
  late MockSpaceXRepository mockSpaceXRepository;

  setUp(() {
    mockSpaceXRepository = MockSpaceXRepository();
    fetchLaunchByIdUseCase =
        FetchLaunchByIdUseCase(spaceXRepository: mockSpaceXRepository);
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

  test("should return a Right(LaunchEntity) when call is successful", () async {
    //arrange
    when(() => mockSpaceXRepository.fetchLaunchById(id: any(named: 'id')))
        .thenAnswer((_) async => Right(testLaunch));

    //act
    final result = await fetchLaunchByIdUseCase.call(id: testLaunch.id);

    //assert
    expect(result, isA<Right<Failure, LaunchEntity>>());
    expect(result.right, equals(testLaunch));
    verify(() => mockSpaceXRepository.fetchLaunchById(id: any(named: 'id')))
        .called(1);
    verifyNoMoreInteractions(mockSpaceXRepository);
  });
}
