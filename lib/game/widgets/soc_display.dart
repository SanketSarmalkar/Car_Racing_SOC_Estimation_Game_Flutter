import 'package:csv/csv.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final SOCValueController _socValueController = Get.put(SOCValueController());

  @override
  Widget build(BuildContext context) {
    //if (_socValueController.data.isEmpty) loadData();
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.withOpacity(0.8),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SpeedometerChart(
              dimension: 200,
              minValue: 0,
              maxValue: 100,
              value: _socValueController.soc.value.toDouble(),
              minTextValue: '0',
              maxTextValue: '100',
              graphColor: const [Colors.red, Colors.yellow, Colors.green],
              pointerColor: Colors.black,
              valueVisible: true,
              rangeVisible: true,
              title: 'SOC Estimation',
            ),
            Text('soc: ${_socValueController.soc}'),
            Text("OCV : ${_socValueController.terminalVoltage}"),
            Text("Speed: ${_socValueController.speed.toStringAsPrecision(4)}"),
            Text(
                "Current: ${_socValueController.current.toStringAsPrecision(4)}"),
            Text(
                "SOC Estimated: ${_socValueController.estimatedSOC.toStringAsPrecision(4)}"),
            Text(
                "Error: ${(_socValueController.soc.toDouble() - _socValueController.estimatedSOC.toDouble()).toPrecision(4)}")
          ],
        ),
      ),
    );
    // return Obx(
    //   () => Text(socValueController.soc.value.toString()),
    // );
  }
}
