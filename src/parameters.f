! usar unit=2*
! parametros
        integer maxatm,maxamn,maxframes
        parameter (maxatm=20000)
        parameter (maxamn=2000)
        parameter (maxframes=50000)
        character pdbin*30
        character pdbref*30
        character out*30
        character rout*30
        character rcsv*30
        character dcd*30
        real probe,density,rp
        integer prattnum
        integer natom,namn
        integer mol(maxatm),amn(maxatm)
        real exclude,scalon,radii(maxatm)
        character*1 cad1,cad2,optext,optscal
        real atoms(3,maxatm)
        real atmden(maxatm)
        integer atten(maxatm)
        real atmarea(maxatm)
        real amnarea(maxamn)
        real amntot(maxamn),amnmed(maxamn),areatot
        character res*3
        dimension res(maxamn)
        real desvio(maxframes,maxamn)
        real dp(maxamn)
        real tmp
        integer amntype(maxamn)
        real hydrophobic,hydrophilic
        integer b !start frame
        integer e !end frame
        real arealig, areaprot 
!maxatm         ; número máximo de átomos
!maxamn         ; número máximo de aminoacidos
!maxframes      ; número máximo de frames (culpa do calculo do desvio)
!pdbin          ; Nome do arquivo contendo a trajetoria (x,y,z)
!pdbref         ; Nome do arquivo .pdb. Só para pegar o tipo dos átomos.
!probe          ; raio da probe [1.4 angstrons]
!density        ; densidade de pontos por A^2 [1.0]
!prattnum       ; numero de atencao [6 so intermol] 
! 2=surf 3="2"+area 4="3"+normal 5="4"+intermol 6="so intermol"'
!natom          ; numero de atomos
!namn           ; numero de aminoacidos
!cad1           ; letra da 1a cadeia
!cad2           ; letra da 2a cadeia
!optext         ; extender (Rvdw + exten) os raios de vdw
!optscal        ; escalonar (Rvdw*scalon) os raios de vdw 
!exclude        ; valor de extensao !by debg nao sei por que se chama "exclude"
!scalon         ; valor de escalonamento
!mol            ; indica se a cadeia é A ou B|
!radii          ; raio de vdw
!atmarea        ; area por atomo (somatorio)
!amntot         ; area total por aminoacido
!amnmed         ; area media por aminoacido
!desvio         ; armazenador de todas as areas / amn para calcular o desvio no final.
!amntype        ; 0=hydrophobic 1=hydrophilic
!line(10:11) numero atomo
!line(18:20) nome do residuo
!line(23:26) numero do residuo

