import 'dart:math';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flame/layers.dart';
import 'package:get/get.dart';
import 'package:mario_game/game/managers/current_interpolation.dart';
import 'package:mario_game/game/managers/matrix_multi.dart';
import 'package:mario_game/game/managers/soc_estimation_kalman_filter.dart';
import 'package:mario_game/game/utils/battery_circuit_model_data.dart';
import 'package:mario_game/game/utils/soc_ocv_data.dart';
import 'package:mario_game/game/utils/time_based_sampling.dart';
import 'dart:math' as math;
import 'package:matrix2d/matrix2d.dart';
import 'package:csv/csv.dart';

class SOCValueController extends GetxController {
  var soc = 100.0.obs;
  var terminalVoltage = 4.15.obs;
  var current = 0.0.obs;
  var speed = 0.0.obs;
  var estimatedSOC = 100.0.obs;
  var iteration = 1.obs;
  //List<List<dynamic>> data = [];

  var data = [].obs;
  void dataFromCsv(List<List<dynamic>> data) {
    data = data;
  }

  final SOCEstimationEKF _socEstimationEKF = Get.put(SOCEstimationEKF());
  final SOCOCVData _sococvData = SOCOCVData();
  final CurrentInterpolator _currentInterpolator = CurrentInterpolator();
  final TimeBasedSampling _timeBasedSampling = TimeBasedSampling();

  num decreaseSOC() {
    if (soc.value > 0) {
      soc.value -= 1 * 0.01 * speed.value;
      updateTerminalVoltage();
      current.value = -terminalVoltage * speed.value * 0.01;
      //current.value =
      //_currentInterpolator.getCurrent(soc.value, terminalVoltage.value);
      estimatedSOC.value = _socEstimationEKF.estimatingSOCEKF(
          current.toDouble(), terminalVoltage.toDouble());
      return soc.value;
    }
    return 0;
  }

  num decreaseSOCCurrentInterpolationMethod() {
    if (soc.value > 0) {
      soc.value -= 1 * 0.01 * speed.value;
      updateTerminalVoltage();
      current.value = -terminalVoltage * speed.value * 0.01;
      current.value =
          _currentInterpolator.getCurrent(soc.value, terminalVoltage.value);
      estimatedSOC.value = _socEstimationEKF.estimatingSOCEKF(
          current.toDouble(), terminalVoltage.toDouble());
      return soc.value;
    }
    return 0;
  }

  Future<num> decreaseSOCTimeBased() async {
    //TimeBasedData dataSample = _timeBasedSampling.data[iteration.value];

    final myData = await rootBundle.loadString("assets/downsampledData.csv");
    data.value = await const CsvToListConverter().convert(myData);
    List<dynamic> dataSample = data[iteration.value];

    // // Calculate the rate of change of speed
    // double previousSpeed = speed.value;
    // double rateOfChange = speed.value - previousSpeed;

    // Increase the iteration value based on the rate of change of speed
    iteration.value += (speed.value * 1).toInt();

    print(dataSample[1]);
    soc.value = dataSample[0];
    print(dataSample[0]);
    print(soc.value);
    current.value = dataSample[2];
    terminalVoltage.value = dataSample[1];
    estimatedSOC.value = _socEstimationEKF.estimatingSOCEKF(
        current.toDouble(), terminalVoltage.toDouble());
    iteration.value++;

    return soc.value;
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
