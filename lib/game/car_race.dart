import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:mario_game/game/managers/game_manager.dart';
import 'package:mario_game/game/sprites/player.dart';

enum Character {
  bmw,
  farari,
  lambo,
  tarzen,
  tata,
  tesla,
}

class CarRace extends FlameGame with HasCollisionDetection {
  final GameManager gameManager = GameManager();
  late Player player;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Create the world and camera
    final world = World();
    final cameraComponent = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = Vector2(800, 600)
      ..viewfinder.zoom = 1.0;

    add(world);
    add(cameraComponent);

    // Add player to world
    player = Player(
      character: gameManager.character,
    );
    add(player);
    cameraComponent.follow(player);

    // Add game manager and background
    world.add(gameManager);
    overlays.add('gameOverlay');
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameManager.isGameOver) return;
    if (gameManager.isIntro) {
      overlays.add('mainMenuOverlay');
      return;
    }
  }

  void initializeGameStart() {
    player.resetPosition();
    gameManager.reset();
    camera.follow(player);
    overlays.remove('mainMenuOverlay');
  }

  void onLose() {
    gameManager.state = GameState.gameOver;
    player.removeFromParent();
    FlameAudio.bgm.stop();
    overlays.add('gameOverOverlay');
  }

  void togglePauseState() {
    if (paused) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }

  void resetGame() {
    startGame();
    overlays.remove('gameOverOverlay');
  }

  void startGame() {
    initializeGameStart();
    gameManager.state = GameState.playing;
    overlays.remove('mainMenuOverlay');
  }
}

// class GameManager extends Component {
//   bool isGameOver = false;
//   bool isIntro = true;
//   void reset() {
//     isGameOver = false;
//     isIntro = false;
//   }
// }
