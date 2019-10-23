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

  // _textoTitulo(String texto) {
  //   return Padding(
  //       padding: EdgeInsets.all(5.0),
  //       child: Text(
  //         texto,
  //         style: TextStyle(fontSize: 15, color: Colors.blue),
  //       ));
  // }

  // _textoMarkdownField() {
  //   return Padding(
  //       padding: EdgeInsets.all(5.0),
  //       child: TextField(
  //         onChanged: (text) {
  //           _textoMarkdown = text;
  //           // print(myController.selection);
  //         },
  //         controller: myController,
  //         keyboardType: TextInputType.multiline,
  //         maxLines: null,
  //         decoration: InputDecoration(
  //           border: OutlineInputBorder(),
  //         ),
  //       ));
  // }

  // _atualizarMarkdown(texto, posicao) {
  //   String inicio =
  //       _textoMarkdown.substring(0, myController.selection.baseOffset);
  //   // print("INICIO:" + inicio);
  //   String fim = _textoMarkdown.substring(
  //       myController.selection.baseOffset, _textoMarkdown.length);
  //   // print("FIM:" + fim);

  //   _textoMarkdown = "$inicio$texto$fim";
  //   myController.setTextAndPosition(_textoMarkdown,
  //       caretPosition: myController.selection.baseOffset + posicao);
  // }

  // _iconesLista() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: <Widget>[
  //       IconButton(
  //         icon: Icon(Icons.format_bold),
  //         onPressed: () {
  //           _atualizarMarkdown("****", 2);
  //         },
  //       ),
  //       IconButton(
  //         icon: Icon(Icons.format_size),
  //         onPressed: () {
  //           _atualizarMarkdown("#", 1);
  //         },
  //       ),
  //       IconButton(
  //         icon: Icon(Icons.format_list_numbered),
  //         onPressed: () {
  //           _atualizarMarkdown("- ", 2);
  //         },
  //       ),
  //       IconButton(
  //         icon: Icon(Icons.link),
  //         onPressed: () {
  //           _atualizarMarkdown("[ clique aqui ](   )", 5);
  //         },
  //       ),
  //       IconButton(
  //           icon: Icon(Icons.attach_file),
  //           onPressed: () {
  //             Navigator.push(context, MaterialPageRoute(builder: (context) {
  //               return UserFilesFirebaseList();
  //             }));
  //           })
  //     ],
  //   );
  // }

  // _bodyTexto(context) {
  //   return ListView(
  //     children: <Widget>[
  //       Expanded(
  //         child: ListView(
  //           padding: EdgeInsets.all(5),
  //           children: <Widget>[
  //             _textoTitulo("Texto da notícia:"),
  //             _textoMarkdownField(),
  //           ],
  //         ),
  //       ),
  //       new Container(
  //         color: Colors.white,
  //         padding: new EdgeInsets.all(10.0),
  //         child: _iconesLista(),
  //       ),
  //     ],
  //   );
  // }

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
