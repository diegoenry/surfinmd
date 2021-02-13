#!/bin/bash 
lista=""
for lig in v1b v5b et2b et4c ; do
   for sim in fp2 fp3 ; do
      for rep in R1 R2 ; do
        lista="$lista surf.${rep}.${lig}_${sim}.dat"
      done
  done
done

# Comando MAGICO do AWK obrigado JESUS !!!
echo "$lista" > surf.total.dat
awk '{ a[FNR] = (a[FNR] ? a[FNR] FS : "") $2 } END { for(i=1;i<=FNR;i++) print a[i] }' $( echo $lista ) >>surf.total.dat

echo "$lista" > surf.hydrophobic.dat
awk '{ a[FNR] = (a[FNR] ? a[FNR] FS : "") $3 } END { for(i=1;i<=FNR;i++) print a[i] }' $( echo $lista ) >> surf.hydrophobic.dat

echo "$lista" > surf.hydrofilic.dat
awk 'NR>7 { a[FNR] = (a[FNR] ? a[FNR] FS : "") $4 } END { for(i=1;i<=FNR;i++) print a[i] }' $( echo $lista ) >> surf.hydrofilic.dat

