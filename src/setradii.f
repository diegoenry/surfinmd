***********************************************************************
        subroutine setradii(line,exclude,scalon,rad)
***********************************************************************
        implicit none
        integer i,ir
        character line*54
        real vdw,exclude,scalon,rad
        dimension vdw(36)
C Raios de vdw tirados de KOLLMAN - Unidade Angstroms
      DATA (VDW(I),I=1,20)/1.20D+00,1.20D+00,1.37D+00,1.45D+00,
     *     1.45D+00,1.50D+00,1.50D+00,1.40D+00,1.35D+00,1.30D+00,
     *     1.57D+00,1.36D+00,1.24D+00,1.17D+00,1.80D+00,1.75D+00,
     *     1.70D+00,1.90D+00,5.276D+00,2.10D+00/    
! ir = 19 added for P3 atom of Martini Forcefield
        ir=0
        ir=1 !padrao

        if(line(14:14).eq."H") ir=1
        if(line(14:14).eq."B") ir=5
        if(line(14:14).eq."C") then
        ir=6
!        canp=canp+1
!        anpi(canp)=j
        endif

        if(line(14:14).eq."N") ir=7
        if(line(14:14).eq."O") ir=8
        if(line(14:14).eq."F") ir=9
        if(line(14:14).eq."P") ir=15
        if(line(14:15).eq."P3") ir=19
        if(line(14:15).eq."SI".or.line(14:15).eq."Si") ir=20
                              
        if(line(14:14).eq."S") then
        ir=16
!        canp=canp+1
!        anpi(canp)=j
        endif

        if(ir.eq.0) then !by dgomes
!          print *, 'Atomo nao listado: assumindo valor default (=H)'
          IR=1
          goto 20
        endif

*        necessario mexer no codigo (DATA)
  20    CONTINUE
         rad=(VDW(IR)+exclude)*scalon

        return
        end
