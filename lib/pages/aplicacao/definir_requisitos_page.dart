import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/pages/aplicacao/definir_requisitos_page_bloc.dart';
import 'package:pmsbmibile3/pages/aplicacao/momento_aplicacao_page_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

// Aplicação 05

class DefinirRequisistosPage extends StatefulWidget {
  const DefinirRequisistosPage(this.momentoBloc, this.referencia,
      this.requisitoId, this.perguntaSelecionadaId,
      {Key key})
      : super(key: key);
  final String referencia;
  final String requisitoId;
  final String perguntaSelecionadaId;
  final MomentoAplicacaoPageBloc momentoBloc;

  @override
  _DefinirRequisistosPageState createState() => _DefinirRequisistosPageState();
}

class _DefinirRequisistosPageState extends State<DefinirRequisistosPage> {
  final bloc = DefinirRequisitosPageBloc(Bootstrap.instance.firestore);

  @override
  void initState() {
    super.initState();
    Bootstrap.instance.authBloc.perfil.listen((usuario) {
      bloc.dispatch(UpdateUsuarioDefinirRequisitosPageBlocEvent(usuario));
    });
    bloc.dispatch(
        UpdateReferenciaDefinirRequisitosPageBlocEvent(widget.referencia));
  }

  String _eixo = "eixo exemplo";
  String _setor = "setor exemplo";
  String _questionario = "questionario exemplo";
  String _local = "local exemplo";

  Widget _RadioTules() {
    return StreamBuilder<DefinirRequisitosPageBlocState>(
      stream: bloc.state,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: Text("SEM DADOS"),
          );
        if (snapshot.data.isFetching) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final perfungas =
            snapshot.data.perguntas != null ? snapshot.data.perguntas : [];

        return perfungas.length <= 0
            ? Center(
                child: Text("Nenhuma pergunta elegível", style: PmsbStyles.textoSecundario,),
              )
            : Column(
                children: perfungas
                    .map((pergunta) => RequisitoRadioTile(
                          widget.momentoBloc,
                          bloc,
                          pergunta,
                          widget.requisitoId,
                          widget.perguntaSelecionadaId,
                        ))
                    .toList(),
              );
      },
    );
  }

  Widget _preambulo() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(3),
          child: Text(
            "Eixo : $_eixo",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(3),
          child: Text(
            "Setor : $_setor",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(3),
          child: Text(
            "Questionário : $_questionario",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(3),
          child: Text(
            "Local : $_local",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(3),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            "Questionário 03 -> Pergunta 01",
            style: PmsbStyles.textoPrimario,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backToRootPage: false,
      title: Text("Definindo Referências"),
      body: ListView(children: <Widget>[
        //_preambulo(),
        _RadioTules(),
      ]),
    );
  }
}

class RequisitoRadioTile extends StatelessWidget {
  const RequisitoRadioTile(this.momentoBloc, this.bloc, this.perguntaAplicada,
      this.requisitoId, this.perguntaSelecionadaId,
      {Key key})
      : super(key: key);

  final DefinirRequisitosPageBloc bloc;
  final MomentoAplicacaoPageBloc momentoBloc;
  final PerguntaAplicadaModel perguntaAplicada;
  final String requisitoId;
  final String perguntaSelecionadaId;

  @override
  Widget build(BuildContext context) {
    //TODO: mudar para radio ou seleção por toque, porque é pra escolher somente um das opções disponiveis
    return InkWell(
      onTap: () {
        momentoBloc.dispatch(SelecionarRequisitoMomentoAplicacaoPageBlocEvent(
            requisitoId, perguntaAplicada.id));
        Navigator.of(context).pop();
      },
      child: ListTile(
        title: Text(
          "${perguntaSelecionadaId == perguntaAplicada.id ? "(selecionado)" : ""} Questionario: ${perguntaAplicada.questionario.nome} Referencia: ${perguntaAplicada.questionario.referencia}",
          style: TextStyle(
              color: perguntaSelecionadaId == perguntaAplicada.id
                  ? Colors.green
                  : null),
        ),
        subtitle: Text("Pergunta: ${perguntaAplicada.titulo}"),
      ),
    );
  }
}
