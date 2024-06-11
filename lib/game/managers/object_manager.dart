import 'dart:math';

import 'package:flame/components.dart';
import 'package:get/get.dart';
import 'package:mario_game/game/managers/game_manager.dart';
import 'package:mario_game/game/car_race.dart';
import 'package:mario_game/game/managers/soc_value_controller.dart';
import 'package:mario_game/game/sprites/competitor.dart';

final Random _rand = Random();

class ObjectManager extends Component with HasGameRef<CarRace> {
  ObjectManager();

  @override
  void onMount() {
    super.onMount();

    //addEnemy(1);
    //_maybeAddEnemy();
  }

  double _timeSinceLastScoreIncrease = 0;
  double _timeSinceLastSOCDecrease = 0;
  final double _scoreIncreaseInterval = 1; // Interval in seconds
  final double _socDecreaseInterval = 2;
  SOCValueController _socValueController = Get.put(SOCValueController());

  @override
  void update(double dt) {
    // if (gameRef.gameManager.state == GameState.playing) {
    //   gameRef.gameManager.increaseScore();
    // }
    if (gameRef.gameManager.state == GameState.playing) {
      _timeSinceLastScoreIncrease += dt;
      _timeSinceLastSOCDecrease += dt;

      if (_timeSinceLastScoreIncrease >= _scoreIncreaseInterval) {
        //var score = gameRef.gameManager.increaseScore();
        //print("score: $score");
        _logScoreIncreaseTime();
        _timeSinceLastScoreIncrease = 0; // Reset the timer
        /*
          for each second a perticular amount of current is reliesed in the 
          motor circuit.
        */
      }
      if (_timeSinceLastSOCDecrease >= _socDecreaseInterval &&
          _socValueController.speed > 0) {
        //var soc = gameRef.gameManager.decreaseSOCCurrentInterpolation();
        //var soc = _socValueController.decreaseSOC();
        var soc = _socValueController.decreaseSOCTimeBased();
        _timeSinceLastSOCDecrease = 0;
        print("soc: $soc");
      }
    }

    //addEnemy(1);

    super.update(dt);
  }

  final Map<String, bool> specialPlatforms = {
    'enemy': false,
  };

  void enableSpecialty(String specialty) {
    specialPlatforms[specialty] = true;
  }

  void addEnemy(int level) {
    switch (level) {
      case 1:
        enableSpecialty('enemy');
    }
  }

  final List<EnemyPlatform> _enemies = [];
  void _maybeAddEnemy() {
    if (specialPlatforms['enemy'] != true) {
      return;
    }

    var currentX = (gameRef.size.x.floor() / 2).toDouble() - 50;

    var currentY =
        gameRef.size.y - (_rand.nextInt(gameRef.size.y.floor()) / 3) - 50;
    var enemy = EnemyPlatform(
      position: Vector2(
        currentX,
        currentY,
      ),
    );
    add(enemy);
    _enemies.add(enemy);
    _cleanupEnemies();
  }

  void _cleanupEnemies() {
    Future.delayed(
      const Duration(seconds: 4),
      () {
        _enemies.clear();
        Future.delayed(
          const Duration(seconds: 1),
          () {
            // _maybeAddEnemy(); removing enemies
          },
        );
      },
    );
  }

  void _logScoreIncreaseTime() {
    final DateTime now = DateTime.now();
    //print('Score increased at: $now');
  }
}
