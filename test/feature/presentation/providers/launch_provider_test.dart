import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacex_flutter_app/core/failures/failures.dart';
import 'package:spacex_flutter_app/domain/entities/launch_entity.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_launch_by_id_use_case.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_launches_by_pagination_use_case.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_launches_use_case.dart';
import 'package:spacex_flutter_app/presentation/providers/launch_provider.dart';

class MockFetchLaunchesUseCase extends Mock implements FetchLaunchesUseCase {}

class MockFetchLaunchByIdUseCase extends Mock
    implements FetchLaunchByIdUseCase {}

class MockFetchLaunchesByPaginationUseCase extends Mock
    implements FetchLaunchesByPaginationUseCase {}

void main() {
  late LaunchProvider launchProvider;
  late MockFetchLaunchesUseCase mockFetchLaunchesUseCase;
  late MockFetchLaunchByIdUseCase mockFetchLaunchByIdUseCase;
  late MockFetchLaunchesByPaginationUseCase
      mockFetchLaunchesByPaginationUseCase;

  setUp(() {
    mockFetchLaunchesUseCase = MockFetchLaunchesUseCase();
    mockFetchLaunchByIdUseCase = MockFetchLaunchByIdUseCase();
    mockFetchLaunchesByPaginationUseCase =
        MockFetchLaunchesByPaginationUseCase();
    launchProvider = LaunchProvider(
        fetchLaunchesUseCase: mockFetchLaunchesUseCase,
        fetchLaunchByIdUseCase: mockFetchLaunchByIdUseCase,
        fetchLaunchesByPaginationUseCase: mockFetchLaunchesByPaginationUseCase);
  });

  final testLaunchA = LaunchEntity(
    id: 'id',
    details: 'details',
    launchDateLocal: DateTime.parse('2025-09-15T13:40:44.563985'),
    missionName: 'missionName',
    rocketName: 'rocketName',
    upcoming: false,
  );

  test('initial state should be empty and not loading', () async {
    //assert
    expect(launchProvider.launches, isEmpty);
    expect(launchProvider.launch, LaunchEntity.dummyLaunch);
    expect(launchProvider.isLoading, isFalse);
    expect(launchProvider.error, isNull);
    expect(launchProvider.hasMore, isTrue);
    expect(launchProvider.isFetchingMore, isFalse);
  });

  group('fetchLaunches', () {
    test(
        'should return an error message when call is unsuccessful',
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

    test('should return [LaunchEntity] when call is successful',
        () async {
      //arrange
      when(() => mockFetchLaunchesUseCase.call())
          .thenAnswer((_) async => Right([testLaunchA]));

      //act
      await launchProvider.fetchLaunches();

      //assert
      expect(launchProvider.launches, equals([testLaunchA]));
      expect(launchProvider.isLoading, isFalse);
      expect(launchProvider.error, isNull);
      verify(() => mockFetchLaunchesUseCase.call()).called(1);
      verifyNoMoreInteractions(mockFetchLaunchesUseCase);
    });
  });

  group('fetchLaunchById', () {
    test('should return an error message when call is unsuccessful', () async {
      //arrange
      when(() => mockFetchLaunchByIdUseCase.call(id: any(named: 'id')))
          .thenAnswer((_) async =>
              const Left(GraphQLFailure(message: 'GraphQL error')));

      //act
      await launchProvider.fetchLaunchById(id: 'id');

      //assert
      expect(launchProvider.launch, LaunchEntity.dummyLaunch);
      expect(launchProvider.isLoading, isFalse);
      expect(launchProvider.error, equals('GraphQL error'));
      verify(() => mockFetchLaunchByIdUseCase.call(id: any(named: 'id')))
          .called(1);
      verifyNoMoreInteractions(mockFetchLaunchByIdUseCase);
    });

    test('should return a LaunchEntity  when call is successful', () async {
      //arrange
      when(() => mockFetchLaunchByIdUseCase.call(id: any(named: 'id')))
          .thenAnswer((_) async => Right(testLaunchA));

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
  });

  group('fetchLaunchesByPagination', () {
    test(
        'should return an error message when call is unsuccessful',
        () async {
      //arrange
      when(() => mockFetchLaunchesByPaginationUseCase.call(
                offset: any<int>(named: 'offset'),
                limit: any<int>(named: 'limit'),
              ))
          .thenAnswer((_) async =>
              const Left(GraphQLFailure(message: 'GraphQL error')));

      //act
      await launchProvider.fetchLaunchesByPagination();

      //assert
      expect(launchProvider.launches.length, 0);
      expect(launchProvider.hasMore, isTrue);
      expect(launchProvider.error, equals('GraphQL error'));
      verify(() => mockFetchLaunchesByPaginationUseCase.call(
            offset: any<int>(named: 'offset'),
            limit: any<int>(named: 'limit'),
          )).called(1);
      verifyNoMoreInteractions(mockFetchLaunchesByPaginationUseCase);
    });

    test(
        'should return [LaunchEntity] when call is successful',
        () async {
      //arrange
      when(() => mockFetchLaunchesByPaginationUseCase.call(
            offset: any<int>(named: 'offset'),
            limit: any<int>(named: 'limit'),
          )).thenAnswer((_) async => Right([testLaunchA]));

      //act
      await launchProvider.fetchLaunchesByPagination();

      //assert
      expect(launchProvider.paginatedLaunches, equals([testLaunchA]));
      expect(launchProvider.hasMore, isTrue);
      expect(launchProvider.error, isNull);
      verify(() => mockFetchLaunchesByPaginationUseCase.call(
            offset: any<int>(named: 'offset'),
            limit: any<int>(named: 'limit'),
          )).called(1);
      verifyNoMoreInteractions(mockFetchLaunchesUseCase);
    });
  });

  group('refreshLaunches', () {
    test('should reset paginated launches and refetch', () async {
      when(() => mockFetchLaunchesByPaginationUseCase.call(
            offset: any<int>(named: 'offset'),
            limit: any<int>(named: 'limit'),
          )).thenAnswer((_) async => Right([testLaunchA]));

      await launchProvider.refreshLaunches();

      expect(launchProvider.paginatedLaunches, contains(testLaunchA));
      expect(launchProvider.offset, greaterThan(0));
      expect(launchProvider.hasMore, isTrue);
      verify(() => mockFetchLaunchesByPaginationUseCase.call(
            offset: any<int>(named: 'offset'),
            limit: any<int>(named: 'limit'),
          )).called(1);
      verifyNoMoreInteractions(mockFetchLaunchesByPaginationUseCase);
    });
  });

}
