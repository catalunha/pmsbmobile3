import 'package:flutter/material.dart';

class InitialValueTextField extends StatefulWidget {
  final void Function(String) onChange;
  final bool Function() initialize;
  final String value;
  final String id;
  final TextInputType keyboardType;
  final int maxLines;
  final InputDecoration decoration;

  const InitialValueTextField({
    Key key,
    this.id,
    this.onChange,
    this.initialize,
    this.value,
    this.keyboardType,
    this.maxLines,
    this.decoration,
  })  : assert(initialize != null),
        super(key: key);

  @override
  _InitialValueTextFieldState createState() => _InitialValueTextFieldState();
}

class _InitialValueTextFieldState extends State<InitialValueTextField> {
  final controller = new TextEditingController();
  bool initial = true;
  String id;

  @override
  Widget build(BuildContext context) {
    if (id != widget.id) {
      id = widget.id;
      initial = true;
      controller.text = "";
    }

    if (initial && widget.initialize()) {
      controller.text = widget.value;
      initial = false;
    }

    return Container(
      child: TextField(
        onChanged: (text) => widget.onChange(text),
        controller: controller,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        decoration: widget.decoration,
      ),
    );
  }
}
