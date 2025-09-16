import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacex_flutter_app/domain/entities/capsule_entity.dart';
import 'package:spacex_flutter_app/domain/repositories/space_x_repository.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_capsules_use_case.dart';

class MockSpaceXRepository extends Mock implements SpaceXRepository {}

void main() {
  late FetchCapsulesUseCase fetchCapsulesUseCase;
  late MockSpaceXRepository mockSpaceXRepository;

  setUp(() {
    mockSpaceXRepository = MockSpaceXRepository();
    fetchCapsulesUseCase =
        FetchCapsulesUseCase(spaceXRepository: mockSpaceXRepository);
  });
  const testCapsule = CapsuleEntity(
    id: 'id',
    reuseCount: 1,
    status: 'status',
    type: 'type',
  );

  test("should return a [CapsuleEntity] when call is successful", () async {
    //arrange
    when(() => mockSpaceXRepository.fetchCapsules())
        .thenAnswer((_) async => [testCapsule]);

    //act
    final results = await fetchCapsulesUseCase.call();

    //assert
    expect(results, isA<List<CapsuleEntity>>());
    expect(results, equals([testCapsule]));
    verify(() => mockSpaceXRepository.fetchCapsules()).called(1);
    verifyNoMoreInteractions(mockSpaceXRepository);
  });
}
