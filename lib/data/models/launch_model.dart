import 'package:equatable/equatable.dart';
import 'package:spacex_flutter_app/domain/entities/launch_entity.dart';


/// Data Model representing SpaceX Launch

class LaunchModel extends Equatable {
  const LaunchModel({
    required this.id,
    required this.details,
    required this.launchDateLocal,
    required this.launchYear,
    required this.missionName,
    required this.rocketName,
    required this.rocketType,
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


   /// Create a LaunchModel from JSON Map
  factory LaunchModel.fromJson(Map<String, dynamic> json) => LaunchModel(
        id: json['id'] as String,
        details: json['details'] ?? 'No details available',
        launchDateLocal: DateTime.parse(json['launch_date_local']),
        launchYear: json['launch_year'] as String,
        missionName: json['mission_name'] as String,
        rocketName: json['rocket']['rocket_name'] as String,
        rocketType: json['rocket']['rocket_type'] as String,
        upcoming: json['upcoming'] as bool,
      );


  /// Converts LaunchModel to JSON Map
  Map<String, dynamic> toJson() => {
        "id": id,
        "details": details,
        "launch_date_local": launchDateLocal.toIso8601String(),
        "launch_year": launchYear,
        "mission_name": missionName,
        "upcoming": upcoming,
        "rocket": {"rocket_name": rocketName, "rocket_type": rocketType}
      };


  /// Converts LaunchModel to LaunchEntity
  /// This is used to pass data from the data layer to the domain layer
  LaunchEntity toEntity() => LaunchEntity(
        id: id,
        details: details,
        launchDateLocal: launchDateLocal,
        launchYear: launchYear,
        missionName: missionName,
        rocketType: rocketType,
        rocketName: rocketName,
        upcoming: upcoming,
      );

  @override
  List<Object?> get props => [
        id,
        details,
        launchDateLocal,
        launchYear,
        missionName,
        rocketType,
        rocketName,
        upcoming,
      ];
}
