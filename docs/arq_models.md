# Models
Este arquivo descreve algumas regras para a construção de modelos do projeto


## Herança do Model
Todos os modelos devem herda da classe Model que reside em models/base_model.dart

## Nome no singular
Todas as classes de modelo devem ser no singular bem como seu arquivo

## Sufix model e Model
Todos os arquivos de declaração de modelo devem terminar com o sufixo [nome_do_modelo no singular]_model.dart

Todos os nomes de classes de modelos devem terminar com o sufixo Model [NomeDoModelo]Model
Exemplo para modelos das notícias:
~~~
$ nano /lib/models/noticia_model.dart
...
class NoticiaModel{
...
}
...
~~~

# JSON
## Auto-Generation code json-to-dart
Alguns geradores de codigo ajudam.
https://javiercbk.github.io/json_to_dart/
Teste com:
~~~json
{"palavra":"a","frase":"Oi tudo bem"}
~~~

## Visualizadores de json
https://jsoneditoronline.org/
http://jsonviewer.stack.hu/
