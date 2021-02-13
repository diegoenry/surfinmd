***********************************************************************
        subroutine getarea
     &(natom,maxamn,namn,amn,amnarea,areatot,atmarea) 
***********************************************************************
        integer natom,a,maxamn,amn(natom)
        real    atmarea(natom),area
        real    amnarea(maxamn)
        real    areatot, areaprot, arealig
        integer aminoacid

!        open(7,file="dots")
!        rewind(7)

!        do i=1,natom
!        atmarea(i)=0.0
!        enddo

        do i=1,maxamn
          amnarea(i)=0.0
        enddo

!area por atomo
!10      read(7,*,end=11) a,area  
!          atmarea(a)=atmarea(a)+area
!          goto 10        
!11      continue
!        close(7)
      
!area total
        areatot=0.0
          do i=1,natom
            areatot=areatot+atmarea(i)
          enddo

!area por residuo
!        do i=1,maxamn !bugfix v1.05r6
        i=1
        aminoacid=amn(1)
        do j=1,natom
!          if(amn(j).eq.i) amnarea(i)=amnarea(i)+atmarea(j) !bugfix v1.05r6
          if(amn(j).eq.aminoacid) then
            amnarea(i)=amnarea(i)+atmarea(j)
          else
            aminoacid=amn(j)
            i=i+1
            amnarea(i)=amnarea(i)+atmarea(j)
          endif
         enddo


!debug
!        do i=1,namn
!          write(*,*) i,amnarea(i)
!        enddo
!        STOP

        return
        end







