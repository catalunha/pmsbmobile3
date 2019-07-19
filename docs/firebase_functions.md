# Regras

# Diretrizes

# Functions
Cada subtitulo a seguir fala a cerca de uma function especifica.

## Perfil
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
O aplicativo se encarregará de dependendo do contentType criar a parte de texto. Ou
~~~json
{
"UsuarioPerfil": {
    "textPlain": "textPlain-valor"
  }
}
~~~
De arquivo.
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
Nao precisa ser automatico, pode ser manual.

