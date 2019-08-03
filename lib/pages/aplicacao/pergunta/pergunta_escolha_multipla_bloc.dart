import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/state/bloc.dart';

class PerguntaEscolhaMultiplaBlocEvent {}

class AlternarEstadoEscolhaPerguntaEscolhaMultiplaBlocEvent
    extends PerguntaEscolhaMultiplaBlocEvent {
  final String id;

  AlternarEstadoEscolhaPerguntaEscolhaMultiplaBlocEvent(this.id);
}

class PerguntaEscolhaMultiplaBlocState {}

class PerguntaEscolhaMultiplaBloc extends Bloc<PerguntaEscolhaMultiplaBlocEvent,
    PerguntaEscolhaMultiplaBlocState> {
  final PerguntaAplicadaModel _perguntaAplicada;

  PerguntaEscolhaMultiplaBloc(this._perguntaAplicada);

  @override
  PerguntaEscolhaMultiplaBlocState getInitialState() {
    return PerguntaEscolhaMultiplaBlocState();
  }

  @override
  Future<void> mapEventToState(PerguntaEscolhaMultiplaBlocEvent event) async {
    if (event is AlternarEstadoEscolhaPerguntaEscolhaMultiplaBlocEvent) {
      _perguntaAplicada.escolhas[event.id].marcada =
          !_perguntaAplicada.escolhas[event.id].marcada;
    }
  }
}
