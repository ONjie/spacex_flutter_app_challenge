import 'package:either_dart/either.dart';

import '../../core/failures/failures.dart';
import '../entities/rocket_entity.dart';
import '../repositories/space_x_repository.dart';

// Use case for fetching a single rocket by its id.
// This class abstracts the business logic from the repository layer.
class FetchRocketByIdUseCase {
  final SpaceXRepository spaceXRepository;

  FetchRocketByIdUseCase({required this.spaceXRepository});

  Future<Either<Failure, RocketEntity>> call({required String id}) async =>
      spaceXRepository.fetchRocketById(id: id);
}
