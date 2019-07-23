
## Salvar o backup em formato de json

~~~dart
    UsuarioModel user = UsuarioModel(id: 'idteste').fromMap({
    "nome": "nome-valor",
    "celular": "celular-valor",
    "cargoID": {"id": "CargoID", "nome": "Cargo_nome"},
    "eixoID": {"id": "EixoID", "nome": "Eixo_nome"},
    "eixoIDAcesso": [
        {"id": "EixoID -> RS", "nome": "nome-valor"},
        {"id": "EixoID -> AA", "nome": "nome-valor"}
    ]
    });
    //SalvarBackup recebe uma instacia de um objeto qualquer
    await SalvarBackupArquivosService.salvarArquivoComoJsonNoStorage(user);
~~~

