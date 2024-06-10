import 'dart:math' as math;
import 'dart:math';

import 'package:get/get.dart';
import 'package:mario_game/game/managers/matrix_multi.dart';
import 'package:mario_game/game/utils/battery_circuit_model_data.dart';

class DataPoint {
  final double x;
  final double value;

  DataPoint(this.x, this.value);
}

class Interpolation {
  double linearInterpolation(List<DataPoint> dataPoints, num x) {
    int i = 0;
    while (i < dataPoints.length - 1 && dataPoints[i + 1].x < x) {
      i++;
    }

    if (i == 0) {
      return dataPoints[0].value;
    } else if (i == dataPoints.length - 1) {
      return dataPoints[dataPoints.length - 1].value;
    } else {
      double x0 = dataPoints[i].x;
      double x1 = dataPoints[i + 1].x;
      double y0 = dataPoints[i].value;
      double y1 = dataPoints[i + 1].value;

      return y0 + (y1 - y0) * (x - x0) / (x1 - x0);
    }
  }
}

class SOCEstimationEKF extends GetxController {
  final Interpolation _interpolation = Interpolation();
  final BatteryCircuitModelData _batteryCircuitModelData =
      BatteryCircuitModelData();
  final Matrix _matrix = Matrix();
  final SOCOCVData _sococvData = SOCOCVData();

  num evaluatePolynomial(List<num> coeffs, num x) {
    num result = 0.0;
    for (int i = 0; i < coeffs.length; i++) {
      result += coeffs[i] * math.pow(x, i);
    }
    return result;
  }

  num differentiatePolynomial(List<num> coeffs, num x) {
    num result = 0.0;
    for (int i = 0; i < coeffs.length; i++) {
      result += coeffs[i] * math.pow(x, i);
    }
    return result;
  }

  List<num> X = [1, 0, 0];
  num deltaT = 1;
  num qnRated = 4.81 * 3600;

  var pXStored = [
    [0.025, 0, 0],
    [0, 0.01, 0],
    [0, 0, 0.01],
  ].obs;

  num interpolate(List<DataPoint> fR0, num x) {
    return _interpolation.linearInterpolation(fR0, x);
  }

  int nX = 3;

  var rX = [2.5e-5].obs;
  var qX = [
    [1.0e-6, 0, 0],
    [0, 1.0e-5, 0],
    [0, 0, 1.0e-5],
  ].obs;

  var socEstimated = 1.0;
  var vtEstimated = 4.15;
  var vtError = 0.0;

  double estimatingSOCEKF(num current, num voltage) {
    num u = current;
    var soc = X[0];
    var v1 = X[1];
    var v2 = X[2];
    var r0 = interpolate(_batteryCircuitModelData.FR0, soc);
    var r1 = interpolate(_batteryCircuitModelData.FR1, soc);
    var r2 = interpolate(_batteryCircuitModelData.FR2, soc);
    var c1 = interpolate(_batteryCircuitModelData.FC1, soc);
    var c2 = interpolate(_batteryCircuitModelData.FC2, soc);

    var ocv = evaluatePolynomial(_sococvData.coefficients, soc);

    var tau1 = c1 * r1;
    var tau2 = c2 * r2;

    var a1 = exp(-deltaT / tau1);
    var a2 = exp(-deltaT / tau2);

    var b1 = r1 * (1 - exp(-deltaT / tau1));
    var b2 = r2 * (1 - exp(-deltaT / tau2));
    var measVoltage = ocv - r0 * u - v1 - v2;

    var dOCV = differentiatePolynomial(_sococvData.derCoefficients, soc);

    List<num> cX = [dOCV, -1, -1];

    vtError = (voltage - measVoltage).toDouble();
    vtEstimated = (measVoltage).toDouble();
    socEstimated = (X[0]).toDouble();

    List<List<num>> a = [
      [1, 0, 0],
      [0, a1, 0],
      [0, 0, a2],
    ];

    List<num> b = [-deltaT / qnRated, b1, b2];
    X = _matrix.add(_matrix.multiply(a, X), _matrix.dotMultiply(b, u));

    pXStored.value = _matrix.add(
        _matrix.multiply(a, _matrix.multiply(pXStored, _matrix.transpose(a))),
        qX);

    List<num> d1 = _matrix.add(
        _matrix.multiply(cX, _matrix.multiply(pXStored, _matrix.transpose(cX))),
        rX);
    List<num> kalmanGain =
        _matrix.dotMultiply(_matrix.multiply(cX, pXStored), 1 / d1[0]);

    X = _matrix.add(X, _matrix.dotMultiply(kalmanGain, vtError));

    pXStored.value = _matrix.subtract(_matrix.eye(nX),
        _matrix.multiply(_matrix.multiply(kalmanGain, cX), pXStored));
    return X[0].toDouble() * 100;
  }
}
