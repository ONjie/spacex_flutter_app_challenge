import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacex_flutter_app/core/failures/failures.dart';
import 'package:spacex_flutter_app/domain/entities/capsule_entity.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_capsule_by_id_use_case.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_capsules_by_pagination_use_case.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_capsules_use_case.dart';
import 'package:spacex_flutter_app/presentation/providers/capsule_provider.dart';

class MockFetchCapsulesUseCase extends Mock implements FetchCapsulesUseCase {}

class MockFetchCapsuleByIdUseCase extends Mock
    implements FetchCapsuleByIdUseCase {}

class MockFetchCapsulesByPaginationUseCase extends Mock
    implements FetchCapsulesByPaginationUseCase {}

void main() {
  late CapsuleProvider capsuleProvider;
  late MockFetchCapsulesUseCase mockFetchCapsulesUseCase;
  late MockFetchCapsuleByIdUseCase mockFetchCapsuleByIdUseCase;
  late MockFetchCapsulesByPaginationUseCase mockFetchCapsulesByPaginationUseCase;

  setUp(() {
    mockFetchCapsulesUseCase = MockFetchCapsulesUseCase();
    mockFetchCapsuleByIdUseCase = MockFetchCapsuleByIdUseCase();
    mockFetchCapsulesByPaginationUseCase = MockFetchCapsulesByPaginationUseCase();
    capsuleProvider = CapsuleProvider(
        fetchCapsulesUseCase: mockFetchCapsulesUseCase,
        fetchCapsuleByIdUseCase: mockFetchCapsuleByIdUseCase,
        fetchCapsulesByPaginationUseCase: mockFetchCapsulesByPaginationUseCase);
  });

  const testCapsuleA = CapsuleEntity(
    id: 'id',
    reuseCount: 1,
    status: 'status',
    type: 'type',
  );
  test('initial state should be empty and not loading', () async {
    //assert
    expect(capsuleProvider.capsules, isEmpty);
    expect(capsuleProvider.capsule, CapsuleEntity.capsuledummy);
    expect(capsuleProvider.isLoading, isFalse);
    expect(capsuleProvider.error, isNull);
  });

  group('fetchCapsules', () {
    test(
        'should return an error message when call is unsuccessful',
        () async {
      //arrange
      when(() => mockFetchCapsulesUseCase.call()).thenAnswer(
          (_) async => const Left(GraphQLFailure(message: 'GraphQL error')));

      //act
      await capsuleProvider.fetchCapsules();

      //assert
      expect(capsuleProvider.capsules, isEmpty);
      expect(capsuleProvider.isLoading, isFalse);
      expect(capsuleProvider.error, equals('GraphQL error'));
      verify(() => mockFetchCapsulesUseCase.call()).called(1);
      verifyNoMoreInteractions(mockFetchCapsulesUseCase);
    });

    test('should return [CapsuleEntity] when call is successful',
        () async {
      //arrange
      when(() => mockFetchCapsulesUseCase.call())
          .thenAnswer((_) async => const Right([testCapsuleA]));

      //act
      await capsuleProvider.fetchCapsules();

      //assert
      expect(capsuleProvider.capsules, equals([testCapsuleA]));
      expect(capsuleProvider.isLoading, isFalse);
      expect(capsuleProvider.error, isNull);
      verify(() => mockFetchCapsulesUseCase.call()).called(1);
      verifyNoMoreInteractions(mockFetchCapsulesUseCase);
    });
  });

  group('fetchCapsuleById', () {
    test(
        'should return an error message when call is unsuccessful',
        () async {
      //arrange
      when(() => mockFetchCapsuleByIdUseCase.call(id: any(named: 'id')))
          .thenAnswer((_) async =>
              const Left(GraphQLFailure(message: 'GraphQL error')));

      //act
      await capsuleProvider.fetchCapsuleById(id: 'id');

      //assert
      expect(capsuleProvider.capsule, CapsuleEntity.capsuledummy);
      expect(capsuleProvider.isLoading, isFalse);
      expect(capsuleProvider.error, equals('GraphQL error'));
      verify(() => mockFetchCapsuleByIdUseCase.call(id: any(named: 'id')))
          .called(1);
      verifyNoMoreInteractions(mockFetchCapsuleByIdUseCase);
    });

    test(
        'should return a CapsuleEntity  when call is successful',
        () async {
      //arrange
      when(() => mockFetchCapsuleByIdUseCase.call(id: any(named: 'id')))
          .thenAnswer((_) async => const Right(testCapsuleA));

      //act
      await capsuleProvider.fetchCapsuleById(id: 'id');

      //assert
      expect(capsuleProvider.capsule, equals(testCapsuleA));
      expect(capsuleProvider.isLoading, isFalse);
      expect(capsuleProvider.error, isNull);
      verify(() => mockFetchCapsuleByIdUseCase.call(id: any(named: 'id')))
          .called(1);
      verifyNoMoreInteractions(mockFetchCapsuleByIdUseCase);
    });
  });

   group('fetchCapsulesByPagination', () {
    test(
        ' should return an error message when call is unsuccessful',
        () async {
      //arrange
      when(() => mockFetchCapsulesByPaginationUseCase.call(
                offset: any<int>(named: 'offset'),
                limit: any<int>(named: 'limit'),
              ))
          .thenAnswer((_) async =>
              const Left(GraphQLFailure(message: 'GraphQL error')));

      //act
      await capsuleProvider.fetchCapsulesByPagination();

      //assert
      expect(capsuleProvider.paginatedCapsules.length, 0);
      expect(capsuleProvider.hasMore, isTrue);
      expect(capsuleProvider.error, equals('GraphQL error'));
      verify(() => mockFetchCapsulesByPaginationUseCase.call(
            offset: any<int>(named: 'offset'),
            limit: any<int>(named: 'limit'),
          )).called(1);
      verifyNoMoreInteractions(mockFetchCapsulesByPaginationUseCase);
    });

    test(
        'should return [LaunchEntity] when call is successful',
        () async {
      //arrange
      when(() => mockFetchCapsulesByPaginationUseCase.call(
            offset: any<int>(named: 'offset'),
            limit: any<int>(named: 'limit'),
          )).thenAnswer((_) async => const Right([testCapsuleA]));

      //act
      await capsuleProvider.fetchCapsulesByPagination();

      //assert
      expect(capsuleProvider.paginatedCapsules, equals([testCapsuleA]));
      expect(capsuleProvider.hasMore, isTrue);
      expect(capsuleProvider.error, isNull);
      verify(() => mockFetchCapsulesByPaginationUseCase.call(
            offset: any<int>(named: 'offset'),
            limit: any<int>(named: 'limit'),
          )).called(1);
      verifyNoMoreInteractions(mockFetchCapsulesUseCase);
    });
  });

   group('refreshLaunches', () {
    test('should reset paginated launches and refetch', () async {
      when(() => mockFetchCapsulesByPaginationUseCase.call(
            offset: any<int>(named: 'offset'),
            limit: any<int>(named: 'limit'),
          )).thenAnswer((_) async => const Right([testCapsuleA]));

      await capsuleProvider.refreshCapsules();

      expect(capsuleProvider.paginatedCapsules, contains(testCapsuleA));
      expect(capsuleProvider.offset, greaterThan(0));
      expect(capsuleProvider.hasMore, isTrue);
      verify(() => mockFetchCapsulesByPaginationUseCase.call(
            offset: any<int>(named: 'offset'),
            limit: any<int>(named: 'limit'),
          )).called(1);
      verifyNoMoreInteractions(mockFetchCapsulesByPaginationUseCase);
    });
  });
}
