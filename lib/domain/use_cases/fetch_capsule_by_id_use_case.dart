import 'package:spacex_flutter_app/domain/entities/capsule_entity.dart';

import '../repositories/space_x_repository.dart';

class FetchCapsuleByIdUseCase {
  final SpaceXRepository spaceXRepository;

  FetchCapsuleByIdUseCase({required this.spaceXRepository});

  Future<CapsuleEntity> call({required String id}) async =>
      spaceXRepository.fetchCapsuleById(id: id);
}
