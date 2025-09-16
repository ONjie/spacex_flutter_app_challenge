import 'package:spacex_flutter_app/domain/entities/capsule_entity.dart';

import '../repositories/space_x_repository.dart';

class FetchCapsulesUseCase {
  final SpaceXRepository spaceXRepository;

  FetchCapsulesUseCase({required this.spaceXRepository});

  Future<List<CapsuleEntity>> call() async => spaceXRepository.fetchCapsules();
}
