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
