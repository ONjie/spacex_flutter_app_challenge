import 'package:either_dart/either.dart';
import 'package:spacex_flutter_app/domain/entities/capsule_entity.dart';

import '../../core/failures/failures.dart';
import '../repositories/space_x_repository.dart';

// Use case for fetching a single capsule by its id.
// This class abstracts the business logic from the repository layer.

class FetchCapsuleByIdUseCase {
  final SpaceXRepository spaceXRepository;

  FetchCapsuleByIdUseCase({required this.spaceXRepository});

  Future<Either<Failure, CapsuleEntity>> call({required String id}) async =>
      spaceXRepository.fetchCapsuleById(id: id);
}
