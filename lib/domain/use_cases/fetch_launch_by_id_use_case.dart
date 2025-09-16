import '../entities/launch_entity.dart';
import '../repositories/space_x_repository.dart';

class FetchLaunchByIdUseCase {
  final SpaceXRepository spaceXRepository;

  FetchLaunchByIdUseCase({required this.spaceXRepository});

  Future<LaunchEntity> call({required String id}) async =>
      spaceXRepository.fetchLaunchById(id: id);
}
