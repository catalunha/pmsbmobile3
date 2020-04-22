import 'package:flutter/material.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';

class PmsbStyles {
  PmsbStyles._();
  static const TextStyle textStyleListPerfil = TextStyle(
    color: PmsbColors.texto_secundario,
    fontSize: 14,
  );

  static const TextStyle textStyleListPerfil01 = TextStyle(
    color: PmsbColors.texto_secundario,
    fontSize: 16,
  );

  static const TextStyle textStyleListPerfilDark01 = TextStyle(
    color: PmsbColors.navbar,
    fontSize: 16,
  );

  static const TextStyle textStyleListPerfilDarkMedio01 = TextStyle(
    color: PmsbColors.fundo,
    fontSize: 16,
  );

  static const TextStyle textStyleListDarkBold = TextStyle(
      color: PmsbColors.navbar, fontSize: 18, fontWeight: FontWeight.bold);

  static const TextStyle textoPrimarioDark = TextStyle(
    color: Colors.black,
    fontSize: 16,
  );

  static const TextStyle textStyleListBold = TextStyle(
      color: PmsbColors.texto_secundario,
      fontSize: 18,
      fontWeight: FontWeight.bold);

  static const TextStyle textoPrimario = TextStyle(
    color: PmsbColors.texto_primario,
    fontSize: 16,
  );

  static const TextStyle textoSecundario = TextStyle(
    color: PmsbColors.texto_secundario,
    fontSize: 14,
  );
}
