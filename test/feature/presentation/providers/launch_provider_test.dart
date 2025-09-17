import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacex_flutter_app/core/failures/failures.dart';
import 'package:spacex_flutter_app/domain/entities/launch_entity.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_launch_by_id_use_case.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_launches_use_case.dart';
import 'package:spacex_flutter_app/presentation/providers/launch_provider.dart';


class MockFetchLaunchesUseCase extends Mock implements FetchLaunchesUseCase {}

class MockFetchLaunchByIdUseCase extends Mock
    implements FetchLaunchByIdUseCase {}

void main() {
  late LaunchProvider launchProvider;
  late MockFetchLaunchesUseCase mockFetchLaunchesUseCase;
  late MockFetchLaunchByIdUseCase mockFetchLaunchByIdUseCase;

  setUp(() {
    mockFetchLaunchesUseCase = MockFetchLaunchesUseCase();
    mockFetchLaunchByIdUseCase = MockFetchLaunchByIdUseCase();
    launchProvider = LaunchProvider(
      fetchLaunchesUseCase: mockFetchLaunchesUseCase,
      fetchLaunchByIdUseCase: mockFetchLaunchByIdUseCase,
    );
  });

  final testLaunchA = LaunchEntity(
    id: 'id',
    details: 'details',
    launchDateLocal: DateTime.parse('2025-09-15T13:40:44.563985'),
    launchYear: 'launchYear',
    missionName: 'missionName',
    rocketType: 'rocketType',
    rocketName: 'rocketName',
    upcoming: false,
  );
  final testLaunchB = LaunchEntity(
    id: 'id',
    details: 'details',
    launchDateLocal: DateTime.parse('2025-09-15T13:40:44.563985'),
    launchYear: 'launchYear',
    missionName: 'missionName',
    rocketType: 'rocketType',
    rocketName: 'rocketName',
    upcoming: false,
  );


  group('LaunchProvider', () {
    test('initial state should be empty and not loading', () async {
      //assert
      expect(launchProvider.launches, isEmpty);
      expect(launchProvider.launch, isNull);
      expect(launchProvider.isLoading, isFalse);
      expect(launchProvider.error, isNull);
    });

    test(
        'fetchLaunches should return an error message when call is unsuccessful',
        () async {
      //arrange
      when(() => mockFetchLaunchesUseCase.call()).thenAnswer(
          (_) async => const Left(GraphQLFailure(message: 'GraphQL error')));

      //act
      await launchProvider.fetchLaunches();

      //assert
      expect(launchProvider.launches, isEmpty);
      expect(launchProvider.isLoading, isFalse);
      expect(launchProvider.error, equals('GraphQL error'));
      verify(() => mockFetchLaunchesUseCase.call()).called(1);
      verifyNoMoreInteractions(mockFetchLaunchesUseCase);
    });

    test('fetchLaunches should return [LaunchEntity] when call is successful',
        () async {
      //arrange
      when(() => mockFetchLaunchesUseCase.call())
          .thenAnswer((_) async =>  Right([testLaunchA]));

      //act
      await launchProvider.fetchLaunches();

      //assert
      expect(launchProvider.launches, equals([testLaunchA]));
      expect(launchProvider.isLoading, isFalse);
      expect(launchProvider.error, isNull);
      verify(() => mockFetchLaunchesUseCase.call()).called(1);
      verifyNoMoreInteractions(mockFetchLaunchesUseCase);
    });

    test(
        'fetchLaunchById should return an error message when call is unsuccessful',
        () async {
      //arrange
      when(() => mockFetchLaunchByIdUseCase.call(id: any(named: 'id')))
          .thenAnswer((_) async =>
              const Left(GraphQLFailure(message: 'GraphQL error')));

      //act
      await launchProvider.fetchLaunchById(id: 'id');

      //assert
      expect(launchProvider.launch, isNull);
      expect(launchProvider.isLoading, isFalse);
      expect(launchProvider.error, equals('GraphQL error'));
      verify(() => mockFetchLaunchByIdUseCase.call(id: any(named: 'id')))
          .called(1);
      verifyNoMoreInteractions(mockFetchLaunchByIdUseCase);
    });

    test(
        'fetchLaunchById should return a LaunchEntity  when call is successful',
        () async {
      //arrange
      when(() => mockFetchLaunchByIdUseCase.call(id: any(named: 'id')))
          .thenAnswer((_) async =>  Right(testLaunchA));

      //act
      await launchProvider.fetchLaunchById(id: 'id');

      //assert
      expect(launchProvider.launch, equals(testLaunchA));
      expect(launchProvider.isLoading, isFalse);
      expect(launchProvider.error, isNull);
      verify(() => mockFetchLaunchByIdUseCase.call(id: any(named: 'id')))
          .called(1);
      verifyNoMoreInteractions(mockFetchLaunchByIdUseCase);
    });

    test('clearError should reset error', () async {
      //act
      launchProvider.clearError();

      //assert
      expect(launchProvider.error, isNull);
    });

    test('refreshLaunches should reset state and fetch launches', () async {
      //arrange
      when(() => mockFetchLaunchesUseCase.call())
          .thenAnswer((_) async =>  Right([testLaunchA]));

      await launchProvider.fetchLaunches();
      expect(launchProvider.launches, equals([testLaunchA]));

      when(() => mockFetchLaunchesUseCase.call())
          .thenAnswer((_) async => Right([testLaunchB]));

      //act
      launchProvider.refreshLaunches();

      //provider should now contain rocketB (refetched)
      //assert

      expect(launchProvider.launches, equals([testLaunchB]));
      expect(launchProvider.isLoading, isTrue);
      expect(launchProvider.error, isNull);

      verify(() => mockFetchLaunchesUseCase.call()).called(2);
      verifyNoMoreInteractions(mockFetchLaunchesUseCase);
    });
  });
}
