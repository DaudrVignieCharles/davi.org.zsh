gitree(){
    git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) -\
%C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all
}

git-graph-SlocOverTime(){
    git-graph --interval day --output chart "find . -type f -name '*.zsh'|xargs wc -l|tail -1" 2>/dev/null
}
