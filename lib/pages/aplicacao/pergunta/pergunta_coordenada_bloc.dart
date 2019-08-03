import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/state/bloc.dart';

class PerguntaCoordenadaBlocEvent {}

class SaveCoordenadaPerguntaCoordenadaBlocEvent
    extends PerguntaCoordenadaBlocEvent {}

class AdicionarCoordenadaPerguntaCoordenadaBlocEvent
    extends PerguntaCoordenadaBlocEvent {
  final double latitude;
  final double longitude;

  AdicionarCoordenadaPerguntaCoordenadaBlocEvent(this.latitude, this.longitude);
}

class RemoverCoordenadaPerguntaCoordenadaBlocEvent
    extends PerguntaCoordenadaBlocEvent {
  final Coordenada coordenada;

  RemoverCoordenadaPerguntaCoordenadaBlocEvent(this.coordenada);
}

class PerguntaCoordenadaBlocState {
  List<Coordenada> _listaLocalizao = List<Coordenada>();

  set listaLocalizao(List<Coordenada> coordenadas) {
    if (coordenadas != null) _listaLocalizao = coordenadas;
  }

  List<Coordenada> get listaLocalizao {
    return _listaLocalizao != null ? _listaLocalizao : [];
  }
}

class PerguntaCoordenadaBloc
    extends Bloc<PerguntaCoordenadaBlocEvent, PerguntaCoordenadaBlocState> {
  final PerguntaAplicadaModel _perguntaAplicada;

  PerguntaCoordenadaBloc(this._perguntaAplicada) : super() {
    updateState();
  }

  void updateState() {
    currentState.listaLocalizao = _perguntaAplicada.coordenada;
  }

  @override
  PerguntaCoordenadaBlocState getInitialState() {
    return PerguntaCoordenadaBlocState();
  }

  @override
  Future<void> mapEventToState(PerguntaCoordenadaBlocEvent event) async {
    if (event is AdicionarCoordenadaPerguntaCoordenadaBlocEvent) {
      currentState.listaLocalizao
          .add(Coordenada(latitude: event.latitude, longitude: event.latitude));
    }
    if (event is RemoverCoordenadaPerguntaCoordenadaBlocEvent) {
      currentState.listaLocalizao.remove(event.coordenada);
    }
    if (event is SaveCoordenadaPerguntaCoordenadaBlocEvent) {
      //TODO: arrayUnion
      //TODO: arrayRemove
    }
  }
}
