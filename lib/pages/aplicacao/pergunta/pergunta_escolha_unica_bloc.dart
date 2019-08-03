import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/state/bloc.dart';

class PerguntaEscolhaUnicaBlocEvent {}

class MudarEscolhaPerguntaEscolhaUnicaBlocEvent
    extends PerguntaEscolhaUnicaBlocEvent {
  final String id;

  MudarEscolhaPerguntaEscolhaUnicaBlocEvent(this.id);
}

class UpdateEscolhaSelecionadaPerguntaEscolhaUnicaBlocEvent
    extends PerguntaEscolhaUnicaBlocEvent {}

class PerguntaEscolhaUnicaBlocState {
  String escolhaID;
}

class PerguntaEscolhaUnicaBloc
    extends Bloc<PerguntaEscolhaUnicaBlocEvent, PerguntaEscolhaUnicaBlocState> {
  final PerguntaAplicadaModel _perguntaAplicada;

  PerguntaEscolhaUnicaBloc(this._perguntaAplicada) {
    dispatch(UpdateEscolhaSelecionadaPerguntaEscolhaUnicaBlocEvent());
  }

  @override
  PerguntaEscolhaUnicaBlocState getInitialState() {
    return PerguntaEscolhaUnicaBlocState();
  }

  @override
  Future<void> mapEventToState(PerguntaEscolhaUnicaBlocEvent event) async {
    if (event is UpdateEscolhaSelecionadaPerguntaEscolhaUnicaBlocEvent) {
      _perguntaAplicada.escolhas.forEach((k, escolha) {
        if (escolha.marcada) {
          if (currentState.escolhaID == null) {
            currentState.escolhaID = k;
          } else {
            escolha.marcada = false;
          }
        }
      });
    }

    if (event is MudarEscolhaPerguntaEscolhaUnicaBlocEvent) {
      currentState.escolhaID = event.id;
      _perguntaAplicada.escolhas.forEach((k, escolha) {
        if (k == event.id) {
          escolha.marcada = true;
        } else {
          escolha.marcada = false;
        }
      });
    }
  }
}
