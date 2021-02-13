! usar unit=1*
        program lmdmsurf
        implicit none      
        integer i,j,nframes,fim,n1
        real t1,t2
        include 'parameters.f'
        nframes=0
        natom=0
        namn=0
        fim=0

        call titulo

        call readparam
     &(pdbref,pdbin,probe,density,prattnum,cad1,cad2,exclude,scalon,
     &out,rout)

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

        do n1=1,30 !by debg !fix input filename
         if(out(n1:n1).eq.' ') goto 1
        enddo
1       n1=n1-1
        open(38,file=out(1:n1))
        write(38,*)'@    title "Interface area"'
        write(38,*)'@    xaxis  label "Frame"'
        write(38,*)'@    yaxis  label "(Angstron\S2\N)"'
        write(38,*)'@TYPE xy'
        write(38,*)'@ s0 legend "Total"'
        write(38,*)'@ s1 legend "Hydrophobic"'
        write(38,*)'@ s2 legend "Hydrophylic"'

        do n1=1,30 !by debg !fix input filename
         if(rout(n1:n1).eq.' ') goto 2
        enddo
2       n1=n1-1
        open(34,file=rout(1:n1))

        do n1=1,30 !by debg !fix input filename
         if(pdbin(n1:n1).eq.' ') goto 3
        enddo
3       n1=n1-1
        open(71,file=pdbin(1:n1))

        do 100 !frames loop
           call readtraj(natom,atoms,fim)
           if(fim.eq.1) goto 101
!           call checkreadtraj(natom,atoms) !ok

        do i=1,natom
        atmarea(i)=0.0
        enddo

           call mds
     &(maxatm,rp,natom,atoms,radii,atmden,atten,mol,atmarea)

           call getarea(natom,maxamn,amn,amnarea,areatot,atmarea)

           do j=1,maxamn
           amntot(j)=amntot(j)+amnarea(j)
           enddo

           nframes=nframes+1

           do j=1,maxamn
           desvio(nframes,j)=amnarea(j)
           enddo

!compute hydrophobic  0=hydrophobic, 1=hydrophilic
           hydrophobic=0.0
           hydrophilic=0.0
           do j=1,maxamn
           if(amntype(j).eq.0) hydrophobic=hydrophobic+amnarea(j)
           if(amntype(j).eq.1) hydrophilic=hydrophilic+amnarea(j)
           enddo
           write(*,*) "model",nframes," Total = ",areatot
     &, " Hydrophobic = ",hydrophobic, " Hydrophilic = ",hydrophilic
        write(38,*) nframes,areatot,hydrophobic,hydrophilic

!patch para a priscila
!escreve a area por residuo a cada passo do calculo
        write(3366,*) "Frame ",nframes
        do j=1,maxamn
        write(3366,*) j, amnarea(j)
        enddo
!final do patch para priscila

100     continue
101     continue


        do i=1,namn
        dp(i)=0.0D0
          amnmed(i)=amntot(i)/nframes
!       write(*,*) i,amnmed(i),dp(i),amntot(i),desvio(nframes,i)
            do j=1,nframes
            dp(i)= dp(i) + (desvio(j,i)-amnmed(i))**2 
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

        end

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
        end

***********************************************************************
        subroutine checkreadtraj(natom,atoms)
***********************************************************************
        integer natom
        real atoms(3,natom)
        do i=1,natom
        write(*,*) (atoms(j,i),j=1,3)
        enddo

        return
        end




!last update 
!Thu Jun 26 19:25:54 BRT 2008 !by DEBG
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
! Instituto de Pesquisas Espaciais - Brasil.
!  alan@lac.inpe.br
!
! !by dgomes or !by debg
! Diego Enry B. Gomes
! Laboratório de Modelagem e Dinâmica Molecular
! Instituto de Biofísica Carlos Chagas Filho - UFRJ - Brasil.
! +55 (21) 2260-6963 | diego@biof.ufrj.br
!
! !by gabriel
! Gabriel Limaverde S. C. Sousa
! Laboratório de Modelagem e Dinâmica Molecular
! Instituto de Biofísica Carlos Chagas Filho - UFRJ - Brasil.
! +55 (21) 2260-6963 | gabriel@biof.ufrj.br
!
! !by melomcr
! Marcelo C. R. Melo
! Laboratório de Modelagem e Dinâmica Molecular
! Instituto de Biofísica Carlos Chagas Filho - UFRJ - Brasil.
! +55 (21) 2260-6963 | melomcr@gmail.com


