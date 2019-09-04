import 'package:flutter/material.dart';

class ApagarConcordo extends StatefulWidget {
  final Function onApagar;
  final String conditionText;

  const ApagarConcordo({
    Key key,
    this.onApagar,
    this.conditionText,
  }) : super(key: key);

  @override
  _ApagarConcordoState createState() {
    return _ApagarConcordoState();
  }
}

class _ApagarConcordoState extends State<ApagarConcordo> {
  String inputText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text("Para apagar digite ${widget.conditionText} e click: "),
        Container(child: Flexible(
          child: TextField(
            onChanged: (text) {
              setState(() {
                inputText = text;
              });
            },
          ),
        )),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: widget.conditionText == inputText ? widget.onApagar : null,
        ),
      ],
    );
  }
}
