! ============= Routine to define aminoacid type =====================
!> @file getatype.f 
!> @brief Rotina para definir o tipo de amino acido
!> @return amntype
!> @define amntype use natm.
!> @author Diego Enry Barreto Gomes, 2015
!> @author Alan Wilter, 2004
!! @todo Melhorar a lista de aminoacidos

        subroutine getatype(res,amntype,namn)
        character res*3
        dimension res(namn)
        integer namn
        integer amntype(namn)
        amntype(namn)=3  !this means undefined type !by debg 29Jul2009
!NON POLAR RESIDUES
        if(res(namn).eq."ALA") amntype(namn)=0
        if(res(namn).eq."CYS") amntype(namn)=0
        if(res(namn).eq."CYM") amntype(namn)=0 !Mon Nov 23 18:59:52 BRST 2015
        if(res(namn).eq."CYX") amntype(namn)=0 !Mon Nov 23 18:59:52 BRST 2015
        if(res(namn).eq."GLY") amntype(namn)=0
        if(res(namn).eq."ILE") amntype(namn)=0
        if(res(namn).eq."LEU") amntype(namn)=0
        if(res(namn).eq."MET") amntype(namn)=0
        if(res(namn).eq."PHE") amntype(namn)=0
        if(res(namn).eq."PRO") amntype(namn)=0
        if(res(namn).eq."TRP") amntype(namn)=0
        if(res(namn).eq."VAL") amntype(namn)=0
!POLAR RESIDUES
        if(res(namn).eq."ARG") amntype(namn)=1
        if(res(namn).eq."ASN") amntype(namn)=1
        if(res(namn).eq."ASP") amntype(namn)=1
        if(res(namn).eq."GLU") amntype(namn)=1
        if(res(namn).eq."GLN") amntype(namn)=1
        if(res(namn).eq."HIS") amntype(namn)=1
        if(res(namn).eq."HIP") amntype(namn)=1 !Mon Nov 23 18:59:52 BRST 2015
        if(res(namn).eq."HIE") amntype(namn)=1 !Mon Nov 23 18:59:52 BRST 2015
        if(res(namn).eq."HID") amntype(namn)=1 !Mon Nov 23 18:59:52 BRST 2015
        if(res(namn).eq."LYS") amntype(namn)=1
        if(res(namn).eq."LYP") amntype(namn)=1 !Mon Nov 23 18:59:52 BRST 2015
        if(res(namn).eq."SER") amntype(namn)=1
        if(res(namn).eq."TYR") amntype(namn)=1
        return
        end        