#!/usr/bin/zsh

get-pub-ip(){
    dig +short myip.opendns.com @resolver1.opendns.com
}
