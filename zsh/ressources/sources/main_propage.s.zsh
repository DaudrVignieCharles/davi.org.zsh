#!/usr/bin/zsh

zz.main.propage () {
	rsync -v $ZDEV_PATH/zshrc.zsh $HOME/.zshrc
	rsync -v $ZDEV_PATH/zshenv.zsh $HOME/.zshenv
	rsync -vr --delete-after --exclude-from=/dev/stdin $ZDEV_PATH/zsh/ $HOME/.zsh <<EOF
ressources/plugins/
TODO
COPYING
INSTALL
README
*\.md
.git
.gitignore
.directory
EOF
    echo "export ZDEV_PATH=$ZDEV_PATH" >> $HOME/.zshrc
    echo "export ZDEV_PATH=$ZDEV_PATH" >> $HOME/.zshenv
}

