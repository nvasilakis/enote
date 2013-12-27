#!/bin/bash
  
##
# 2013, Nikos Vasilakis
# n.c.vasilakis@gmail.com
#
# A script to quickly build and test the application
#
# Usage: ./view.sh
##

valac --pkg gtk+-3.0 --pkg granite Wee.vala && ./Wee
