!Created by: debg
!Tue Jul 29 20:56:57 BRT 2008
************************************************************************
        subroutine readparam
     &(pdbref,pdbin,probe,density,prattnum,cad1,cad2,exclude,scalon,
     &out,rout,rcsv,dcd,b,e)! by dgomes;  Mon Jun  6 17:24:45 CEST 2016
************************************************************************
       character*30  pdbref, pdbin, argv, out, rout, dcd, default
       character*30  rcsv  ! by dgomes;  Mon Jun  6 17:24:45 CEST 2016
       character*2 ext,scal
       character*1 cad1,cad2
       integer iargc
       integer prattnum
       real probe,density
       real exclude,scalon
       integer b,e
!usefull colors
       character red*5,normal*5,underline*4
       red=char(27)//"[31m"
       normal=char(27)//"[0m"
       underline=char(27)//"[4m"

!default values
       pdbref  = default(1) ; pdbin = default(2) 
       out     = default(3) ; rout = default(11)       
       rcsv    = default(12) ! by dgomes;  Mon Jun  6 17:24:45 CEST 2016
       argv    = default(4) ; read(argv,*) probe   
       argv    = default(5) ; read(argv,*) density
       argv    = default(6) ; read(argv,*) prattnum
       ext     = default(7) ; scal    = default(8)
       cad1    = default(9) ; cad2    = default(10)
       if(ext.eq."no")  exclude=0.0
       if(scal.eq."no") scalon=1.0
       b = 1 ; e = 0  

       n = iargc() ;  if(n.eq.0) goto 910

       do i = 1, n  !check if -h is anywhere in the command line
        call getarg( i, argv ) ; if(argv(1:2).eq."-h") call help()
       enddo


       do i = 1, n  ! Yeah, lots of sanity checks. !by debg
        call getarg( i, argv )  
!strings
         if(argv(1:4).eq."-dcd") then ; call getarg(i+1,argv)
            if(argv.eq." ".or.argv(1:1).eq."-") argv=default(1)
            dcd=argv
          endif
         
         if(argv(1:3).eq."-r ") then ; call getarg(i+1,argv)
            if(argv.eq." ".or.argv(1:1).eq."-") argv=default(1)
            pdbref=argv
          endif

! by dgomes;  Mon Jun  6 17:24:45 CEST 2016
         if(argv(1:5).eq."-csv ") then ; call getarg(i+1,argv)
            if(argv.eq." ".or.argv(1:1).eq."-") argv=default(12)
            rcsv=argv
          endif

          if(argv(1:3).eq."-i ") then ; call getarg(i+1,argv)
            if(argv.eq." ".or.argv(1:1).eq."-") argv=default(2)
            pdbin=argv
          endif

          if(argv(1:3).eq."-o ") then ; call getarg(i+1,argv)
            if(argv.eq." ".or.argv(1:1).eq."-") argv=default(3)
            out=argv
          endif

          if(argv(1:3).eq."-or") then ; call getarg(i+1,argv)
            if(argv.eq." ".or.argv(1:1).eq."-") argv=default(11)
            rout=argv
          endif

!string to number (float or integer)
          if(argv(1:3).eq."-p ") then ; call getarg(i+1,argv) 
            if(argv.eq." ".or.argv(1:1).eq."-") argv=default(4)
            read(argv,*,err=920) probe !string to FLOAT
          endif

          if(argv(1:3).eq."-d ") then ; call getarg(i+1,argv)
            if(argv.eq." ".or.argv(1:1).eq."-") argv=default(5)
            read(argv,*,err=930) density !string to FLOAT
          endif

          if(argv(1:3).eq."-a ") then ; call getarg(i+1,argv)
            if(argv.eq." ".or.argv(1:1).eq."-") argv=default(6)
            read(argv,'(i1)',err=940) prattnum !string to INTEGER
            if(prattnum.gt.6.or.prattnum.le.0) goto 940
          endif

          if(argv(1:4).eq."-ext") then ; call getarg(i+1,argv)
            if(argv.eq." ".or.argv(1:1).eq."-") argv=default(7)
            read(argv,*,err=950) exclude !string to INTEGER
          endif

          if(argv(1:4).eq."-scal") then ; call getarg(i+1,argv)
            if(argv.eq." ".or.argv(1:1).eq."-") argv=default(8)
            read(argv,*,err=960) scalon !string to INTEGER
          endif

          if(argv(1:3).eq."-b ") then ; call getarg(i+1,argv)
            if(argv.eq." ".or.argv(1:1).eq."-") argv=default(12)
            read(argv,*,err=960) b !string to INTEGER
          endif

          if(argv(1:3).eq."-e ") then ; call getarg(i+1,argv)
            if(argv.eq." ".or.argv(1:1).eq."-") argv=default(13)
            read(argv,*,err=960) e !string to INTEGER
          endif

      enddo  

!        write(*,*) pdbref,pdbin,out 
!        write(*,*) probe,density,prattnum
!        write(*,*) exclude,scalon

100    continue
       return

!error codes       
910    write(*,*) "\n WARNING: Program executed without any arguments."
       write(*,*) "Running with default parameters"
        goto 100

920    write(*,*) "\n ERROR: Invalid value for "
     &//red//"probe"//normal," --> ",argv
        goto 999

930    write(*,*) "\n ERROR: Invalid value for "
     &//red//"density"//normal," --> ",argv
        goto 999

940    write(*,*) "\n ERROR: Invalid value for "
     &//red//"attention number"//normal," --> ",argv
       write(*,*) red//"attention numbers"//normal//
     &" available are 1,2,3,4,5 and 6"
        goto 999

950    write(*,*) "\n ERROR: Invalid value for "
     &//red//"(Rvdw + ext )"//normal," --> ",argv
        goto 999

960    write(*,*) "\n ERROR: Invalid value for "
     &//red//"(Rvdw * scal)"//normal," --> ",argv
        goto 999


999    write(*,*) "\n Type "//red//"surfinmd -h"//normal//
     & "to review all usage options \n"

       END
