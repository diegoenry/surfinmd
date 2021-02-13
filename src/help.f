************************************************************************
        subroutine help()
************************************************************************
        character red*5,normal*5,underline*4

        red=char(27)//"[31m"
        normal=char(27)//"[0m"
        underline=char(27)//"[4m"
       print*
      write(*,*) underline//"Usage:"//normal
       print*

       write(*,*) "surfinmd"
     &  //red//" -r"//normal//"ref.pdb"
     &  //red//" -i"//normal//"traj.pdb"
     &  //red//" -dcd"//normal//"traj.dcd"
     &  //red//" -o"//normal//"surf.dat"
     &  //red//" -or"//normal//"rsurf.dat"
     &  //red//" -csv"//normal//"rsurf.csv"
     &  //red//" -p"//normal//"1.4"
     &  //red//" -d"//normal//"1.0"
     &  //red//" -a"//normal//"6"

      print*
      write(*,*) 
     & underline//"Please review all usage options"//normal//"[defaul]"
      print*


        write(*,*)
     & red//" -h   "//normal//"= Display this help "
        write(*,*)
     & red//" -r   "//normal//"= Reference Structure [ref.pdb]"
        write(*,*)
     & red//" -i   "//normal//"= Input file          [traj.pdb]"
        write(*,*) 
     & red//" -dcd "//normal//"= Input file          [traj.dcd]"
        write(*,*)
     & red//" -o   "//normal//"= Output surface      [surf.dat]"
        write(*,*)
     & red//" -or  "//normal//"= Output surface/residue [rsurf.dat]"
        write(*,*)
     & red//" -csv "//normal//"= Output ALL surf/res [rsurf.csv]"
        write(*,*) 
     & red//" -p   "//normal//"= probe radius        [1.4]"
        write(*,*) 
     & red//" -d   "//normal//"= probe density       [1.0 A^2]"
        write(*,*) 
     & red//" -a   "//normal//"= attention number    [6]"
        write(*,*) 
     & red//" -ext "//normal//"= (Rvdw + ext )       [n]"
        write(*,*) 
     & red//" -scal"//normal//"= (Rvdw * scal)       [n]"


        print*
        STOP
        return
        end

