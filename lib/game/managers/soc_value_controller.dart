import 'package:get/get.dart';
import 'package:mario_game/game/managers/soc_estimation_kalman_filter.dart';
import 'package:mario_game/game/utils/soc_ocv_data.dart';
import 'dart:math' as math;

class SOCValueController extends GetxController {
  var soc = 100.0.obs;
  var terminalVoltage = 4.15.obs;
  var current = 4.obs;
  var speed = 0.obs;
  final SOCDataList _socDataList = SOCDataList();
  final Interpolation _interpolation = Interpolation();

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

  List<double> differentiatePolynomial(List<double> coefficients) {
    List<double> derivativeCoefficients = [];
    int degree = coefficients.length - 1;
    for (int i = 0; i < degree; i++) {
      derivativeCoefficients.add(coefficients[i] * (degree - i));
    }

    return derivativeCoefficients;
  }

  double decreaseSOC() {
    if (soc.value > 0) {
      soc.value -= 1;
      updateTerminalVoltage();
      return soc.value;
    }
    return 0;
  }

  void updateTerminalVoltage() {
    //terminalVoltage.value = _socDataList.getOCV(soc.value);
    terminalVoltage.value =
        evaluatePolynomial(coefficients, soc.value / 100).toPrecision(3);
  }

  double SOC_Init = 1;
  List<double> X = [1, 0, 0];
  double DeltaT = 1;
  double Qn_rated = 4.81 * 3600;

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

  double interpolate(double x) {
    return _interpolation.linearInterpolation(FR0, x);
  }
}
