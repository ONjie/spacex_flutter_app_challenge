import 'package:either_dart/either.dart';
import 'package:spacex_flutter_app/core/failures/failures.dart' show Failure;

import '../entities/launch_entity.dart';
import '../repositories/space_x_repository.dart';

class FetchLaunchByIdUseCase {
  final SpaceXRepository spaceXRepository;

  FetchLaunchByIdUseCase({required this.spaceXRepository});

  Future<Either<Failure, LaunchEntity>> call({required String id}) async =>
      spaceXRepository.fetchLaunchById(id: id);
}
