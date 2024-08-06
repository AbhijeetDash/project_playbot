part of 'bloc.dart';

abstract class BleState extends Equatable {}

class BleStateInit extends BleState {
  @override
  List<Object?> get props => [];
}

class BleEnableState extends BleState {
  @override
  List<Object?> get props => [];
}

class BleDisableState extends BleState {
  @override
  List<Object?> get props => [];
}

class BleScanStart extends BleState {
  @override
  List<Object?> get props => [];
}

class BleScanResult extends BleState {
  final bool isSuccess;
  final BluetoothDevice? devices;

  BleScanResult({this.devices, required this.isSuccess});

  @override
  List<Object?> get props => [isSuccess, devices];
}

class BleConnectSuccess extends BleState {
  final BluetoothConnection connection;

  BleConnectSuccess({required this.connection});

  @override
  List<Object?> get props => [connection];
}