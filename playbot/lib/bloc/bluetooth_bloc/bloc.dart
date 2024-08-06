import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:playbot/application/application.dart';
import 'package:playbot/services/bluetooth_service.dart';

part './event.dart';
part './state.dart';

class BleBloc extends Bloc<BleEvent, BleState> {
  final service = locator.get<BluetoothService>();

  BleBloc(super.initialState) {
    on<BleEventGetState>(_handleEventGetState);
    on<BleEventEnable>(_handleEnableEvent);
    on<BleEventDisable>(_handleDisableEvent);
    on<BleEventScan>(_handleScanEvent);
    on<BleEventConnect>(_handleConnectEvent);
  }

  Future<void> _handleEventGetState(
    BleEventGetState event,
    Emitter emit,
  ) async {
    try {
      BluetoothState state = await service.getBluetoothState();
      print(state.stringValue);
      emit(BleCurrentState(state: state));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _handleEnableEvent(
    BleEventEnable event,
    Emitter emit,
  ) async {
    try {
      bool res = await service.enableBluetooth();
      if (res) {
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
      rethrow;
    }
  }

  Future<void> _handleScanEvent(
    BleEventScan event,
    Emitter emit,
  ) async {
    try {
      // Check BleEnable Status
      BluetoothState state = await service.getBluetoothState();
      if (state == BluetoothState.STATE_OFF) {
        await service.enableBluetooth();
      }

      emit(BleScanStart());
      final BluetoothDevice device = await service.scanDevices();
      emit(BleScanResult(isSuccess: true, devices: device));
    } catch (e) {
      emit(BleScanResult(isSuccess: false));
      rethrow;
    }
  }

  Future<void> _handleConnectEvent(
    BleEventConnect event,
    Emitter emit,
  ) async {
    try {
      BluetoothConnection connection =
          await service.connectToDevice(event.device);
      emit(BleConnectSuccess(connection: connection));
    } catch (e) {
      rethrow;
    }
  }
}
