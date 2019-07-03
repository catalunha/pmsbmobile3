import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/state/services.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

import 'package:pmsbmibile3/pages/perfil/editar_variavel_bloc.dart';

class PerfilEditarVariavelPage extends StatefulWidget {
  @override
  PerfilEditarVariavelState createState() {
    return PerfilEditarVariavelState();
  }
}

class PerfilEditarVariavelState extends State<PerfilEditarVariavelPage> {
  final EditarVariavelBloc bloc = EditarVariavelBloc(DatabaseService());

  @override
  Widget build(BuildContext context) {
    var db = Provider.of<DatabaseService>(context);

    final String administradorVariavelId =
        ModalRoute.of(context).settings.arguments;

    return StreamBuilder<bool>(
      stream: bloc.isSalvando,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("ERRO");
        }
        if (!snapshot.hasData) {
          return Text("SEM DADOS");
        }
        if (snapshot.data) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Provider<EditarVariavelBloc>.value(
          value: bloc,
          child: StreamProvider<AdministradorVariavelModel>.value(
            stream: db.streamAdministradorVariavelById(administradorVariavelId),
            child: Scaffold(
              appBar: AppBar(
                title: Text("Editar Item do Perfil"),
              ),
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Consumer<AdministradorVariavelModel>(
                  builder: (BuildContext context,
                      AdministradorVariavelModel administradorVariavel,
                      Widget child) {
                    if (administradorVariavel == null) {
                      return child;
                    }
                    bloc.disptach(UpdateVariavelIdEditarVariavelBlocEvent(
                        administradorVariavelId));
                    bloc.disptach(UpdateTipoEditarVariavelBlocEvent(
                        administradorVariavel.tipo));
                    bloc.disptach(UpdateNomeEditarVariavelBlocEvent(administradorVariavel.nome));
                    if (administradorVariavel.tipo == "valor") {
                      return VariavelFormularioValor(
                        administradorVariavel: administradorVariavel,
                      );
                    } else if (administradorVariavel.tipo == "arquivo") {
                      return VariavelFormularioArquivo(
                        administradorVariavel: administradorVariavel,
                      );
                    }
                  },
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              floatingActionButton: SaveButton(),
            ),
          ),
        );
      },
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
    final authBloc = Provider.of<AuthBloc>(context);

    return StreamBuilder<String>(
      stream: authBloc.userId,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("ERRO");
        }
        if (!snapshot.hasData) {
          return Text("SEM DADOS");
        }
        final String userId = snapshot.data;
        return StreamProvider<VariavelUsuarioModel>.value(
          stream: db.streamVarivelUsuarioByNomeAndUserId(
            userId: userId,
            variavelId: administradorVariavel.id,
          ),
          child: child,
        );
      },
    );
  }
}

class VariavelFormularioArquivo extends StatelessWidget {
  final AdministradorVariavelModel administradorVariavel;

  const VariavelFormularioArquivo({
    Key key,
    this.administradorVariavel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<EditarVariavelBloc>(context);
    return VariavelUsuarioFormulario(
      administradorVariavel: administradorVariavel,
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
                    bloc.disptach(
                        UpdateConteudoEditarVariavelBlocEvent(filePath));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VariavelFormularioValor extends StatefulWidget {
  final AdministradorVariavelModel administradorVariavel;

  VariavelFormularioValor({
    Key key,
    this.administradorVariavel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VariavelFormularioValorState();
  }
}

class VariavelFormularioValorState extends State<VariavelFormularioValor> {
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<EditarVariavelBloc>(context);
    return VariavelUsuarioFormulario(
      administradorVariavel: widget.administradorVariavel,
      child: Consumer<VariavelUsuarioModel>(
        builder: (context, variavelUsuario, child) {
          if(variavelUsuario == null){
            return child;
          }
          if (_textEditingController.text.isEmpty) {
            _textEditingController.text = variavelUsuario.conteudo;
          }
          return ListView(
            children: <Widget>[
              Text(
                widget.administradorVariavel.nome,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _textEditingController,
                onChanged: (conteudo) {
                  bloc.disptach(
                      UpdateConteudoEditarVariavelBlocEvent(conteudo));
                },
              ),
            ],
          );
        },
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    final bloc = Provider.of<EditarVariavelBloc>(context);

    return StreamBuilder<String>(
      stream: authBloc.userId,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("ERRO");
        }
        if (!snapshot.hasData) {
          return Text("SEM DADOS");
        }
        final String userId = snapshot.data;

        return Consumer<AdministradorVariavelModel>(
          builder: (context, administradorVariavel, child) {
            if (administradorVariavel == null) {
              return child;
            }
            return FloatingActionButton(
              child: Icon(Icons.save),
              onPressed: () {
                bloc.disptach(UpdateUserIdEditarVariavelBlocEvent(userId));
                bloc.disptach(SaveEditarVariavelBlocEvent());
                //Navigator.pop(context);
              },
            );
          },
          child: Icon(Icons.block),
        );
      },
    );
  }
}
