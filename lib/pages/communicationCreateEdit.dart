import 'package:flutter/material.dart';
import 'package:pmsbmibile3/pages/area_checked_list.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class CommunicationCreateEdit extends StatefulWidget {
  @override
  _CommunicationCreateEditState createState() =>
      _CommunicationCreateEditState();
}

class _CommunicationCreateEditState extends State<CommunicationCreateEdit> {
  DateTime _date = new DateTime.now();
  TimeOfDay _hora = new TimeOfDay.now();

  String _markdownData = """# Markdown Example
Markdown allows you to easily include formatted text, images, and even formatted Dart code in your app.

## Styling
Style text as _italic_, __bold__, or `inline code`.

- Use bulleted lists
- To better clarify
- Your points

## Links
You can use [hyperlinks](https://rockcontent.com/blog/wp-content/uploads/2017/01/formatos-de-imagem-2.jpg) in markdown

## Images

You can include images:

![Flutter logo](https://rockcontent.com/blog/wp-content/uploads/2017/01/formatos-de-imagem-2.jpg)

## Markdown widget

This is an example of how to create your own Markdown widget:

    new Markdown(data: 'Hello _world_!');

## Code blocks
Formatted Dart code looks really pretty too:

```
void main() {
  runApp(new MaterialApp(
    home: new Scaffold(
      body: new Markdown(data: markdownData)
    )
  ));
}
```

Enjoy!
""";

  //Destinatario
  _tituloNoticia() {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            //labelText: 'Titulo da notícia',
          ),
        ));
  }

  // Data - Horario

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2019),
        lastDate: DateTime(2022),
        builder: (BuildContext context, Widget child) {
          return FittedBox(
            child: Theme(
              child: child,
              data: ThemeData(
                primaryColor: Colors.purple[300],
              ),
            ),
          );
        });
    if (picked != null) {
      setState(() {
        _date = picked;
      });
    }
  }

  _selectHorario(context) async {
    TimeOfDay selectedTime = await showTimePicker(
      initialTime: _hora,
      context: context,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
    if (selectedTime != null) {
      setState(() {
        _hora = selectedTime;
      });
    }
  }

  _ajustarTempoAux(tempo) {
    if (tempo > 9) {
      return tempo;
    }
    return "0$tempo";
  }

  _dataHorarioNoticia(context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Flexible(
            child: TextField(
              obscureText: true,
              enabled: false,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  //labelText: '${_datestring}',
                  hintText:
                      "${_ajustarTempoAux(_date.day)}/${_ajustarTempoAux(_date.month)}/${_date.year} ${_ajustarTempoAux(_hora.hour)}:${_ajustarTempoAux(_hora.minute)}"),
            ),
          ),
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () {
              _selectDate(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.access_time),
            onPressed: () {
              _selectHorario(context);
            },
          ),
        ],
      ),
    );
  }

  //Anexo

  //Texto da Noticia
  _textoNoticia() {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: TextField(
          onChanged: (text) {
            setState(() {
               _markdownData = text;
            });
          },
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ));
  }

  _anexos() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Flexible(
            child: TextField(
              obscureText: true,
              enabled: false,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  //labelText: '${_datestring}',
                  hintText: ""),
            ),
          ),
          IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: () {
              //inserir arquivos anexos aqui
            },
          ),
        ],
      ),
    );
  }

  _botoes() {
    return SafeArea(
        child: Row(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
                color: Colors.red,
                onPressed: () {},
                child: Row(
                  children: <Widget>[
                    Text('Apagar', style: TextStyle(fontSize: 20)),
                    Icon(Icons.delete)
                  ],
                ))),
      ],
    ));
  }

  _eixos(context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Flexible(
            child: TextField(
              obscureText: true,
              enabled: false,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  //labelText: '${_datestring}',
                  hintText: ""),
            ),
          ),
          IconButton(
            icon: Icon(Icons.check_box),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AreaCheckedList();
              }));
            },
          ),
        ],
      ),
    );
  }

  _texto(String texto) {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: Text(
          texto,
          style: TextStyle(fontSize: 15, color: Colors.blue),
        ));
  }

  _bodyDados(context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: ListView(
          padding: EdgeInsets.all(5),
          children: <Widget>[
            _texto("Titulo da notícia:"),
            _tituloNoticia(),
            _texto("Data / Hora da notícia:"),
            _dataHorarioNoticia(context),
            _texto("Anexo:"),
            _anexos(),
            _texto("Escolha um ou varios destinatarios:"),
            _eixos(context),
            _botoes()
          ],
        ));
  }

  _bodyTexto(context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: ListView(
          padding: EdgeInsets.all(5),
          children: <Widget>[
            _texto("Texto da notícia:"),
            _textoNoticia(),
          ],
        ));
  }

  _bodyPreview(context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: ListView(
          padding: EdgeInsets.all(5),
          children: <Widget>[
            _texto("Texto:"),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            bottom: TabBar(
              tabs: [
                Tab(text: "Dados"),
                Tab(text: "Texto"),
                Tab(text: "Preview")
              ],
            ),
            title: Text('Criação e edicao de notícias'),
          ),
          body: TabBarView(
            children: [
              _bodyDados(context),
              _bodyTexto(context),
              Markdown(data: _markdownData)
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Icon(Icons.thumb_up),
            backgroundColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}
