# Regras

# Diretrizes

# Functions
Cada subtitulo a seguir fala a cerca de uma function especifica.
Consulte sempre o arquivo **arq_models.json**

## Perfil
### Function PerfilToUsuarioPerfil
Quando um novo documento de perfil for cadastrado em **Perfil** a function deverá cadastrar este perfil em **UsuarioPerfil** constando apenas as partes
~~~json
{
  "UsuarioPerfil": {
    "usuarioID": {
      "id": "UsuarioID",
      "nome": "UsuarioID->Nome"
    },
    "perfilID": {
      "id": "PerfilID",
      "nome": "nome-valor",
      "contentType": "contentType-valor"
    }
  }
}
~~~

## Usuario
### Function UsuarioUpdateNome
Quando o usuario atualizar estes campos nesta coleção: 
~~~json
"Usuario": {
  "nome": "nome-valor",
}
~~~
A function deverá atualizar as seguintes coleções que se referenciam a ela
~~~json
  "UsuarioPerfil": {
    "usuario": {
      "usuarioID": "UsuarioID",
      "nome": "UsuarioIDNome"
    },
  }
~~~
~~~json
"Noticia": {
  "editor": {
    "usuarioID": "UsuarioID",
    "nome": "UsuarioIDNome"
  },
  "destinatario": {
    "usuarioID": {
      "id": true,
      "nome": "nome-valor",
    }
  }
}
~~~
~~~json
  "QuestionarioProposto": {
    "editou": {
      "usuarioID": "UsuarioID",
      "nome": "UsuarioID->nome"
    },
  }
~~~
~~~json
  "QuestionarioAplicado": {
    "editou": {
      "usuarioID": "UsuarioID",
      "nome": "UsuarioID->nome"
    },
  }
~~~
~~~json
"Produto": {
  "editou": {
    "usuarioID": "UsuarioID",
    "nome": "Usuario_nome"
  },
}
~~~
~~~json
"Produto/produtoID/ProdutoTexto": {
  "editou": {
    "usuarioID": "UsuarioID",
    "nome": "Usuario_nome"
  },
}
~~~
~~~json
"Produto/produtoID/ProdutoPost": {
  "editou": {
    "usuarioID": "UsuarioID",
    "nome": "Usuario_nome"
  },
}
~~~
### Function UsuarioToUsuarioPerfil - Ok.
Quando um novo **UsuarioDocument** for criado a function de pegar a **PerfilCollection** toda e cadastrar estes perfis em **UsuarioPerfil** constando apenas as partes
~~~json
{
  "UsuarioPerfil": {
    "usuarioID": {
      "id": "UsuarioID",
      "nome": "UsuarioID->Nome"
    },
    "perfilID": {
      "id": "PerfilID",
      "nome": "nome-valor",
      "contentType": "contentType-valor"
    }
  }
}
~~~


## Cargo
### Function CargoUpdateNome

Quando o usuario atualizar estes campos nesta coleção: 
~~~json
"Cargo": {
  "nome": "nome-valor",
}
~~~
A function deverá atualizar as seguintes coleções que se referenciam a ela
~~~json
"Usuario": {
  "cargo": {
    "cargoID": "CargoID",
    "nome": "CargoID->nome"
  },
}
~~~

## Eixo
### Function EixoUpdateNome

Quando o usuario atualizar estes campos nesta coleção: 
~~~json
"Eixo": {
  "nome": "nome-valor",
}
~~~
A function deverá atualizar as seguintes coleções que se referenciam a ela
~~~json
"Usuario": {
  "eixoAtual": {
    "eixoID": "EixoID",
    "nome": "EixoID->nome"
  },
  "eixo": {
    "eixoID": "EixoID",
    "nome": "EixoID->nome"
  },
  "eixoAcesso": [
    {
      "eixoID": "EixoID",
      "nome": "EixoID->nome"
    }
  ]
}
~~~

~~~json
"QuestionarioProposto": {
  "eixo": {
    "eixoID": "EixoID",
    "nome": "EixoID->nome"
  },
}
~~~
~~~json
"QuestionarioAplicado": {
  "eixo": {
    "eixoID": "EixoID",
    "nome": "EixoID->nome"
  },
}
~~~

~~~json
"Produto": {
  "eixo": {
    "eixoID": "EixoID",
    "nome": "Eixo_nome"
  },
}
~~~


## SetorCensitario
### Function SetorCensitarioUpdateNome

Quando o usuario atualizar estes campos nesta coleção: 
~~~json
"SetorCensitario": {
  "nome": "nome-valor"
},
~~~
A function deverá atualizar as seguintes coleções que se referenciam a ela
~~~json
"Usuario": {
  "setorCensitario": {
    "setorCensitarioID": "SetorCensitarioID",
    "nome": "SetorCensitarioID->nome"
  },
}
~~~

~~~json
"QuestionarioAplicado": {
  "setorCensitario": {
    "setorCensitarioID": "SetorCensitarioID",
    "nome": "SetorCensitarioID->nome"
  },
}
~~~

~~~json
"Produto": {
  "setorCensitario": {
    "setorCensitarioID": "SetorCensitarioID",
    "nome": "SetorCensitarioID->nome"
  },
}
~~~


# Upload
A Aplicação criará o UploadCollection com esta estrutura
~~~json
  "Upload": {
    "usuario": "idUsuario",
    "localPath": "path local do arquivo no celular do usuario.",
    "upload": false,
    "updateCollection": {
      "collection": "Usuario || UsuarioPerfil || Produto || PerguntaAplicada",
      "document": "ID do documento nesta coleção",
      "field": "foto (UsuarioID) || arquivo (UsuarioPerfilID) || uid.rascunhoIdUpload ou uid.editadoIdUpload (ProdutoID) || arquivo (PerguntaAplicadaID)"
    },
  },
~~~
O usuario então solicitará o upload no aplicativo e o UploadCollection ficará com esta estrutura.
~~~json
  "Upload": {
    "usuario": "idUsuario",
    "localPath": "path local do arquivo no celular do usuario.",
    "upload": true,
    "updateCollection": {
      "collection": "Usuario || UsuarioPerfil || Produto || PerguntaAplicada",
      "document": "ID do documento nesta coleção",
      "field": "foto (UsuarioID) || arquivo (UsuarioPerfilID) || uid.rascunhoIdUpload ou uid.editadoIdUpload (ProdutoID) || arquivo (PerguntaAplicadaID)"
    },
    "storagePath": "obtida do storage após upload",
    "contentType": "definido pelo metadata text/plain | text/markdown | text/csv | text/html | image/png | image/jpeg | image/svg+xml  | application/pdf | application/msword | application/zip | video/x-msvideo | video/mpeg | audio/aac",
    "url": "obtida do storage após upload",
    "hash": "gerado pelo dart na leitura local do arquivo"
  },
~~~

Neste momento o campo upload=false foi atualizado para upload=true bem como os demai campos.

Então a function deverá considerar o campo updateCollection e atualizar a collection, document e field correspondente.
