import 'package:either_dart/either.dart';
import 'package:spacex_flutter_app/domain/entities/capsule_entity.dart';
import 'package:spacex_flutter_app/domain/entities/launch_entity.dart';
import 'package:spacex_flutter_app/domain/entities/rocket_entity.dart';

import '../../core/failures/failures.dart';

// Abstract repository defining all SpaceX-related data operations.
// This allows decoupling the data layer from the domain and presentation layers.

abstract class SpaceXRepository {
  Future<Either<Failure, List<RocketEntity>>> fetchRockets();
  Future<Either<Failure, RocketEntity>> fetchRocketById({required String id});
  Future<Either<Failure, List<CapsuleEntity>>> fetchCapsules();
  Future<Either<Failure, CapsuleEntity>> fetchCapsuleById({required String id});
  Future<Either<Failure, List<LaunchEntity>>> fetchLaunches();
  Future<Either<Failure, LaunchEntity>> fetchLaunchById({required String id});
  Future<Either<Failure, List<LaunchEntity>>> fetchLaunchesByPagination({
    required int offset,
    required int limit,
  });
  Future<Either<Failure, List<CapsuleEntity>>> fetchCapsulesByPagination({
    required int offset,
    required int limit,
  });
}
