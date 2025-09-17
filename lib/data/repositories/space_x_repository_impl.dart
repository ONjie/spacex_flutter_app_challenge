import 'package:either_dart/either.dart';
import 'package:spacex_flutter_app/core/exceptions/exceptions.dart';
import 'package:spacex_flutter_app/data/models/capsule_model.dart';
import 'package:spacex_flutter_app/data/models/launch_model.dart'
    show LaunchModel;
import 'package:spacex_flutter_app/data/models/rocket_model.dart';
import 'package:spacex_flutter_app/data/queries/capsule_queries.dart';
import 'package:spacex_flutter_app/data/queries/launch_queries.dart';
import 'package:spacex_flutter_app/domain/entities/capsule_entity.dart';
import 'package:spacex_flutter_app/domain/entities/launch_entity.dart';
import 'package:spacex_flutter_app/domain/entities/rocket_entity.dart';
import '../../core/failures/failures.dart';
import '../../core/network/graphql_client.dart';
import '../../core/network/network_info.dart';
import '../../core/utils/infos/infos.dart';
import '../../domain/repositories/space_x_repository.dart';
import '../queries/rocket_queries.dart';

class SpaceXRepositoryImpl implements SpaceXRepository {
  final NetworkInfo networkInfo;
  final GraphQLService graphQLService;

  SpaceXRepositoryImpl({
    required this.networkInfo,
    required this.graphQLService,
  });

  @override
  Future<Either<Failure, CapsuleEntity>> fetchCapsuleById(
      {required String id}) async {
    if (!await networkInfo.isConnected) {
      return const Left(
          InternetConnectionFailure(message: noInternetConnectionMessage));
    }

    try {
      final result = await graphQLService
          .executeQuery(getCapsuleByIdQuery, variables: {'id': id});

      final capsuleData = result.data?['capsule'];
      if (capsuleData == null) {
        return const Left(DataNotFoundFailure(message: "Capsule not found"));
      }

      final capsuleModel = CapsuleModel.fromJson(capsuleData);

      final capsuleEntity = capsuleModel.toEntity();

      return Right(capsuleEntity);
    } on GraphQLException catch (e) {
      return Left(GraphQLFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<CapsuleEntity>>> fetchCapsules() async {
    if (!await networkInfo.isConnected) {
      return const Left(
          InternetConnectionFailure(message: noInternetConnectionMessage));
    }

    try {
      final result = await graphQLService.executeQuery(getCapsulesQuery);

      final capsulesData = result.data?['capsules'] as List<dynamic>?;
      if (capsulesData!.isEmpty) {
        return const Left(DataNotFoundFailure(message: "Capsules not found"));
      }

      final capsuleModelList = capsulesData
          .map((json) => CapsuleModel.fromJson(json as Map<String, dynamic>))
          .toList();

      final capsuleEntityList = capsuleModelList.map((e) => e.toEntity()).toList();

      return Right(capsuleEntityList);
    } on GraphQLException catch (e) {
      return Left(GraphQLFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, LaunchEntity>> fetchLaunchById(
      {required String id}) async {
    if (!await networkInfo.isConnected) {
      return const Left(
          InternetConnectionFailure(message: noInternetConnectionMessage));
    }

    try {
      final result = await graphQLService
          .executeQuery(getLaunchByIdQuery, variables: {'id': id});

      final launchData = result.data?['launch'];
      if (launchData == null) {
        return const Left(DataNotFoundFailure(message: "Launch not found"));
      }

      final launchModel = LaunchModel.fromJson(launchData);

      final launchEntity = launchModel.toEntity();

      return Right(launchEntity);
    } on GraphQLException catch (e) {
      return Left(GraphQLFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<LaunchEntity>>> fetchLaunches() async {
    if (!await networkInfo.isConnected) {
      return const Left(
          InternetConnectionFailure(message: noInternetConnectionMessage));
    }

    try {
      final result = await graphQLService.executeQuery(getLaunchesQuery);

      final launchesData = result.data?['launches'] as List<dynamic>?;
      if (launchesData!.isEmpty) {
        return const Left(DataNotFoundFailure(message: "Launches not found"));
      }

      final launcheModelList = launchesData
          .map((json) => LaunchModel.fromJson(json as Map<String, dynamic>))
          .toList();

      final launcheEntityList = launcheModelList.map((e) => e.toEntity()).toList();

      return Right(launcheEntityList);
    } on GraphQLException catch (e) {
      return Left(GraphQLFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, RocketEntity>> fetchRocketById({required String id}) async {
     if (!await networkInfo.isConnected) {
      return const Left(
          InternetConnectionFailure(message: noInternetConnectionMessage));
    }

    try {
      final result = await graphQLService
          .executeQuery(getRocketByIdQuery, variables: {'id': id});

      final rocketData = result.data?['rocket'];
      if (rocketData == null) {
        return const Left(DataNotFoundFailure(message: "Rocket not found"));
      }

      final rocketModel = RocketModel.fromJson(rocketData);

      final rocketEntity = rocketModel.toEntity();

      return Right(rocketEntity);
    } on GraphQLException catch (e) {
      return Left(GraphQLFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<RocketEntity>>> fetchRockets() async {
    if (!await networkInfo.isConnected) {
      return const Left(
          InternetConnectionFailure(message: noInternetConnectionMessage));
    }

    try {
      final result = await graphQLService.executeQuery(getRocketsQuery);

      final rocketsData = result.data?['rockets'] as List<dynamic>?;
      if (rocketsData!.isEmpty) {
        return const Left(DataNotFoundFailure(message: "Rockets not found"));
      }

      final rocketModelList = rocketsData
          .map((json) => RocketModel.fromJson(json as Map<String, dynamic>))
          .toList();

      final rocketEntityList = rocketModelList.map((e) => e.toEntity()).toList();

      return Right(rocketEntityList);
    } on GraphQLException catch (e) {
      return Left(GraphQLFailure(message: e.message));
    }
    
  }
}
