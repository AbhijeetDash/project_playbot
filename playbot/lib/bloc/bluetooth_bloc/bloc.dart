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
      print(e);
      rethrow;
    }
  }

  Future<void> _handleScanEvent(
    BleEventScan event,
    Emitter emit,
  ) async {
    try {
      final Stream<BluetoothDiscoveryResult> scanStream =
          await service.scanDevices();

      emit(BleScanStart());

      // Listen to scan
      await scanStream
          .firstWhere((test) => test.device.name!.contains("HC-05"))
          .then((device) {
            // The stream found a match.. 
            // Emit success case.
            emit(BleScanResult(devices: device, isSuccess: true));
          })
          .onError((error, st) {
            // No match found and scan is completed..
            // Emit error case.
            emit(BleScanResult(isSuccess: false));
          });
      return;
    } catch (e) {
      rethrow;
    }
  }
}
