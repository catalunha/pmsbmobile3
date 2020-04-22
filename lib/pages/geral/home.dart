import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/login_required.dart';
import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/pages/geral/home_grid.dart';
import 'package:pmsbmibile3/pages/geral/home_grid_admin.dart';
// import 'package:pmsbmibile3/services/page_size_map.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';
import 'package:pmsbmibile3/widgets/round_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// class HomePageSizeMap extends PageSizeMap {
//   double iconSize;
//   double alturaHeader;
//   double alturaImagem;
//   double larguraImagem;

//   HomePageSizeMap();
// }

class HomePage extends StatefulWidget {
  final AuthBloc authBloc;
  HomePage(this.authBloc);

  _HomePageState createState() => _HomePageState(this.authBloc);
}

class _HomePageState extends State<HomePage> {
  final AuthBloc authBloc;

  // Mapeamento do tamanho dos elementos de tela

  // HomePageSizeMap homePageSizeMap;

  // PageSizeMapController homePageSizeMapController = new PageSizeMapController(
  //   webPageSizeMap: HomePageSizeMap(),
  //   mobileSizeMap: HomePageSizeMap(),
  // );

  _HomePageState(this.authBloc);

  // void initState() {
  //   this.homePageSizeMap = this.homePageSizeMapController.definirSizeMap();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultLoginRequired(
        child: Container(
          color: PmsbColors.fundo,
          child: Column(
            children: <Widget>[
              // Header da pagina
              StreamBuilder<UsuarioModel>(
                stream: authBloc.perfil,
                builder: (context, snap) {
                  if (snap.hasError) {
                    return Center(
                      child: Text("Erro"),
                    );
                  }
                  if (!snap.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  // Header da pagina
                  return ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: Container(
                      height: kIsWeb
                          ? MediaQuery.of(context).size.height * 0.16
                          : MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: PmsbColors.cor_destaque,
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.green[300],
                            PmsbColors.cor_destaque,
                          ],
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: kIsWeb
                                ? MediaQuery.of(context).size.height * 0.02
                                : MediaQuery.of(context).size.height * 0.05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // Foto
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: RoundImage(
                                      fotoUrl: snap.data?.foto?.url,
                                      fotoLocalPath: snap.data?.foto?.localPath,
                                      heigth: kIsWeb
                                          ? MediaQuery.of(context).size.height *
                                              0.08
                                          : MediaQuery.of(context).size.height *
                                              0.12,
                                      width: kIsWeb
                                          ? MediaQuery.of(context).size.height *
                                              0.08
                                          : MediaQuery.of(context).size.height *
                                              0.12,
                                      corBorda: Colors.white70,
                                      espesuraBorda: 5,
                                    ),
                                  ),

                                  // Informacoes em texto
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "${snap.data.nome}",
                                        style: PmsbStyles.textStyleListBold,
                                      ),
                                      Text(
                                        "${snap.data.email}",
                                        style: PmsbStyles.textStyleListPerfil01,
                                      ),
                                      Text(
                                        "${snap.data.celular}",
                                        style: PmsbStyles.textStyleListPerfil01,
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // Icone do menu
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, "/configuracao/home");
                                  },
                                  child: Icon(
                                    Icons.list,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  color: Colors.black12,
                                ),
                                child: Text(
                                  " Eixo: ${snap.data.eixoIDAtual.nome} ",
                                  style: PmsbStyles.textStyleListPerfil01,
                                ),
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    color: Colors.black12,
                                  ),
                                  child: Text(
                                    " Setor: ${snap.data.setorCensitarioID.nome} ",
                                    style: PmsbStyles.textStyleListPerfil01,
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              Expanded(child: _gridListContainer()),
            ],
          ),
        ),
        authBloc: this.authBloc,
      ),
    );
  }

  Container _gridListContainer() {
    return Container(
      child: ListView(
        children: <Widget>[
          HomeGrid(),
          // HomeGridAdmin(),
        ],
      ),
    );
  }
}
