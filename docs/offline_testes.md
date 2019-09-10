# Relatorio de teste do aplicativo

## Teste 01 : **Produto**
    
**Modo:** 
    
    Offline

**Local do teste:** 
    
    Smartphone

**Descrição do teste:**
    
    Com o celular em modo offline criar um produto e novas imagens.
    Criar texto e salvar. 
    Logo apos delogar. 
    Depois ativar a rede do celular e relogar.
    Verificar se todos os dados foram salvos no firebase corretamente. 
    
## **Passos:**
   
         
- Criar um novo produto  
    
        Ok
    
- Criar nova imagem só com o titulo
        
        OK
    
- Criar nova imagem com titulo e anexando as imagens 
    
        ERROR - A nova imagem não aparece na listagem de imagens para o produto, entretanto elas aparecem na listagem do upload
    
- Criar um novo texto

        ERROR - O texto não foi salvo localmente, quando a internet foi ligada gerou um erro na tela de Editar texto produto 

- Deslogar do aplicativo

        OK

- Relogar e verificar se os dados foram salvos

        Houve perda do cadastro da imagem no produto

## Observações:

- Dentro de produto - quando algo envolve a anexação de uma imagem ocorem erros
- Quando duas imagem são anexadas em produto apenas uma está aparecendo dentro da lista de upload
- A maquina virtual consegue realizar testes offline
---

## Teste 02 : **Noticias**
    
**Modo:** 
    
    Offline

**Local do teste:** 
    
    Smartphone

**Descrição do teste:**
    
    Com o celular em modo offline criar noticias e verifcar se a postagem vai ser salva no firebase quando a rede for ligada.
    
## **Passos:**
   
         
- Criar uma nova noticia : offline  
    
        Listagem na home -> OK
        Listagem na comunicação -> Ok 

- Ligar a rede do celular e verificar se os dados foram salvos de forma correta

        Ok

## Observações:


---


## Teste 02 : **Questionario**
    
**Modo:** 
    
    Offline

**Local do teste:** 
    
    Smartphone

**Descrição do teste:**
    
    Com o celular em modo offline criar nova aplicação de questionario e verificar se vai se comportar de forma esperada.
    
## **Passos:**
   
- Criar novo questionario offline
        
        Ok

- Criar pergunta offline

        OK

- Delogar e relogar
        
        OK -> Os dados foram enviados ao firebase

- Desativar a rede e criar nova aplicacao de questionario offline

        Ok

- Responder aplicacao de questionario offline

        OK

- Deslogar e desligar aparelho, depois reconectar e verificar se os dados vão ser enviados de forma correta ao firebase

        OK



## Observações:

- Quando o celular está em modo offline ele não consegue pegar uma coordenada.

---

## Teste 02 : **Questionario**
    
**Modo:** 
    
    Offline

**Local do teste:** 
    
    Smartphone

**Descrição do teste:**
    
    Com o celular em modo offline criar nova aplicação de questionario.
    Deslogar e depois ligar a rede.
    Logar com a conta de outro usuario.
    Depois relogar com a conta que foi usada para aplicar o questionario e verificar se os dados são mantidos de forma correta.
    
## **Passos:**
   

- Responder aplicacao de questionario offline

        OK

- Deslogar, depois relogar com conta de outro usuario.

        OK

- Relogar com a conta que foi usada para aplicar o questionario e verificar se os dados são mantidos de forma correta.

        OK
        
## Observações:

- Quando o celular está em modo offline ele não consegue pegar uma coordenada.