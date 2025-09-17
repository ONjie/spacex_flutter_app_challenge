import 'package:either_dart/either.dart';
import 'package:spacex_flutter_app/domain/entities/capsule_entity.dart';

import '../../core/failures/failures.dart';
import '../repositories/space_x_repository.dart';

class FetchCapsulesUseCase {
  final SpaceXRepository spaceXRepository;

  FetchCapsulesUseCase({required this.spaceXRepository});

  Future<Either<Failure, List<CapsuleEntity>>> call() async => spaceXRepository.fetchCapsules();
}
