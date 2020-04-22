import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';

class RotaGrid {
  final String nome;
  final IconData icone;
  RotaGrid(this.nome, this.icone);
}

class RotaGridAction {
  final RotaGrid rota;
  final Function action;
  RotaGridAction(this.rota, this.action);
}

class OpcaoCard extends StatelessWidget {
  const OpcaoCard({Key key, this.rotaAction, this.contextTela}) : super(key: key);
  
  final RotaGridAction rotaAction;
  final BuildContext contextTela;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: rotaAction.action,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          width: 30,
          // kIsWeb
          //     ? (MediaQuery.of(this.contextTela).size.width > 800
          //         ? MediaQuery.of(this.contextTela).size.width * 0.10
          //         : MediaQuery.of(this.contextTela).size.width * 0.10)
          //     : MediaQuery.of(this.contextTela).size.width * 0.28,
          height: 30,
          // kIsWeb
          //     ? (MediaQuery.of(this.contextTela).size.width > 800
          //         ? MediaQuery.of(this.contextTela).size.width * 0.10
          //         : MediaQuery.of(this.contextTela).size.width * 0.10)
          //     : MediaQuery.of(this.contextTela).size.width * 0.28,

          // MediaQuery.of(context).size.width > 800
          //     ? MediaQuery.of(context).size.width * 0.14
          //     : MediaQuery.of(context).size.width * 0.28,
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
      ),
    );
  }
}
