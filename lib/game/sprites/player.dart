import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mario_game/game/car_race.dart';
import 'package:mario_game/game/managers/soc_value_controller.dart';

enum PlayerState {
  left,
  right,
  up,
  down,
  center,
}

class Player extends SpriteGroupComponent<PlayerState>
    with HasGameRef<CarRace>, KeyboardHandler, CollisionCallbacks {
  Player({
    required this.character,
    this.baseSpeed = 0, // 60 km/hr in m/s
    this.maxSpeed = 100, // 120 km/hr in m/s
    this.horizontalBaseSpeed = 100.0,
    this.verticalBaseSpeed = 0.4,
    this.acceleration = 2.78, // 10 km/hr/s in m/s^2
    this.deceleration = 2.78, // 10 km/hr/s in m/s^2
  }) : super(
          size: Vector2(79, 109),
          anchor: Anchor.center,
          priority: 1,
        );

  double baseSpeed;
  double maxSpeed;
  double acceleration;
  double deceleration;
  double horizontalBaseSpeed;
  double verticalBaseSpeed;
  double currentSpeed = 0;
  Character character;

  int _hAxisInput = 0;
  int _vAxisInput = 0;
  final int movingLeftInput = -1;
  final int movingRightInput = 1;
  final int movingUpInput = -1;
  final int movingDownInput = 1;
  Vector2 _velocity = Vector2.zero();

  final SOCValueController _socValueController = Get.put(SOCValueController());

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    await add(CircleHitbox());
    await _loadCharacterSprites();
    current = PlayerState.center;
  }

  @override
  void update(double dt) {
    if (gameRef.gameManager.isIntro || gameRef.gameManager.isGameOver) return;

    _velocity.x = _hAxisInput * horizontalBaseSpeed;

    if (_vAxisInput == movingUpInput) {
      currentSpeed += acceleration * dt;
      if (currentSpeed > maxSpeed) {
        currentSpeed = maxSpeed;
      }
    } else if (_vAxisInput == movingDownInput) {
      currentSpeed -= deceleration * dt;
      if (currentSpeed < baseSpeed) {
        currentSpeed = baseSpeed;
      }
    }

    _socValueController.speedUpdate(currentSpeed);

    _velocity.y = _vAxisInput * verticalBaseSpeed * currentSpeed;

    final double marioHorizontalCenter = size.x / 2;
    final double marioVerticalCenter = size.y / 2;

    if (position.x < marioHorizontalCenter) {
      position.x = gameRef.size.x - marioHorizontalCenter;
    }
    if (position.x > gameRef.size.x - marioHorizontalCenter) {
      position.x = marioHorizontalCenter;
    }
    if (position.y < marioVerticalCenter) {
      position.y = gameRef.size.y - marioVerticalCenter;
    }
    if (position.y > gameRef.size.y - marioVerticalCenter) {
      position.y = marioVerticalCenter;
    }

    position += _velocity * dt;

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    gameRef.onLose();
    return;
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;
    _vAxisInput = 0;

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      moveLeft();
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      moveRight();
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      moveUp();
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      moveDown();
    }

    return true;
  }

  void moveLeft() {
    _hAxisInput = 0;
    current = PlayerState.left;
    _hAxisInput += movingLeftInput;
  }

  void moveRight() {
    _hAxisInput = 0;
    current = PlayerState.right;
    _hAxisInput += movingRightInput;
  }

  void moveUp() {
    _vAxisInput = 0;
    current = PlayerState.up;
    _vAxisInput += movingUpInput;
  }

  void moveDown() {
    _vAxisInput = 0;
    current = PlayerState.down;
    _vAxisInput += movingDownInput;
  }

  void resetDirection() {
    _hAxisInput = 0;
    _vAxisInput = 0;
  }

  void reset() {
    _velocity = Vector2.zero();
    currentSpeed = baseSpeed;
    current = PlayerState.center;
  }

  void resetPosition() {
    position = Vector2(
      (gameRef.size.x - size.x) / 2,
      (gameRef.size.y - size.y) / 2,
    );
  }

  Future<void> _loadCharacterSprites() async {
    final left = await gameRef.loadSprite('game/${character.name}.png');
    final right = await gameRef.loadSprite('game/${character.name}.png');
    final up = await gameRef.loadSprite('game/${character.name}.png');
    final down = await gameRef.loadSprite('game/${character.name}.png');
    final center = await gameRef.loadSprite('game/${character.name}.png');

    sprites = <PlayerState, Sprite>{
      PlayerState.left: left,
      PlayerState.right: right,
      PlayerState.up: up,
      PlayerState.down: down,
      PlayerState.center: center,
    };
  }
}
