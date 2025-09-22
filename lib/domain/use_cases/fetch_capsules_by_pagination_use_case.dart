import 'package:either_dart/either.dart';
import 'package:spacex_flutter_app/domain/repositories/space_x_repository.dart';

import '../../core/failures/failures.dart';
import '../entities/capsule_entity.dart';

// Use case for fetching capsules by pagination.
// This class abstracts the business logic from the repository layer.
class FetchCapsulesByPaginationUseCase {
  final SpaceXRepository spaceXRepository;

  FetchCapsulesByPaginationUseCase({required this.spaceXRepository});

  
  Future<Either<Failure, List<CapsuleEntity>>> call({
    required int offset,
    required int limit,
  }) async => spaceXRepository.fetchCapsulesByPagination(
        offset: offset,
        limit: limit,
      );
}
