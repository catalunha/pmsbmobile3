import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/services/cache_service.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

import '../../bootstrap.dart';

class ConfiguracaoHome extends StatefulWidget {
  final AuthBloc authBloc;

  ConfiguracaoHome(this.authBloc);

  @override
  _ConfiguracaoHomeState createState() => _ConfiguracaoHomeState(this.authBloc);
}

class _ConfiguracaoHomeState extends State<ConfiguracaoHome> {
  final AuthBloc authBloc;

  _ConfiguracaoHomeState(this.authBloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: PmsbColors.fundo,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 9, top: 9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: PmsbColors.texto_terciario,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  SizedBox(
                    width: 70,
                  ),
                  Text(
                    "Configurações",
                    style: PmsbStyles.textStyleListBold,
                  ),
                ],
              ),
            ),
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.pushNamed(context, "/perfil/configuracao");
                },
                title: Text("Perfil"),
                subtitle: Text("Configurações do perfil do usuário"),
                leading: Icon(
                  Icons.face,
                  color: PmsbColors.cor_destaque,
                  size: 30,
                ),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.pushNamed(context, "/perfil");
                },
                title: Text("Documentos"),
                subtitle: Text("Informações e anexos do usuário"),
                leading: Icon(
                  Icons.crop_landscape,
                  color: PmsbColors.cor_destaque,
                  size: 30,
                ),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.pushNamed(context, "/versao");
                },
                title: Text("Sobre"),
                subtitle: Text("Versão e dados do aplicativo"),
                leading: Icon(
                  Icons.info,
                  color: PmsbColors.cor_destaque,
                  size: 30,
                ),
              ),
            ),
            StreamBuilder<UsuarioModel>(
                stream: authBloc.perfil,
                builder: (context, snap) {
                  if (snap.hasError) {
                    return Center(
                      child: Text("Erro"),
                    );
                  }
                  List<Widget> list = List<Widget>();
                  if (snap.data == null ||
                      snap.data.routes == null ||
                      snap.data.routes.isEmpty) {
                    list.add(Container());
                  } else {
                    // MODO OFFLINE -----------------------------------------------
                    list.add(Card(
                      child: ListTile(
                        title: Text("Habilitar modo offline"),
                        onTap: () async {
                          final cacheService =
                              CacheService(Bootstrap.instance.firestore);
                          await cacheService.load();
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Modo offline completo.")));
                          Navigator.pop(context);
                        },
                        leading: Icon(
                          Icons.phonelink_erase,
                          color: PmsbColors.cor_destaque,
                          size: 30,
                        ),
                      ),
                    ));
                  }
                  list.add(
                    Card(
                      child: ListTile(
                        onTap: () {
                          authBloc.dispatch(LogoutAuthBlocEvent());
                          Navigator.pushReplacementNamed(context, "/");
                        },
                        title: Text("Sair"),
                        leading: Icon(
                          Icons.exit_to_app,
                          color: Colors.red[300],
                          size: 30,
                        ),
                      ),
                    ),
                  );
                  return Column(children: list);
                }),
          ],
        ),
      ),
    );
  }
}

// // Perfil
// rotas["/perfil/configuracao"] = Rota("Configurações", Icons.settings);
// // Documentos
// rotas["/perfil"] = Rota("Itens do Perfil", Icons.person);
// // Sobre
// rotas["/versao"] = Rota("Versão & Sobre", Icons.device_unknown);
// // Sair
