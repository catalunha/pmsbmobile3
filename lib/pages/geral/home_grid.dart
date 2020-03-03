import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/services/recursos.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';

class Rota {
  final String nome;
  final IconData icone;

  Rota(this.nome, this.icone);
}

class HomeGrid extends StatefulWidget {
  _HomeGridState createState() => _HomeGridState();
}

class _HomeGridState extends State<HomeGrid> {
  final AuthBloc authBloc;
  Map<String, Rota> rotas;

  _HomeGridState() : authBloc = Bootstrap.instance.authBloc {
    rotas = Map<String, Rota>();
    if (Recursos.instance.plataforma == 'android') {
      //rotas["/"] = Rota("Home", Icons.home);

      //rotas["/desenvolvimento"] = Rota("Desenvolvimento", Icons.build);

      //rotas["/resposta/home"] = Rota("Resposta", Icons.playlist_add_check);
      //rotas["/questionario/home"] = Rota("Questionários", Icons.assignment);
      //rotas["/aplicacao/home"] = Rota("Aplicar Questionário", Icons.directions_walk);

      rotas["/upload"] = Rota("Upload de arquivos", Icons.file_upload);

      rotas["/sintese/home"] = Rota("Síntese", Icons.equalizer);
      rotas["/produto/home"] = Rota("Produto", Icons.chrome_reader_mode);
      rotas["/controle/home"] = Rota("Controle", Icons.control_point);
      rotas["/setor_painel/home"] = Rota("Painel", Icons.compare);

      // rotas["/comunicacao/home"] = Rota("Comunicação", Icons.contact_mail);

      rotas["/administracao/home"] =  Rota("Administração", Icons.business_center);
    } else if (Recursos.instance.plataforma == 'web') {
      rotas["/"] = Rota("Home", Icons.home);
      rotas["/questionario/home"] = Rota("Questionários", Icons.assignment);
      rotas["/resposta/home"] = Rota("Resposta", Icons.playlist_add_check);
      rotas["/sintese/home"] = Rota("Síntese", Icons.equalizer);
      rotas["/produto/home"] = Rota("Produto", Icons.chrome_reader_mode);
      rotas["/controle/home"] = Rota("Controle", Icons.control_point);
      rotas["/setor_painel/home"] = Rota("Painel", Icons.compare);
      rotas["/administracao/home"] =
          Rota("Administração", Icons.business_center);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          iconeRow(
            <Widget>[
              icone(
                icon: Icons.assignment,
                iconName: "Questionários",
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/questionario/home");
                },
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.03),
              icone(
                icon: Icons.playlist_add_check,
                iconName: "Resposta",
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/resposta/home");
                },
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.03),
              icone(
                icon: Icons.directions_walk,
                iconName: "Aplicar",
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/aplicacao/home");
                },
              ),
            ],
          ),
      
      //rotas["/resposta/home"] = Rota("Resposta", Icons.playlist_add_check);
      //rotas["/upload"] = Rota("Upload de arquivos", Icons.file_upload);
     // rotas["/sintese/home"] = Rota("Síntese", Icons.equalizer);
      //rotas["/produto/home"] = Rota("Produto", Icons.chrome_reader_mode);

          iconeRow(
            <Widget>[
              icone(
                icon: Icons.file_upload,
                iconName: "Upload",
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/upload");
                },
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.03),
              icone(
                icon: Icons.equalizer,
                iconName: "Síntese",
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/sintese/home");
                },
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.03),
              icone(
                icon: Icons.chrome_reader_mode,
                iconName: "Produto",
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/produto/home");
                },
              ),
            ],
          ),
           iconeRow(
            <Widget>[
              icone(
                icon: Icons.control_point,
                iconName: "Controle",
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/controle/home");
                },
              ),
              // SizedBox(width: MediaQuery.of(context).size.width * 0.03),
              // icone(
              //   icon: Icons.equalizer,
              //   iconName: "Síntese",
              //   onTap: () {
              //     Navigator.pushReplacementNamed(context, "/sintese/home");
              //   },
              // ),
              // SizedBox(width: MediaQuery.of(context).size.width * 0.03),
              // icone(
              //   icon: Icons.directions_walk,
              //   iconName: "Produto",
              //   onTap: () {
              //     Navigator.pushReplacementNamed(context, "/produto/home");
              //   },
              // ),
            ],
          ),
        ],
      ),
    );
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

//  Drawer(
//       child: SafeArea(
//     child: Column(children: <Widget>[
//       StreamBuilder<UsuarioModel>(
//         stream: authBloc.perfil,
//         builder: (context, snap) {
//           if (snap.hasError) {
//             return Center(
//               child: Text("Erro"),
//             );
//           }
//           if (!snap.hasData)
//             return Center(
//               child: CircularProgressIndicator(),
//             );

//           return Container(

//           );
//         },
//       ),

//       StreamBuilder<UsuarioModel>(
//           stream: authBloc.perfil,
//           builder: (context, snap) {
//             if (snap.hasError) {
//               return Center(
//                 child: Text("Erro"),
//               );
//             }

//             List<Widget> list = List<Widget>();
//             if (snap.data == null ||
//                 snap.data.routes == null ||
//                 snap.data.routes.isEmpty) {
//               list.add(Container());
//             } else {
//               rotas.forEach((k, v) {
//                 if (snap.data.routes.contains(k)) {
//                   list.add(ListTile(
//                     title: Text(v.nome),
//                     trailing: Icon(v.icone),
//                     onTap: () {
//                       Navigator.pushReplacementNamed(context, k);
//                     },
//                   ));
//                 }
//               });
//             }
//             if (list.isEmpty || list == null) {
//               list.add(Container());
//             }
//             return Expanded(child: ListView(children: list));
//           })
//     ]),
//   ));
