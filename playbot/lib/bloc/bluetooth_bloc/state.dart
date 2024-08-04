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

class BleScanResult extends BleState {
  final PlayDiscoveryState discoveryState;
  final BluetoothDiscoveryResult devicesList;

  BleScanResult({required this.devicesList, required this.discoveryState});

  @override
  List<Object?> get props => [discoveryState];
}
