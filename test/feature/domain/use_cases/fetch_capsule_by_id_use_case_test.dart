import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacex_flutter_app/core/failures/failures.dart';
import 'package:spacex_flutter_app/domain/entities/capsule_entity.dart';
import 'package:spacex_flutter_app/domain/repositories/space_x_repository.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_capsule_by_id_use_case.dart';

class MockSpaceXRepository extends Mock implements SpaceXRepository {}

void main() {
  late FetchCapsuleByIdUseCase fetchCapsuleByIdUseCase;
  late MockSpaceXRepository mockSpaceXRepository;

  setUp(() {
    mockSpaceXRepository = MockSpaceXRepository();
    fetchCapsuleByIdUseCase =
        FetchCapsuleByIdUseCase(spaceXRepository: mockSpaceXRepository);
  });
  const testCapsule = CapsuleEntity(
    id: 'id',
    reuseCount: 1,
    status: 'status',
    type: 'type',
  );

  test("should return a Right(CapsuleEntity) when call is successful", () async {
    //arrange
    when(() => mockSpaceXRepository.fetchCapsuleById(id: any(named: 'id')))
        .thenAnswer((_) async => const Right(testCapsule));

    //act
    final result = await fetchCapsuleByIdUseCase.call(id: testCapsule.id);

    //assert
    expect(result, isA<Right<Failure, CapsuleEntity>>());
    expect(result.right, equals(testCapsule));
    verify(() => mockSpaceXRepository.fetchCapsuleById(id: any(named: 'id')))
        .called(1);
    verifyNoMoreInteractions(mockSpaceXRepository);
  });
}
