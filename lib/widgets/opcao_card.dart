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
  final double width;
  final double height;
  final RotaGridAction rotaAction;

  const OpcaoCard(
      {Key key, this.rotaAction, @required this.height, @required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: rotaAction.action,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          width: this.width,
          // kIsWeb
          //     ? (MediaQuery.of(this.contextTela).size.width > 800
          //         ? MediaQuery.of(this.contextTela).size.width * 0.10
          //         : MediaQuery.of(this.contextTela).size.width * 0.10)
          //     : MediaQuery.of(this.contextTela).size.width * 0.28,
          height: this.height,
          // kIsWeb
          //     ? (MediaQuery.of(this.contextTela).size.width > 800
          //         ? MediaQuery.of(this.contextTela).size.width * 0.10
          //         : MediaQuery.of(this.contextTela).size.width * 0.10)
          //     : MediaQuery.of(this.contextTela).size.width * 0.28,,
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
