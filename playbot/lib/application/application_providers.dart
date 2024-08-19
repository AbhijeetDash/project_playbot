import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playbot/bloc/bluetooth_bloc/bloc.dart';

class PlaybotProviders extends StatelessWidget {
  final Widget child;
  const PlaybotProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<BleBloc>(create: (_) => BleBloc(BleStateInit()))
    ], child: child,);
  }
}
