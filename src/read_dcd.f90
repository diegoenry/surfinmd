program BinRead
implicit none
character*80      :: filename
double precision  :: d
real              :: t,dummyr
real,allocatable  :: x(:,:),y(:,:),z(:,:)
integer           :: nset,natom,dummyi,i,j,nframes
character*4       :: dummyc

! getarg retrieves command line arguments, and sets first to "filename"
call getarg(1,filename)

open(10,file=trim(filename),status='old',form='unformatted')
read(10) dummyc, nframes, (dummyi,i=1,8), dummyr, (dummyi,i=1,9)
read(10) dummyi, dummyr
read(10) natom

allocate(x(nframes,natom))
allocate(y(nframes,natom))
allocate(z(nframes,natom))


do i = 1, nframes
   read(10) (d, j=1, 6)
   read(10) (x(i,j),j=1,natom)
   read(10) (y(i,j),j=1,natom)
   read(10) (z(i,j),j=1,natom)
end do

15 format(a17,i6,a12,i6,a6)
16 format(6f13.8)
print*
print 15, 'The dcd contains ',nframes,' frames and ',natom,' atoms'
print*


! print 16,x(1,21362),y(1,21362),z(1,21362),x(125,1),y(125,1),z(125,1)
deallocate(x)
deallocate(y)
deallocate(z)


close(10)

end program BinRead
