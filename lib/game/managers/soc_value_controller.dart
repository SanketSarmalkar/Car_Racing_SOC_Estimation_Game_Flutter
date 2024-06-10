import 'dart:math';

import 'package:flame/layers.dart';
import 'package:get/get.dart';
import 'package:mario_game/game/managers/matrix_multi.dart';
import 'package:mario_game/game/managers/soc_estimation_kalman_filter.dart';
import 'package:mario_game/game/utils/battery_circuit_model_data.dart';
import 'package:mario_game/game/utils/soc_ocv_data.dart';
import 'dart:math' as math;
import 'package:matrix2d/matrix2d.dart';

class SOCValueController extends GetxController {
  var soc = 100.0.obs;
  var terminalVoltage = 4.15.obs;
  var current = 0.0.obs;
  var speed = 0.0.obs;
  var estimatedSOC = 100.0.obs;
  final SOCEstimationEKF _socEstimationEKF = Get.put(SOCEstimationEKF());
  final SOCOCVData _sococvData = SOCOCVData();

  num decreaseSOC() {
    if (soc.value > 0) {
      soc.value -= 1 * 0.01 * speed.value;
      updateTerminalVoltage();
      current.value = terminalVoltage * speed.value * 0.4;
      estimatedSOC.value = _socEstimationEKF.estimatingSOCEKF(
          current.toDouble(), terminalVoltage.toDouble());
      return soc.value;
    }
    return 0;
  }

  num speedUpdate(double data) {
    speed.value = data;
    return speed.value;
  }

  void updateTerminalVoltage() {
    terminalVoltage.value = _socEstimationEKF
        .evaluatePolynomial(_sococvData.coefficients, soc.value / 100)
        .toDouble()
        .toPrecision(4);
  }
}
