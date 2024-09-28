import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mario_game/game/car_race.dart';
import 'package:mario_game/game/managers/soc_value_controller.dart';

class BackGround extends ParallaxComponent<CarRace> {
  double backgroundSpeed = 2; // Initial speed value
  final SOCValueController _socValueController = Get.put(SOCValueController());

  @override
  FutureOr<void> onLoad() async {
    //if (_socValueController.data.isEmpty) await loadData();
    parallax = await game.loadParallax(
      [
        ParallaxImageData('game/road1.png'),
        ParallaxImageData('game/road1.png'),
      ],
      fill: LayerFill.width,
      repeat: ImageRepeat.repeat,
      baseVelocity: Vector2(0, -70 * backgroundSpeed.toDouble()),
      velocityMultiplierDelta: Vector2(0, 1.2 * backgroundSpeed),
    );

    _socValueController.speed.listen((p0) {
      backgroundSpeed = p0.toDouble();
      parallax!.baseVelocity = Vector2(0, -70 * backgroundSpeed.toDouble());
      //parallax!.velocityMultiplierDelta = Vector2(0, 1.2*backgroundSpeed);
    });
  }
}
