import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mario_game/game/car_race.dart';
import 'package:mario_game/game/managers/soc_value_controller.dart';
import 'package:speedometer_chart/speedometer_chart.dart';

class SOCValueDisplay extends StatefulWidget {
  const SOCValueDisplay({super.key});

  @override
  State<SOCValueDisplay> createState() => _SOCValueDisplayState();
}

class _SOCValueDisplayState extends State<SOCValueDisplay> {
  SOCValueController socValueController = Get.put(SOCValueController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.withOpacity(0.8),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SpeedometerChart(
              dimension: 200,
              minValue: 0,
              maxValue: 100,
              value: socValueController.soc.value.toDouble(),
              minTextValue: 'Min. 0',
              maxTextValue: 'Max. 100',
              graphColor: const [Colors.red, Colors.yellow, Colors.green],
              pointerColor: Colors.black,
              valueVisible: true,
              rangeVisible: true,
              title: 'SOC Estimation',
            ),
            Text("OCV : ${socValueController.terminalVoltage}"),
          ],
        ),
      ),
    );
    // return Obx(
    //   () => Text(socValueController.soc.value.toString()),
    // );
  }
}
