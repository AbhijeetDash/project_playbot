import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

abstract class BluetoothService {
  Future<bool> enableBluetooth();

  Future<bool> disableBluetooth();

  Future<Stream<BluetoothDiscoveryResult>> scanDevices();

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
  Future<Stream<BluetoothDiscoveryResult>> scanDevices() async {
    try {
      Stream<BluetoothDiscoveryResult> result = FlutterBluetoothSerial.instance.startDiscovery();
      return result;
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
