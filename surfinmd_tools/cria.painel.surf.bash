#!/bin/bash 
lista="v1b v5b et2b et4c"

escreve_cabecalho() {
echo "
@with g${j}
@target G${j}.S${k}
@type xy
@ yaxis label \"${i}_${rep}\"
" >> $saida 
} 


rm $saida
for sim in fp2 fp3 ; do
saida="surf.${sim}.tudo.agr"
   j=0
  for i in $lista ; do
    for rep in R1 R2 ; do
      k=0 ; escreve_cabecalho 
      #Total
      grep -v "@\|#"  "surf.${rep}.${i}_${sim}.dat" | awk '{print $2}' >> $saida
      k=1 ; escreve_cabecalho
      #Hidrofobic
      grep -v "@\|#"  "surf.${rep}.${i}_${sim}.dat" | awk '{print $3}' >> $saida
      k=2 ; escreve_cabecalho
      #Hidrofilic
      grep -v "@\|#"  "surf.${rep}.${i}_${sim}.dat" | awk '{print $4}' >> $saida
      let j=$j+1
      echo "&" >> $saida
    done
  done
done
