#!/bin/bash
  
##
# A script to build elementary enoté 
# from sources (or cleanup) on linux
#
# Usage: ./make.sh [clean]
#
# TODO:
#    *  write a full-install part
##

if [[ "$1" == 'clean' ]]; then
  for file in $(cat .gitignore); do
    echo "removing $file"
    rm -rf $file # No quotes for full shell expansion
  done
else 
  
  rm -rf ~/.enote # remove data dir
  rm -r ./build # re-create build for temp's
  mkdir ./build  && cd ./build
  # Initiate cmake and build source; also, if
  # everything ok, bring executable to project's root
  cmake .. -DCMAKE_INSTALL_PREFIX=/usr \
  &&  make && mv ./enote ../enote && ../enote -d
fi
