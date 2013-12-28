#!/bin/bash
  
##
# A script to build elementary note 
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
  
  rm -r ./build # re-create build for temp's
  mkdir ./build  && cd ./build
  # Initiate cmake and build source; also, if
  # everything ok, bring executable to project's root
  cmake .. -DCMAKE_INSTALL_PREFIX=/usr \
  &&  make && mv ./Note ../Note && ../Note
fi
