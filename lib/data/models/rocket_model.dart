import 'package:equatable/equatable.dart';
import 'package:spacex_flutter_app/domain/entities/rocket_entity.dart';

/// Data Model representing SpaceX Rocket
class RocketModel extends Equatable {
  const RocketModel({
    required this.id,
    required this.active,
    required this.boosters,
    required this.company,
    required this.costPerLaunch,
    required this.country,
    required this.description,
    required this.diameterInFeet,
    required this.diameterInMeters,
    required this.firstFlight,
    required this.heightInFeet,
    required this.heightInMeters,
    required this.massInKg,
    required this.massInLb,
    required this.name,
    required this.stages,
    required this.successRate,
    required this.type,
  });

  final String id;
  final String name;
  final String type;
  final bool active;
  final int stages;
  final int boosters;
  final int costPerLaunch;
  final int successRate;
  final double heightInFeet;
  final double heightInMeters;
  final double diameterInFeet;
  final double diameterInMeters;
  final int massInKg;
  final int massInLb;
  final DateTime firstFlight;
  final String description;
  final String company;
  final String country;

  /// Create a RocketModel from JSON Map
  factory RocketModel.fromJson(Map<String, dynamic> json) {
    return RocketModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      active: json['active'] as bool,
      stages: (json['stages'] as num).toInt(),
      boosters: (json['boosters'] as num).toInt(),
      costPerLaunch: (json['cost_per_launch'] as num).toInt(),
      successRate: (json['success_rate_pct'] as num).toInt(),
      country: json['country'] as String,
      company: json['company'] as String,
      description: json['description'] as String,
      heightInFeet: (json['height']['feet'] as num).toDouble(),
      heightInMeters: (json['height']['meters'] as num).toDouble(),
      diameterInFeet: (json['diameter']['feet'] as num).toDouble(),
      diameterInMeters: (json['diameter']['meters'] as num).toDouble(),
      massInKg: (json['mass']['kg'] as num).toInt(),
      massInLb: (json['mass']['lb'] as num).toInt(),
      firstFlight: DateTime.parse(json['first_flight']),
    );
  }

 /// Converts RocketModel to JSON Map
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'active': active,
        'stages': stages,
        'boosters': boosters,
        'cost_per_launch': costPerLaunch,
        'success_rate_pct': successRate,
        'country': country,
        'company': company,
        'description': description,
        'height': {
          'feet': heightInFeet,
          'meters': heightInMeters,
        },
        'diameter': {
          'feet': diameterInFeet,
          'meters': diameterInMeters,
        },
        'mass': {
          'kg': massInKg,
          'lb': massInLb,
        },
        'first_flight': firstFlight.toIso8601String(),
      };


  /// Converts RocketModel to RocketEntity
  /// This is used to pass data from the data layer to the domain layer
  RocketEntity toEntity() => RocketEntity(
        id: id,
        active: active,
        boosters: boosters,
        company: company,
        costPerLaunch: costPerLaunch,
        country: country,
        description: description,
        diameterInFeet: diameterInFeet,
        diameterInMeters: diameterInMeters,
        firstFlight: firstFlight,
        heightInFeet: heightInFeet,
        heightInMeters: heightInMeters,
        massInKg: massInKg,
        massInLb: massInLb,
        name: name,
        stages: stages,
        successRate: successRate,
        type: type,
      );

  @override
  List<Object?> get props => [
     id,
    name,
    type,
    active,
    stages,
    boosters,
    costPerLaunch,
    successRate,
    heightInFeet,
    heightInMeters,
    diameterInFeet,
    diameterInMeters,
    massInKg,
    massInLb,
    firstFlight,
    description,
    company,
    country
  ];
}
