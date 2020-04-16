import 'package:flutter/material.dart';

class DeleteDocument extends StatefulWidget {
  final Function onDelete;
  const DeleteDocument({this.onDelete});
  @override
  DeleteDocumentState createState() {
    return DeleteDocumentState(this.onDelete);
  }
}

class DeleteDocumentState extends State<DeleteDocument> {
  final Function onDelete;

  final _textFieldController = TextEditingController();
  DeleteDocumentState(this.onDelete);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Divider(),
        IconButton(
          tooltip: 'Para apagar digite CONCORDO e depois click aqui.',
          icon: Icon(Icons.delete),
          onPressed: () {
            if (_textFieldController.text == 'CONCORDO') {
              onDelete();
            }
          },
        ),
        Text('Digite  '),
        Container(
          child: Flexible(
            child: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: 'CONCORDO'),

            ),
          ),
        ),
        Text('e libere o ícone para apagar !'),
      ],
    );
  }
}
