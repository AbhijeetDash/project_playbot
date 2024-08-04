import 'package:flutter_bloc/flutter_bloc.dart';

part  './event.dart';
part './state.dart';

class FirebaseBloc extends Bloc<FireEvent, FireState> {
  FirebaseBloc(super.initialState);
}