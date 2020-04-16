import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/usuario_perfil_model.dart';
import 'package:pmsbmibile3/pages/perfil/perfil_page_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

class PerfilPage extends StatefulWidget {
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final bloc = PerfilPageBloc(Bootstrap.instance.firestore);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PmsbColors.fundo,
      appBar: AppBar(
        backgroundColor: PmsbColors.fundo,
        bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: true,
        title: Text('Documentos do Usuário'),
      ),
      body: Container(
          child: StreamBuilder<List<UsuarioPerfilModel>>(
              stream: bloc.usuarioPerfilModelListStream,
              initialData: [],
              builder: (BuildContext context,
                  AsyncSnapshot<List<UsuarioPerfilModel>> snapshot) {
                if (snapshot.hasError) {
                  return Text('Erro ao listar perfil');
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                    children: snapshot.data
                        .map((usuarioPerfil) =>
                            _listTile(context, usuarioPerfil))
                        .toList());
              })),
    );
  }

  Widget _listTile(BuildContext context, UsuarioPerfilModel usuarioPerfil) {
    return Card(
      color: PmsbColors.card,
      child: InkWell(
        onTap: () {
          if (usuarioPerfil.perfilID.contentType == 'text') {
            Navigator.pushNamed(context, "/perfil/crudtext",
                arguments: usuarioPerfil.id);
          } else {
            Navigator.pushNamed(context, "/perfil/crudarq",
                arguments: usuarioPerfil.id);
          }
        },
        child: ListTile(
          
          title: Text('${usuarioPerfil?.perfilID?.nome}'),
          subtitle: usuarioPerfil.textPlain != null
              ? Text('${usuarioPerfil?.textPlain}')
              : usuarioPerfil.arquivo != null
                  ? Text('Imagem anexada com sucesso!')
                  : Text('Anexe a imagem do seu documento aqui', style: PmsbStyles.textoSecundario,),
          trailing: usuarioPerfil.perfilID?.contentType == 'text'
              ? Icon(Icons.edit)
              : Icon(Icons.art_track),
        ),
      ),
    );
  }
}
