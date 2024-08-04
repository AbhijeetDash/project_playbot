part of 'bloc.dart';

abstract class BleEvent {}

class BleEventEnable extends BleEvent {}

class BleEventDisable extends BleEvent {}

class BleEventScan extends BleEvent {}