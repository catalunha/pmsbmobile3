# Folders and Files

## /lib/components
Diretorio contento Widgets para serem reutilizados em todo o projeto focado em elementos graficos.

## /lib/pages
Diretorio contendo telas do app. As areas do app são divididas em subdiretorios dentro desta pasta. Com a respectiva tela/bloc conforme padrao:
Exemplo para área de comunicacao no gerenciamento de noticias.
~~~
/lib/pages/comunicacao
/lib/pages/comunicacao/comunicacao.dart // tela principal lista noticias
/lib/pages/comunicacao/comunicacao_bloc.dart // bloc
/lib/pages/comunicacao/comunicacao_crud_noticia.dart // tela crud noticia
/lib/pages/comunicacao/comunicacao_crud_noticia_bloc.dart // bloc para crud noticia
...
~~~

## /lib/models ?
Diretorio contendo modelos dos dados.
