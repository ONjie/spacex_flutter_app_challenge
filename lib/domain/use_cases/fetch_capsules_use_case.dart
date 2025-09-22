import 'package:either_dart/either.dart';
import 'package:spacex_flutter_app/domain/entities/capsule_entity.dart';

import '../../core/failures/failures.dart';
import '../repositories/space_x_repository.dart';

// Use case for fetching capsules.
// This class abstracts the business logic from the repository layer.
class FetchCapsulesUseCase {
  final SpaceXRepository spaceXRepository;

  FetchCapsulesUseCase({required this.spaceXRepository});

  Future<Either<Failure, List<CapsuleEntity>>> call() async => spaceXRepository.fetchCapsules();
}
