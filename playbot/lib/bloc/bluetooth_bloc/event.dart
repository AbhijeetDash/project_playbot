part of 'bloc.dart';

abstract class BleEvent {}

class BleEventEnable extends BleEvent {}

class BleEventDisable extends BleEvent {}

class BleEventScan extends BleEvent {}

class BleEventConnect extends BleEvent {
  final BluetoothDevice device;

  BleEventConnect({required this.device});
}

class BleEventTXD extends BleEvent {}
