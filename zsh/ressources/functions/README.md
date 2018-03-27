[index](../../../README.md)

# Fonctions

- [Chemin](#chemin)
- [Autoloading](#autoloading)
- [Fichiers de définitions de fonctions](#fichiers-de-definitions-de-fonctions)
- [Liste des fonctions](#liste-des-fonctions)
	- [dev](#dev)
	- [net](#net)
	- [stdfu](#stdfu)
	- [util](#util)

## Chemin

		/zsh/ressources/functions/

## Autoloading
Touts les fichiers de définition de fonctions situés dans ce chemin seront automatiquement chargés si ils ont une extension **.s.zsh**.
**.s** signifie source, il indique un fichier qui sera sourcé.
**.zsh** est l'extension habituelle des fichiers scripts zsh.

Ex:

		/zsh/ressources/functions/monfichierdefonctions.s.zsh

sera automatiquement sourcé.

## Fichiers de définition de fonctions

Ex: Le fichier précedent contient :

```shell
#!/usr/bin/zsh
mafonction () {
	local MSG
	MSG="Une nouvelle fonction avec comme arguments :"
	printf "%s %s\n" "$MSG" "$*"
}
```
Cela définit une nouvelle fonction **mafonction** qui sera automatiquement sourcée au démarage du shell.

## Liste des fonctions

1. #### dev

- ##### ccompile
		ccompile source.c [strict]
Compile *source.c*, output is *source* without *.c* extension.
With strict mode enabled, gcc is enforced with **-Wall -Wextra -std=c99 -g**
- ##### gitree
		gitree
fancy log graph for git
- ##### memaudit
```
Utilisation : memaudit [OPTION] PID
Surveille la mémoire utilisée par un processus.
-m      --mega          La mémoire occupée sera indiquée en mega octet.
-g      --giga          La mémoire occupée sera indiquée en giga octet.
-i[=n]   --monitor[=n]  Renvoi le résultat toute les n secondes si il à changé.
```
- ##### running-dellib
		running-dellib
Liste les processus faisant appel à une version supprimée d’une librairie.

3. #### stdfu

- ##### dev_cheat_sheet :
		dev_cheat_sheet
Print help about glob modifier.
- ##### find_item :
                find_item ITEM ITEMS
return 0 if ITEM is in ITEMS else return 1
- ##### is_int :
                is_int ARG
Return 0 if ARG is an int else return 1
- #####  setbg :
                setbg COMMAND [command args]
Command is launched in background and detached from the current shell without shell monitoring.
- ##### typeof :
                typeof ARG
return type of ARG. If it is a variable, print is type and content, else return the good type from these : function, alias, shell builtin, reserved word, external command (return the command path in this case)

- ##### zfilemode
                zfilemode -[rodhb] FILE
Print filemode of FILE in octal without argument, else :
>  -r : raw
    -d : decimal
    -h : hexadecimal
    -b : binary
