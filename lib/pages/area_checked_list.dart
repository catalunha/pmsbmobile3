import 'package:flutter/material.dart';

class AreaCheckedList extends StatefulWidget {
  @override
  _AreaCheckedListState createState() => _AreaCheckedListState();
}

class _AreaCheckedListState extends State<AreaCheckedList> {
  List<bool> inputs = [false, false, false];
  List<String> inputs_name = ["Area 01", "Area 02", "Area 03"];

  @override
  void initState() {
    // TODO: implement initState
    setState(() {});
  }

  void _itemChange(bool val, int index) {
    setState(() {
      inputs[index] = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: new Text('Selecionar áreas'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.blue,
      ),
      body: new ListView.builder(
          itemCount: inputs.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: new EdgeInsets.all(10.0),
              child: new Column(
                children: <Widget>[
                  new CheckboxListTile(
                      value: inputs[index],
                      title: new Text('${inputs_name[index]}'),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool val) {
                        _itemChange(val, index);
                      })
                ],
              ),
            );
          }),
    );
  }
}
