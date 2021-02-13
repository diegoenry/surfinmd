       subroutine readdcd(natom,atoms,fim)
       !implicit none
       double precision  d
       real atoms(3,natom)
       read(77) (d, j=1, 6)
       read(77) (atoms(1,j),j=1,natom)
       read(77) (atoms(2,j),j=1,natom)
       read(77) (atoms(3,j),j=1,natom)
       end subroutine readdcd
