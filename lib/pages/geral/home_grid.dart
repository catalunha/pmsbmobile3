import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/services/recursos.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/widgets/opcao_card.dart';

class HomeGrid extends StatefulWidget {
  _HomeGridState createState() => _HomeGridState();
}

class _HomeGridState extends State<HomeGrid> {
  final AuthBloc authBloc;

  List<RotaGridAction> opcoes = <RotaGridAction>[];

  Map<String, RotaGrid> rotas;

  _HomeGridState() : authBloc = Bootstrap.instance.authBloc {
    rotas = Map<String, RotaGrid>();

    if (Recursos.instance.plataforma == 'android') {
      rotas["/questionario/home"] = RotaGrid("Questionários", Icons.assignment);
      rotas["/aplicacao/home"] = RotaGrid("Aplicar", Icons.directions_walk);
      rotas["/resposta/home"] = RotaGrid("Resposta", Icons.playlist_add_check);
      rotas["/sintese/home"] = RotaGrid("Síntese", Icons.equalizer);
      rotas["/produto/home"] = RotaGrid("Produto", Icons.chrome_reader_mode);
      rotas["/painel/home"] = RotaGrid("Itens do painel", Icons.table_chart);
      rotas["/setor_painel/home"] = RotaGrid("Painel", Icons.compare);
      rotas["/controle/home"] = RotaGrid("Controle", Icons.control_point);
      rotas["/checklist/produto/list"] = RotaGrid("Checklist", Icons.check_box);
      rotas["/administracao/home"] = RotaGrid("Equipe", Icons.business_center);
      rotas["/upload"] = RotaGrid("Upload", Icons.file_upload);
      rotas["/desenvolvimento"] = RotaGrid("Desenvolv", Icons.build);

      // rotas["/comunicacao/home"] = Rota("Comunicação", Icons.contact_mail);
      // rotas["/administracao/home"] = Rota("Administração", Icons.business_center);
      // rotas["/"] = Rota("Home", Icons.home);
    } else if (Recursos.instance.plataforma == 'web') {
      // rotas["/"] = Rota("Home", Icons.home);
      rotas["/questionario/home"] = RotaGrid("Questionários", Icons.assignment);
      rotas["/resposta/home"] = RotaGrid("Resposta", Icons.playlist_add_check);
      rotas["/sintese/home"] = RotaGrid("Síntese", Icons.equalizer);
      rotas["/produto/home"] = RotaGrid("Produto", Icons.chrome_reader_mode);
      rotas["/painel/home"] = RotaGrid("Itens do painel", Icons.table_chart);
      rotas["/setor_painel/home"] = RotaGrid("Painel", Icons.compare);
      rotas["/controle/home"] = RotaGrid("Controle", Icons.control_point);
      rotas["/checklist/produto/list"] = RotaGrid("Checklist", Icons.check_box);
      rotas["/administracao/home"] = RotaGrid("Equipe", Icons.business_center);
      // rotas["/administracao/home"] =  Rota("Administração", Icons.business_center);
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _heigth = MediaQuery.of(context).size.height;

    return Container(
      // height: 500,
      child: StreamBuilder<UsuarioModel>(
        stream: authBloc.perfil,
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(
              child: Text("Erro"),
            );
          }

          var listaRotasKey = rotas.keys.toList();
          var listaRotasValue = rotas.values.toList();

          return Padding(
            padding: EdgeInsets.all(
              kIsWeb ? (_width > 800 ? 20 : 3) : 3,
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  // child: Text("Geral", style: PmsbStyles.textStyleListBold),
                ),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: kIsWeb ? (_width > 1000 ? 6 : 4) : 3,
                    // crossAxisSpacing: kIsWeb ? (_width > 1000 ? 30 : 30 ) : 5,
                    // mainAxisSpacing: kIsWeb ? (_width > 1000 ? 30 : 30) : 5,
                  ),
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: rotas.length,
                  itemBuilder: (context, int index) {
                    var rotaKey = listaRotasKey[index];
                    var rotaValue = listaRotasValue[index];

                    if (snap.data == null ||
                        snap.data.routes == null ||
                        snap.data.routes.isEmpty) {
                      return Container();
                    } else if (snap.data.routes.contains(rotaKey)) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: kIsWeb
                              ? (_width > 800 ? _heigth * 0.03 : _heigth * 0.00125)
                              : _width * 0.00125,
                          vertical: kIsWeb
                              ? (_width > 800 ? _heigth * 0.03 : _heigth * 0.00125)
                              : _width * 0.00125,
                        ),
                        child: OpcaoCard(
                          width: _width * 0.28,
                          // kIsWeb
                          //     ? (_width > 800 ? _width * 0.10 : _width * 0.30)
                          //     : _width * 0.28,
                          height: _width * 0.28,
                          //  kIsWeb
                          //     ? (_heigth > 800
                          //         ? _heigth * 0.10
                          //         : _heigth * 0.30)
                          //     : _heigth * 0.28,
                          rotaAction: RotaGridAction(
                            RotaGrid(rotaValue.nome, rotaValue.icone),
                            () {
                              Navigator.pushReplacementNamed(context, rotaKey);
                            },
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  // child: Text("Geral", style: PmsbStyles.textStyleListBold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// this.list = List<Widget>();

// if (snap.data == null ||
//     snap.data.routes == null ||
//     snap.data.routes.isEmpty) {
//   this.list.add(Container());
// } else {
//   rotas.forEach((k, v) {
//     if (snap.data.routes.contains(k)) {
//       opcoes.add(
//         RotaGridAction(
//           RotaGrid(v.nome, v.icone),
//           () {
//             Navigator.pushReplacementNamed(context, k);
//           },
//         ),
//       );
//     }
//   });
// }

// if (list.isEmpty || list == null) {
//   list.add(Container());
// }
