# Regras

# Diretrizes

# Functions
Cada subtitulo a seguir fala a cerca de uma function especifica.

## Perfil
Quando um novo documento de perfil por cadastrado em **Perfil** a function deverá cadastrar este perfil em **UsuarioPerfil** constando apenas as partes
~~~json
{
  "UsuarioPerfil": {
    "usuarioID": {
      "id": "UsuarioID",
      "nome": "UsuarioIDNome"
    },
    "perfilID": {
      "id": "PerfilID",
      "nome": "nome-valor",
      "contentType": "contentType-valor"
    }
  }
}
~~~

~~~json
{
"UsuarioPerfil": {
    "textPlain": "textPlain-valor"
  }
}
~~~


~~~json
{
  "UsuarioPerfil": {
    "usuarioArquivoID": {
      "id": "UsuarioArquivoID",
      "url": "url-valor"
    }
  }
 }
~~~


