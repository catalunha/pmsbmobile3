import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/usuario_perfil_model.dart';
import 'package:pmsbmibile3/pages/perfil/perfil_crud_page_bloc.dart';


class PerfilCRUDPage extends StatefulWidget {
  final String usuarioPerfilID;
  final PerfilCRUDPageBloc bloc;

  PerfilCRUDPage(this.usuarioPerfilID)
      : bloc = PerfilCRUDPageBloc(Bootstrap.instance.firestore) {
    bloc.perfilCRUDPageEventSink(UpDateUsuarioPerfilIDEvent(usuarioPerfilID));
  }

  _PerfilCRUDPageState createState() => _PerfilCRUDPageState();
}

class _PerfilCRUDPageState extends State<PerfilCRUDPage> {
  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar item do perfil '),
        // title: Text('Item de ${usuarioPerfilID.substring(0, 5)}'),
      ),
      body: ListView(
        children: <Widget>[
          StreamBuilder<UsuarioPerfilModel>(
            stream: widget.bloc.usuarioPerfilModelStream,
            // initialData: null,
            builder: (BuildContext context,
                AsyncSnapshot<UsuarioPerfilModel> snapshot) {
              if (!snapshot.hasData) {
                return Text('Sem dados');
              }
              if (textEditingController.text == null ||
                  textEditingController.text.isEmpty) {
                textEditingController.text = snapshot.data?.textPlain;
              }
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    Text(
                      '${snapshot.data.perfilID.nome}',
                      // 'a',
                      style: Theme.of(context).textTheme.title,
                    ),
                    TextField(
                      controller: textEditingController,
                      onChanged: (textPlain) {
                        return widget.bloc.perfilCRUDPageEventSink(
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
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.bloc.perfilCRUDPageEventSink(SaveStateToFirebaseEvent());
          Navigator.pop(context);
        },
        child: Icon(Icons.check),
      ),
    );
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}
