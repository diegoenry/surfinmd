# surfinmd
Binding **Surf**ace **in** **M**olecular **D**ynamics

SurfinMD computes the binding surface area between a pair of chains as indicated in a reference structures.
In addition it decomposes the binding area by residue, allowing the user to dig deep into the interactions.

There is an extensive documentation produced by Doxygen. Download and have fun browsing it :) 

```bash
###################################################
 # Program:  SurfinMD - version 1.06p4 - 14Oct2016 #
 # Diego E.B. Gomes(1), Gabriel Limaverde SCS(2)   #
 # Alan Wilter SS (3), Pedro G. Pascutti(4)        #
 # 1) INMETRO - Brasil                             #
 # 2) Fundacao Oswaldo Cruz - Brasil               #
 # 3) EMBL - EBI, Wellcome Trust Genome Campus     #
 # 4) Universidade Federal do Rio de Janeiro       #
 # mailto: dgomes@pq.cnpq.br                       #
 ###################################################

 Usage: 

 surfinmd -r ref.pdb -i traj.pdb -dcd traj.dcd -o surf.dat -or rsurf.dat -csv rsurf.csv -p 1.4 -d 1.0 -a 6

 Please review all usage options [defaul]

  -h    = Display this help 
  -r    = Reference Structure [ref.pdb]
  -i    = Input file          [traj.pdb]
  -dcd  = Input file          [traj.dcd]
  -o    = Output surface      [surf.dat]
  -or   = Output surface/residue [rsurf.dat]
  -csv  = Output ALL surf/res [rsurf.csv]
  -p    = probe radius        [1.4]
  -d    = probe density       [1.0 A^2]
  -a    = attention number    [6]
  -ext  = (Rvdw + ext )       [n]
  -scal = (Rvdw * scal)       [n]
```

LMDM - SURFINMD - version 1.06 - Fri Nov 20 11:38:58 BRST 2015

Developed by:
!debg           ; Diego Enry B. Gomes,                  ; dgomes@pq.cnpq.br
!awss           ; Alan Wilter                           ; 
!gabriel        ; Gabriel Limaverde S. C. Sousa         ; 
!melomcr        ; Marcelo C. R. Melo                    ; 
!pegepa         ; Pedro G. Pascutti                     ; pascutti@biof.ufrj.br

Laboratorio de Modelagem e Dinamica Molecular
Instituto de Biofísica Carlos Chagas Filho - UFRJ


# Install
1. Edit "complile.sh" to select your favorite, and available compiler (intel is the fastest):
"g77,gfortran,intel32,intel64,sun"
compiler=intel64

2. If necessary, change the compiler path and flags

3. Run the compilation script " ./compile".

II) Usage
1. You need a PDB file with TWO diffent chain identifiers: A for the receptor and B for the ligand.
2. Parameters are passed through the command line.
3. Type "surfinmd -h" for more information.

WARNING: You MUST have only two chains: A and B !!!

III) Test

cd test/
./please.test


----//-----
Compared to PISA on 1BVE.PDB  (I think it gives you the average of all frames)
chain1    chain2    area/a^2
   A          B       1583.8
   B         DMP       354.7
   A         DMP       348.2
Sum of chain A and B chains with DMP = 702.9


SurfinMD results
gfortran |  Runtime =   8.588537     seconds
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
