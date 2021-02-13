! usar unit=7*
***********************************************************************
        subroutine readtraj(natom,atoms,fim)
***********************************************************************
        integer natom,fim
        real atoms(3,natom)

        read(71,*,err=101,end=101) !le o cabeçalho
        read(71,*) !le o cabeçalho
        read(71,*) !le o cabeçalho
!        read(71,*) !le o cabeçalho
!        read(71,*) !le o cabeçalho !o gromacs tem 5 linhas
        do i=1,natom
         read(71,700) (atoms(j,i),j=1,3)
        enddo

        read(71,*) !le o final
        read(71,*) !le o final

100     goto 102
101     fim=1
102     continue

700     format(30x,3f8.3)
        return
        end

! atom          ;coordenadas dos atomos


