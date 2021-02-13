#!/bin/bash
# g77,gfortran,intel32,intel64,sun,pfg
compiler=gfortran

########################################################################
# Setup do compilador
########################################################################
case $compiler in

"g77")
F77=g77
FLAGS=" -O3 -static"
;;

"gfortran")
F77=gfortran
FLAGS="-O5 -mtune=native -march=native -mno-avx " 
;;

"intel32")
F77=ifort
FLAGS="-O3 -static -fast"
;;

"intel64")
F77=ifort
FLAGS="-O3 -static -m64 "
;;

"sun")
F77="sunf77"
FLAGS="-xO3 -static -f77=no%intrinsics"
;;

"pgf")
F77="pgf"
FLAGS="-O3 -static"
;;

"")
echo "ERROR: You should provide a compiler name"
exit 1
;;

*)
echo "ERROR: *"$compiler"* is not a supported compiler" 
exit 1
;;

esac

########################################################################
# Compila o programa
########################################################################
cd src

echo -e "\033[31m"
echo "Compiling SURFINMD with: " $F77 $FLAGS
$F77 $FLAGS  \
   surfinmd.f  \
   titulo.f    \
   readparam.f \
   readref.f   \
   readtraj.f  \
   setradii.f  \
   lmdm.mds.f  \
   getarea.f   \
   help.f      \
   default.f   \
   getatype.f  \
   -o ../bin/surfinmd


echo -e "\033[31m"
echo "Compiling SURFINMD DCD version with: " $F77 $FLAGS
$F77 $FLAGS  \
   surfinmd.dcd.f  \
   titulo.f    \
   readparam.f \
   readref.f   \
   open_dcd.f  \
   readtraj_dcd.f  \
   setradii.f  \
   lmdm.mds.f  \
   getarea.f   \
   help.f      \
   default.f   \
   getatype.f  \
   -o ../bin/surfinmd.dcd 


echo -e "\033[32m"
echo "Compiling PUTCHAIN with: " $F77 $FLAGS
$F77 $FLAGS putchain.f -o ../bin/putchain


echo -e "\033[32m"
echo "Compiling SPLIT_DCD with: " $F77 $FLAGS
$F77 $FLAGS split_dcd.f90 -o ../bin/split_dcd


cd -
echo -e "\033[36m"
echo "Binaries for SURFINMD and PUTCHAIN can be found at"
echo $PWD"/bin/"
echo -e "\033[0m"


