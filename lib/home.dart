import 'dart:typed_data';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:velocity_x/velocity_x.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // The color selected in the color picker.
  Color screenPickerColor = Colors.blue;
  Color backGroundColor = Colors.transparent;

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
    exportPenColor: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text('SignMe'),
      ),
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //   color picker
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Pick background color!'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            // Use the screenPickerColor as start color.
                            color: screenPickerColor,
                            // Update the screenPickerColor using the callback.
                            onColorChanged: (Color color) {
                              setState(() {
                                backGroundColor = color;
                              });
                            },
                            width: 40,
                            height: 40,
                            borderRadius: 10,
                            heading: const Text('Select color'),
                            pickersEnabled: const <ColorPickerType, bool>{
                              ColorPickerType.both: false,
                              ColorPickerType.primary: true,
                              ColorPickerType.accent: true,
                              ColorPickerType.bw: false,
                              ColorPickerType.custom: true,
                              ColorPickerType.wheel: true,
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text('Pick Background Color'),
              ).px8().w64(context),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Signature(
            controller: _controller,
            height: 300,
            backgroundColor: backGroundColor,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.undo),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() => _controller.undo());
                  },
                  tooltip: 'Undo',
                ),
                IconButton(
                  icon: const Icon(Icons.redo),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() => _controller.redo());
                  },
                  tooltip: 'Redo',
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _controller.clear();
            },
            child: const Text('Clear'),
          ),
          ElevatedButton(
            onPressed: () async {
              final data = await _controller.toPngBytes();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // add buttons for save and cancel
                    actions: [
                      ElevatedButton(
                          onPressed: () {}, child: const Text('Save')),
                    ],
                    content: Image.memory(data!),
                  );
                },
              );
            },
            child: const Text('Save'),
          ),
        ],
      ).px8(),
    );
  }
}
