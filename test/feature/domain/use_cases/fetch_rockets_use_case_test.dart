import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacex_flutter_app/core/failures/failures.dart';
import 'package:spacex_flutter_app/domain/entities/rocket_entity.dart';
import 'package:spacex_flutter_app/domain/repositories/space_x_repository.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_rockets_use_case.dart';

class MockSpaceXRepository extends Mock implements SpaceXRepository {}

void main() {
  late FetchRocketsUseCase fetchRocketsUseCase;
  late MockSpaceXRepository mockSpaceXRepository;

  setUp(() {
    mockSpaceXRepository = MockSpaceXRepository();
    fetchRocketsUseCase =
        FetchRocketsUseCase(spaceXRepository: mockSpaceXRepository);
  });

  final testRocket = RocketEntity(
    id: 'id',
    active: false,
    boosters: 1,
    costPerLaunch: 100,
    description: 'description',
    diameterInFeet: 1.0,
    diameterInMeters: 1.0,
    firstFlight: DateTime.parse('2025-09-15T13:40:44.563985'),
    heightInFeet: 1.0,
    heightInMeters: 1,
    massInKg: 10,
    massInLb: 12,
    name: 'name',
    stages: 1,
    successRate: 100,
    type: 'type',
    numberOfEngines: 1
  );

  test("should return a Right([RocketEntity]) when call is successful", () async {
    //arrange
    when(() => mockSpaceXRepository.fetchRockets())
        .thenAnswer((_) async => Right([testRocket]));

    //act
    final results = await fetchRocketsUseCase.call();

    //assert
    expect(results, isA<Right<Failure, List<RocketEntity>>>());
    expect(results.right, equals([testRocket]));
    verify(() => mockSpaceXRepository.fetchRockets()).called(1);
    verifyNoMoreInteractions(mockSpaceXRepository);
  });
}
