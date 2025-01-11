import 'package:easy_form_builder_example/objects/keyboard_types.dart';
import 'package:flutter/material.dart';
import 'package:virtual_keyboard_custom_layout/virtual_keyboard_custom_layout.dart';

class KeyboardAux extends StatefulWidget {
  final TextEditingController? controller;
  final VirtualKeyboardType typeKeyboard;
  final KeyboardTypes typeLayout;
  final bool alwaysCaps;
  final Function? onChange;
  final double height;

  const KeyboardAux({
    super.key,
    this.alwaysCaps = false,
    this.controller,
    this.onChange,
    this.height = 300,
    this.typeLayout = KeyboardTypes.alphaEmail,
    required this.typeKeyboard,
  });

  @override
  State<KeyboardAux> createState() => _KeyboardAuxState();
}

class _KeyboardAuxState extends State<KeyboardAux> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          color: const Color.fromARGB(192, 199, 199, 199),
          child: VirtualKeyboard(
            height: widget.height,
            width: MediaQuery.of(context).size.width,
            fontSize: 26,
            textColor: const Color.fromARGB(255, 0, 0, 0),
            textController: widget.controller,
            defaultLayouts: const [
              VirtualKeyboardDefaultLayouts.English,
            ],
            alwaysCaps: widget.alwaysCaps,
            borderColor: const Color.fromARGB(255, 151, 151, 151),
            type: widget.typeKeyboard,
            keys: (widget.typeKeyboard == VirtualKeyboardType.Custom) ? widget.typeLayout.keyboard : [],
            onKeyPress: onKeyPress,
          ),
        ),
      ),
    );
  }

  onKeyPress(VirtualKeyboardKey key) {
    widget.onChange?.call(widget.controller);
  }
}
