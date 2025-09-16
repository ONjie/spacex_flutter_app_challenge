import 'package:spacex_flutter_app/domain/repositories/space_x_repository.dart';

import '../entities/rocket_entity.dart';

class FetchRocketsUseCase {
  final SpaceXRepository spaceXRepository;

  FetchRocketsUseCase({required this.spaceXRepository});

  Future<List<RocketEntity>> call() async => spaceXRepository.fetchRockets();
}
