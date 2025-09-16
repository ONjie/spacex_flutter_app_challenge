import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:spacex_flutter_app/data/models/capsule_model.dart';
import 'package:spacex_flutter_app/domain/entities/capsule_entity.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  const testCapsuleModel = CapsuleModel(
    id: 'id',
    reuseCount: 1,
    status: 'status',
    type: 'type',
  );

  const testCapsuleEntity = CapsuleEntity(
    id: 'id',
    reuseCount: 1,
    status: 'status',
    type: 'type',
  );


  group('Capsule Model', () {
    test('fromJson should return a valid model when successful', () async {
      //arrange
      final jsonData = json.decode(fixture('capsules_data_response.json'))
          as Map<String, dynamic>;

      //act
      final result = CapsuleModel.fromJson(jsonData['data']['capsules'][0]);

      //assert
      expect(result, isA<CapsuleModel>());
      expect(result, equals(testCapsuleModel));
    });

    test('toJson should return a valid Json containing the proper data', () async {
      //arrange
      final expectedJsonData =
          json.decode(fixture('capsules_data_response.json'))
              as Map<String, dynamic>;

      //act
      final result = testCapsuleModel.toJson();

      //assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result, equals(expectedJsonData['data']['capsules'][0]));
    });
    
    test('toEntity should return a valid CapsuleEntity containing the proper data', () async {
      //arrange & act
      final result = testCapsuleModel.toEntity();

      //assert
      expect(result, isA<CapsuleEntity>());
      expect(result, equals(testCapsuleEntity));
    });
  });
}
