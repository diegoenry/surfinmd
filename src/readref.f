! Laboratorio de Modelagem e Dinamica Molecular
! SurfinMD v1.05 
!***********************************************************************
!versao 1.05 | Wed May 27 09:41:32 PDT 2009 !by debg
!***********************************************************************
!Requires: maxatm,pdbref,cad1,cad2,exclude,scalon
!Returns: natoms, molec,radius
!1) Read the reference .pdb (pdbref)
!2) Count the number of atoms (natom)
!3) Stores which chain each atom belongs (molec)
!4) Selects the van de Waals radius (call setradius)
!5) Indicates which atom belongs to which residue (call aminoatom) 
!
! usar unit=6*
!
***********************************************************************
        subroutine readref
     &(maxatm,pdbref,cad1,cad2,natom,exclude,scalon,radii,mol,amn,namn,
     & maxamn,res,amntype)
***********************************************************************
        implicit none
        integer   natom,namn,n1
        integer   maxatm,maxamn
        integer   mol(maxatm),amn(maxatm)
        integer   lastamn
        real      exclude,scalon,rad
        real      radii(maxatm)
        character pdbref*30,line*54
        character cad1*1,cad2*1,res*3
        dimension res(maxamn)
        integer   amntype(maxamn)
        real      atype
        lastamn=0

        do n1=1,30 !by debg !fix input filename
         if(pdbref(n1:n1).eq.' ') goto 3
        enddo
3       n1=n1-1

        open(61,file=pdbref(1:n1))
!        open(61,file=pdbref,status='old',err=610) !ainda nao fiz o error code.
!leitura do arquivo de referencia        

        do 10
          read(61,600) line
          if(line(1:6).eq."ATOM  ") goto 11
10      continue
11      continue
        backspace(61)

        natom=0
        do 20
          read(61,600,err=21,end=21) line
          natom=natom+1
           if((line(1:6).eq."TER   ").or.(line(1:6).eq."ENDMDL").
     & or.(line(1:6).eq."      ").or.(line(1:6).eq."END   ")) then
           natom=natom-1
           goto 21
           endif
         if(line(22:22).eq.cad1) mol(natom)=2
         if(line(22:22).eq.cad2) mol(natom)=3
         read(line(23:26),*) amn(natom)! char=>int !by debg
           if(amn(natom).ne.lastamn) then
           namn=namn+1
           read(line(18:20),*) res(namn)
           endif        
         lastamn=amn(natom)

         call getatype(res,amntype,namn)

         call setradii(line,exclude,scalon,rad)
         radii(natom)=rad

***********************************************************************
!         amn="         "
!         call aminoatom(line)
***********************************************************************


20      continue
21      continue

        close(61)
600     format(a54)
        
        return
        end
