import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/usuario_perfil_model.dart';
import 'package:pmsbmibile3/pages/perfil/perfil_crud_page_bloc.dart';

class PerfilCRUDPage extends StatefulWidget {
  final String usuarioPerfilID;

  PerfilCRUDPage(this.usuarioPerfilID);

  _PerfilCRUDPageState createState() => _PerfilCRUDPageState();
}

class _PerfilCRUDPageState extends State<PerfilCRUDPage> {
  final textEditingController = TextEditingController();
  final PerfilCRUDPageBloc bloc;
  _PerfilCRUDPageState()
      : bloc = PerfilCRUDPageBloc(Bootstrap.instance.firestore);

  @override
  void initState() {
    super.initState();
    bloc.perfilCRUDPageEventSink(
        UpDateUsuarioPerfilIDEvent(widget.usuarioPerfilID));
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar item do perfil '),
      ),
      body: ListView(
        children: <Widget>[
          StreamBuilder<UsuarioPerfilModel>(
            stream: bloc.usuarioPerfilModelStream,
            builder: (BuildContext context,
                AsyncSnapshot<UsuarioPerfilModel> snapshot) {
              if (!snapshot.hasData) {
                return Text('Sem dados');
              }
              if (textEditingController.text == null ||
                  textEditingController.text.isEmpty) {
                textEditingController.text = snapshot.data?.textPlain;
              }
              return Column(
                children: <Widget>[
                  Text(
                    '${snapshot.data.perfilID.nome}',
                    style: Theme.of(context).textTheme.title,
                  ),
                  TextField(
                    controller: textEditingController,
                    onChanged: (textPlain) {
                      return bloc.perfilCRUDPageEventSink(
                          UpDateTextPlainEvent(textPlain));
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bloc.perfilCRUDPageEventSink(SaveStateToFirebaseEvent());
          Navigator.pop(context);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
