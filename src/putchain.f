      program putchain
      integer alimit
      character*20  in, out
      write(*,*) char(27)//"[31m"
      write(*,*)"******************************************************"
      write(*,*)"*                 LMDM - PUTCHAIN                    *"
      write(*,*)"******************************************************"
      write(*,*) char(27)//"[0m"

      !get command line arguments.
!     in=input ; out=output ; alimit= last atom of chain A
      call getparam(in,out,alimit) 

      OPEN(1,FILE=in)
      OPEN(2,FILE=out)

      !find the ATOM record on the PDB file 
      call getfirstatom()

      !read coordinates and now writes with the chain identifiers 
      call readwritepdb(alimit)

       END

************************************************************************
       subroutine getparam(in,out,alimit) !
************************************************************************
       character*20  in, out, argv
       integer i, iargc, n
       integer alimit
!usefull colors
       character red*5,normal*5,underline*4
       red=char(27)//"[31m"
       normal=char(27)//"[0m"
       underline=char(27)//"[4m"

       alimit=0

       n = iargc() ;  if(n.eq.0) goto 10

        do i = 1, n
         call getarg( i, argv )
         if(argv(1:2).eq."-h") call help()  
        enddo

       do i = 1, n  
        call getarg( i, argv )  

        if(argv(1:2).eq."-i") then ; call getarg(i+1,argv)
          if(argv.eq." ".or.argv(1:1).eq."-") goto 11
          in=argv
        endif

        if(argv(1:2).eq."-o") then ; call getarg(i+1,argv)
          if(argv.eq." ".or.argv(1:1).eq."-") goto 12
          out=argv
        endif

        if(argv(1:2).eq."-a") then ; call getarg(i+1,argv)
          if(argv.eq." ".or.argv(1:1).eq."-") goto 14
          read(argv,'(i5)',err=14) alimit !string to INTEGER
        endif

       end do  

        if(in.eq." ") goto 11
        if(out.eq." ") goto 12
        if(alimit.eq.0) goto 13

       return
10     write(*,*) "\n ERROR: Program executed without arguments." 
        goto 999
11     write(*,*) "\n ERROR: No input file"
        goto 999
12     write(*,*) "\n ERROR: No output file"
        goto 999
13     write(*,*) "\n ERROR: Last atom of chain A not specified"
        goto 999
14     write(*,*) "\n ERROR: Invalid value for "
     &//red//"Last atom of chain A"//normal," --> ",argv
        goto 999

999    write(*,*) "\n Type "//red//"putchain -h"//normal//
     & "to review all usage options \n"
       STOP
       end

************************************************************************
        subroutine getfirstatom()
************************************************************************
        character line*70
       do 10
          read(1,"(a70)") line
          if(line(1:6).eq."ATOM  ") goto 11
10      continue
11      continue
        backspace(1)

        return
        end
************************************************************************
        subroutine readwritepdb(alimit)
************************************************************************
        character line*70
        integer i, alimit

       i=0
10     continue
       i=i+1
        READ(1,"(a70)",end=11,err=11) line 
         if(line(1:6).eq."ATOM") then

           if(i.le.alimit) then
             line=line(1:20)//" A"//line(23:70)
             WRITE(2,"(a70)") line
           else
             line=line(1:20)//" B"//line(23:70)
             WRITE(2,"(a70)") line
           endif
        endif
        goto 10
11    continue

        return
        end

************************************************************************
        subroutine help()
************************************************************************
!        write(*,*) "Usage: putchain -i input.pdb -o output.pdb -a 3120"
       write(*,*) "Usage: putchain"
     &  //char(27)//"[31m -i"//char(27)//"[0m  input.pdb"
     &  //char(27)//"[32m -o"//char(27)//"[0m output.pdb"
     &  //char(27)//"[33m -a"//char(27)//"[0m 3120"

        print*
        write(*,*) char(27)//"[31m  -i"//char(27)//"[0m  = Input file"
        write(*,*) char(27)//"[32m  -o"//char(27)//"[0m  = Output file"
        write(*,*) char(27)//"[33m  -a"//char(27)//"[0m  = Last atom of
     & chain A"
        print*
        write(*,*) "There is no need to define the last atom of chain B"
        print*

        STOP
        return
        end
