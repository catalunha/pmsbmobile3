import 'package:pmsbmibile3/state/services.dart';
import 'package:rxdart/rxdart.dart';

class EditarVariavelBlocEvent {}

class UpdateConteudoEditarVariavelBlocEvent extends EditarVariavelBlocEvent {
  final String conteudo;

  UpdateConteudoEditarVariavelBlocEvent(this.conteudo);
}

class UpdateUserIdEditarVariavelBlocEvent extends EditarVariavelBlocEvent {
  final String userId;

  UpdateUserIdEditarVariavelBlocEvent(this.userId);
}

class UpdateVariavelIdEditarVariavelBlocEvent extends EditarVariavelBlocEvent {
  final String variavelId;

  UpdateVariavelIdEditarVariavelBlocEvent(this.variavelId);
}

class UpdateTipoEditarVariavelBlocEvent extends EditarVariavelBlocEvent {
  final String tipo;

  UpdateTipoEditarVariavelBlocEvent(this.tipo);
}

class UpdateNomeEditarVariavelBlocEvent extends EditarVariavelBlocEvent {
  final String nome;

  UpdateNomeEditarVariavelBlocEvent(this.nome);
}

class SaveEditarVariavelBlocEvent extends EditarVariavelBlocEvent {}

class EditarVariavelBlocState {
  String conteudo;
  String userId;
  String variavelId;
  String tipo;
  String nome;
}

class EditarVariavelBloc {
  final DatabaseService _databaseService;
  final _state = EditarVariavelBlocState();

  final _inputController = BehaviorSubject<EditarVariavelBlocEvent>();

  Function get disptach => _inputController.add;

  final _outputController = BehaviorSubject<EditarVariavelBlocState>();

  Stream<EditarVariavelBlocState> get state => _outputController.stream;

  final _salvandoController = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get isSalvando => _salvandoController.stream;

  EditarVariavelBloc(this._databaseService) {
    _inputController.listen(_handleInputEvent);
  }

  void dispose() {
    _inputController.close();
    _outputController.close();
    _salvandoController.close();
  }

  void _handleInputEvent(EditarVariavelBlocEvent event) {
    if (event is UpdateConteudoEditarVariavelBlocEvent) {
      _state.conteudo = event.conteudo;
    }
    if (event is UpdateTipoEditarVariavelBlocEvent) {
      _state.tipo = event.tipo;
    }
    if (event is UpdateUserIdEditarVariavelBlocEvent) {
      _state.userId = event.userId;
    }
    if (event is UpdateVariavelIdEditarVariavelBlocEvent) {
      _state.variavelId = event.variavelId;
    }
    if(event is UpdateNomeEditarVariavelBlocEvent){
      _state.nome = event.nome;
    }
    if (event is SaveEditarVariavelBlocEvent) {
      _handleSaveEvent();
    }
    _outputController.add(_state);
  }

  _handleSaveEvent() {
    _salvandoController.add(true);
    _databaseService.updateVariavelUsuario(
      userId: _state.userId,
      conteudo: _state.conteudo,
      nome: _state.nome,
      tipo: _state.tipo,
      variavelId: _state.variavelId,
    ).then((_){
      _salvandoController.add(false);
    }, onError: (e){
      _salvandoController.add(false);
    });

  }
}
