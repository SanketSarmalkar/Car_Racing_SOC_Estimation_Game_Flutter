import 'package:get/get.dart';
import 'package:mario_game/game/utils/soc_ocv_data.dart';

class SOCValueController extends GetxController {
  var soc = 100.0.obs;
  var terminalVoltage = 4.15.obs;
  final SOCDataList _socDataList = SOCDataList();

  double decreaseSOC() {
    soc.value -= 1;
    updateTerminalVoltage();
    return soc.value;
  }

  void updateTerminalVoltage() {
    terminalVoltage.value = _socDataList.getOCV(soc.value);
  }
}
