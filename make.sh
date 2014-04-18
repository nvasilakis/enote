#!/bin/bash
  
##
# A script to build elementary enoté 
# from sources (or cleanup) on linux
#
# Usage: ./make.sh [clean | install]
##

function get_there {
  [[ ! -d "$1" ]] && { mkdir "$1"; cd "$1"; } || { 
    rm -rf "$1";
    mkdir "$1";
    cd "$1";
  }
}


if [[ "$1" == "clean" ]]; then
  for file in $(cat .gitignore); do
    echo "removing $file"
    rm -rf $file # No quotes for full shell expansion
  done
elif [[ "$1" == "install" || "$1" == "all" ]]; then
  get_there "build"
  cmake .. -DCMAKE_INSTALL_PREFIX=/usr \
  &&  make && sudo make install
else 
  get_there "build"
  # Initiate cmake and build source; also, if
  # everything ok, bring executable to project's root
  cmake .. -DCMAKE_INSTALL_PREFIX=/usr \
  &&  make && mv ./enote ../enote && ../enote -d
fi
