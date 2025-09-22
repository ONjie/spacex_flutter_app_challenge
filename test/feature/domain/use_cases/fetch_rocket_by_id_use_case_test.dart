import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacex_flutter_app/core/failures/failures.dart';
import 'package:spacex_flutter_app/domain/entities/rocket_entity.dart';
import 'package:spacex_flutter_app/domain/repositories/space_x_repository.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_rocket_by_id_use_case.dart';

class MockSpaceXRepository extends Mock implements SpaceXRepository {}

void main() {
  late FetchRocketByIdUseCase fetchRocketByIdUseCase;
  late MockSpaceXRepository mockSpacXRepository;

  setUp(() {
    mockSpacXRepository = MockSpaceXRepository();
    fetchRocketByIdUseCase =
        FetchRocketByIdUseCase(spaceXRepository: mockSpacXRepository);
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

  test("should return a Right(RocketEntity) when call is successful", () async {
    //arrange
    when(() => mockSpacXRepository.fetchRocketById(id: any(named: 'id')))
        .thenAnswer((_) async => (Right(testRocket)));

    //act
    final result = await fetchRocketByIdUseCase.call(id: testRocket.id);

    //assert
    expect(result, isA<Right<Failure, RocketEntity>>());
    expect(result.right, equals(testRocket));
    verify(() => mockSpacXRepository.fetchRocketById(id: any(named: 'id')))
        .called(1);
    verifyNoMoreInteractions(mockSpacXRepository);
  });
}
