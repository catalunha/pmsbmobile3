## Bloc de elementos que não estão abaixo da na sua arvore

Solução:
- Injetar a dependencia apartir dos widgets que fazem parte da sua arvore principal
- Registrar usando um Provider no primeiro nivel e disponibilizar para toda a arvores "irmã". Se sua arvore fora da estrutura principal ficar muito complicada e a injeção de dependencifa passar de um(1) elemento.

O padrão usado ate agora é 

~~~dart
class XPageEvent{}

class UpdateFieldEvent extends XPageEvent{}

class XPageState{
    String field;
}

class XPageBloc{
  // Firestore

  //Event controller, stream, sink

  //State xPageState, controller, stream, sink


  //Model controller, stream, sink

  XPageBloc();

  void dispose() {}

  _mapEventToState(){}


}

~~~

[veja lá](https://github.com/catalunha/pmsbmobile3/blob/master/lib/bootstrap.dart)
