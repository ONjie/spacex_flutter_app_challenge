import 'package:either_dart/either.dart';
import 'package:spacex_flutter_app/core/failures/failures.dart' show Failure;

import '../entities/launch_entity.dart';
import '../repositories/space_x_repository.dart';


// Use case for fetching a single launch by its id.
// This class abstracts the business logic from the repository layer.
class FetchLaunchByIdUseCase {
  final SpaceXRepository spaceXRepository;

  FetchLaunchByIdUseCase({required this.spaceXRepository});

  Future<Either<Failure, LaunchEntity>> call({required String id}) async =>
      spaceXRepository.fetchLaunchById(id: id);
}
