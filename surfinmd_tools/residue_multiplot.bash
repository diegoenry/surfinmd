#!/bin/bash 

echo "
# SurfinMD tools #

Residue Multiplot
@brief write a multiplot using gnuplot for selected residues  


"

a="1"
list=""
while [ $a -gt 0 ] ; do
  read a
  list="${list} ${a}"
done

echo ${list}
