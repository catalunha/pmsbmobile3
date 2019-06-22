import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/state/services.dart';
import 'package:pmsbmibile3/state/user_repository.dart';

class FormData {
  String conteudo = "";
}


class PerfilEditarVariavelPage extends StatefulWidget {
  @override
  PerfilEditarVariavelState createState() {
    return PerfilEditarVariavelState();
  }
}

class PerfilEditarVariavelState extends State<PerfilEditarVariavelPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FormData _formData = FormData();

  @override
  Widget build(BuildContext context) {
    var db = Provider.of<DatabaseService>(context);

    final String administradorVariavelId =
        ModalRoute.of(context).settings.arguments;
    return StreamProvider<AdministradorVariavelModel>.value(
      stream: db.streamAdministradorVariavelById(administradorVariavelId),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Editar Item do Perfil"),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Consumer<AdministradorVariavelModel>(
            builder: (BuildContext context,
                AdministradorVariavelModel administradorVariavel, Widget child) {
              if (administradorVariavel == null) {
                return child;
              }
              if (administradorVariavel.tipo == "valor") {
                return VariavelFormularioValor(
                  formKey: _formKey,
                  formData: _formData,
                  administradorVariavel: administradorVariavel,
                );
              } else if (administradorVariavel.tipo == "arquivo") {
                return VariavelFormularioArquivo(
                  formKey: _formKey,
                  formData: _formData,
                  administradorVariavel: administradorVariavel,
                );
              }
            },
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        floatingActionButton: Consumer2<AdministradorVariavelModel, UserRepository>(
          builder: (context, administradorVariavel, userRepository, child) {
            if (administradorVariavel == null || userRepository == null) {
              return child;
            }
            return FloatingActionButton(
              child: Icon(Icons.save),
              onPressed: () async {
                _formKey.currentState.save();
                await db.updateVariavelUsuario(
                  userId: userRepository.user.uid,
                  variavelId: administradorVariavel.id,
                  tipo: administradorVariavel.tipo,
                  nome: administradorVariavel.nome,
                  conteudo: _formData.conteudo,
                );

                Navigator.pop(context);
              },
            );
          },
          child: Icon(Icons.block),
        ),
      ),
    );
  }
}

class VariavelUsuarioFormulario extends StatelessWidget {
  final AdministradorVariavelModel administradorVariavel;
  final Widget child;

  const VariavelUsuarioFormulario({
    Key key,
    this.administradorVariavel,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var db = Provider.of<DatabaseService>(context);

    return Consumer<UserRepository>(
      builder: (context, userRepository, builderChild) {
        if (userRepository.user == null) {
          return builderChild;
        } else {
          return StreamProvider<VariavelUsuarioModel>.value(
            stream: db.streamVarivelUsuarioByNomeAndUserId(
                userId: userRepository.user.uid,
                variavelId: administradorVariavel.id,
            ),
            child: child,
          );
        }
      },
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class VariavelFormularioArquivo extends StatelessWidget {
  final AdministradorVariavelModel administradorVariavel;
  final GlobalKey<FormState> formKey;
  final FormData formData;

  const VariavelFormularioArquivo({
    Key key,
    this.administradorVariavel,
    this.formKey,
    this.formData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VariavelUsuarioFormulario(
      administradorVariavel: administradorVariavel,
      child: Form(
        key: formKey,
        child: ListView(
          children: <Widget>[
            Text(
              administradorVariavel.nome,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("nada preenchido"),
            Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Text("Selecione o arquivo"),
                  InkWell(
                    child: Icon(Icons.attach_file),
                    onTap: () async {
                      String filePath =
                          await FilePicker.getFilePath(type: FileType.ANY);
                      formData.conteudo = filePath;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VariavelFormularioValor extends StatelessWidget {
  final AdministradorVariavelModel administradorVariavel;
  final GlobalKey<FormState> formKey;
  final FormData formData;

  VariavelFormularioValor({
    Key key,
    this.administradorVariavel,
    this.formKey,
    this.formData,
  }) : super(key: key);

  void valurOnSave(String valor) {
    formData.conteudo = valor;
  }

  @override
  Widget build(BuildContext context) {
    return VariavelUsuarioFormulario(
      administradorVariavel: administradorVariavel,
      child: Consumer<VariavelUsuarioModel>(
        builder: (context, variavelUsuario, child) {
          return Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                Text(
                  administradorVariavel.nome,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  onSaved: valurOnSave,
                  initialValue: variavelUsuario?.conteudo,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
