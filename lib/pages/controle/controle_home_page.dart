import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
// import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
//     if (dart.library.io) 'package:url_launcher/url_launcher.dart';


class ControleTarefaHomePage extends StatefulWidget {
  final AuthBloc authBloc;

  const ControleTarefaHomePage(this.authBloc);

  @override
  _ControleTarefaHomePageState createState() => _ControleTarefaHomePageState();
}

class _ControleTarefaHomePageState extends State<ControleTarefaHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backToRootPage: true,
      title: Text("Escolha um setor"),
      body: body(),
    );
  }

  Widget body() {
    return Container();
  }
}
