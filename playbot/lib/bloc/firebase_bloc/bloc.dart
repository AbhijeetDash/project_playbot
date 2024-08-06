import 'package:flutter_bloc/flutter_bloc.dart';

part  './event.dart';
part './state.dart';

class FirebaseBloc extends Bloc<FireEvent, FireState> {
  FirebaseBloc(super.initialState){
    on<FireEventCreateRoom>(_handleCreateRoomEvent);
    on<FireEventJoinRoom>(_handleJoinRoomEvent);
  }

  Future<void> _handleCreateRoomEvent(FireEventCreateRoom event, Emitter emit) async {}

  Future<void> _handleJoinRoomEvent(FireEventJoinRoom event, Emitter emit) async {}
}