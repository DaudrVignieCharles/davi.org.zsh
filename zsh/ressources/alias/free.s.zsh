#!/usr/bin/zsh

() {
    alias free='free -h' # free est par défaut en format humain
    alias free-ram='echo -n '\''Mémoire RAM libre : '\''&&echo $(free -h | grep Mem | awk '\''{print $4}'\'')' # Renvoie la mémoire RAM libre en format humain
    alias free-swap='echo -n '\''Mémoire SWAP libre : '\''&&echo $(free -h | grep Swap | awk '\''{print $4}'\'')' # Renvoie la mémoire SWAP libre en format humain
    alias free-all='echo -n '\''Mémoire totale libre : '\''&&echo $(free -th| grep Total | awk '\''{print $4}'\'')' # Renvoie la mémoire libre totale en format humain
}
