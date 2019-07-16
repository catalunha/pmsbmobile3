import 'package:flutter/widgets.dart';
import 'dart:io';

class ArquivoLocalModel {
  String nome;
  String endereco;

  ArquivoLocalModel({@required this.nome, @required this.endereco});
}

class ArquivoLocalListModel {

  Set<ArquivoLocalModel> _listaArquivos = Set<ArquivoLocalModel>();

  ArquivoLocalListModel();

  getListaAquivos() => _listaArquivos.toList();

  //funcao que vai converter de list para o formato que vai ser enviado ao firebase
  getListaFormatoFirebase() => null;

  getArquivoPorIndex(int index) => _listaArquivos.toList()[index];
  
  void removerArquivoLista(ArquivoLocalModel arquivo){
    _listaArquivos.remove(arquivo);
  }

  void setNovosArquivo(arquivoNovo){
  //verificar se nao e nulo e entao retorna direcionar o dado de acordo com o tipo
        if (arquivoNovo != null)
          {
            arquivoNovo.length > 1
                ? _adicionarArquivosMultiplosLista(arquivoNovo)
                : _adicionarArquivoIndividualLista(arquivoNovo);
          }
      }

  void _adicionarArquivoIndividualLista(Map<String, String> arquivoNovo) {
    String nome = arquivoNovo.keys.toList()[0];
    String endereco = arquivoNovo.values.toList()[0];

    _listaArquivos.add(new ArquivoLocalModel(nome: nome, endereco: endereco));
  }

  void _adicionarArquivosMultiplosLista(Map<String, String> arquivosNovos) {
    arquivosNovos.forEach((nome,endereco)=>{
          _listaArquivos.add(new ArquivoLocalModel(nome: nome, endereco: endereco))
    });
  }

  Future<File> _localFile(String _localPath) async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }


}
