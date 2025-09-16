import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_flutter_app/data/models/landpad_model.dart';
import 'package:spacex_flutter_app/domain/entities/landpad_entity.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  const testLandpadModel = LandpadModel(
    id: 'id',
    fullName: 'fullName',
    details: 'details',
    status: 'status',
  );

  const testLandpadEntity = LandpadEntity(
    id: 'id',
    fullName: 'fullName',
    details: 'details',
    status: 'status',
  );

   group('Landpad Model', () {
    test('fromJson should return a valid model when successful', () async {
      //arrange
      final jsonData = json.decode(fixture('landpads_data_response.json'))
          as Map<String, dynamic>;

      //act
      final result = LandpadModel.fromJson(jsonData['data']['landpads'][0]);

      //assert
      expect(result, isA<LandpadModel>());
      expect(result, equals(testLandpadModel));
    });

    test('toJson should return a valid Json containing the proper data', () async {
      //arrange
      final expectedJsonData =
          json.decode(fixture('landpads_data_response.json'))
              as Map<String, dynamic>;

      //act
      final result = testLandpadModel.toJson();

      //assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result, equals(expectedJsonData['data']['landpads'][0]));
    });
    
    test('toEntity should return a valid LandpadEntity containing the proper data', () async {
      //arrange & act
      final result = testLandpadModel.toEntity();

      //assert
      expect(result, isA<LandpadEntity>());
      expect(result, equals(testLandpadEntity));
    });
  });
}
