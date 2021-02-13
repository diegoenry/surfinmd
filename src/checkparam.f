************************************************************************        
!        subroutine checkparam
!     &(nr,ni,no,np,nd,na,pdbref,pdbin,probe,density,prattnum)
************************************************************************
        if(nr.eq.0) write(*,*) "Using ref.pdb"
        if(ni.eq.0) write(*,*) ""
        if(no.eq.0) write(*,*) ""
        if(np.eq.0) write(*,*) ""
        if(nd.eq.0) write(*,*) ""
        if(na.eq.0) write(*,*) ""

        if(na.eq.0) call aew(na+51)

!        return
        end

        subroutine aew(i)
        write(*,*) "aew",i
        return
        end
