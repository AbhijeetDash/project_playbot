import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:playbot/application/application.dart';
import 'package:playbot/models/enums.dart';
import 'package:playbot/services/bluetooth_service.dart';

part './event.dart';
part './state.dart';

class BleBloc extends Bloc<BleEvent, BleState> {
  final service = locator.get<BluetoothService>();

  BleBloc(super.initialState) {
    on<BleEventEnable>(_handleEnableEvent);
    on<BleEventDisable>(_handleDisableEvent);
    on<BleEventScan>(_handleScanEvent);
  }

  Future<void> _handleEnableEvent(
    BleEventEnable event,
    Emitter emit,
  ) async {
    try {
      bool res = await service.enableBluetooth();      
      if(res) {
        emit(BleEnableState());
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _handleDisableEvent(
    BleEventDisable event,
    Emitter emit,
  ) async {
    try {
      bool res = await service.disableBluetooth();
      if (res) {
        emit(BleDisableState());
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> _handleScanEvent(
    BleEventScan event,
    Emitter emit,
  ) async {
    try {
      final BluetoothDiscoveryResult discoveryResult =
          await service.scanDevices();
      emit(BleScanResult(devicesList: discoveryResult, discoveryState: PlayDiscoveryState.deviceFound));
    } catch (e) {
      rethrow;
    }
  }
}
