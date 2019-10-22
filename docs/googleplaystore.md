# Gerar versão de release e salvar na loja google play

## Gerar a versão de release

### Passo 0

Fechar versão atual q esta no emulator
Chaves
~~~
catalunha@nbuft:~$ keytool -list -v -keystore ~/key_pmsb_paulo.jks
Informe a senha da área de armazenamento de chaves: c@taft
~~~



### Passo 1 

Abra o arquivo: android/app/build.gradle

Para configurar a verão do app. No defaultConfig atualizar as variáveis **versionCode** e **versionName**. Quando subir um app para a loja com um versionCode não é possivel subir novamente com o mesmo numero, sempre que gerar um novo release acrescentar o valor do versionCode.

Exemplo: 
Valor antigo
~~~
android {
        defaultConfig {
            versionCode 1
            versionName '1.0.1'
        }
}
~~~
Novo valor após atualizações para subir nova release
~~~
android {
        defaultConfig {
            versionCode 2
            versionName '1.0.2'
        }
}
~~~

### Passo 2
Na parte de release comenta a linha de modo de debug ( signingConfig signingConfigs.debug ) e descomentar a modo de release ( signingConfig signingConfigs.release ), deve ficar da seguinte forma.

Desenvolvimento:
~~~
android {
    buildTypes {
        release {
            //signingConfig signingConfigs.release
            signingConfig signingConfigs.debug

        }
    }
}
~~~

Gerar release.
~~~
android {
    buildTypes {
        release {
            signingConfig signingConfigs.release
            //signingConfig signingConfigs.debug

        }
    }
}
~~~
### Passo 2

Gerar app bundler com o seguinte comando, isso vai gerar um arquivo que vamos enviar ao google play ( Observação : O flutter tem que está na versao 1.7.8 ou superior). Usando o terminal faça

~~~
catalunha@nbuft:~/AndroidStudioProjects/pmsbmobile3$
flutter build appbundle --release 
~~~

Será gerado uma nova versão como este exemplo. 
~~~
Built build/app/outputs/bundle/release/app.aab (23.5MB).
~~~
---

## Salvar na loja.

### Passo 1
Acesse o google play console
https://play.google.com/apps/publish/?hl=pt-BR&account=8452409294372920349#AppListPlace

### Passo 2

Sera exibido a lista de seu aplicativos, escolha o que quer enviar a nova versão

![img01](./imagens/img04.png)


### Passo 3

Vá em gerenciamento da versão e depois em versões de app 

![img01](./imagens/img01.PNG)

### Passo 4

Vá em faixa de produção clique em gereciar no card de produção

![img02](./imagens/img02.PNG)

### Passo 5

Apos isso vá em criar nova versão

![img03](./imagens/img03.PNG)


### Passo 6
Vai abrir um formulario para nova versão do app.

Envie a nova versao do app no botão PROCURAR ARQUIVOS, e selecione o arquivo de appBundler gerado na parte anterior conforme caminho informado no terminal.

![img03](./imagens/img05.png)


Atualize o nome da versão. Importante para o usuario se localizar.
![img03](./imagens/img08.png)

No campo: **O que há de novo na versão?** atualize com a melhorias recentes deste lançamennto.
![img03](./imagens/img09.png)


Depois clique em Salvar. Se precisar alterar alguma coisa mude. Senão clique em Revisar.

### Passo 7

Vc será lançado a tela seguinte com resumo das informação e basta clicar em **INICIAR LANÇAMENTO PARA PRODUÇÃO**

![img03](./imagens/img06.png)
![img03](./imagens/img07.png)


### Passo 8

Vai levar algumas horas para o app ser disponibilizado na loja com a nova versão. As atualizações automáticas ocorrerão gradativamente nos celulares por versao de android e por perfil de uso. As vezes a atualização chega mas nao inicial automaticamente e vc pode ir na loja e forçar atualização.


