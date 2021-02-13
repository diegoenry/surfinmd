program BinRead
implicit none
character*80      :: filename
double precision  :: d
real              :: t,dummyr
!real,allocatable  :: x(:,:),y(:,:),z(:,:)
real,allocatable  :: x(:),y(:),z(:)
integer           :: nset,natom,dummyi,i,j,nframes
character*4       :: dummyc
integer           :: nsplit !guarda em quantas partes queremos separar o DCD
integer           :: nfsplit  !numero de frames por parte
integer           :: k,l

! getarg retrieves command line arguments, and sets first to "filename"
call getarg(1,filename)

open(10,file=trim(filename),status='old',form='unformatted')
read(10) dummyc, nframes, (dummyi,i=1,8), dummyr, (dummyi,i=1,9)
read(10) dummyi, dummyr
read(10) natom

print 15, 'The dcd contains ',nframes,' frames and ',natom,' atoms'

write(*,*) "Em quantas partes voce quer separar o DCD ?"
read(*,*) nsplit

write(*,*) nframes/nsplit

write(*,*) "Quantos frames voce quer por parte "
read(*,*) nfsplit

allocate(x(natom))
allocate(y(natom))
allocate(z(natom))

do k = 1, nsplit
  write (*,*) "Digite o nome da parte ", k
  read(*,*) filename
  open(11,file=trim(filename),status='new',form='unformatted')
  write(11) dummyc, nframes, (dummyi,i=1,8), dummyr, (dummyi,i=1,9)
  write(11) dummyi, dummyr
  write(11) natom
 
  do l = 1, nfsplit
     read(10) (d, j=1, 6)
     read(10) (x(j),j=1,natom)
     read(10) (y(j),j=1,natom)
     read(10) (z(j),j=1,natom)

     write(11) (d, j=1, 6)
     write(11) (x(j),j=1,natom)
     write(11) (y(j),j=1,natom)
     write(11) (z(j),j=1,natom)
  enddo
  close(11)
enddo


deallocate(x)
deallocate(y)
deallocate(z)

close(10)
15 format(a17,i6,a12,i6,a6)

end program BinRead
