import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_flutter_app/data/models/rocket_model.dart';
import 'package:spacex_flutter_app/domain/entities/rocket_entity.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final testRocketModel = RocketModel(
    id: 'id',
    active: false,
    boosters: 1,
    company: 'company',
    costPerLaunch: 100,
    country: 'country',
    description: 'description',
    diameterInFeet: 2.0,
    diameterInMeters: 1.0,
    firstFlight: DateTime.parse('2025-09-15T13:40:44.563985'),
    heightInFeet: 11.0,
    heightInMeters: 10.0,
    massInKg: 20,
    massInLb: 30,
    name: 'name',
    stages: 1,
    successRate: 100,
    type: 'type',
  );

   final testRocketEntity = RocketEntity(
    id: 'id',
    active: false,
    boosters: 1,
    company: 'company',
    costPerLaunch: 100,
    country: 'country',
    description: 'description',
    diameterInFeet: 2.0,
    diameterInMeters: 1.0,
    firstFlight: DateTime.parse('2025-09-15T13:40:44.563985'),
    heightInFeet: 11.0,
    heightInMeters: 10.0,
    massInKg: 20,
    massInLb: 30,
    name: 'name',
    stages: 1,
    successRate: 100,
    type: 'type',
  );

  group('Rocket Model', () {
    test('fromJson should return a valid model when successful', () async {
      //arrange
      final jsonData = json.decode(fixture('rockets_data_response.json'))
          as Map<String, dynamic>;

      //act
      final result = RocketModel.fromJson(jsonData['data']['rockets'][0]);

      //assert
      expect(result, isA<RocketModel>());
      expect(result, equals(testRocketModel));
    });

    test('toJson should return a valid Json containing the proper data', () async {
      //arrange
      final expectedJsonData =
          json.decode(fixture('rockets_data_response.json'))
              as Map<String, dynamic>;

      //act
      final result = testRocketModel.toJson();

      //assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result, equals(expectedJsonData['data']['rockets'][0]));
    });
    
    test('toEntity should return a valid RocketEntity containing the proper data', () async {
      //arrange & act
      final result = testRocketModel.toEntity();

      //assert
      expect(result, isA<RocketEntity>());
      expect(result, equals(testRocketEntity));
    });
  });
}
