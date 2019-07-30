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


