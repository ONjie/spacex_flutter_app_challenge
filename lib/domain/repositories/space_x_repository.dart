import 'package:spacex_flutter_app/domain/entities/capsule_entity.dart';
import 'package:spacex_flutter_app/domain/entities/launch_entity.dart';
import 'package:spacex_flutter_app/domain/entities/rocket_entity.dart';

abstract class SpaceXRepository {
  Future<List<RocketEntity>> fetchRockets();
  Future<RocketEntity> fetchRocketById({required String id});
  Future<List<CapsuleEntity>> fetchCapsules();
  Future<CapsuleEntity> fetchCapsuleById({required String id});
  Future<List<LaunchEntity>> fetchLaunches();
  Future<LaunchEntity> fetchLaunchById({required String id});
}
