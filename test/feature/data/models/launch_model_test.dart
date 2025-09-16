import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_flutter_app/data/models/launch_model.dart';
import 'package:spacex_flutter_app/domain/entities/launch_entity.dart';

import '../../../fixtures/fixture_reader.dart';

void main(){

  final testLaunchModel = LaunchModel(
    id: 'id',
    details: 'details',
    launchDateLocal: DateTime.parse('2025-09-15T13:40:44.563985'),
    launchYear: 'launchYear',
    missionName: 'missionName',
    rocketType: 'rocketType',
    rocketName: 'rocketName',
    upcoming: false,
  );

   final testLaunchEnity = LaunchEntity(
    id: 'id',
    details: 'details',
    launchDateLocal: DateTime.parse('2025-09-15T13:40:44.563985'),
    launchYear: 'launchYear',
    missionName: 'missionName',
    rocketType: 'rocketType',
    rocketName: 'rocketName',
    upcoming: false,
  );

  group('Launch Model', () {
    test('fromJson should return a valid model when successful', () async {
      //arrange
      final jsonData = json.decode(fixture('launches_data_response.json'))
          as Map<String, dynamic>;

      //act
      final result = LaunchModel.fromJson(jsonData['data']['launches'][0]);

      //assert
      expect(result, isA<LaunchModel>());
      expect(result, equals(testLaunchModel));
    });

    test('toJson should return a valid Json containing the proper data', () async {
      //arrange
      final expectedJsonData =
          json.decode(fixture('launches_data_response.json'))
              as Map<String, dynamic>;

      //act
      final result = testLaunchModel.toJson();

      //assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result, equals(expectedJsonData['data']['launches'][0]));
    });
    
    test('toEntity should return a valid LaunchEntity containing the proper data', () async {
      //arrange & act
      final result = testLaunchModel.toEntity();

      //assert
      expect(result, isA<LaunchEntity>());
      expect(result, equals(testLaunchEnity));
    });
  });
}