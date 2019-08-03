import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/state/bloc.dart';

class PerguntaTextoBlocEvent {}

class UpdateTextoRespostaPerguntaTextoBlocEvent extends PerguntaTextoBlocEvent {
  final String texto;

  UpdateTextoRespostaPerguntaTextoBlocEvent(this.texto);
}

class PerguntaTextoBlocState {}

class PerguntaTextoBloc
    extends Bloc<PerguntaTextoBlocEvent, PerguntaTextoBlocState> {
  final PerguntaAplicadaModel _perguntaAplicada;

  PerguntaTextoBloc(this._perguntaAplicada);

  @override
  PerguntaTextoBlocState getInitialState() {
    return PerguntaTextoBlocState();
  }

  @override
  Future<void> mapEventToState(PerguntaTextoBlocEvent event) async {
    if (event is UpdateTextoRespostaPerguntaTextoBlocEvent) {
      _perguntaAplicada.texto = event.texto;
    }
  }
}
