import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:spacex_flutter_app/core/network/graphql_client.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_capsules_by_pagination_use_case.dart';
import 'package:spacex_flutter_app/domain/use_cases/fetch_launches_by_pagination_use_case.dart';

import 'core/network/network_info.dart';
import 'data/repositories/space_x_repository_impl.dart';
import 'domain/repositories/space_x_repository.dart';
import 'domain/use_cases/fetch_capsule_by_id_use_case.dart';
import 'domain/use_cases/fetch_capsules_use_case.dart';
import 'domain/use_cases/fetch_launch_by_id_use_case.dart';
import 'domain/use_cases/fetch_launches_use_case.dart';
import 'domain/use_cases/fetch_rocket_by_id_use_case.dart';
import 'domain/use_cases/fetch_rockets_use_case.dart';
import 'presentation/providers/capsule_provider.dart';
import 'presentation/providers/launch_provider.dart';
import 'presentation/providers/rocket_provider.dart';

GetIt locator = GetIt.instance;

Future<void> initializeDependencyInjection() async {
  // Initializing dependency injections

  //registering Providers
  //rocketProvider
  locator.registerFactory(() => RocketProvider(
        fetchRocketsUseCase: locator(),
        fetchRocketByIdUseCase: locator(),
      ));

  //launchProvider
  locator.registerFactory(() => LaunchProvider(
      fetchLaunchesUseCase: locator(),
      fetchLaunchByIdUseCase: locator(),
      fetchLaunchesByPaginationUseCase: locator()));

  //CapsuleProvider
  locator.registerFactory(() => CapsuleProvider(
      fetchCapsulesUseCase: locator(),
      fetchCapsuleByIdUseCase: locator(),
      fetchCapsulesByPaginationUseCase: locator()));

  //registering UseCases
  //rocketUseCases
  locator.registerLazySingleton(
      () => FetchRocketsUseCase(spaceXRepository: locator()));
  locator.registerLazySingleton(
      () => FetchRocketByIdUseCase(spaceXRepository: locator()));

  //launchUseCases
  locator.registerLazySingleton(
      () => FetchLaunchesUseCase(spaceXRepository: locator()));
  locator.registerLazySingleton(
      () => FetchLaunchByIdUseCase(spaceXRepository: locator()));
  locator.registerLazySingleton(
      () => FetchLaunchesByPaginationUseCase(spaceXRepository: locator()));

  //capsuleUseCases
  locator.registerLazySingleton(
      () => FetchCapsulesUseCase(spaceXRepository: locator()));
  locator.registerLazySingleton(
      () => FetchCapsuleByIdUseCase(spaceXRepository: locator()));

  locator.registerLazySingleton(
      () => FetchCapsulesByPaginationUseCase(spaceXRepository: locator()));

  //registering Repositories
  locator.registerLazySingleton<SpaceXRepository>(() => SpaceXRepositoryImpl(
        networkInfo: locator(),
        graphQLService: locator(),
      ));

  ///registering networkInfo
  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker: locator()),
  );

  //registering InternetConnectionChecker
  locator.registerLazySingleton(
    () => InternetConnectionChecker.createInstance(),
  );

  // registering GraphQLService
  locator.registerLazySingleton(() => GraphQLService());
}
