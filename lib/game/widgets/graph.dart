import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mario_game/game/utils/app_theme.dart';

// ignore: must_be_immutable
class LineChartSample9 extends StatefulWidget {
  final List<double> result;
  final List<double> xResult;
  final double upperBound;
  final double lowerBound;
  const LineChartSample9({
    super.key,
    required this.result,
    required this.xResult,
    required this.upperBound,
    required this.lowerBound,
  });

  @override
  State<LineChartSample9> createState() => _LineChartSample9State();
}

class _LineChartSample9State extends State<LineChartSample9> {
  // final spots = List.generate(101, (i) => (i - 50) / 10)
  dynamic spots;

  Widget bottomTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    spots = widget.xResult
        .map((x) => FlSpot(x, widget.result[widget.xResult.indexOf(x)]))
        .toList();

    if (value % 1 != 0) {
      return Container();
    }
    final style = TextStyle(
      color: AppColors.contentColorBlue,
      fontWeight: FontWeight.bold,
      fontSize: min(18, 18 * chartWidth / 300),
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(meta.formattedValue, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    final style = TextStyle(
      color: AppColors.contentColorYellow,
      fontWeight: FontWeight.bold,
      fontSize: min(18, 18 * chartWidth / 300),
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(meta.formattedValue, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 0,
        bottom: 12,
        right: 20,
        top: 20,
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    maxContentWidth: 100,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final textStyle = TextStyle(
                          color: touchedSpot.bar.gradient?.colors[0] ??
                              touchedSpot.bar.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        return LineTooltipItem(
                          '${touchedSpot.x}, ${touchedSpot.y.toStringAsFixed(2)}',
                          textStyle,
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                  getTouchLineStart: (data, index) => 0,
                ),
                lineBarsData: [
                  LineChartBarData(
                    color: AppColors.contentColorPink,
                    spots: spots,
                    isCurved: true,
                    isStrokeCapRound: true,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: false,
                    ),
                    dotData: FlDotData(show: true),
                  ),
                ],
                minY: widget.result.reduce(min),
                maxY: widget.result.reduce(max),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    axisNameWidget: const Text(
                      'solution',
                      style: TextStyle(
                        color: AppColors.contentColorYellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) =>
                            leftTitleWidgets(value, meta, constraints.maxWidth),
                        reservedSize: 56,
                        interval: (widget.result[widget.result.length - 1] -
                                widget.result[0]) /
                            10),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameWidget: const Text(
                      'Iteration',
                      style: TextStyle(
                        color: AppColors.contentColorBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) =>
                          bottomTitleWidgets(value, meta, constraints.maxWidth),
                      reservedSize: 36,
                      interval: 0.5,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: true,
                  horizontalInterval: (widget.result[widget.result.length - 1] -
                          widget.result[0]) /
                      10,
                  verticalInterval: (widget.xResult[widget.xResult.length - 1] -
                          widget.xResult[0]) /
                      10,
                  checkToShowHorizontalLine: (_) => true,
                  checkToShowVerticalLine: (_) => true,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppColors.contentColorYellow.withOpacity(1),
                    dashArray: [5, 10],
                    strokeWidth: 1,
                  ),
                  getDrawingVerticalLine: (_) => FlLine(
                    color: AppColors.contentColorBlue.withOpacity(1),
                    dashArray: [5, 10],
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                        color: AppColors.contentColorWhite, width: 1)),
              ),
            );
          },
        ),
      ),
    );
  }
}
