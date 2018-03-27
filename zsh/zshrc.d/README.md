# zshrc.d

### 1. Fonctionnement :
- Contient une liste de script qui seront exécutés par le [~/.zshrc](/zshrc.zsh).
- Les fichiers **doivent** commencer par trois chiffres, le numéro de priorité.
- Tout fichier ne commençant pas par ce numéro de priorité ne sera pas chargé.
- Le plus petit numéro de priorité est 000, le plus grand est 999.
- Les fichiers seront exécuté dans l'ordre numérique croissant de priorité soit de 000 à 999.
- Les fichiers **doivent** avoir l'extension *.init.zsh* sinon ils ne seront pas chargés.

### 2. Nom des scripts d'init :
Le nom du script doit être de la forme suivante :

        555_myscript.init.zsh
        700_otherscript.init.zsh

Soit le numéro de priorité, un underbar, un nom clair et explicite de préférence.
