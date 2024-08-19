import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:playbot/utilities/util_colors.dart';

final List<int> list = <int>[0, 1, 2, 3, 4, 5, 6, 7, 8];

class ControlScreen extends StatefulWidget {
  final BluetoothDevice device;
  final BluetoothConnection connection;
  const ControlScreen(
      {super.key, required this.device, required this.connection});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  int selectedCards = 0, selectedPlayers = 0;

  void _setSelectedCards(int cards) {
    if (selectedCards == cards) {
      return;
    }

    selectedCards = cards;
  }

  void _setSelectedPlayers(int players) {
    if (selectedPlayers == players) {
      return;
    }

    selectedPlayers = players;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PlayColors.backgroundWhite,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Players"),
            const SizedBox(
              height: 12.0,
            ),
            DropdownButtonExample(
              onSelected: _setSelectedPlayers,
            ),
            const SizedBox(
              height: 12.0,
            ),
            const Text("Select Cards"),
            const SizedBox(
              height: 12.0,
            ),
            DropdownButtonExample(
              onSelected: _setSelectedCards,
            ),
            const SizedBox(
              height: 12.0,
            ),
            RawMaterialButton(
              onPressed: () {
                print(selectedCards.toString());
                widget.connection.output.add(Uint8List.fromList('$selectedCards'.codeUnits));
              },
              fillColor: PlayColors.buttonOrange,
              elevation: 0.0,
              shape: const StadiumBorder(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Text(
                  "START DISTRIBUTION",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                      color: Colors.white),
                ),
              ),
            ),
            // JUST FOR TESTING THE MOTORS
            // TextButton(
            //   onPressed: () {
            //     widget.connection.output.add(Uint8List.fromList('1'.codeUnits));
            //   },
            //   child: Text("M1 Forward"),
            // ),
            // TextButton(
            //   onPressed: () {
            //     widget.connection.output.add(Uint8List.fromList('2'.codeUnits));
            //   },
            //   child: Text("M1 Reverse"),
            // ),
            // TextButton(
            //   onPressed: () {
            //     widget.connection.output.add(Uint8List.fromList('3'.codeUnits));
            //   },
            //   child: Text("M2 Forward"),
            // ),
            // TextButton(
            //   onPressed: () {
            //     widget.connection.output.add(Uint8List.fromList('4'.codeUnits));
            //   },
            //   child: Text("M2 Reverse"),
            // ),
            // TextButton(
            //   onPressed: () {
            //     widget.connection.output.add(Uint8List.fromList('0'.codeUnits));
            //   },
            //   child: Text("Stop All"),
            // ),
            // JUST FOR TESTING THE MOTORS - END
          ],
        ),
      ),
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  final Function(int num) onSelected;
  const DropdownButtonExample({super.key, required this.onSelected});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  int dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<int>(
        hint: const Text("Select a value"),
        value: dropdownValue,
        icon: const Padding(
          padding: EdgeInsets.only(left: 100),
          child: Icon(Icons.arrow_drop_down),
        ),
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(),
        onChanged: (int? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
          });
          widget.onSelected(value!);
        },
        items: list.map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
      ),
    );
  }
}
