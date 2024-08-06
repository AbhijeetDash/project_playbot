part of 'bloc.dart';

abstract class FireState {}

class FireStateInit extends FireState {}

class FireRoomState extends FireState {
  final String roomID;

  FireRoomState({required this.roomID}); 
}