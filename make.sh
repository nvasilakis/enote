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
elif [[ "$1" == "webkit" || "$1" == "all" ]]; then
  # Create webkit 3.0 bindings that don't ship with Vala
  cd /usr/share/vala-0.24/vapi # esp.: valac --version
  sudo cp webkit-1.0.deps webkitgtk-3.0.deps
  sudo cp webkit-1.0.vapi webkitgtk-3.0.vapi
  sudo sed -e "s/gdk-2.0/gdk-3.0/" -e "s/gtk+-2.0/gtk+-3.0/" \
    webkit-3.0.deps > tmp_debs && sudo mv tmp_debs webkitgtk-3.0.deps
else 
  get_there "build"
  # Initiate cmake and build source; also, if
  # everything ok, bring executable to project's root
  cmake .. -DCMAKE_INSTALL_PREFIX=/usr \
  &&  make && mv ./enote ../enote && ../enote -d
fi
