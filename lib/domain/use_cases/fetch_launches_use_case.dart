import 'package:spacex_flutter_app/domain/entities/launch_entity.dart';

import '../repositories/space_x_repository.dart';

class FetchLaunchesUseCase {
  final SpaceXRepository spaceXRepository;

  FetchLaunchesUseCase({required this.spaceXRepository});

  Future<List<LaunchEntity>> call() async => spaceXRepository.fetchLaunches();
}
