import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacex_flutter_app/core/failures/failures.dart';
import 'package:spacex_flutter_app/domain/entities/rocket_entity.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_rocket_by_id_use_case.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_rockets_use_case.dart';
import 'package:spacex_flutter_app/presentation/providers/rocket_provider.dart';

class MockFetchRocketsUseCase extends Mock implements FetchRocketsUseCase {}

class MockFetchRocketByIdUseCase extends Mock
    implements FetchRocketByIdUseCase {}

void main() {
  late RocketProvider rocketProvider;
  late MockFetchRocketsUseCase mockFetchRocketsUseCase;
  late MockFetchRocketByIdUseCase mockFetchRocketByIdUseCase;

  setUp(() {
    mockFetchRocketsUseCase = MockFetchRocketsUseCase();
    mockFetchRocketByIdUseCase = MockFetchRocketByIdUseCase();
    rocketProvider = RocketProvider(
      fetchRocketsUseCase: mockFetchRocketsUseCase,
      fetchRocketByIdUseCase: mockFetchRocketByIdUseCase,
    );
  });

  final testRocketA = RocketEntity(
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
    numberOfEngines: 1,
  );

  final testRocketB = RocketEntity(
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
    numberOfEngines: 1,
  );

  group('RocketProvider', () {
    test('initial state should be empty and not loading', () async {
      //assert
      expect(rocketProvider.rockets, isEmpty);
      expect(rocketProvider.rocket, RocketEntity.rocketDummy);
      expect(rocketProvider.isLoading, isFalse);
      expect(rocketProvider.error, isNull);
    });

    test(
        'fetchRockets should return an error message when call is unsuccessful',
        () async {
      //arrange
      when(() => mockFetchRocketsUseCase.call()).thenAnswer(
          (_) async => const Left(GraphQLFailure(message: 'GraphQL error')));

      //act
      await rocketProvider.fetchRockets();

      //assert
      expect(rocketProvider.rockets, isEmpty);
      expect(rocketProvider.isLoading, isFalse);
      expect(rocketProvider.error, equals('GraphQL error'));
      verify(() => mockFetchRocketsUseCase.call()).called(1);
      verifyNoMoreInteractions(mockFetchRocketsUseCase);
    });

    test('fetchRockets should return [RocketEntity] when call is successful',
        () async {
      //arrange
      when(() => mockFetchRocketsUseCase.call())
          .thenAnswer((_) async => Right([testRocketA]));

      //act
      await rocketProvider.fetchRockets();

      //assert
      expect(rocketProvider.rockets, equals([testRocketA]));
      expect(rocketProvider.isLoading, isFalse);
      expect(rocketProvider.error, isNull);
      verify(() => mockFetchRocketsUseCase.call()).called(1);
      verifyNoMoreInteractions(mockFetchRocketsUseCase);
    });

    test(
        'fetchRocketById should return an error message when call is unsuccessful',
        () async {
      //arrange
      when(() => mockFetchRocketByIdUseCase.call(id: any(named: 'id')))
          .thenAnswer((_) async =>
              const Left(GraphQLFailure(message: 'GraphQL error')));

      //act
      await rocketProvider.fetchRocketById(id: 'id');

      //assert
      expect(rocketProvider.rocket, RocketEntity.rocketDummy);
      expect(rocketProvider.isLoading, isFalse);
      expect(rocketProvider.error, equals('GraphQL error'));
      verify(() => mockFetchRocketByIdUseCase.call(id: any(named: 'id')))
          .called(1);
      verifyNoMoreInteractions(mockFetchRocketByIdUseCase);
    });

    test(
        'fetchRocketById should return a RocketEntity  when call is successful',
        () async {
      //arrange
      when(() => mockFetchRocketByIdUseCase.call(id: any(named: 'id')))
          .thenAnswer((_) async => Right(testRocketA));

      //act
      await rocketProvider.fetchRocketById(id: 'id');

      //assert
      expect(rocketProvider.rocket, equals(testRocketA));
      expect(rocketProvider.isLoading, isFalse);
      expect(rocketProvider.error, isNull);
      verify(() => mockFetchRocketByIdUseCase.call(id: any(named: 'id')))
          .called(1);
      verifyNoMoreInteractions(mockFetchRocketsUseCase);
    });

    test('clearError should reset error', () async {
      //act
      rocketProvider.clearError();

      //assert
      expect(rocketProvider.error, isNull);
    });

    test('refreshRockets should reset state and fetch rockets', () async {
      //arrange
      when(() => mockFetchRocketsUseCase.call())
          .thenAnswer((_) async => Right([testRocketA]));

      await rocketProvider.fetchRockets();
      expect(rocketProvider.rockets, equals([testRocketA]));

      when(() => mockFetchRocketsUseCase.call())
          .thenAnswer((_) async => Right([testRocketB]));

      //act
      rocketProvider.refreshRockets();

      //provider should now contain rocketB (refetched)
      //assert

      expect(rocketProvider.rockets, equals([testRocketB]));
      expect(rocketProvider.isLoading, isTrue);
      expect(rocketProvider.error, isNull);

      verify(() => mockFetchRocketsUseCase.call()).called(2);
      verifyNoMoreInteractions(mockFetchRocketsUseCase);
    });
  });
}
