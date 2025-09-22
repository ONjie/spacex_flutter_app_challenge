import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacex_flutter_app/core/exceptions/exceptions.dart';
import 'package:spacex_flutter_app/core/failures/failures.dart';
import 'package:spacex_flutter_app/core/network/graphql_client.dart';
import 'package:spacex_flutter_app/core/network/network_info.dart';
import 'package:spacex_flutter_app/core/utils/infos/infos.dart';
import 'package:spacex_flutter_app/data/models/capsule_model.dart';
import 'package:spacex_flutter_app/data/models/launch_model.dart';
import 'package:spacex_flutter_app/data/models/rocket_model.dart';
import 'package:spacex_flutter_app/data/queries/capsule_queries.dart';
import 'package:spacex_flutter_app/data/queries/launch_queries.dart';
import 'package:spacex_flutter_app/data/queries/rocket_queries.dart';
import 'package:spacex_flutter_app/data/repositories/space_x_repository_impl.dart';
import 'package:spacex_flutter_app/domain/entities/capsule_entity.dart';
import 'package:spacex_flutter_app/domain/entities/launch_entity.dart';
import 'package:spacex_flutter_app/domain/entities/rocket_entity.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockGraphQLService extends Mock implements GraphQLService {}

class MockQueryResult extends Mock implements QueryResult {}

void main() {
  late SpaceXRepositoryImpl repositoryImpl;
  late MockNetworkInfo mockNetworkInfo;
  late MockGraphQLService mockGraphQLService;
  late MockQueryResult mockQueryResult;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockGraphQLService = MockGraphQLService();
    repositoryImpl = SpaceXRepositoryImpl(
      networkInfo: mockNetworkInfo,
      graphQLService: mockGraphQLService,
    );
    mockQueryResult = MockQueryResult();
  });

  const testCapsuleModel = CapsuleModel(
    id: 'id',
    reuseCount: 1,
    status: 'status',
    type: 'type',
  );

  final testLaunchModel = LaunchModel(
    id: 'id',
    details: 'details',
    launchDateLocal: DateTime.parse('2025-09-15T13:40:44.563985'),
    missionName: 'missionName',
    rocketName: 'rocketName',
    upcoming: false,
  );

  const testOffset = 0;
  const testLimit = 1;

  final testRocketModel = RocketModel(
    id: 'id',
    active: false,
    boosters: 1,
    costPerLaunch: 100,
    description: 'description',
    diameterInFeet: 2.0,
    diameterInMeters: 1.0,
    firstFlight: DateTime.parse('2025-09-15T13:40:44.563985'),
    heightInFeet: 11.0,
    heightInMeters: 10.0,
    massInKg: 20,
    massInLb: 30,
    name: 'name',
    stages: 1,
    successRate: 100,
    type: 'type',
    numberOfEngines: 1,
  );

  void runOnlineTests(Function body) {
    group('when device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runOfflineTests(Function body) {
    group('when device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('fetchCapsuleById', () {
    test('Checks if the device is online', () async {
      //arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      //act
      await repositoryImpl.fetchCapsuleById(id: 'id');

      //assert
      verify(() => mockNetworkInfo.isConnected).called(1);
    });

    runOfflineTests(() {
      test(
          'Should return Left(InternetConnectionFailure) when device is offline',
          () async {
        //act
        final result = await repositoryImpl.fetchCapsuleById(id: 'id');

        //assert
        expect(result, isA<Left<Failure, CapsuleEntity>>());
        expect(
            result.left,
            equals(const InternetConnectionFailure(
                message: noInternetConnectionMessage)));
        verify(() => mockNetworkInfo.isConnected).called(1);
      });
    });

    runOnlineTests(() {
      test('should return Left(DataNotFoundFailure) when data is null',
          () async {
        //arrange
        when(() => mockGraphQLService.executeQuery(getCapsuleByIdQuery,
            variables: {'id': 'id'})).thenAnswer((_) async => mockQueryResult);
        when(() => mockQueryResult.data).thenReturn({'capsule': null});

        //act
        final result = await repositoryImpl.fetchCapsuleById(id: 'id');

        //assert
        expect(result, isA<Left<Failure, CapsuleEntity>>());
        expect(
          result.left,
          equals(const DataNotFoundFailure(message: "Capsule not found")),
        );
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(getCapsuleByIdQuery,
            variables: {'id': 'id'})).called(1);
        verify(() => mockQueryResult.data).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
        verifyNoMoreInteractions(mockQueryResult);
      });
      test('should return Right(CapsuleEntity) when data is not null',
          () async {
        //arrange
        when(() => mockGraphQLService.executeQuery(getCapsuleByIdQuery,
            variables: {'id': 'id'})).thenAnswer((_) async => mockQueryResult);
        when(() => mockQueryResult.data)
            .thenReturn({'capsule': testCapsuleModel.toJson()});

        //act
        final result = await repositoryImpl.fetchCapsuleById(id: 'id');

        //assert
        expect(result, isA<Right<Failure, CapsuleEntity>>());
        expect(result.right, equals(testCapsuleModel.toEntity()));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(getCapsuleByIdQuery,
            variables: {'id': 'id'})).called(1);
        verify(() => mockQueryResult.data).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
        verifyNoMoreInteractions(mockQueryResult);
      });

      test('should return Left(GraphQLFailure) when GraphQLException is thrown',
          () async {
        //arrange
        when(() => mockGraphQLService
                .executeQuery(getCapsuleByIdQuery, variables: {'id': 'id'}))
            .thenThrow(GraphQLException(message: 'GraphQL error occurred'));

        //act
        final result = await repositoryImpl.fetchCapsuleById(id: 'id');

        //assert
        expect(result, isA<Left<Failure, CapsuleEntity>>());
        expect(result.left,
            equals(const GraphQLFailure(message: 'GraphQL error occurred')));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(getCapsuleByIdQuery,
            variables: {'id': 'id'})).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
      });
    });
  });

  group('fetchCapsules', () {
    test('Checks if the device is online', () async {
      //arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      //act
      await repositoryImpl.fetchCapsules();

      //assert
      verify(() => mockNetworkInfo.isConnected).called(1);
    });

    runOfflineTests(() {
      test(
          'Should return Left(InternetConnectionFailure) when device is offline',
          () async {
        //act
        final result = await repositoryImpl.fetchCapsules();

        //assert
        expect(result, isA<Left<Failure, List<CapsuleEntity>>>());
        expect(
            result.left,
            equals(const InternetConnectionFailure(
                message: noInternetConnectionMessage)));
        verify(() => mockNetworkInfo.isConnected).called(1);
      });
    });

    runOnlineTests(() {
      test('should return Left(DataNotFoundFailure) when data is empty',
          () async {
        //arrange
        when(() => mockGraphQLService.executeQuery(getCapsulesQuery))
            .thenAnswer((_) async => mockQueryResult);
        when(() => mockQueryResult.data).thenReturn({'capsules': []});

        //act
        final result = await repositoryImpl.fetchCapsules();

        //assert
        expect(result, isA<Left<Failure, List<CapsuleEntity>>>());
        expect(
          result.left,
          equals(const DataNotFoundFailure(message: "Capsules not found")),
        );
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(getCapsulesQuery))
            .called(1);
        verify(() => mockQueryResult.data).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
        verifyNoMoreInteractions(mockQueryResult);
      });
      test('should return Right([CapsuleEntity]) when data is not empty',
          () async {
        //arrange
        when(() => mockGraphQLService.executeQuery(getCapsulesQuery))
            .thenAnswer((_) async => mockQueryResult);
        when(() => mockQueryResult.data).thenReturn({
          'capsules': [testCapsuleModel.toJson()]
        });

        //act
        final result = await repositoryImpl.fetchCapsules();

        //assert
        expect(result, isA<Right<Failure, List<CapsuleEntity>>>());
        expect(result.right, equals([testCapsuleModel.toEntity()]));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(getCapsulesQuery))
            .called(1);
        verify(() => mockQueryResult.data).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
        verifyNoMoreInteractions(mockQueryResult);
      });

      test('should return Left(GraphQLFailure) when GraphQLException is thrown',
          () async {
        //arrange
        when(() => mockGraphQLService.executeQuery(getCapsulesQuery))
            .thenThrow(GraphQLException(message: 'GraphQL error occurred'));

        //act
        final result = await repositoryImpl.fetchCapsules();

        //assert
        expect(result, isA<Left<Failure, List<CapsuleEntity>>>());
        expect(result.left,
            equals(const GraphQLFailure(message: 'GraphQL error occurred')));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(getCapsulesQuery))
            .called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
      });
    });
  });

  group('fetchLaunchById', () {
    test('Checks if the device is online', () async {
      //arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      //act
      await repositoryImpl.fetchLaunchById(id: 'id');

      //assert
      verify(() => mockNetworkInfo.isConnected).called(1);
    });

    runOfflineTests(() {
      test(
          'Should return Left(InternetConnectionFailure) when device is offline',
          () async {
        //act
        final result = await repositoryImpl.fetchLaunchById(id: 'id');

        //assert
        expect(result, isA<Left<Failure, LaunchEntity>>());
        expect(
            result.left,
            equals(const InternetConnectionFailure(
                message: noInternetConnectionMessage)));
        verify(() => mockNetworkInfo.isConnected).called(1);
      });
    });

    runOnlineTests(() {
      test('should return Left(DataNotFoundFailure) when data is null',
          () async {
        //arrange
        when(() => mockGraphQLService.executeQuery(getLaunchByIdQuery,
            variables: {'id': 'id'})).thenAnswer((_) async => mockQueryResult);
        when(() => mockQueryResult.data).thenReturn({'launch': null});

        //act
        final result = await repositoryImpl.fetchLaunchById(id: 'id');

        //assert
        expect(result, isA<Left<Failure, LaunchEntity>>());
        expect(
          result.left,
          equals(const DataNotFoundFailure(message: "Launch not found")),
        );
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(getLaunchByIdQuery,
            variables: {'id': 'id'})).called(1);
        verify(() => mockQueryResult.data).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
        verifyNoMoreInteractions(mockQueryResult);
      });
      test('should return Right(LaunchEntity) when data is not null', () async {
        //arrange
        when(() => mockGraphQLService.executeQuery(getLaunchByIdQuery,
            variables: {'id': 'id'})).thenAnswer((_) async => mockQueryResult);
        when(() => mockQueryResult.data)
            .thenReturn({'launch': testLaunchModel.toJson()});

        //act
        final result = await repositoryImpl.fetchLaunchById(id: 'id');

        //assert
        expect(result, isA<Right<Failure, LaunchEntity>>());
        expect(result.right, equals(testLaunchModel.toEntity()));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(getLaunchByIdQuery,
            variables: {'id': 'id'})).called(1);
        verify(() => mockQueryResult.data).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
        verifyNoMoreInteractions(mockQueryResult);
      });

      test('should return Left(GraphQLFailure) when GraphQLException is thrown',
          () async {
        //arrange
        when(() => mockGraphQLService
                .executeQuery(getLaunchByIdQuery, variables: {'id': 'id'}))
            .thenThrow(GraphQLException(message: 'GraphQL error occurred'));

        //act
        final result = await repositoryImpl.fetchLaunchById(id: 'id');

        //assert
        expect(result, isA<Left<Failure, LaunchEntity>>());
        expect(result.left,
            equals(const GraphQLFailure(message: 'GraphQL error occurred')));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(getLaunchByIdQuery,
            variables: {'id': 'id'})).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
      });
    });
  });

  group('fetchLaunches', () {
    test('Checks if the device is online', () async {
      //arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      //act
      await repositoryImpl.fetchLaunches();

      //assert
      verify(() => mockNetworkInfo.isConnected).called(1);
    });

    runOfflineTests(() {
      test(
          'Should return Left(InternetConnectionFailure) when device is offline',
          () async {
        //act
        final result = await repositoryImpl.fetchLaunches();

        //assert
        expect(result, isA<Left<Failure, List<LaunchEntity>>>());
        expect(
            result.left,
            equals(const InternetConnectionFailure(
                message: noInternetConnectionMessage)));
        verify(() => mockNetworkInfo.isConnected).called(1);
      });
    });

    runOnlineTests(() {
      test('should return Left(DataNotFoundFailure) when data is empty',
          () async {
        //arrange
        when(() => mockGraphQLService.executeQuery(getLaunchesQuery))
            .thenAnswer((_) async => mockQueryResult);
        when(() => mockQueryResult.data).thenReturn({'launches': []});

        //act
        final result = await repositoryImpl.fetchLaunches();

        //assert
        expect(result, isA<Left<Failure, List<LaunchEntity>>>());
        expect(
          result.left,
          equals(const DataNotFoundFailure(message: "Launches not found")),
        );
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(getLaunchesQuery))
            .called(1);
        verify(() => mockQueryResult.data).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
        verifyNoMoreInteractions(mockQueryResult);
      });
      test('should return Right([LaunchEntity]) when data is not empty',
          () async {
        //arrange
        when(() => mockGraphQLService.executeQuery(getLaunchesQuery))
            .thenAnswer((_) async => mockQueryResult);
        when(() => mockQueryResult.data).thenReturn({
          'launches': [testLaunchModel.toJson()]
        });

        //act
        final result = await repositoryImpl.fetchLaunches();

        //assert
        expect(result, isA<Right<Failure, List<LaunchEntity>>>());
        expect(result.right, equals([testLaunchModel.toEntity()]));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(getLaunchesQuery))
            .called(1);
        verify(() => mockQueryResult.data).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
        verifyNoMoreInteractions(mockQueryResult);
      });

      test('should return Left(GraphQLFailure) when GraphQLException is thrown',
          () async {
        //arrange
        when(() => mockGraphQLService.executeQuery(getLaunchesQuery))
            .thenThrow(GraphQLException(message: 'GraphQL error occurred'));

        //act
        final result = await repositoryImpl.fetchLaunches();

        //assert
        expect(result, isA<Left<Failure, List<LaunchEntity>>>());
        expect(result.left,
            equals(const GraphQLFailure(message: 'GraphQL error occurred')));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(getLaunchesQuery))
            .called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
      });
    });
  });

  group('fetchRocketById', () {
    test('Checks if the device is online', () async {
      //arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      //act
      await repositoryImpl.fetchRocketById(id: 'id');

      //assert
      verify(() => mockNetworkInfo.isConnected).called(1);
    });

    runOfflineTests(() {
      test(
          'Should return Left(InternetConnectionFailure) when device is offline',
          () async {
        //act
        final result = await repositoryImpl.fetchRocketById(id: 'id');

        //assert
        expect(result, isA<Left<Failure, RocketEntity>>());
        expect(
            result.left,
            equals(const InternetConnectionFailure(
                message: noInternetConnectionMessage)));
        verify(() => mockNetworkInfo.isConnected).called(1);
      });
    });

    runOnlineTests(() {
      test('should return Left(DataNotFoundFailure) when data is null',
          () async {
        //arrange
        when(() => mockGraphQLService.executeQuery(getRocketByIdQuery,
            variables: {'id': 'id'})).thenAnswer((_) async => mockQueryResult);
        when(() => mockQueryResult.data).thenReturn({'rocket': null});

        //act
        final result = await repositoryImpl.fetchRocketById(id: 'id');

        //assert
        expect(result, isA<Left<Failure, RocketEntity>>());
        expect(
          result.left,
          equals(const DataNotFoundFailure(message: "Rocket not found")),
        );
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(getRocketByIdQuery,
            variables: {'id': 'id'})).called(1);
        verify(() => mockQueryResult.data).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
        verifyNoMoreInteractions(mockQueryResult);
      });
      test('should return Right(RocketEntity) when data is not null', () async {
        //arrange
        when(() => mockGraphQLService.executeQuery(getRocketByIdQuery,
            variables: {'id': 'id'})).thenAnswer((_) async => mockQueryResult);
        when(() => mockQueryResult.data)
            .thenReturn({'rocket': testRocketModel.toJson()});

        //act
        final result = await repositoryImpl.fetchRocketById(id: 'id');

        //assert
        expect(result, isA<Right<Failure, RocketEntity>>());
        expect(result.right, equals(testRocketModel.toEntity()));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(getRocketByIdQuery,
            variables: {'id': 'id'})).called(1);
        verify(() => mockQueryResult.data).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
        verifyNoMoreInteractions(mockQueryResult);
      });

      test('should return Left(GraphQLFailure) when GraphQLException is thrown',
          () async {
        //arrange
        when(() => mockGraphQLService
                .executeQuery(getRocketByIdQuery, variables: {'id': 'id'}))
            .thenThrow(GraphQLException(message: 'GraphQL error occurred'));

        //act
        final result = await repositoryImpl.fetchRocketById(id: 'id');

        //assert
        expect(result, isA<Left<Failure, RocketEntity>>());
        expect(result.left,
            equals(const GraphQLFailure(message: 'GraphQL error occurred')));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(getRocketByIdQuery,
            variables: {'id': 'id'})).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
      });
    });
  });

  group('fetchRockets', () {
    test('Checks if the device is online', () async {
      //arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      //act
      await repositoryImpl.fetchRockets();

      //assert
      verify(() => mockNetworkInfo.isConnected).called(1);
    });

    runOfflineTests(() {
      test(
          'Should return Left(InternetConnectionFailure) when device is offline',
          () async {
        //act
        final result = await repositoryImpl.fetchRockets();

        //assert
        expect(result, isA<Left<Failure, List<RocketEntity>>>());
        expect(
            result.left,
            equals(const InternetConnectionFailure(
                message: noInternetConnectionMessage)));
        verify(() => mockNetworkInfo.isConnected).called(1);
      });
    });

    runOnlineTests(() {
      test('should return Left(DataNotFoundFailure) when data is empty',
          () async {
        //arrange
        when(() => mockGraphQLService.executeQuery(getRocketsQuery))
            .thenAnswer((_) async => mockQueryResult);
        when(() => mockQueryResult.data).thenReturn({'rockets': []});

        //act
        final result = await repositoryImpl.fetchRockets();

        //assert
        expect(result, isA<Left<Failure, List<RocketEntity>>>());
        expect(
          result.left,
          equals(const DataNotFoundFailure(message: "Rockets not found")),
        );
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(getRocketsQuery))
            .called(1);
        verify(() => mockQueryResult.data).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
        verifyNoMoreInteractions(mockQueryResult);
      });
      test('should return Right([RocketEntity]) when data is not empty',
          () async {
        //arrange
        when(() => mockGraphQLService.executeQuery(getRocketsQuery))
            .thenAnswer((_) async => mockQueryResult);
        when(() => mockQueryResult.data).thenReturn({
          'rockets': [testRocketModel.toJson()]
        });

        //act
        final result = await repositoryImpl.fetchRockets();

        //assert
        expect(result, isA<Right<Failure, List<RocketEntity>>>());
        expect(result.right, equals([testRocketModel.toEntity()]));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(getRocketsQuery))
            .called(1);
        verify(() => mockQueryResult.data).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
        verifyNoMoreInteractions(mockQueryResult);
      });

      test('should return Left(GraphQLFailure) when GraphQLException is thrown',
          () async {
        //arrange
        when(() => mockGraphQLService.executeQuery(getRocketsQuery))
            .thenThrow(GraphQLException(message: 'GraphQL error occurred'));

        //act
        final result = await repositoryImpl.fetchRockets();

        //assert
        expect(result, isA<Left<Failure, List<RocketEntity>>>());
        expect(result.left,
            equals(const GraphQLFailure(message: 'GraphQL error occurred')));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(getRocketsQuery))
            .called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
      });
    });
  });

  group('fetchLaunchesByPagination', () {
    test('Checks if the device is online', () async {
      //arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      //act
      await repositoryImpl.fetchLaunchesByPagination(
        offset: testOffset,
        limit: testLimit,
      );

      //assert
      verify(() => mockNetworkInfo.isConnected).called(1);
    });

    runOfflineTests(() {
      test(
          'Should return Left(InternetConnectionFailure) when device is offline',
          () async {
        //act
        final result = await repositoryImpl.fetchLaunchesByPagination(
          offset: testOffset,
          limit: testLimit,
        );

        //assert
        expect(result, isA<Left<Failure, List<LaunchEntity>>>());
        expect(
            result.left,
            equals(const InternetConnectionFailure(
                message: noInternetConnectionMessage)));
        verify(() => mockNetworkInfo.isConnected).called(1);
      });
    });

    runOnlineTests(() {
      test('should return Left(DataNotFoundFailure) when data is empty',
          () async {
        //arrange
        when(() => mockGraphQLService.executeQuery(
              getLaunchesByPaginationQuery,
              variables: {"offset": testOffset, "limit": testLimit},
            )).thenAnswer((_) async => mockQueryResult);
        when(() => mockQueryResult.data).thenReturn({'launches': []});

        //act
        final result = await repositoryImpl.fetchLaunchesByPagination(
          offset: testOffset,
          limit: testLimit,
        );

        //assert
        expect(result, isA<Left<Failure, List<LaunchEntity>>>());
        expect(
          result.left,
          equals(const DataNotFoundFailure(message: "Launches not found")),
        );
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(
              getLaunchesByPaginationQuery,
              variables: {"offset": testOffset, "limit": testLimit},
            )).called(1);
        verify(() => mockQueryResult.data).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
        verifyNoMoreInteractions(mockQueryResult);
      });
      test('should return Right([LaunchEntity]) when data is not empty',
          () async {
        //arrange
        when(() => mockGraphQLService.executeQuery(
              getLaunchesByPaginationQuery,
              variables: {"offset": testOffset, "limit": testLimit},
            )).thenAnswer((_) async => mockQueryResult);
        when(() => mockQueryResult.data).thenReturn({
          'launches': [testLaunchModel.toJson()]
        });

        //act
        final result = await repositoryImpl.fetchLaunchesByPagination(
          offset: testOffset,
          limit: testLimit,
        );

        //assert
        expect(result, isA<Right<Failure, List<LaunchEntity>>>());
        expect(result.right, equals([testLaunchModel.toEntity()]));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(
              getLaunchesByPaginationQuery,
              variables: {"offset": testOffset, "limit": testLimit},
            )).called(1);
        verify(() => mockQueryResult.data).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
        verifyNoMoreInteractions(mockQueryResult);
      });

      test('should return Left(GraphQLFailure) when GraphQLException is thrown',
          () async {
        //arrange
        when(() => mockGraphQLService.executeQuery(
              getLaunchesByPaginationQuery,
              variables: {"offset": testOffset, "limit": testLimit},
            )).thenThrow(GraphQLException(message: 'GraphQL error occurred'));

        //act
        final result = await repositoryImpl.fetchLaunchesByPagination(
          offset: testOffset,
          limit: testLimit,
        );

        //assert
        expect(result, isA<Left<Failure, List<LaunchEntity>>>());
        expect(result.left,
            equals(const GraphQLFailure(message: 'GraphQL error occurred')));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(
              getLaunchesByPaginationQuery,
              variables: {"offset": testOffset, "limit": testLimit},
            )).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
      });
    });
  });

   group('fetchCapsulesByPagination', () {
    
    test('Checks if the device is online', () async {
      //arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      //act
      await repositoryImpl.fetchCapsulesByPagination(
        offset: testOffset,
        limit: testLimit,
      );

      //assert
      verify(() => mockNetworkInfo.isConnected).called(1);
    });

    runOfflineTests(() {
      test(
          'Should return Left(InternetConnectionFailure) when device is offline',
          () async {
        //act
        final result = await repositoryImpl.fetchCapsulesByPagination(
          offset: testOffset,
          limit: testLimit,
        );

        //assert
        expect(result, isA<Left<Failure, List<CapsuleEntity>>>());
        expect(
            result.left,
            equals(const InternetConnectionFailure(
                message: noInternetConnectionMessage)));
        verify(() => mockNetworkInfo.isConnected).called(1);
      });
    });

    runOnlineTests(() {
      test('should return Left(DataNotFoundFailure) when data is empty',
          () async {
        //arrange
        when(() => mockGraphQLService.executeQuery(
              getCapsulesByPaginationQuery,
              variables: {"offset": testOffset, "limit": testLimit},
            )).thenAnswer((_) async => mockQueryResult);
        when(() => mockQueryResult.data).thenReturn({'capsules': []});

        //act
        final result = await repositoryImpl.fetchCapsulesByPagination(
          offset: testOffset,
          limit: testLimit,
        );

        //assert
        expect(result, isA<Left<Failure, List<CapsuleEntity>>>());
        expect(
          result.left,
          equals(const DataNotFoundFailure(message: "Capsules not found")),
        );
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(
              getCapsulesByPaginationQuery,
              variables: {"offset": testOffset, "limit": testLimit},
            )).called(1);
        verify(() => mockQueryResult.data).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
        verifyNoMoreInteractions(mockQueryResult);
      });
      test('should return Right([CapsuleEntity]) when data is not empty',
          () async {
        //arrange
        when(() => mockGraphQLService.executeQuery(
              getCapsulesByPaginationQuery,
              variables: {"offset": testOffset, "limit": testLimit},
            )).thenAnswer((_) async => mockQueryResult);
        when(() => mockQueryResult.data).thenReturn({
          'capsules': [testCapsuleModel.toJson()]
        });

        //act
        final result = await repositoryImpl.fetchCapsulesByPagination(
          offset: testOffset,
          limit: testLimit,
        );

        //assert
        expect(result, isA<Right<Failure, List<CapsuleEntity>>>());
        expect(result.right, equals([testCapsuleModel.toEntity()]));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(
              getCapsulesByPaginationQuery,
              variables: {"offset": testOffset, "limit": testLimit},
            )).called(1);
        verify(() => mockQueryResult.data).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
        verifyNoMoreInteractions(mockQueryResult);
      });

      test('should return Left(GraphQLFailure) when GraphQLException is thrown',
          () async {
        //arrange
        when(() => mockGraphQLService.executeQuery(
              getCapsulesByPaginationQuery,
              variables: {"offset": testOffset, "limit": testLimit},
            )).thenThrow(GraphQLException(message: 'GraphQL error occurred'));

        //act
        final result = await repositoryImpl.fetchCapsulesByPagination(
          offset: testOffset,
          limit: testLimit,
        );

        //assert
        expect(result, isA<Left<Failure, List<CapsuleEntity>>>());
        expect(result.left,
            equals(const GraphQLFailure(message: 'GraphQL error occurred')));
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockGraphQLService.executeQuery(
              getCapsulesByPaginationQuery,
              variables: {"offset": testOffset, "limit": testLimit},
            )).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockGraphQLService);
      });
    });
  });
}
