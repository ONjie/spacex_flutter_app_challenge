import 'package:equatable/equatable.dart';

class LaunchEntity extends Equatable {
  const LaunchEntity({
    required this.id,
    required this.details,
    required this.launchDateLocal,
    required this.launchYear,
    required this.missionName,
    required this.rocketType,
    required this.rocketName,
    required this.upcoming,
  });

  final String id;
  final String details;
  final DateTime launchDateLocal;
  final String launchYear;
  final String missionName;
  final String rocketType;
  final String rocketName;
  final bool upcoming;

  @override
  List<Object?> get props => [
        id,
        details,
        launchDateLocal,
        launchYear,
        missionName,
        rocketType,
        rocketName,
        upcoming
      ];
}
