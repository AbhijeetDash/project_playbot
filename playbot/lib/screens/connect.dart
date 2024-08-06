import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:playbot/bloc/bluetooth_bloc/bloc.dart';
import 'package:playbot/bloc/firebase_bloc/bloc.dart';
import 'package:playbot/utilities/util_assets.dart';

import 'package:playbot/utilities/util_colors.dart';

class ConnectScreen extends StatefulWidget {
  final bool start;
  const ConnectScreen({super.key, this.start = true});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  late BluetoothDevice device;
  late BluetoothConnection connection;
  late TextEditingController textController;
  late final BleBloc bleBloc;

  bool bleStateOn = false;
  bool showScanning = false;
  bool deviceFound = false;
  bool isConneted = false;

  @override
  void initState() {
    textController = TextEditingController();
    bleBloc = context.read<BleBloc>();
    super.initState();
  }

  void showConnectionSuccess() {
    final snackBar = SnackBar(
      content: const Text('CONNECTED'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PlayColors.backgroundWhite,
      body: SingleChildScrollView(
        child: Column(
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
                  image: const DecorationImage(
                      image: AssetImage(PlayAssets.robot))),
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
                if (state is BleStateInit) {
                  // Get the current state of Bluetooth
                  bleBloc.add(BleEventGetState());
                }

                if (state is BleCurrentState) {
                  if (state.state == BluetoothState.STATE_ON) {
                    bleStateOn = true;
                  } else {
                    bleStateOn = false;
                  }
                }

                if (state is BleEnableState) {
                  bleStateOn = true;
                }

                if (state is BleDisableState) {
                  bleStateOn = false;
                }

                if (state is BleScanResult) {
                  showScanning = false;
                  deviceFound = state.isSuccess;

                  if (deviceFound) {
                    device = state.devices!;
                  }
                }

                if (state is BleConnectSuccess) {
                  isConneted = true;
                  connection = state.connection;
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
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
                            if (!showScanning && !deviceFound) ...[
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
                            if (deviceFound)
                              ListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                title: Text(device.name ?? "Playbot"),
                                subtitle: Text(device.address),
                                leading: const CircleAvatar(
                                  child: Icon(Icons.important_devices_outlined),
                                ),
                                trailing: isConneted
                                    ? RawMaterialButton(
                                        onPressed: () {
                                          // Connect to the device.
                                          bleBloc.add(
                                              BleEventConnect(device: device));
                                        },
                                        fillColor: PlayColors.buttonPurple,
                                        shape: const StadiumBorder(),
                                        child: Text(
                                          "Connect",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: Colors.white),
                                        ),
                                      )
                                    : const CircleAvatar(
                                        radius: 10.0,
                                        backgroundColor: PlayColors.buttonGreen,
                                      ),
                              )
                          ],
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      BlocBuilder<FirebaseBloc, FireState>(
                          builder: (context, state) {
                        if (state is FireRoomState) {}

                        return SizedBox(
                          width: double.maxFinite,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "GAME ROOM",
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(
                                height: 6.0,
                              ),
                              Text(
                                "Create a game room and invite other players to join.",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(letterSpacing: 2.0),
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              RawMaterialButton(
                                onPressed: () {},
                                fillColor: PlayColors.buttonPurple,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0))),
                                child: Container(
                                  height: 40.0,
                                  width: double.maxFinite,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "CREATE ROOM",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              SizedBox(
                                width: double.maxFinite,
                                child: Text(
                                  "--- OR ---",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          letterSpacing: 2.0,
                                          fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              Text(
                                "Join a game room with other players to start a game.",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(letterSpacing: 2.0),
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              TextField(
                                controller: textController,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter room code',
                                ),
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              RawMaterialButton(
                                onPressed: () {
                                  // Add event to join the room.
                                },
                                fillColor: PlayColors.buttonOrange,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0))),
                                child: Container(
                                  height: 40.0,
                                  width: double.maxFinite,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "JOIN ROOM",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
