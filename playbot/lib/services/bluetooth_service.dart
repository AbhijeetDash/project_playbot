import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

abstract class BluetoothService {
  Future<bool> enableBluetooth();

  Future<bool> disableBluetooth();

  Future<BluetoothDiscoveryResult> scanDevices();

  Future<void> connectToDevice();
}

class BluetoothServiceImpl extends BluetoothService {
  @override
  Future<void> connectToDevice() async {
    try {} catch (e) {
      rethrow;
    }
  }

  @override
  Future<BluetoothDiscoveryResult> scanDevices() async {
    try {
      Stream<BluetoothDiscoveryResult> result = FlutterBluetoothSerial.instance.startDiscovery();
      // We only want to return the HC-05 Bluetooth module.
      return await result.firstWhere((discoveryResult) => discoveryResult.device.name == "HC-05");
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<bool> disableBluetooth() async {
    try {
      // Check if the ble is ON 
      BluetoothState state = await FlutterBluetoothSerial.instance.state;
      bool? disableStatus = false;
      if(state == BluetoothState.STATE_BLE_ON){
         disableStatus = await FlutterBluetoothSerial.instance.requestDisable();
         return disableStatus??false;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<bool> enableBluetooth() async {
     try {
      // Check if the ble is ON 
      BluetoothState state = await FlutterBluetoothSerial.instance.state;
      bool? disableStatus = false;
      if(state == BluetoothState.STATE_OFF){
         disableStatus = await FlutterBluetoothSerial.instance.requestEnable();
         return disableStatus??true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }
}
