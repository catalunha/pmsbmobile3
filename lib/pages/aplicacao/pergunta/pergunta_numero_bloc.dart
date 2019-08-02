import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/state/bloc.dart';

class PerguntaNumeroBlocEvent {}

class UpdateNumeroRespostaPerguntaNumeroBlocEvent
    extends PerguntaNumeroBlocEvent {
  final String _texto;

  double get numero {
    try {
      return double.parse(_texto);
    } catch (e) {
      return 0;
    }
  }

  UpdateNumeroRespostaPerguntaNumeroBlocEvent(this._texto);
}

class PerguntaNumeroBlocState {}

class PerguntaNumeroBloc
    extends Bloc<PerguntaNumeroBlocEvent, PerguntaNumeroBlocState> {
  final PerguntaAplicadaModel _perguntaAplicada;

  PerguntaNumeroBloc(this._perguntaAplicada);

  @override
  PerguntaNumeroBlocState getInitialState() {
    return PerguntaNumeroBlocState();
  }

  @override
  Future<void> mapEventToState(PerguntaNumeroBlocEvent event) async {
    if (event is UpdateNumeroRespostaPerguntaNumeroBlocEvent) {
      _perguntaAplicada.numero = event.numero;
    }
  }
}
