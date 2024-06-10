class BatteryData {
  final double time;
  final double speed;
  final double current;
  final double voltage;
  final double soc;
  final double powerDemand;

  BatteryData(this.time, this.speed, this.current, this.voltage, this.soc,
      this.powerDemand);

  @override
  String toString() {
    return 'Time: $time, Speed: $speed, Current: $current, Voltage: $voltage, SOC: $soc, PowerDemand: $powerDemand';
  }
}

class BatterySimulation {
  final List<BatteryData> data;

  BatterySimulation(this.data);

  BatteryData interpolate(double targetSpeed) {
    if (targetSpeed <= data.first.speed) {
      return data.first;
    }
    if (targetSpeed >= data.last.speed) {
      return data.last;
    }

    for (int i = 0; i < data.length - 1; i++) {
      if (targetSpeed >= data[i].speed && targetSpeed <= data[i + 1].speed) {
        final d0 = data[i];
        final d1 = data[i + 1];

        final double fraction =
            (targetSpeed - d0.speed) / (d1.speed - d0.speed);

        final double time = d0.time + fraction * (d1.time - d0.time);
        final double current =
            d0.current + fraction * (d1.current - d0.current);
        final double voltage =
            d0.voltage + fraction * (d1.voltage - d0.voltage);
        final double soc = d0.soc + fraction * (d1.soc - d0.soc);
        final double powerDemand =
            d0.powerDemand + fraction * (d1.powerDemand - d0.powerDemand);

        return BatteryData(
            time, targetSpeed, current, voltage, soc, powerDemand);
      }
    }

    throw ArgumentError('Speed out of range');
  }
}
