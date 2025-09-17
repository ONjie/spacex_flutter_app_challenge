import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacex_flutter_app/core/failures/failures.dart';
import 'package:spacex_flutter_app/domain/entities/capsule_entity.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_capsule_by_id_use_case.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_capsules_use_case.dart';
import 'package:spacex_flutter_app/presentation/providers/capsule_provider.dart';


class MockFetchCapsulesUseCase extends Mock implements FetchCapsulesUseCase {}

class MockFetchCapsuleByIdUseCase extends Mock
    implements FetchCapsuleByIdUseCase {}

void main() {
  late CapsuleProvider capsuleProvider;
  late MockFetchCapsulesUseCase mockFetchCapsulesUseCase;
  late MockFetchCapsuleByIdUseCase mockFetchCapsuleByIdUseCase;

  setUp(() {
    mockFetchCapsulesUseCase = MockFetchCapsulesUseCase();
    mockFetchCapsuleByIdUseCase = MockFetchCapsuleByIdUseCase();
    capsuleProvider = CapsuleProvider(
      fetchCapsulesUseCase: mockFetchCapsulesUseCase,
      fetchCapsuleByIdUseCase: mockFetchCapsuleByIdUseCase,
    );
  });

  const testCapsuleA = CapsuleEntity(
    id: 'id',
    reuseCount: 1,
    status: 'status',
    type: 'type',
  );
  const testCapsuleB = CapsuleEntity(
    id: 'id',
    reuseCount: 1,
    status: 'status',
    type: 'type',
  );


  group('CapsuleProvider', () {
    test('initial state should be empty and not loading', () async {
      //assert
      expect(capsuleProvider.capsules, isEmpty);
      expect(capsuleProvider.capsule, isNull);
      expect(capsuleProvider.isLoading, isFalse);
      expect(capsuleProvider.error, isNull);
    });

    test(
        'fetchCapsules should return an error message when call is unsuccessful',
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

    test('fetchCapsules should return [CapsuleEntity] when call is successful',
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

    test(
        'fetchCapsuleById should return an error message when call is unsuccessful',
        () async {
      //arrange
      when(() => mockFetchCapsuleByIdUseCase.call(id: any(named: 'id')))
          .thenAnswer((_) async =>
              const Left(GraphQLFailure(message: 'GraphQL error')));

      //act
      await capsuleProvider.fetchCapsuleById(id: 'id');

      //assert
      expect(capsuleProvider.capsule, isNull);
      expect(capsuleProvider.isLoading, isFalse);
      expect(capsuleProvider.error, equals('GraphQL error'));
      verify(() => mockFetchCapsuleByIdUseCase.call(id: any(named: 'id')))
          .called(1);
      verifyNoMoreInteractions(mockFetchCapsuleByIdUseCase);
    });

    test(
        'fetchCapsuleById should return a CapsuleEntity  when call is successful',
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

    test('clearError should reset error', () async {
      //act
      capsuleProvider.clearError();

      //assert
      expect(capsuleProvider.error, isNull);
    });

    test('refreshCapsules should reset state and fetch capsules', () async {
      //arrange
      when(() => mockFetchCapsulesUseCase.call())
          .thenAnswer((_) async => const Right([testCapsuleA]));

      await capsuleProvider.fetchCapsules();
      expect(capsuleProvider.capsules, equals([testCapsuleA]));

      when(() => mockFetchCapsulesUseCase.call())
          .thenAnswer((_) async => const Right([testCapsuleB]));

      //act
      capsuleProvider.refreshCapsules();

      //provider should now contain rocketB (refetched)
      //assert

      expect(capsuleProvider.capsules, equals([testCapsuleB]));
      expect(capsuleProvider.isLoading, isTrue);
      expect(capsuleProvider.error, isNull);

      verify(() => mockFetchCapsulesUseCase.call()).called(2);
      verifyNoMoreInteractions(mockFetchCapsulesUseCase);
    });
  });
}
