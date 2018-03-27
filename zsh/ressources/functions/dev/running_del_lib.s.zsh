#!/usr/bin/zsh

# Liste les processus faisant appel à une version supprimée d’une librairie.
# lsof +L1 liste les processus utilisant un fichier supprimé, grep permet de trier les fichiers et de garder seulement les libs.
running_dellib(){
    lsof +L1 | grep -E "(/usr/bin|/usr/sbin|/bin/|/sbin|/lib|/usr/lib|/usr/local/lib|/usr/local/bin|/usr/local/sbin|^COMMAND)"
}
