class BatteryData {
  final double soc;
  final double voltage;

  BatteryData(this.soc, this.voltage);
}

class CurrentData {
  final double current;
  final double soc;

  CurrentData(this.current, this.soc);
}

class CurrentInterpolator {
  List<BatteryData> data = [
    BatteryData(28.3305613305613, 3.7317),
    BatteryData(28.3305613305613, 3.7320),
    BatteryData(28.3305613305613, 3.7322),
    BatteryData(28.3305613305613, 3.7324),
    BatteryData(29.3825363825364, 3.7341),
    BatteryData(29.9958419958420, 3.7371),
    BatteryData(30.9688149688150, 3.7238),
    BatteryData(31.9916839916840, 3.7412),
    BatteryData(32.7380457380457, 3.7467),
    BatteryData(33.3388773388773, 3.7378),
    BatteryData(34.9604989604990, 3.7514),
    BatteryData(35.5696465696466, 3.7498),
    BatteryData(35.8295218295218, 3.7568),
    BatteryData(36.5072765072765, 3.7575),
    BatteryData(37.1933471933472, 3.7684),
    BatteryData(37.6548856548856, 3.7755),
    BatteryData(39.3180873180873, 3.7811),
    BatteryData(39.7962577962578, 3.7818),
    BatteryData(40.1413721413721, 3.7856),
    BatteryData(41.7900207900208, 3.7846),
    BatteryData(42.6278586278586, 3.7989),
    BatteryData(43.1912681912682, 3.7980),
    BatteryData(43.3659043659044, 3.7951),
    BatteryData(44.2515592515592, 3.8013),
    BatteryData(44.7172557172557, 3.7978),
    BatteryData(45.3222453222453, 3.7895),
    BatteryData(46.9480249480249, 3.8098),
    BatteryData(47.5093555093555, 3.8125),
    BatteryData(47.8045738045738, 3.8071),
    BatteryData(49.8357588357588, 3.8212),
    BatteryData(50.3659043659044, 3.8217),
    BatteryData(50.6361746361746, 3.8226),
    BatteryData(51.0644490644491, 3.8294),
    BatteryData(51.5571725571726, 3.8165),
    BatteryData(52.2203742203742, 3.8190),
    BatteryData(54.1226611226611, 3.8367),
    BatteryData(54.2806652806653, 3.8367),
    BatteryData(54.9542619542619, 3.8409),
    BatteryData(56.2349272349272, 3.8415),
    BatteryData(57.3076923076923, 3.8499),
    BatteryData(57.8128898128898, 3.8578),
    BatteryData(57.8814968814969, 3.8541),
    BatteryData(58.7983367983368, 3.8615),
    BatteryData(59.3679833679834, 3.8531),
    BatteryData(59.6237006237006, 3.8474),
    BatteryData(61.5571725571726, 3.8703),
    BatteryData(61.8856548856549, 3.8739),
    BatteryData(62.0790020790021, 3.8652),
    BatteryData(64.3908523908524, 3.8858),
    BatteryData(64.5987525987526, 3.8834),
    BatteryData(65.1808731808732, 3.8903),
    BatteryData(65.2702702702703, 3.8863),
    BatteryData(65.9542619542620, 3.8932),
    BatteryData(66.7234927234927, 3.9029),
    BatteryData(68.5488565488566, 3.9021),
    BatteryData(68.8627858627859, 3.9203),
    BatteryData(69.4158004158004, 3.9192),
    BatteryData(70.2952182952183, 3.9139),
    BatteryData(71.6715176715177, 3.9340),
    BatteryData(72.1746361746362, 3.9485),
    BatteryData(72.4178794178794, 3.9431),
    BatteryData(73.2349272349272, 3.9498),
    BatteryData(73.7401247401247, 3.9551),
    BatteryData(73.6237006237006, 3.9451),
    BatteryData(75.7941787941788, 3.9687),
    BatteryData(76.2307692307692, 3.9731),
    BatteryData(76.4116424116424, 3.9859),
    BatteryData(78.2266112266112, 3.9819),
    BatteryData(78.7422037422037, 3.9920),
    BatteryData(73.7401247401247, 3.9551),
    BatteryData(73.6237006237006, 3.9451),
    BatteryData(73.6237006237006, 3.9451),
    BatteryData(75.7941787941788, 3.9687),
    BatteryData(75.7941787941788, 3.9687),
    BatteryData(76.2307692307692, 3.9731),
    BatteryData(76.2307692307692, 3.9731),
    BatteryData(76.4116424116424, 3.9859),
    BatteryData(76.4116424116424, 3.9859),
    BatteryData(78.2266112266112, 3.9819),
    BatteryData(78.2266112266112, 3.9819),
    BatteryData(78.7422037422037, 3.992),
    BatteryData(78.7422037422037, 3.992),
    BatteryData(79.3762993762994, 4.0024),
    BatteryData(79.3762993762994, 4.0024),
    BatteryData(79.4885654885655, 4.0011),
    BatteryData(79.4885654885655, 4.0011),
    BatteryData(80.3825363825364, 4.0085),
    BatteryData(80.3825363825364, 4.0085),
    BatteryData(80.977130977131, 4.0184),
    BatteryData(80.977130977131, 4.0184),
    BatteryData(81.8336798336798, 4.0174),
    BatteryData(81.8336798336798, 4.0174),
    BatteryData(82.8316008316008, 4.04),
    BatteryData(82.8316008316008, 4.04),
    BatteryData(83.5239085239085, 4.0501),
    BatteryData(83.5239085239085, 4.0501),
    BatteryData(84.029106029106, 4.0447),
    BatteryData(84.029106029106, 4.0447),
    BatteryData(85.5446985446985, 4.0599),
    BatteryData(85.5446985446985, 4.0599),
    BatteryData(86.0644490644491, 4.0557),
    BatteryData(86.0644490644491, 4.0557),
    BatteryData(86.3659043659044, 4.0693),
    BatteryData(86.3659043659044, 4.0693),
    BatteryData(86.966735966736, 4.065),
    BatteryData(86.966735966736, 4.065),
    BatteryData(87.6486486486487, 4.0798),
    BatteryData(87.6486486486487, 4.0798),
    BatteryData(88.0831600831601, 4.0863),
    BatteryData(88.0831600831601, 4.0863),
    BatteryData(89.6216216216216, 4.1005),
    BatteryData(89.6216216216216, 4.1005),
    BatteryData(90, 4.0943),
    BatteryData(90, 4.0943),
    BatteryData(90.3617463617464, 4.1042),
    BatteryData(90.3617463617464, 4.1042),
    BatteryData(91.8253638253638, 4.1083),
    BatteryData(91.8253638253638, 4.1083),
    BatteryData(92.6403326403326, 4.125),
    BatteryData(92.6403326403326, 4.125),
    BatteryData(93.1600831600832, 4.129),
    BatteryData(93.1600831600832, 4.129),
    BatteryData(93.2889812889813, 4.1253),
    BatteryData(93.2889812889813, 4.1253),
    BatteryData(94.1268191268191, 4.1378),
    BatteryData(94.1268191268191, 4.1378),
    BatteryData(94.5343035343035, 4.1368),
    BatteryData(94.5343035343035, 4.1368),
    BatteryData(95.0769230769231, 4.139),
    BatteryData(96.5987525987526, 4.1604),
    BatteryData(97.0748440748441, 4.159),
    BatteryData(97.3513513513514, 4.1609),
    BatteryData(99.2328482328482, 4.1855),
    BatteryData(99.7525987525988, 4.1904),
    BatteryData(100, 4.1929),
  ];

  List<CurrentData> currentData = [
    CurrentData(-0.1022, 28.3305613305613),
    CurrentData(0, 28.3305613305613),
    CurrentData(0, 28.3305613305613),
    CurrentData(0, 28.3305613305613),
    CurrentData(0, 28.3305613305613),
    CurrentData(0.7611, 28.3908523908524),
    CurrentData(-0.6845, 29.3825363825364),
    CurrentData(-0.1073, 29.9958419958420),
    CurrentData(-5.7952, 30.9688149688150),
    CurrentData(-0.6845, 31.9916839916840),
    CurrentData(-0.1047, 32.7380457380457),
    CurrentData(-4.25, 33.3388773388773),
    CurrentData(-2.1812, 34.9604989604990),
    CurrentData(-5.0316, 35.5696465696466),
    CurrentData(-2.0407, 35.8295218295218),
    CurrentData(-2.2629, 36.5072765072765),
    CurrentData(0.9195, 37.1933471933472),
    CurrentData(2.0867, 37.6548856548856),
    CurrentData(0.613, 39.3180873180873),
    CurrentData(-1.1698, 39.7962577962578),
    CurrentData(1.3792, 40.1413721413721),
    CurrentData(-2.4545, 41.7900207900208),
    CurrentData(0.0919, 42.6278586278586),
    CurrentData(-0.1022, 43.1912681912682),
    CurrentData(-1.6704, 43.3659043659044),
    CurrentData(-0.1022, 44.2515592515592),
    CurrentData(-1.8492, 44.7172557172557),
    CurrentData(-5.2078, 45.3222453222453),
    CurrentData(-0.1047, 46.9480249480249),
    CurrentData(-0.6845, 47.5093555093555),
    CurrentData(-0.1047, 49.8357588357588),
    CurrentData(-0.1022, 50.3659043659044),
    CurrentData(-0.9884, 51.0644490644491),
    CurrentData(-0.0996, 51.5571725571726),
    CurrentData(-1.5784, 52.2203742203742),
    CurrentData(-0.1737, 54.1226611226611),
    CurrentData(-0.2707, 54.2806652806653),
    CurrentData(-1.1034, 54.9542619542619),
    CurrentData(0.2784, 57.3076923076923),
    CurrentData(-0.1047, 57.8128898128898),
    CurrentData(-3.5962, 57.8814968814969),
    CurrentData(-4.7123, 59.3679833679834),
    CurrentData(0.258, 59.6237006237006),
    CurrentData(0.7918, 61.5571725571726),
    CurrentData(0.1584, 61.8856548856549),
    CurrentData(-0.4367, 62.0790020790021),
    CurrentData(-0.1047, 64.3908523908524),
    CurrentData(-0.1022, 64.5987525987526),
    CurrentData(3.0522, 65.1808731808732),
    CurrentData(-3.5962, 65.2702702702703),
    CurrentData(-4.7123, 65.9542619542620),
    CurrentData(6.1197, 66.7234927234927),
    CurrentData(-3.2488, 68.5488565488566),
    CurrentData(-0.9322, 68.8627858627859),
    CurrentData(0.0281, 69.4158004158004),
    CurrentData(-0.0434, 70.2952182952183),
    CurrentData(-1.9769, 71.6715176715177),
    CurrentData(-0.0996, 72.1746361746362),
    CurrentData(-2.646, 72.4178794178794),
    CurrentData(-0.59, 73.2349272349272),
    CurrentData(-0.0996, 73.7401247401247),
    CurrentData(-1.4737, 73.7941787941788),
    CurrentData(-0.0971, 75.7941787941788),
    CurrentData(-3.4736, 76.2307692307692),
    CurrentData(-2.4187, 76.4116424116424),
    CurrentData(-0.0945, 78.2266112266112),
    CurrentData(-2.4289, 78.7422037422037),
    CurrentData(-0.1022, 79.3762993762994),
    CurrentData(-0.5900, 79.4885654885655),
    CurrentData(-0.0996, 80.3825363825364),
    CurrentData(-1.4737, 80.9771309771310),
    CurrentData(-3.1415, 81.8336798336798),
    CurrentData(0, 82.8316008316008),
    CurrentData(-0.1022, 83.5239085239085),
    CurrentData(-0.1047, 84.0291060291060),
    CurrentData(-2.4877, 85.5446985446985),
    CurrentData(-2.1735, 86.0644490644491),
    CurrentData(-6.2243, 86.3659043659044),
    CurrentData(0.0587, 86.9667359667360),
    CurrentData(-4.1249, 87.6486486486487),
    CurrentData(-0.2171, 88.0831600831601),
    CurrentData(0.5261, 89.6216216216216),
    CurrentData(1.5836, 90),
    CurrentData(-3.5962, 90.3617463617464),
    CurrentData(-0.4061, 91.8253638253638),
    CurrentData(-0.332, 92.6403326403326),
    CurrentData(-0.0945, 93.1600831600832),
    CurrentData(-2.646, 93.2889812889813),
    CurrentData(-0.1022, 94.1268191268191),
    CurrentData(-1.9692, 94.5343035343035),
    CurrentData(-1.4737, 95.0769230769231),
    CurrentData(-0.0971, 96.5987525987526),
    CurrentData(-3.4736, 97.0748440748441),
    CurrentData(-2.4187, 97.3513513513514),
    CurrentData(-0.0945, 99.2328482328482),
    CurrentData(-0.0919, 99.7525987525988),
    CurrentData(-0.0766, 100),
  ];

  CurrentInterpolator();

  double getCurrent(double soc, double voltage) {
    // Find the BatteryData object with the given SOC and voltage
    BatteryData batteryDatum = data.firstWhere(
      (datum) => datum.soc == soc && datum.voltage == voltage,
    );

    if (batteryDatum != null) {
      // Find the corresponding current from CurrentData list
      CurrentData currentDatum = currentData.firstWhere(
        (datum) => datum.soc == soc,
      );

      if (currentDatum != null) {
        return currentDatum.current;
      }
    }

    // Return null if data for the given SOC and voltage is not found
    return -1.4;
  }
}
