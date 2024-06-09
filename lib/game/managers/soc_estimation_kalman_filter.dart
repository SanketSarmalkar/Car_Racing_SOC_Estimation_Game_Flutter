import 'dart:math';

// Define a data point class to represent scattered data
class DataPoint {
  final double x;
  final double value;

  DataPoint(this.x, this.value);
}

class Interpolation {
  double linearInterpolation(List<DataPoint> dataPoints, double x) {
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
