import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/login_required.dart';

import 'noticias/noticias_page.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return DefaultLoginRequired(
      child: NoticiasNaoVisualizadasPage(),
    );
  }
}
