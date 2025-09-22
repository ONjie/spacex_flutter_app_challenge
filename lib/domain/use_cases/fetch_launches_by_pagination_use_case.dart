import 'package:either_dart/either.dart';
import 'package:spacex_flutter_app/domain/repositories/space_x_repository.dart';

import '../../core/failures/failures.dart';
import '../entities/launch_entity.dart';


// Use case for fetching launches by pagination.
// This class abstracts the business logic from the repository layer.
class FetchLaunchesByPaginationUseCase {
  final SpaceXRepository spaceXRepository;

  FetchLaunchesByPaginationUseCase({required this.spaceXRepository});

  Future<Either<Failure, List<LaunchEntity>>> call({
    required int offset,
    required int limit,
  }) async => spaceXRepository.fetchLaunchesByPagination(
        offset: offset,
        limit: limit,
      );
}
