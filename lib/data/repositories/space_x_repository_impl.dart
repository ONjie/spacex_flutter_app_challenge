import 'package:spacex_flutter_app/domain/entities/capsule_entity.dart';

import 'package:spacex_flutter_app/domain/entities/launch_entity.dart';

import 'package:spacex_flutter_app/domain/entities/rocket_entity.dart';

import '../../domain/repositories/space_x_repository.dart';

class SpaceXRepositoryImpl implements SpaceXRepository{
  @override
  Future<CapsuleEntity> fetchCapsuleById({required String id}) {
    // TODO: implement fetchCapsuleById
    throw UnimplementedError();
  }

  @override
  Future<List<CapsuleEntity>> fetchCapsules() {
    // TODO: implement fetchCapsules
    throw UnimplementedError();
  }

  @override
  Future<LaunchEntity> fetchLaunchById({required String id}) {
    // TODO: implement fetchLaunchById
    throw UnimplementedError();
  }

  @override
  Future<List<LaunchEntity>> fetchLaunches() {
    // TODO: implement fetchLaunches
    throw UnimplementedError();
  }

  @override
  Future<RocketEntity> fetchRocketById({required String id}) {
    // TODO: implement fetchRocketById
    throw UnimplementedError();
  }

  @override
  Future<List<RocketEntity>> fetchRockets() {
    // TODO: implement fetchRockets
    throw UnimplementedError();
  }
}