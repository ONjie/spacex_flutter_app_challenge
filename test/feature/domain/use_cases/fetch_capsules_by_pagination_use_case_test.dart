import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacex_flutter_app/core/failures/failures.dart';
import 'package:spacex_flutter_app/domain/entities/capsule_entity.dart';
import 'package:spacex_flutter_app/domain/repositories/space_x_repository.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_capsules_by_pagination_use_case.dart';


class MockSpaceXRepository extends Mock implements SpaceXRepository {}

void main() {
  late FetchCapsulesByPaginationUseCase fetchCapsulesByPaginationUseCase;
  late MockSpaceXRepository mockSpaceXRepository;

  setUp(() {
    mockSpaceXRepository = MockSpaceXRepository();
    fetchCapsulesByPaginationUseCase = FetchCapsulesByPaginationUseCase(
        spaceXRepository: mockSpaceXRepository);
  });
  const testCapsule = CapsuleEntity(
    id: 'id',
    reuseCount: 1,
    status: 'status',
    type: 'type',
  );

  const testOffset = 0;
  const testLimit = 0;

  test("should return a Right([CapsuleEntity]) when call is successful",
      () async {
    //arrange
    when(() => mockSpaceXRepository.fetchCapsulesByPagination(
        offset: testOffset,
        limit: testLimit)).thenAnswer((_) async => const Right([testCapsule]));

    //act
    final results = await fetchCapsulesByPaginationUseCase.call(
        offset: testOffset, limit: testLimit);

    //assert
    expect(results, isA<Right<Failure, List<CapsuleEntity>>>());
    expect(results.right, equals([testCapsule]));
    verify(() => mockSpaceXRepository.fetchCapsulesByPagination(
        offset: testOffset, limit: testLimit)).called(1);
    verifyNoMoreInteractions(mockSpaceXRepository);
  });
}
