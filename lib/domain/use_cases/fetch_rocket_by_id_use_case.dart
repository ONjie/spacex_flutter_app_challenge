import '../entities/rocket_entity.dart';
import '../repositories/space_x_repository.dart';

class FetchRocketByIdUseCase {
  final SpaceXRepository spaceXRepository;

  FetchRocketByIdUseCase({required this.spaceXRepository});

  Future<RocketEntity> call({required String id}) async =>
      spaceXRepository.fetchRocketById(id: id);
}
