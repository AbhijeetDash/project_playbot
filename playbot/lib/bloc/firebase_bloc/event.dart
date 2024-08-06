part of 'bloc.dart';

abstract class FireEvent {}

class FireEventCreateRoom extends FireEvent {}

class FireEventJoinRoom extends FireEvent {
  final String roomID;

  FireEventJoinRoom({required this.roomID});
}