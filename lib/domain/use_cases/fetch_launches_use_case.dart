import 'package:either_dart/either.dart';
import 'package:spacex_flutter_app/domain/entities/launch_entity.dart';

import '../../core/failures/failures.dart';
import '../repositories/space_x_repository.dart';


// Use case for fetching launches.
// This class abstracts the business logic from the repository layer.
class FetchLaunchesUseCase {
  final SpaceXRepository spaceXRepository;

  FetchLaunchesUseCase({required this.spaceXRepository});

  Future<Either<Failure, List<LaunchEntity>>> call() async =>
      spaceXRepository.fetchLaunches();
}
