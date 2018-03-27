# Plugins

### 1. Ajout d'un plugin
Créez un dossier au nom du plugin dans *"$HOME/.zsh/ressources/plugins/ressources/"*.

	# Exemple :
	mkdir $HOME/.zsh/ressources/plugins/ressources/my_new_plugin

Puis placez le(s) fichier(s) nécessaire(s) au plugin dans ce nouveau dossier.

### 2. Activation automatique du plugin
Pour qu'un plugin soit chargé automatiquement au démarage d'une nouvelle session ZSH, il convient d'ajouter un lien symbolique relatif dans le dossier *"$HOME/.zsh/ressources/plugins/rcs/"*. Le lien symbolique doit obligatoirement commencer par un numéro de priorité à trois chiffres. Ce numéro doit être suivi d'un underbar puis du nom du plugin.

Un utilitaire est fourni pour créer ce lien plus facilement : *generate_symlink.zsh*. Il s'utilise de la façon suivante :

	# ./generate_symlink.zsh numéro_de_priorité ressources/myplugin/myplugin.plugin.zsh
	cd $HOME/.zsh/ressources/plugins/
	./generate_symlink 001 ressources/myplugin/myplugin.plugin.zsh

**ATTENTION** : Le script doit être exécuté depuis le dossier *"$HOME/.zsh/ressources/plugins/"*, le chemin du plugin doit commencer au dossier *"ressources"* et ne doit pas comporter de slash au début !
