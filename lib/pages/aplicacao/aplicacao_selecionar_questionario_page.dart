import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/pages/aplicacao/momento_aplicacao_page_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';

class AplicacaoSelecionarQuestionarioPage extends StatefulWidget {
  final MomentoAplicacaoPageBloc bloc;

  const AplicacaoSelecionarQuestionarioPage(this.bloc, {Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AplicacaoSelecionarQuestionarioPage(bloc);
  }
}

class _AplicacaoSelecionarQuestionarioPage
    extends State<AplicacaoSelecionarQuestionarioPage> {
  final MomentoAplicacaoPageBloc bloc;

  _AplicacaoSelecionarQuestionarioPage(this.bloc);

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backToRootPage: false,
      title: Text("Selecionar Questionario"),
      body: SafeArea(
        child: StreamBuilder<MomentoAplicacaoPageBlocState>(
            stream: bloc.state,
            builder: (context, snapshot) {
              final questionarios = snapshot.data?.questionarios != null
                  ? snapshot.data.questionarios
                  : [];
              return ListView(
                children: questionarios
                    .map((q) => SelectionarQuestionarioItem(bloc, q))
                    .toList(),
              );
            }),
      ),
    );
  }
}

class SelectionarQuestionarioItem extends StatelessWidget {
  final QuestionarioModel questionario;
  final bloc;

  const SelectionarQuestionarioItem(this.bloc, this.questionario, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        color: PmsbColors.card,
        child: Container(
          padding: EdgeInsets.all(24),
          child: Center(
            child: Text("${questionario.nome}"),
          ),
        ),
      ),
      onTap: () {
        bloc.dispatch(
            SelecionarQuestionarioMomentoAplicacaoPageBlocEvent(questionario));
        Navigator.pop(context);
      },
    );
  }
}
