import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/state/bloc.dart';

class PerguntaCoordenadaBlocEvent {}

class AdicionarCoordenadaPerguntaCoordenadaBlocEvent
    extends PerguntaCoordenadaBlocEvent {
  final double latitude;
  final double longitude;
  final double altitude;
  final double accuracy;

  AdicionarCoordenadaPerguntaCoordenadaBlocEvent(
    this.latitude,
    this.longitude,
    this.altitude,
    this.accuracy,
  );
}

class RemoverCoordenadaPerguntaCoordenadaBlocEvent
    extends PerguntaCoordenadaBlocEvent {
  final Coordenada coordenada;

  RemoverCoordenadaPerguntaCoordenadaBlocEvent(this.coordenada);
}

class PerguntaCoordenadaBlocState {}

class PerguntaCoordenadaBloc
    extends Bloc<PerguntaCoordenadaBlocEvent, PerguntaCoordenadaBlocState> {
  final PerguntaAplicadaModel _perguntaAplicada;

  PerguntaCoordenadaBloc(this._perguntaAplicada);

  @override
  PerguntaCoordenadaBlocState getInitialState() {
    return PerguntaCoordenadaBlocState();
  }

  @override
  Future<void> mapEventToState(PerguntaCoordenadaBlocEvent event) async {
    if (event is AdicionarCoordenadaPerguntaCoordenadaBlocEvent) {
      final coordenada = Coordenada(
        latitude: event.latitude,
        longitude: event.latitude,
        altitude: event.altitude,
        accuracy: event.accuracy,
      );
      _perguntaAplicada.coordenada.add(coordenada);
    }
    if (event is RemoverCoordenadaPerguntaCoordenadaBlocEvent) {
      _perguntaAplicada.coordenada.remove(event.coordenada);
    }
  }
}
