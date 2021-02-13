************************************************************************
        function default(i)
************************************************************************
        integer i
        character*30 default
!default values
        if(i.eq.1)  default="ref.pdb"    !pdbref
        if(i.eq.2)  default="traj.pdb"   !pdbin
        if(i.eq.3)  default="surf.dat"   !surf
        if(i.eq.11) default="rsurf.dat"  !rsurf
        if(i.eq.12) default="rsurf.csv"  !rsurf by frame ! by dgomes;  Mon Jun  6 17:24:45 CEST 2016
!        if(i.eq.12) csv=.FALSE.          !Do not write all areas by default
        if(i.eq.4)  default="1.4"        !probe
        if(i.eq.5)  default="1.0"        !density
        if(i.eq.6)  default="6"          !atten or prattnum
        if(i.eq.7)  default="no"         !exclude
        if(i.eq.8)  default="no"         !scalon
        if(i.eq.9)  default="A"         !chain 1 identifier
        if(i.eq.10) default="B"         !chain 2 identifier

        return
!error code
901     write(*,*) "Default value unknown"
        end
