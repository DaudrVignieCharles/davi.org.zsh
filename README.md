# ZZ - ZSH framework ![license](https://img.shields.io/badge/license-GPLv3-green.svg?style=flat)

# [Wiki](https://github.com/Daudre-Vignier-Charles/davi.org.zsh/wiki/home)


## Index

- [Introduction](#introduction)
- [Feature presentation](#feature-presentation)
- [Install](#install)

## Introduction

ZZ is a powerful ZSH framework. It is modularly designed to be debugged or modified as easily as possible.
It comes with many aliases, functions, ZLE widgets or TUI tools using zsh/curses (`zcurses`) module. It also comes with a unit test module.

ZZ is designed to make the most of the possibilities of ZSH and to use at least external tools like `grep` or `ls` for example.

## Feature presentation

### Functions and alias

There are many functions and aliases, go to the [specific wiki page]().

### ZLE widgets
ZZ comes with [ZLE widgets](). These are mainly code insertion widget (printf, while loop, conditional statement, etc), Git management widget, or widget enhancing ZLE by giving it IDE functionality (like automatic closing of parentheses, brackets, etc.).

Some of the widgets will open TUI interfaces like the widget for `git add` :

![git-tui add](https://user-images.githubusercontent.com/17654421/39536905-44cf576a-4e38-11e8-8949-b4a3706b2a6f.png)

It also comes with a prompt graphically inspired by adam2 that supports Git repositories.

### Prompt

It display :
- line 1 left   : job(s), relative path
- line 1 right  : date, tty, shlvl, user@host
- line 2 left   : return of the last command, time of the last command
- line 2 right  : if git repo : branch, status

![prompt without git](https://user-images.githubusercontent.com/17654421/39536898-42102928-4e38-11e8-9647-b18731123b81.png)

Prompt while in Git repository :

![prompt with git](https://user-images.githubusercontent.com/17654421/39536902-439700b4-4e38-11e8-955f-ee65fa64c97b.png)

### ztest

[ztest]() is a unittest module for ZSH :
![ztest](https://user-images.githubusercontent.com/17654421/39536893-3e1fd930-4e38-11e8-8cf5-d0224b6347cb.png)

## Install

```
git clone https://github.com/DaudrVignieCharles/davi.org.zsh.git
cd davi.org.zsh
zsh ./init.zsh
```
The git clone is called the development version. This is used to make the changes that can then be sent to production with the `zz.main.propage` function.

Your old ZSH environment will be backed up and can be restored if ZZ was uninstalled.
