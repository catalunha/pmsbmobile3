Alguns comentarios sobre a utilização do git e github

# ISSUES
- Utilize as issues para ajudar a se organizar e comunicar com a equipe sobre as demandas geradas e atendidas por você.
- Tente não codificar muitas issues ao mesmo tempo, isso pode levar a dificuldade de merge no futuro e a demora do merge individual de cada demanda.

Isso é ruim porque algum membro da equipe pode estar com trabalho bloqueado esperando uma issue ser liberada.

# BRANCHS
Alguns comentarios sobre branchs

## MASTER
Este branch deve conter a ultima versão funcional do projeto

## DEV
Este branch contem o projeto em desenvolvimento

## Branching
Branchs devem ser usados de forma pontual, para atender uma demanda especifica, guardar trabalho incompleto ou experimentos.

A não ser em casos especiais deve-se evitar gerar branchs de longa duração. Branchs de longa duração podem gerar retrabalho,
 merge complexo e bloqueio de demanda.

# Receitas Git

Atualizei algumas linhas sem teste.

## Pull branchs
~~~
git init
git config credential.helper store
git clone https://github.com/usuarioX/repositorioX.git
git fetch --all
git branch -a
git checkout branchX
// codificar...
git status
git add .
git commit -m '...'
git push origin branchX
~~~

## Atualizado o gitignore
~~~
// rm all files
git rm -r --cached .
// edit .gitignore
git add .
// now, commit for new .gitignore to apply
git commit -m ".gitignore is now working"
~~~

# Guias Git
- Desfazendo Coisas: 
https://git-scm.com/book/pt-br/v1/Git-Essencial-Desfazendo-Coisas
