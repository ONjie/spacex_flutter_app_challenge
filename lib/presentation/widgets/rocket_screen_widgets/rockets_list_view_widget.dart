import 'package:flutter/material.dart';
import 'package:spacex_flutter_app/domain/entities/rocket_entity.dart';
import 'package:spacex_flutter_app/presentation/widgets/rocket_screen_widgets/rocket_card_widget.dart';

class RocketsListViewWidget extends StatelessWidget {
  const RocketsListViewWidget({super.key, required this.rockets});

  final List<RocketEntity> rockets;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: rockets.length,
      itemBuilder: (context, index) {
        final rocket = rockets[index];
        return RocketCardWidget(rocket: rocket);
      },
    );
  }
}
