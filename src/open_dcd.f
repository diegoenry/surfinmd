!Sun Nov 15 15:20:54 BRST 2015
       subroutine open_dcd(dcd,nframes)
       implicit none
       character          dcd*30
       real               t,dummyr
       integer            nset,natom,dummyi,i,j,nframes
       character*4        dummyc
       open(77,file=trim(dcd),status='old',form='unformatted')
       read(77) dummyc, nframes, (dummyi,i=1,8), dummyr, (dummyi,i=1,9)
       read(77) dummyi, dummyr
       read(77) natom

15     format(a17,i6,a12,i6,a6)
       print*
       print 15, 'The dcd contains ',nframes,' frames and ',natom,
     &' atoms'
       print*
       
       end subroutine open_dcd
