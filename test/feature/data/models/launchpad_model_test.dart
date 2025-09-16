import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_flutter_app/data/models/launchpad_model.dart';
import 'package:spacex_flutter_app/domain/entities/launchpad_entity.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  const testLaunchpadModel = LaunchpadModel(
    id: 'id',
    details: 'details',
    name: 'name',
    status: 'status',
    wikipedia: 'wikipedia',
  );

  const testLaunchpadEntity = LaunchpadEntity(
    id: 'id',
    details: 'details',
    name: 'name',
    status: 'status',
    wikipedia: 'wikipedia',
  );

  group('Launchpad Model', () {
    test('fromJson should return a valid model when successful', () async {
      //arrange
      final jsonData = json.decode(fixture('launchpads_data_response.json'))
          as Map<String, dynamic>;

      //act
      final result = LaunchpadModel.fromJson(jsonData['data']['launchpads'][0]);

      //assert
      expect(result, isA<LaunchpadModel>());
      expect(result, equals(testLaunchpadModel));
    });

    test('toJson should return a valid Json containing the proper data', () async {
      //arrange
      final expectedJsonData =
          json.decode(fixture('launchpads_data_response.json'))
              as Map<String, dynamic>;

      //act
      final result = testLaunchpadModel.toJson();

      //assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result, equals(expectedJsonData['data']['launchpads'][0]));
    });
    
    test('toEntity should return a valid LaunchpadEntity containing the proper data', () async {
      //arrange & act
      final result = testLaunchpadModel.toEntity();

      //assert
      expect(result, isA<LaunchpadEntity>());
      expect(result, equals(testLaunchpadEntity));
    });
  });
}
