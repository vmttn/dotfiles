#!/bin/bash
alias !='sudo'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cdg='cd $(git rev-parse --git-dir)/..'
alias dsz='du -sh $(find $(pwd) -maxdepth 1 -type d) | sort -h'
alias grep='grep --color'
alias hman='man -Hchromium-browser'
alias j='jobs'
alias ls='ls --color=auto'
alias ll='ls -la --group-directories-first'
alias lsd='ls -l | grep ^[dl] --color=none'
alias md5='md5sum'
alias mkchpkg='sudo makechrootpkg -c -r /mnt/Entropy/cleanroot'
alias pp='powerpill'
alias spp='sudo powerpill'
alias sls='slurpy -c -s'
alias sld='slurpy -c -d'
alias sli='slurpy -c -i'
alias udevinfo='udevadm info -q all -n'
alias webshare='python /usr/lib/python2.6/SimpleHTTPServer.py 8001'
alias wgetxc='wget `xclip -o`'

deps() {
    [[ `file $1 | grep "shared lib"` ]] || { echo "Not a dynamically linked file"; return 1; }
    readelf -d $1 | sed -n '/NEEDED/s/.* library: \[\(.*\)\]/\1/p'

}

qp() {
    pacman-color -Qi $1 2> /dev/null
    if [[ $? -gt 0 ]]; then
        echo "$1 not found, searching..."
        pacman-color -Qs $1
        [[ $? -gt 0 ]] && echo "No local results for $1"
    fi
}

calc() {
    echo "scale=3; $*" | bc
}

unwork() {
    if [[ -z $1 ]]; then
        echo "USAGE: unwork [dirname]"
    else
        if [[ -d $1 ]]; then
            count=0
            for f in `find $1 -name .svn`; do 
                rm -r $f
                count=$((count + 1))
            done
            echo "SUCCESS. Directory is no longer a working copy ($count .svns removed)."
            unset count
        else
            echo "ERROR: $1 is not a directory"
        fi
    fi
}

man2pdf() {
    if [[ -z $1 ]]; then
        echo "USAGE: man2pdf [manpage]"
    else
        if [[ `find /usr/share/man -name $1\* | wc -l` -gt 0 ]]; then
        out=/tmp/$1.pdf
        if [[ ! -e $out ]]; then
            man -t $1 | ps2pdf - > $out
        fi
        if [[ -e $out ]]; then
            /usr/bin/apvlv $out
        fi
    else
        echo "ERROR: manpage \"$1\" not found."
    fi
    fi
}

git-comm-xc () {
    # send first 6 characters of git commit signature to xclip
    git log | head -1 | cut -c8-13 | xclip
}

ex () {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       unrar x $1     ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *.exe)       cabextract $1  ;;
          *)           echo "'$1': unrecognized file compression" ;;
      esac
  else
      echo "'$1' is not a valid file"
  fi
}

ljoin() {
    local OLDIFS=$IFS
    IFS=${1:?"Missing separator"}; shift
    echo "$*"
    IFS=$OLDIFS
}

scr () {
    screen -ls | grep -q Main && screen -xr Main || screen -S Main
}

t () {
    if [[ `tmux -L Main ls | grep windows` ]]; then
        tmux -L Main a
    else
        tmux -L Main
    fi
}

miso () {
    [[ ! -f "$1" ]] && { echo "Provide a valid iso file"; return 1; }
    mountpoint="/media/${1//.iso}"
    sudo mkdir -p "$mountpoint"
    sudo mount -o loop "$1" "$mountpoint"

}

umiso () {
    mountpoint="/media/${1//.iso}"
    [[ ! -d "$mountpoint" ]] && { echo "Not a valid mount point"; return 1; }
    sudo umount "$mountpoint"
    sudo rm -ir "$mountpoint"

}

