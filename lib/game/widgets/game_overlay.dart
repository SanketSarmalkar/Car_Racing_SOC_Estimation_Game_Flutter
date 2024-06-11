import 'dart:io' show Platform;
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mario_game/game/car_race.dart';
import 'package:mario_game/game/widgets/soc_display.dart';
import 'widgets.dart';

class GameOverlay extends StatefulWidget {
  const GameOverlay(this.game, {super.key});

  final Game game;

  @override
  State<GameOverlay> createState() => GameOverlayState();
}

class GameOverlayState extends State<GameOverlay> {
  //final SOCValueController _socValueController = Get.put(SOCValueController());
  bool isPaused = false;
  final bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  final Game game = CarRace();
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Positioned(
          //   top: 30,
          //   left: 30,
          //   child: GameScoreDisplay(game: widget.game),
          // ),
          const Positioned(
            top: 30,
            left: 30,
            //child: Obx(() => Text("${_socValueController.soc}")),
            child: SOCValueDisplay(),
          ),
          Positioned(
            top: 30,
            right: 30,
            child: Column(
              children: [
                ElevatedButton(
                  child: isPaused
                      ? const Icon(
                          Icons.play_arrow,
                          size: 48,
                        )
                      : const Icon(
                          Icons.pause,
                          size: 48,
                        ),
                  onPressed: () {
                    (widget.game as CarRace).togglePauseState();
                    setState(
                      () {
                        isPaused = !isPaused;
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                IconButton(
                    icon: const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 48,
                    ),
                    onPressed: () {
                      (widget.game as CarRace).togglePauseState();
                      Get.defaultDialog(
                        onCancel: () {
                          (widget.game as CarRace).togglePauseState();
                        },
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        title: 'About',
                        titlePadding: const EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                        ),
                        titleStyle: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleLarge!.fontSize,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        content: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'The goal of this project is to develop a system that estimates the battery current for specific values of State of Charge (SOC) and voltage using interpolation techniques. This system is useful for applications requiring precise battery management and monitoring, such as electric vehicles, renewable energy storage systems, and portable electronics.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Developer: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Sanket S.Sarmalkar',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
          // if (isMobile)
          Positioned(
            bottom: 10,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24),
                        child: GestureDetector(
                          onTapDown: (details) {
                            (widget.game as CarRace).player.moveLeft();
                          },
                          onTapUp: (details) {
                            (widget.game as CarRace).player.resetDirection();
                          },
                          child: Material(
                            color: Colors.transparent,
                            elevation: 3.0,
                            shadowColor:
                                Theme.of(context).colorScheme.background,
                            child: const Icon(Icons.arrow_left, size: 64),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 24),
                        child: GestureDetector(
                          onTapDown: (details) {
                            (widget.game as CarRace).player.moveRight();
                          },
                          onTapUp: (details) {
                            (widget.game as CarRace).player.resetDirection();
                          },
                          child: Material(
                            color: Colors.transparent,
                            elevation: 3.0,
                            shadowColor:
                                Theme.of(context).colorScheme.background,
                            child: const Icon(Icons.arrow_right, size: 64),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const WhiteSpace(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          if (isPaused)
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 72.0,
              right: MediaQuery.of(context).size.width / 2 - 72.0,
              child: const Icon(
                Icons.pause_circle,
                size: 144.0,
                color: Colors.black12,
              ),
            ),
        ],
      ),
    );
  }
}
