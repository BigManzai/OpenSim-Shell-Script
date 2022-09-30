#!/bin/sh

case "$1" in

  'clean')

    mono bin/Prebuild.exe /clean

  ;;


  'autoclean')

    echo y|mono bin/Prebuild.exe /clean

  ;;



  *)

    mono bin/Prebuild.exe /target vs2022 /targetframework net6_0 /excludedir = "obj | bin"

  ;;

esac
