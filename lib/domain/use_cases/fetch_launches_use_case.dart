import 'package:either_dart/either.dart';
import 'package:spacex_flutter_app/domain/entities/launch_entity.dart';

import '../../core/failures/failures.dart';
import '../repositories/space_x_repository.dart';

class FetchLaunchesUseCase {
  final SpaceXRepository spaceXRepository;

  FetchLaunchesUseCase({required this.spaceXRepository});

  Future<Either<Failure, List<LaunchEntity>>> call() async =>
      spaceXRepository.fetchLaunches();
}
