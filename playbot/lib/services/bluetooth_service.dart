import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

abstract class BluetoothService {
  Future<bool> enableBluetooth();

  Future<bool> disableBluetooth();

  Future<BluetoothDevice> scanDevices();

  Future<BluetoothConnection> connectToDevice(BluetoothDevice device);

  Future<BluetoothState> getBluetoothState();
}

class BluetoothServiceImpl extends BluetoothService {
  @override
  Future<BluetoothConnection> connectToDevice(BluetoothDevice device) async {
    try {
      // return the bluetooth connection
      // tobe used in inputs and outputs
      return await BluetoothConnection.toAddress(device.address);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BluetoothDevice> scanDevices() async {
    try {
      FlutterBluetoothSerial inst = FlutterBluetoothSerial.instance;
      Stream<BluetoothDiscoveryResult> result = inst.startDiscovery();
      BluetoothDiscoveryResult disco = await result.firstWhere((test) => (test.device.name != null && (test.device.name == "HC-05" || test.device.name!.contains("K2"))));
      // Stop the discovery as soon as device is found.
      inst.cancelDiscovery();
      return disco.device;
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
  
  @override
  Future<BluetoothState> getBluetoothState() {
    return FlutterBluetoothSerial.instance.state;
  }
}
