import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/state/bloc.dart';

class PerguntaEscolhaUnicaBlocEvent {}

class PerguntaEscolhaUnicaBlocState {}

class PerguntaEscolhaUnicaBloc
    extends Bloc<PerguntaEscolhaUnicaBlocEvent, PerguntaEscolhaUnicaBlocState> {
  final PerguntaAplicadaModel _perguntaAplicada;

  PerguntaEscolhaUnicaBloc(this._perguntaAplicada);

  @override
  PerguntaEscolhaUnicaBlocState getInitialState() {
    return PerguntaEscolhaUnicaBlocState();
  }

  @override
  Future<void> mapEventToState(PerguntaEscolhaUnicaBlocEvent event) async {}
}
