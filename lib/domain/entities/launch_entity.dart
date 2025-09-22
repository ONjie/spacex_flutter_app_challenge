import 'package:equatable/equatable.dart';

class LaunchEntity extends Equatable {
  const LaunchEntity({
    required this.id,
    required this.details,
    required this.launchDateLocal,
    required this.missionName,
    required this.rocketName,
    required this.upcoming,
  });

  final String id;
  final String details;
  final DateTime launchDateLocal;
  final String missionName;
  final String rocketName;
  final bool upcoming;

  @override
  List<Object?> get props => [
        id,
        details,
        launchDateLocal,
        missionName,
        rocketName,
        upcoming
      ];

 static LaunchEntity dummyLaunch = LaunchEntity(
      id: '0',
      missionName: 'Loading...',
      rocketName: 'Rocket',
      upcoming: false,
      details: 'details',
      launchDateLocal: DateTime.now(),
    );
}
