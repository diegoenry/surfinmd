! usar unit=1*
        program lmdmsurf
        implicit none      
        integer i,j,nframes,frame,fim
        real t1,t2
        include 'parameters.f'
        nframes=0
        natom=0
        namn=0
        fim=0

        call titulo
    
        call readparam
     &(pdbref,pdbin,probe,density,prattnum,cad1,cad2,exclude,scalon,
     &out,rout,rcsv,dcd,b,e)

        call readref
     &(maxatm,pdbref,cad1,cad2,natom,exclude,scalon,radii,mol,amn,namn,
     & maxamn,res,amntype)

        


!        call checkreadref (natom,radii,mol) !ok
        call cpu_time(t1)
        rp=probe

        do i=1,natom
          atmden(i)=density
          atten(i)=prattnum
        enddo

        do i=1,maxamn
          amntot(i)=0.0
        enddo

        open(38,file=trim(out)) ; call write_header
        open(34,file=trim(rout))
        open(71,file=trim(pdbin))


 
        frame=0

        do 100 !frames loop
           call readtraj(natom,atoms,fim)
           if(fim.eq.1) goto 101
!           call checkreadtraj(natom,atoms) !ok

        do i=1,natom
          atmarea(i)=0.0
        enddo

           call mds
     &(maxatm,rp,natom,atoms,radii,atmden,atten,mol,atmarea)

           call getarea
     &(natom,maxamn,namn,amn,amnarea,areatot,atmarea) !bugfix v1.05r6

!Tem algo estranho nesses maxamn toda hora, deveriamos usar o numero correto de amn
!amntot deveria ser zerado
           do j=1,maxamn 
             amntot(j)=amntot(j)+amnarea(j)
           enddo

!Tem algo estranho nesses maxamn toda hora, deveriamos usar o numero correto de amn
!Por que mesmo estamos guardando desvio de todos os frames ?
           frame=frame+1
           do j=1,maxamn
             desvio(frame,j)=amnarea(j)
           enddo


!1.06p1  area por cadeia ! mover para dentro do GETAREA
!Mon Nov 23 18:38:02 BRST 2015
           areaprot=0.0
           arealig=0.0
           do j=1,natom
             if (mol(j)==2) then
               areaprot=areaprot+atmarea(j)
             else
               arealig=arealig+atmarea(j)
             end if
           enddo
! mover para dentro do GETAREA


!compute hydrophobic  0=hydrophobic, 1=hydrophilic
! OK se voce tem 1 proteina com um ligantes qualquer.
! Mas se voce tem duas proteinas a interpretacao pode ficar estranha.
! precisamos separar as areas no caso de ser protein-protein.
           hydrophobic=0.0
           hydrophilic=0.0
           do j=1,maxamn
             if(amntype(j).eq.0) hydrophobic=hydrophobic+amnarea(j)
             if(amntype(j).eq.1) hydrophilic=hydrophilic+amnarea(j)
           enddo
       if (frame.eq.1) then 
         write(*,"(6A15)") "#         Model","Total",
     & "Receptor", "Hydrophobic", "Hydrophilic", "Ligand"
       endif
        write(*,"(i15,5(3x,f12.2))") frame,areatot,areaprot,
     & hydrophobic,hydrophilic,arealig
        write(38,*) frame,areatot,areaprot,
     & hydrophobic,hydrophilic,arealig

100     continue
101     continue

       nframes=frame
        do i=1,namn
          dp(i)=0.0D0
          amnmed(i)=amntot(i)/nframes
!       write(*,*) i,amnmed(i),dp(i),amntot(i),desvio(nframes,i)
          do j=1,nframes
            dp(i)= dp(i) + (desvio(j,i)-amnmed(i))**2   !isso tah horrivel
          enddo
          dp(i)= sqrt( dp(i) / nframes )
        enddo

        do i=1,namn
          write(34,*) res(i), i,amnmed(i),dp(i)
        enddo
        close(34)


        call cpu_time(t2)
        write(*,*)
        write(*,*) "Tempo de execução =",t2-t1,"segundos"
        write(*,*) "Tempo por frame   =",((t2-t1)/nframes),"segundos"

        end program lmdmsurf

***********************************************************************
        subroutine checkreadref (natom,radii,mol)
***********************************************************************
        integer natom
        integer mol(natom)
        real radii(natom)
        do i=1,natom
        write(*,*) i,mol(i),radii(i)
        enddo

        return
        end subroutine checkreadref

***********************************************************************
        subroutine checkreadtraj(natom,atoms)
***********************************************************************
        integer natom
        real atoms(3,natom)
        do i=1,natom
        write(*,*) (atoms(j,i),j=1,3)
        enddo

        return
        end subroutine checkreadtraj

***********************************************************************
        subroutine write_header
***********************************************************************
        write(38,*)'@    title "Interface area"'
        write(38,*)'@    xaxis  label "Frame"'
        write(38,*)'@    yaxis  label "(Angstron\S2\N)"'
        write(38,*)'@TYPE xy'
        write(38,*)'@ s0 legend "Total"'
        write(38,*)'@ s1 legend "Receptor"'
        write(38,*)'@ s2 legend "Hydrophobic (receptor)"'
        write(38,*)'@ s3 legend "Hydrophylic (receptor)"'
        write(38,*)'@ s4 legend "Ligand"'
        end subroutine write_header


!last update 
! Mon Jun  6 17:34:31 CEST 2016 by DEBG, dgomes
! ***********************
! * Program Description *
! ***********************
! This software uses the Molecular Dot Surface algorithm 
!{Connolly, Science/Journal of Applied Crystallography 1986} 
!to compute the solvent-accessible molecular surface of a molecule,
! given the coordinates and radii of its atoms, and a probe radius.
!
! ***************************
! * Program Functionalities *
! ***************************
! Calculates Interfaces between chains in PDB files.
! Calculates Surface Complementarieties between chains in PDB files.
!
! Developers
!
! !by AWSS
! Alan Wilter
! EMBL - EBI, Wellcome Trust Genome Campus  
! former Instituto de Pesquisas Espaciais - Brasil.
!  alan@lac.inpe.br
!
! !by dgomes or !by debg
! Diego Enry B. Gomes
! Instituto Nacional de Metrologia, Qualidade e Tecnologia - Brasil
! dgomes@pq.cnpq.br
!
! formelly from:
! Laboratório de Modelagem e Dinâmica Molecular
! Instituto de Biofísica Carlos Chagas Filho - UFRJ - Brasil.
! +55 (21) 2260-6963 | diego@biof.ufrj.br
!
! !by gabriel
! Gabriel Limaverde S. C. Sousa
! Fundacao Oswaldo Cruz - Brasil 
!
! Laboratório de Modelagem e Dinâmica Molecular
! Instituto de Biofísica Carlos Chagas Filho - UFRJ - Brasil.
! +55 (21) 2260-6963 | gabriel@biof.ufrj.br

