import 'package:flutter/material.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';

class EquipeWrapWidget extends StatefulWidget {
  @override
  _EquipeWrapWidgetState createState() => _EquipeWrapWidgetState();
}

class _EquipeWrapWidgetState extends State<EquipeWrapWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              textoQuadro("Equipe"),
              IconButton(icon: Icon(Icons.person_add), onPressed: () {})
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.77,
            child: Wrap(
              direction: Axis.horizontal,
              textDirection: TextDirection.ltr,
              spacing: 8.0,
              runSpacing: 4.0,
              children: <Widget>[
                Chip(
                  backgroundColor: PmsbColors.card,
                  avatar: CircleAvatar(

                      backgroundColor: PmsbColors.cor_destaque,
                      child: Text('BS')),
                  label: Text('Bruno'),
                ),
                Chip(
                  backgroundColor: PmsbColors.card,
                  avatar: CircleAvatar(
                      backgroundColor: PmsbColors.cor_destaque,
                      child: Text('TL')),
                  label: Text('Tiago'),
                ),
                Chip(
                  backgroundColor: PmsbColors.card,
                  avatar: CircleAvatar(
                      backgroundColor: PmsbColors.cor_destaque,
                      child: Text('SM')),
                  label: Text('Susana'),
                ),
                Chip(
                  backgroundColor: PmsbColors.card,
                  avatar: CircleAvatar(
                      backgroundColor: PmsbColors.cor_destaque,
                      child: Text('MJ')),
                  label: Text('Mariana'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget textoQuadro(String texto) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 30),
      child: Text(
        texto,
        style: TextStyle(
          color: PmsbColors.texto_secundario,
          fontSize: 18,
        ),
      ),
    );
  }
}
