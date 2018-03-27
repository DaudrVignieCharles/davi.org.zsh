# DaVi_ZSH

## Table des matières :
- [Installation](#installation)
- [Commandes internes](#commandes-internes)
- [Alias](#alias)
- [Fonctions](#fonctions)
- [ZLE widgets](#zle-widgets)
- [Spécifications du code source](#spécifications-du-code-source)

## Installation

![warning](https://upload.wikimedia.org/wikipedia/commons/thumb/2/27/Alert-Stop-Warning-Error_icon.svg/32px-Alert-Stop-Warning-Error_icon.svg.png)    **Attention : Si un dossier $HOME/.zsh ou un fichier $HOME/.zsh existe, il sera renommé avec l'extension ".old". Si vous voulez écraser votre ancien environnement ZSH, passez l'option "-ow" ou sa forme longue "--overwrite" lors de l'exécution du script "init.zsh"."**

	git clone https://github.com/DaudrVignieCharles/davi.org.zsh.git
	cd davi.org.zsh
	./init.zsh
	
Le clone de git est appelé version de développement. Cette sert à faire les modifications qui peuvent ensuite être envoyée en production avec la fonction [**zz.main.propage**](#commandes-internes).

## Commandes internes

- ##### zz.main.propage

		Synopsis :
			zz.main.propage
		
		Description :
			Utilise rsync pour synchroniser le dossier .zsh et le fichier .zshrc avec le dépôt Git local.
		
		Arguments :
			Aucun.
		
- ##### zz.main.update
		
		Synopsis :
			zz.main.update [-n --no-sync] [-d --dry-run]
		
		Description :
			Met à jour ZZ en utilisant git pull puis synchronise automatiquement
			en utilisant zz.main.propage.
		
		Arguments : 
			-d --dry-run		Simule la mise à jour.
			-ns --no-sync		Met le dépôts local à jour sans synchroniser automatiquement
							avec la production.

- ##### zz.plugin.link

		Synopsis :
			zz.plugin.link PLUGIN NUM
		
		Description :
			Crée un lien symbolique activant un plugin.
			Cette fonction est acompagnée d'une autocompletion pour le nom du plugin.
			
		Arguments :
			PLUGIN				Plugin ZSH
			NUM				Numéro de priorité à trois chiffres compris entre 000 et 999.
							Les plugins sont chargés en fonction de ce numéro.
							Les liens seront chargés par ordre croissant. 000 en premier,
							999 en dernier.

- ##### zz.plugin.unlink

		Synopsis :
			zz.plugin.unlink LINK
		
		Description :
			Supprime un lien symbolique créé par zz.plugin.link.
			Cette fonction est acompagnée d'une autocompletion pour le fichier lien.
		
		Arguments :
			LINK				Fichier lien symbolique.

## Alias
Voir [alias](./zsh/ressources/alias/README.md).

## Fonctions
Voir [fonctions](./zsh/ressources/functions/README.md).

## ZLE widgets

#### 1. Insertion de code :
**NOTE** : Lors d'une insertion de code, le curseur sera toujours placé de façon optimale dans le code inséré.

- **Alt** + **!** + **p**

Insère **printf "\n"**

- **Alt** + **!** + **i**

Insère une structure conditionnelle **if**.

- **Alt** + **!** + **w**

Insère une boucle **while**.

- **Alt** + **!** + **f**

Insère une boucle **for**.

- **Alt** + **!** + **c**

Insère une structure conditionnelle **case**.

#### 2. Fermeture automatique des parenthèses et guillemets.
Lorsque vous taperez l'un des symboles **( [ { "**, le symbole fermant corespondant **) ] } "** sera automatiquement ajouté.
Le widget ZLE backward_kill_char est remplacé pour prendre en compte ce comportement.

#### 3. Raccourcis Git
- **Alt** + **:** + **:**

	git status
	
- **Alt** + **:** + **;**

	git add
Pour ajouter des fichier, tapez leurs chemins dans le shell courant avant d'invoquer le widget.
	
- **Alt** + **:** + **!**

	git commit

- **Alt** + **:** + **m**

	git push $remote master
	
- **Alt** + **:** + **\***

	git push $repo $currentbranch

- **Alt** + **:** + **l**

	git pull $repo master

## Spécifications du code source

#### 1. Fonctions
Toujours enclore le code dans une fonction quitte à que ce soit une fonction anonyme pour une exécution immédiate. Cela permet de définir des variable locale et évitera donc une polution de l'espace global.
Toute fonction qui est déclarée et n'est plus utile doit être détruite.

#### 2. Variables
Les variables doivent explicitement être déclarée locale si elle n'ont pas d'utilité dans l'espace global. Si une variable nécessite d'être globale, elle devra être declarée explicitement comme globale.

#### Code type :

```zsh
#!/usr/bin/zsh
# Ne pas oublier le shebang
# Tout executer dans une fonction, ici une fonction anonyme
() {
	# OUverture d'un bloc "always", doit être utilisé pour supprimer les fonctions internes proprement.
	{
		# Déclarer les variables locales en local !
		typeset LOCAL_VAR_1 LOCAL_VAR_2
		#ou son équivalent :
		local LOCAL_VAR_3 LOCAL_VAR_4
		# definition d'une fonction vide et inutile :
		myemptyfunction () {
			:
		}
	} always {
		# fermeture du bloc "always", c'est ici que les fonctions doivent être supprimée, en cas d'erreur
		# dans la première partie, la deuxième s'exécutera quand même.
		unset -f myemptyfunction
		# OU son équivalent :
		unfunction myemptyfunction
	}
}
```
