import 'package:equatable/equatable.dart';
import 'package:spacex_flutter_app/domain/entities/launchpad_entity.dart';


/// Data Model representing SpaceX Launchpad
class LaunchpadModel extends Equatable {
  const LaunchpadModel(
      {required this.id,
      required this.details,
      required this.name,
      required this.status,
      required this.wikipedia,});

  final String id;
  final String details;
  final String name;
  final String status;
  final String wikipedia;

   /// Create a LaunchpadModel from JSON Map
  factory LaunchpadModel.fromJson(Map<String, dynamic> json) => LaunchpadModel(
        id: json['id'] as String,
        details: json['details'] as String,
        name: json['name'] as String,
        status: json['status'] as String,
        wikipedia: json['wikipedia'] as String,
      );

  /// Converts LaunchpadModel to JSON Map
  Map<String, dynamic> toJson() => {
        "details": details,
        "id": id,
        "name": name,
        "status": status,
        "wikipedia": wikipedia
      };

  /// Converts LaunchpadModel to LaunchpadEntity
  /// This is used to pass data from the data layer to the domain layer
  LaunchpadEntity toEntity() => LaunchpadEntity(
      id: id,
      details: details,
      name: name,
      status: status,
      wikipedia: wikipedia,
      );

  @override
  List<Object?> get props => [id, details, name, status, wikipedia];
}
