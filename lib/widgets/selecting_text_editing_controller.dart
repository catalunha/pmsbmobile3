import 'package:flutter/material.dart';

class SelectingTextEditingController extends TextEditingController {
  SelectingTextEditingController({String text}) : super(text: text) {
    if (text != null) setTextAndPosition(text);
  }

  void setTextAndPosition(String newText, {int caretPosition}) {
    int offset = caretPosition != null ? caretPosition : newText.length;
    value = value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: offset),
        composing: TextRange.empty);
  }
}

class MarkdownTextEditor extends StatefulWidget {
  @override
  _MarkdownTextEditorState createState() => _MarkdownTextEditorState();
}

class _MarkdownTextEditorState extends State<MarkdownTextEditor> {
  
  String _textoMarkdown = "  ";
  var myController = new SelectingTextEditingController();


  @override
  Widget build(BuildContext context) {
    myController.setTextAndPosition(_textoMarkdown);
    return Container(
      height: 100,
      width: 100
      ,child: Column(
      children: <Widget>[
        Text("data"),
        Text("data"),
        Text("data"),
        Text("data"),
        Text("data"),
      ],
    ) );
  }
}
