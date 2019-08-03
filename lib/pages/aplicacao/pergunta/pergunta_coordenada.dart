import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta/pergunta_coordenada_bloc.dart';

class PerguntaCoordenada extends StatefulWidget {
  final PerguntaAplicadaModel perguntaAplicada;

  const PerguntaCoordenada(this.perguntaAplicada, {Key key}) : super(key: key);

  @override
  _PerguntaCoordenadaState createState() {
    return _PerguntaCoordenadaState();
  }
}

class _PerguntaCoordenadaState extends State<PerguntaCoordenada> {
  PerguntaCoordenadaBloc bloc;

  final Location location = Location();

  @override
  void initState() {
    bloc = PerguntaCoordenadaBloc(widget.perguntaAplicada);
    super.initState();
  }

  void _salvarLocalizacao() {
    location.getLocation().then((LocationData currentLocation) {
      bloc.dispatch(AdicionarCoordenadaPerguntaCoordenadaBlocEvent(
          currentLocation.latitude, currentLocation.longitude));
    }, onError: (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print("ERROR: ${e.code} ");
      }
    });
  }

  Widget _listTileCoordenada(Coordenada coordenada) {
    return ListTile(
      leading: Icon(Icons.location_on),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          bloc.dispatch(
              RemoverCoordenadaPerguntaCoordenadaBlocEvent(coordenada));
        },
      ),
      title: Text(
          "Latitude: ${coordenada.latitude}\nLongitude: ${coordenada.longitude} "),
    );
  }

  Widget _makeList() {
    return StreamBuilder<PerguntaCoordenadaBlocState>(
      stream: bloc.state,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("ERROR"),
          );
        }
        if (!snapshot.hasData) {
          return Container();
        }
        return Column(
          children: widget.perguntaAplicada.coordenada
              .map((coordenada) => _listTileCoordenada(coordenada))
              .toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
              title: Text("Adicionar nova coordenada"),
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _salvarLocalizacao();
                },
              )),
          _makeList(),
        ],
      ),
    );
  }
}
