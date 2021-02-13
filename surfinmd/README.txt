LMDM - SURFINMD - versao 1.06_patch_4
Fri Oct 14 19:43:33 BRT 2016

Desenvolvido por:
!pegepa         ; Pedro G. Pascutti                     
!awss           ; Alan Wilter
!debg           ; Diego Enry Barreto Gomes
!gabriel        ; Gabriel Limaverde S. C. Sousa 

Laboratorio de Macromoleculas - INMETRO 
Grupo de Pesquisa em Biologia Computacional
+55 21 2145-3070 - diego@biof.ufrj.br

Laboratorio de Modelagem e Dinamica Molecular
Instituto de Biofísica Carlos Chagas Filho - UFRJ
+55 21 25626507 | pascutti@biof.ufrj.br


I) Instalacao
II) Utilização


I) Instalacao

Recomendo que compile usando o Intel Compiler pois ele deixa o programa com o DOBRO da velocidade dos demais.

1. Edite o arquivo "compile.sh", selecionando um dos compiladores listados:
# g77,gfortran,intel32,intel64,sun
compiler=intel64

2. Caso necessário modifique o caminho do compilador e as flags.

3. Execute o script de compilação " ./compile".

II) Utilização
1. Você precisa de um arquivo .pdb já com as letras das cadeias (ex. A e B).
2. Os parametros são passados pela linha de comando.
3. Digite "surfinmd -h" para mais informações.

OBS: O programa só reconhece DUAS CADEIAS de cada vez em sequencia !!!

III) Testando

cd test/
./please.test


----//-----
Resultado de referencia, calculado pelo PISA para a estrutura 1BVE.PDB (nao sei qual quadro que ele usa)
cadeia1    cadeia2    area/a^2
   A          B       1583.8
   B         DMP       354.7
   A         DMP       348.2
Soma das areas cadeia A cadeiaB com o DMP = 702.9


Resultado no meu PC usando diferentes compiladores
(na ordem de velocidade).

intel64 | Tempo de execução =   6.016375     segundos
 model           1  total area   652.8456
 model           2  total area   628.1080
 model           3  total area   696.3689
 model           4  total area   669.5484
 model           5  total area   700.6868
 model           6  total area   703.6956
 model           7  total area   736.4619
 model           8  total area   682.5358
 model           9  total area   729.1375
 model          10  total area   654.0751
 model          11  total area   726.0376
 model          12  total area   689.3501
 model          13  total area   674.8272
 model          14  total area   680.9189
 model          15  total area   659.8978

gfortran |  Tempo de execução =   8.588537     segundos
 model           1  total area   654.5414
 model           2  total area   620.0327
 model           3  total area   694.4353
 model           4  total area   673.0942
 model           5  total area   697.4927
 model           6  total area   698.9967
 model           7  total area   731.1608
 model           8  total area   682.5359
 model           9  total area   727.3707
 model          10  total area   648.9081
 model          11  total area   726.0377
 model          12  total area   692.0990
 model          13  total area   675.2982
 model          14  total area   685.4004
 model          15  total area   658.2787

g77 |  Tempo de execução =  11.4207134segundos
 model 1 total area  658.457886
 model 2 total area  620.032715
 model 3 total area  694.435242
 model 4 total area  673.094238
 model 5 total area  699.534607
 model 6 total area  700.945801
 model 7 total area  731.160767
 model 8 total area  681.532166
 model 9 total area  728.833557
 model 10 total area  648.908142
 model 11 total area  726.037659
 model 12 total area  692.098999
 model 13 total area  675.298218
 model 14 total area  685.400391
 model 15 total area  656.320679


