import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playbot/bloc/bluetooth_bloc/bloc.dart';
import 'package:playbot/utilities/util_assets.dart';

import 'package:playbot/utilities/util_colors.dart';

class ConnectScreen extends StatefulWidget {
  final bool start;
  const ConnectScreen({super.key, this.start = true});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  late final BleBloc bleBloc;
  bool bleStateOn = false;
  bool showScanning = false;

  @override
  void initState() {
    bleBloc = context.read<BleBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PlayColors.backgroundWhite,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 80.0,
          ),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 10.0),
                borderRadius: BorderRadius.circular(100.0),
                color: PlayColors.backgroundYellow,
                image:
                    const DecorationImage(image: AssetImage(PlayAssets.robot))),
          ),
          const SizedBox(
            height: 30.0,
          ),
          BlocBuilder<BleBloc, BleState>(
            bloc: bleBloc,
            buildWhen: (oldState, newState) {
              return oldState.runtimeType != newState.runtimeType;
            },
            builder: (context, state) {
              if (state is BleEnableState) {
                bleStateOn = true;
              }

              if (state is BleDisableState) {
                bleStateOn = false;
              }

              if(state is BleScanResult){
                showScanning = false;
              }

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 12.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "ADMIN CONNECT",
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  if (bleStateOn) {
                                    // Add Bluetooth TurnOff event
                                    bleBloc.add(BleEventDisable());
                                  } else {
                                    bleBloc.add(BleEventEnable());
                                  }
                                },
                                icon: !bleStateOn
                                    ? const Icon(Icons.bluetooth_disabled)
                                    : const Icon(Icons.bluetooth),
                                iconSize: 24,
                              )
                            ],
                          ),
                          if (!showScanning) ...[
                            Text(
                              "Start looking for Playbot Card",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(letterSpacing: 2.0),
                            ),
                            const SizedBox(height: 12.0),
                            Row(
                              children: [
                                RawMaterialButton(
                                  onPressed: () {
                                    bleBloc.add(BleEventScan());
                                    showScanning = true;
                                  },
                                  fillColor: PlayColors.buttonOrange,
                                  elevation: 0.0,
                                  shape: const StadiumBorder(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 8.0),
                                    child: Text(
                                      "START SCAN",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0,
                                              color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                          if (showScanning)
                            const Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 40.0,
                                    child: Icon(
                                      Icons.bluetooth,
                                      size: 40,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 82.0,
                                    width: 82.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 10.0,
                                      color: PlayColors.buttonPurple,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12.0),
                        Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: PlayColors.buttonGreen,
                            borderRadius: BorderRadius.circular(12.0)
                          ),
                          child: const Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                            child: Text("CONECTED", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                          ),
                        )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
