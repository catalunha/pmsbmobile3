import 'package:pmsbmibile3/models/models.dart';

class GeradorMdService {
  static generateMdFromUsuarioModel(UsuarioModel usuarioModel) {
    return """
${usuarioModel.nome}
====================================================

![alt text](${usuarioModel.usuarioArquivoID.url})

### Id: ${usuarioModel.id}
### Celular: ${usuarioModel.celular}
### Email: ${usuarioModel.email}
### Eixo: ${usuarioModel.eixoID.nome}

## Perfil em construção
""";
  }
  static generateMdFromNoticiaModelList(List<NoticiaModel> noticiaModelList) {
    String texto = '';
    noticiaModelList.forEach((noticia) {
      texto += """
# Noticias  Publicadas

## ${noticia.titulo}
id: ${noticia.id}

${noticia.textoMarkdown}

---
""";
    });
    return texto;
  }
}
