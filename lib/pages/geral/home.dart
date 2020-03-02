import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/login_required.dart';
import 'package:pmsbmibile3/models/models.dart';
// import 'package:pmsbmibile3/pages/geral/bemvindo.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';
import 'package:pmsbmibile3/widgets/round_image.dart';

class HomePage extends StatefulWidget {
  final AuthBloc authBloc;
  HomePage(this.authBloc);

  _HomePageState createState() => _HomePageState(this.authBloc);
}

class _HomePageState extends State<HomePage> {
  final AuthBloc authBloc;
  _HomePageState(this.authBloc);

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

                  return ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: Container(
                      height: 150,
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
                          SizedBox(height: 23),
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
                                      heigth: 90,
                                      width: 90,
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
                                      // Text(
                                      //   "Eixo: ${snap.data.eixoIDAtual.nome}",
                                      //   style: PmsbStyles.textStyleListPerfil01,
                                      // ),
                                      // Text(
                                      //   "Setor: ${snap.data.setorCensitarioID.nome}",
                                      //   style: PmsbStyles.textStyleListPerfil01,
                                      // ),
                                    ],
                                  ),
                                ],
                              ),

                              // Icone do menu
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  Icons.list,
                                  size: 30,
                                  color: Colors.white,
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
                                    " ${snap.data.eixoIDAtual.nome} ",
                                    style: PmsbStyles.textStyleListPerfil01,
                                  )),
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    color: Colors.black12,
                                  ),
                                  child: Text(
                                    " ${snap.data.setorCensitarioID.nome} ",
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

              Expanded(
                child: ListView(
                  children: <Widget>[
                    iconeRow(),
                    iconeRow(),
                    iconeRow(),
                    iconeRow(),
                    iconeRow(),
                    iconeRow(),
                    iconeRow(),
                    iconeRow(),
                    iconeRow(),
                    iconeRow(),
                    iconeRow(),
                    iconeRow(),
                  ],
                ),
              ),
            ],
          ),
        ),
        //BemVindo(widget.authBloc),
        // child: NoticiaLeituraPage(),
        authBloc: this.authBloc,
      ),
    );
  }

  iconeRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //SizedBox(width: MediaQuery.of(context).size.width * 0.066),
          icone(),
          SizedBox(width: MediaQuery.of(context).size.width * 0.03),
          icone(),
          SizedBox(width: MediaQuery.of(context).size.width * 0.03),
          icone(),
          //SizedBox(width: MediaQuery.of(context).size.width * 0.066),
        ],
      ),
    );
  }

  icone() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      height: MediaQuery.of(context).size.width * 0.28,
      decoration: BoxDecoration(
        color: PmsbColors.card,
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Icon(Icons.info, size: 60),
    );
  }
}
