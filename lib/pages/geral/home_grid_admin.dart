import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/services/recursos.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

class Rota {
  final String nome;
  final IconData icone;
  Rota(this.nome, this.icone);
}

class RotaAction {
  final Rota rota;
  final Function action;
  RotaAction(this.rota, this.action);
}

class HomeGridAdmin extends StatefulWidget {
  _HomeGridAdminState createState() => _HomeGridAdminState();
}

class _HomeGridAdminState extends State<HomeGridAdmin> {
  final AuthBloc authBloc;
  List<RotaAction> opcoes = <RotaAction>[];
  Map<String, Rota> rotas;

  _HomeGridAdminState() : authBloc = Bootstrap.instance.authBloc {
    rotas = Map<String, Rota>();

    if (Recursos.instance.plataforma == 'android') {
      rotas["/painel/home"] = Rota("Painel", Icons.table_chart);
      rotas["/administracao/home"] =
          Rota("Administração", Icons.business_center);
    } else if (Recursos.instance.plataforma == 'web') {
      // rotas["/"] = Rota("Home", Icons.home);
      // rotas["/questionario/home"] = Rota("Questionários", Icons.assignment);
      // rotas["/resposta/home"] = Rota("Resposta", Icons.playlist_add_check);
      // rotas["/sintese/home"] = Rota("Síntese", Icons.equalizer);
      // rotas["/produto/home"] = Rota("Produto", Icons.chrome_reader_mode);
      // rotas["/controle/home"] = Rota("Controle", Icons.control_point);
      // rotas["/setor_painel/home"] = Rota("Painel", Icons.compare);
      // rotas["/administracao/home"] =
      //     Rota("Administração", Icons.business_center);
    }
  }

  @override
  Widget build(BuildContext context) {
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

          List<Widget> list = List<Widget>();
          
          if (snap.data == null ||
              snap.data.routes == null ||
              snap.data.routes.isEmpty) {
            list.add(Container());
          } else {
            rotas.forEach((k, v) {
              if (snap.data.routes.contains(k)) {
                opcoes.add(
                  RotaAction(
                    Rota(v.nome, v.icone),
                    () {
                      Navigator.pushReplacementNamed(context, k);
                    },
                  ),
                );
                // list.add(icone(
                //         icon: Icons.ac_unit,
                //         iconName: "Teste",
                //         onTap: () {
                //           print("hey");
                //         })
                //   ListTile(
                //   title: Text(v.nome,style: PmsbStyles.textStyleListBold,),
                //   trailing: Icon(v.icone),
                //   onTap: () {
                //     Navigator.pushReplacementNamed(context, k);
                //   },
                // )
                // );
              }
            });
          }
          
          if (list.isEmpty || list == null) {
            list.add(Container());
          }

          return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child:
                    Text("Administração", style: PmsbStyles.textStyleListBold),
              ),
              GridView.count(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                crossAxisCount: 3,
                children: List.generate(
                  opcoes.length,
                  (index) {
                    return Center(
                      child: OpcaoCard(rotaAction: opcoes[index]),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );

    // Container(
    //   child: Column(
    //     children: <Widget>[
    //       Padding(
    //         padding: EdgeInsets.all(8),
    //         child: Text("Administração", style: PmsbStyles.textStyleListBold),
    //       ),
    //       iconeRow(
    //         <Widget>[
    //           icone(
    //             icon: Icons.business_center,
    //             iconName: "Equipe",
    //             onTap: () {
    //               Navigator.pushReplacementNamed(
    //                   context, "/administracao/home");
    //             },
    //           ),
    //           SizedBox(width: MediaQuery.of(context).size.width * 0.03),
    //           icone(
    //             icon: Icons.table_chart,
    //             iconName: "Painel",
    //             onTap: () {
    //               Navigator.pushReplacementNamed(context, "/painel/home");
    //             },
    //           ),
    //           SizedBox(width: MediaQuery.of(context).size.width * 0.03),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }

  iconeRow(List<Widget> iconsLista) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center, children: iconsLista),
    );
  }

  icone({IconData icon, String iconName, GestureTapCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        height: MediaQuery.of(context).size.width * 0.28,
        decoration: BoxDecoration(
          color: PmsbColors.card,
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[Icon(icon, size: 50), Text(iconName)],
        ),
      ),
    );
  }
}

class OpcaoCard extends StatelessWidget {
  const OpcaoCard({Key key, this.rotaAction}) : super(key: key);
  final RotaAction rotaAction;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return GestureDetector(
      onTap: rotaAction.action,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        height: MediaQuery.of(context).size.width * 0.28,
        decoration: BoxDecoration(
          color: PmsbColors.card,
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(rotaAction.rota.icone, size: 50),
            Text(rotaAction.rota.nome)
          ],
        ),
      ),
    );
  }
}
