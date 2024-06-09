import 'dart:math';

import 'package:flame/layers.dart';
import 'package:get/get.dart';
import 'package:mario_game/game/managers/soc_estimation_kalman_filter.dart';
import 'package:mario_game/game/utils/soc_ocv_data.dart';
import 'dart:math' as math;
import 'package:matrix2d/matrix2d.dart';

class SOCValueController extends GetxController {
  var soc = 100.0.obs;
  var terminalVoltage = 4.15.obs;
  var current = 0.0.obs;
  var speed = 60.0.obs;
  //final SOCDataList _socDataList = SOCDataList();
  final Interpolation _interpolation = Interpolation();
  final Matrix2d m2d = const Matrix2d();

  static const List<double> coefficients = [
    -1.67005725550949,
    149.333081034388,
    -1819.65645688542,
    12747.9448271829,
    -57066.7661703343,
    172000.758360604,
    -357316.529440401,
    512996.045847065,
    -499926.362296817,
    315556.874766604,
    -116311.086920594,
    18995.3152597971,
  ];

  List<double> derCoefficients = [
    208948.467857768,
    -1163110.86920594,
    2840011.87289944,
    -3999410.89837454,
    3590972.32092945,
    -2143899.17664241,
    860003.791803021,
    -228267.064681337,
    38243.8344815488,
    -3639.31291377084,
    149.333081034388
  ];

  double evaluatePolynomial(List<double> coeffs, double x) {
    double result = 0.0;
    for (int i = 0; i < coeffs.length; i++) {
      result += coeffs[i] * math.pow(x, i);
    }
    return result;
  }

  double differentiatePolynomial(List<double> coeffs, double x) {
    // List<double> derivativeCoefficients = [];
    // int degree = coefficients.length - 1;
    // for (int i = 0; i < degree; i++) {
    //   derivativeCoefficients.add(coefficients[i] * (degree - i));
    // }

    // return derivativeCoefficients;
    double result = 0.0;
    for (int i = 0; i < coeffs.length; i++) {
      result += coeffs[i] * math.pow(x, i);
    }
    return result;
  }

  double decreaseSOC() {
    if (soc.value > 0) {
      soc.value -= 1 * 0.1 * speed.value;
      updateTerminalVoltage();
      current.value = terminalVoltage * speed.value * 0.1;
      // await estimatingSOCEKF(current.toDouble(), terminalVoltage.toDouble());
      return soc.value;
    }
    return 0;
  }

  double speedUpdate(double data) {
    speed.value = data;
    return speed.value;
  }

  void updateTerminalVoltage() {
    //terminalVoltage.value = _socDataList.getOCV(soc.value);
    terminalVoltage.value =
        evaluatePolynomial(coefficients, soc.value / 100).toPrecision(3);
  }

  //double SOC_Init = 1;
  List<dynamic> X = [1, 0, 0];
  double deltaT = 1;
  double qnRated = 4.81 * 3600;

  List<DataPoint> FR0 = [
    DataPoint(0.00508583000000000, 0.00472931000000000),
    DataPoint(0.0773343040000000, 0.00170683700000000),
    DataPoint(0.212933763000000, 0.00242513800000000),
    DataPoint(0.262179829000000, 0.00175909500000000),
    DataPoint(0.413139091000000, 0.00194551100000000),
    DataPoint(0.520390223000000, 0.00172803000000000),
    DataPoint(0.636951682000000, 0.00165792900000000),
    DataPoint(0.762809801000000, 0.00175219900000000),
    DataPoint(0.887624617000000, 0.00177816100000000),
    DataPoint(0.994787581000000, 0.00173402900000000),
  ];

  List<DataPoint> FR1 = [
    DataPoint(0.00508583000000000, 0.000536040000000000),
    DataPoint(0.0773343040000000, 0.000504197000000000),
    DataPoint(0.212933763000000, 0.000514078000000000),
    DataPoint(0.262179829000000, 0.000528667000000000),
    DataPoint(0.413139091000000, 0.000490667000000000),
    DataPoint(0.520390223000000, 0.000541283000000000),
    DataPoint(0.636951682000000, 0.000528384000000000),
    DataPoint(0.762809801000000, 0.000512774000000000),
    DataPoint(0.887624617000000, 0.000517860000000000),
    DataPoint(0.994787581000000, 0.000515144000000000),
  ];

  List<DataPoint> FR2 = [
    DataPoint(0.00508583000000000, 0.000535684000000000),
    DataPoint(0.0773343040000000, 0.000491060000000000),
    DataPoint(0.212933763000000, 0.000507067000000000),
    DataPoint(0.262179829000000, 0.000517108000000000),
    DataPoint(0.413139091000000, 0.000511585000000000),
    DataPoint(0.520390223000000, 0.000510458000000000),
    DataPoint(0.636951682000000, 0.000509100000000000),
    DataPoint(0.762809801000000, 0.000500386000000000),
    DataPoint(0.887624617000000, 0.000530881000000000),
    DataPoint(0.994787581000000, 0.000515451000000000),
  ];

  List<DataPoint> FC1 = [
    DataPoint(0.00508583000000000, 16732.1533700000),
    DataPoint(0.0773343040000000, 19566.1835700000),
    DataPoint(0.212933763000000, 20344.3909000000),
    DataPoint(0.262179829000000, 19175.1408400000),
    DataPoint(0.413139091000000, 20262.9483700000),
    DataPoint(0.520390223000000, 18447.2954300000),
    DataPoint(0.636951682000000, 19359.4526900000),
    DataPoint(0.762809801000000, 19619.1726000000),
    DataPoint(0.887624617000000, 19398.0021900000),
    DataPoint(0.994787581000000, 19575.5618300000),
  ];

  List<DataPoint> FC2 = [
    DataPoint(0.00508583000000000, 171880.451300000),
    DataPoint(0.0773343040000000, 206799.805500000),
    DataPoint(0.212933763000000, 198967.001100000),
    DataPoint(0.262179829000000, 193859.604500000),
    DataPoint(0.413139091000000, 203644.783700000),
    DataPoint(0.520390223000000, 195065.148200000),
    DataPoint(0.636951682000000, 196021.275700000),
    DataPoint(0.762809801000000, 192824.039700000),
    DataPoint(0.887624617000000, 189488.815700000),
    DataPoint(0.994787581000000, 199163.882300000),
  ];

  double interpolate(List<DataPoint> fR0, double x) {
    return _interpolation.linearInterpolation(fR0, x);
  }

  List nX = [3];

  // Example matrices
  List<dynamic> rX = [2.5e-5];
  List<dynamic> pX = [
    [0.025, 0, 0],
    [0, 0.01, 0],
    [0, 0, 0.01],
  ];
  List<dynamic> qX = [
    [1.0e-6, 0, 0],
    [0, 1.0e-5, 0],
    [0, 0, 1.0e-5],
  ];

  var soc_estimated = 1.0;
  var vt_estimated = 4.15;
  dynamic vt_error = 0.0;

  Future<void> estimatingSOCEKF(double current, double voltage) async {
    List<dynamic> u = [current];
    var soc = X[0];
    var v1 = X[1];
    var v2 = X[2];

    var r0 = interpolate(FR0, soc);
    var r1 = interpolate(FR1, soc);
    var r2 = interpolate(FR2, soc);
    var c1 = interpolate(FC1, soc);
    var c2 = interpolate(FC2, soc);

    var ocv = evaluatePolynomial(coefficients, soc);

    var tau1 = c1 * r1;
    var tau2 = c2 * r2;

    var a1 = exp(-deltaT / tau1);
    var a2 = exp(-deltaT / tau2);

    var b1 = r1 * (1 - exp(-deltaT / tau1));
    var b2 = r2 * (1 - exp(-deltaT / tau2));
    var measVoltage = ocv - r0 * u[0] - v1 - v2;

    var dOCV = differentiatePolynomial(derCoefficients, soc);

    List<dynamic> cX = [dOCV, -1, -1];

    vt_error = voltage - measVoltage;
    vt_estimated = measVoltage;
    soc_estimated = X[0];

    List<dynamic> a = [
      [1, 0, 0],
      [0, a1, 0],
      [0, 0, a2],
    ];

    List<dynamic> b = [-deltaT / qnRated, b1, b2];

    X = await m2d.addition(m2d.dot(a, X), m2d.dot(b, u));

    pX = await m2d.addition(m2d.dot(a, m2d.dot(pX, m2d.transpose(a))), qX);

    List d1 = await m2d.dot(pX, m2d.transpose(cX));

    List d2 = [1];
    List<dynamic> kalmanGain =
        await m2d.dot(d1, m2d.division(d2, m2d.addition(m2d.dot(cX, d1), rX)));

    X = await m2d.addition(X, m2d.dot(kalmanGain, vt_error));
    pX = await m2d.subtraction(
        m2d.dot(m2d.ones(3, 3), nX), m2d.dot(m2d.dot(kalmanGain, cX), pX));
  }
}
