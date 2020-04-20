import 'package:flutter/material.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';

class RoundImage extends StatelessWidget {
  final String fotoUrl;
  final String fotoLocalPath;
  final double width;
  final double heigth;
  final Color corBorda;
  final double espesuraBorda;

  const RoundImage(
      {@required this.fotoUrl,
      @required this.fotoLocalPath,
      @required this.width,
      @required this.heigth,
      @required this.corBorda,
      @required this.espesuraBorda});

  @override
  Widget build(BuildContext context) {
    Widget foto;
    final _width = MediaQuery.of(context).size.width;

    if (fotoUrl != null) {
      foto = Container(
        width: width, // espessura da imagem de perfil
        height: heigth, // altura da imagem de perfil
        decoration: BoxDecoration(
          color: PmsbColors.card,

          border: Border.all(
            width: this.espesuraBorda, //espessura da borda
            color: this.corBorda,
          ),
          shape: BoxShape.circle, //formato imagem
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(fotoUrl), //chama url
          ),
        ),
      );
    } else {
      String mensagem = (fotoUrl == null && fotoLocalPath == null)
          ? "Sem imagem."
          : "Não enviada.";

      foto = Stack(
        children: <Widget>[
          Container(
            width: width, // espessura da imagem de perfil
            height: heigth, // altura da imagem de perfil
            decoration: BoxDecoration(
              color: PmsbColors.card,
              //borda ao redor da imagem de perfil
              border: Border.all(
                width: this.espesuraBorda, //espessura da borda
                color: this.corBorda, // cor da borda
              ),
              shape: BoxShape.circle, //formato imagem
            ),
          ),
          Positioned(
              top: _width * 0.15, left: _width * 0.050, child: Text(mensagem)),
        ],
      );
    }
    return foto;
  }
}
