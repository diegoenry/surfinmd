      program botacadeia
      CHARACTER ATM*17,AA*3,CADEIA*2,RESTO*32

       OPEN(1,FILE='ref.pdb')
       OPEN(2,FILE='refc.pdb')

 1000  FORMAT(A17,A3,2X,A32)       
 2000  FORMAT(A17,A3,A2,A32)       

        do 100    

!        do i=1,5
        do i=1,4
        read(1,"(a32)") RESTO
        write(2,"(a32)") RESTO
        enddo

        CADEIA = ' A' 
!Coloque aqui o numero do ultimo atomo da cadeia A
        DO I=1,3120
        READ(1,1000) ATM,AA,RESTO
        WRITE(2,2000) ATM,AA,CADEIA,RESTO
        ENDDO

        CADEIA = ' B'
!não precisa mais colocar o numero do ultimo atomo :) !by debg
       DO 200
       READ(1,1000,end=201,err=201) ATM,AA,RESTO
       WRITE(2,2000) ATM,AA,CADEIA,RESTO
200    continue
201    continue

100    continue    
       END

