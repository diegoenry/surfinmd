***************************************************
c molecular dot surface computation subroutine:

!by debg 25Jul2008      subroutine mds(rp,natom,atoms,radii,atmden,atten,mol)
      subroutine mds
     &(maxatm,rp,natom,atoms,radii,atmden,atten,mol,atmarea)
      real atmarea(natom) !by debg 25Jul2008
      real rp
      integer natom
      real atoms(3,natom)
      real radii(natom)
      real atmden(natom)
      integer atten(natom)
      integer mol(natom)

c MAXATM parameter should have the same value in the calling program
      integer MAXATM
!      parameter (MAXATM=10000)
c MAXNBR parameter should have the same value in the putpnt subroutine
      integer MAXNBR, MAXSUB, MAXPRB, MAXLOW
      parameter (MAXNBR=20000) ! changed from 10000 for big structures ! by debg 29Jul2009
      parameter (MAXSUB=20000) ! changed from 10000 for big structures ! by debg 29Jul2009
      parameter (MAXPRB=20000) ! changed from 10000 for big structures ! by debg 29Jul2009
      parameter (MAXLOW=20000) ! changed from 10000 for big structures ! by debg 29Jul2009


      integer i, j, k, l, m, n, mm, mc
      integer i1, i2, i3, i4, nnbr, nbur, nbb, inbr, jnbr, knbr, lnbr  
      integer ilat, nlat, nlow, nnear, nprobe, iprb, iprb2
      integer isign, is0, isub, nsub, ipnt, npnt
      real contain
      real pradius, bb, bb2, radmax, d, d2, density, bridge
      real ri, rj, rk, rl, eri, erj, erk, erl
      real rij, rci, rcj, rb, area, rad
      real dij, djk, dik, asymm, dmin, dt, wijk, swijk, far
      real anglei, anglej, dtq, e, rs, cs, ps, ts
      real hijk, dtijk2, rkp2, dm, edens

      real dot
      real triple
      real dis2
      real dis
      real disptl

  
c neighbor arrays:
      integer nbr(MAXNBR)
      real disnbr(MAXNBR),nbrstd(MAXNBR)
      logical nbrusd(MAXNBR)

c probe placement arrays:
      real heights(MAXPRB), probes(3,MAXPRB), alts(3,MAXPRB)
      integer pi1(MAXPRB), pi2(MAXPRB), pi3(MAXPRB)
      integer lowprbs(MAXLOW),nears(MAXLOW)

c subdivision arrays:
      real subs(3,MAXSUB),pnts(3,MAXSUB)
      real lats(3,MAXSUB)

c accessibility array:
      logical access(MAXATM)

      integer is(3)
      real uij(3),tij(3),uik(3),tik(3),uijk(3)
      real utb(3),bijk(3),pijk(3),pij(3)
      real pi(3),pj(3),axis(3), qij(3),qji(3)
      real north(3)
      real pqi(3),pqj(3),o(3),south(3)
      real eqvec(3),cen(3),pcen(3),vp(3,3),vector(3,3)
      real vtemp(3),vql(3)
      logical pcusp, between

c common block arrays:
      integer nsp(3),nspt !by AWSS
      real burco(3,MAXNBR),burrad(MAXNBR),pprev(3)
      logical bprev
      common /geral2/ nspt
      common /mdsblk/nsp,pradius,nbur,burco,burrad,pprev,bprev
c      common /geral/ natom,nspt      
c check for atom overflow
      if (natom .gt. MAXATM) stop 'mds: too many atoms'

c initialization

      pradius = rp

      do 25 k = 1,3
        nsp(k) = 0
25    continue

      nprobe = 0

      do 50 i = 1,natom
        access(i) = .false.
50    continue

      do 60 k = 1,3
        pprev(k) = 1000000.0
        o(k) = 0.0
60    continue
      radmax = 0.0
      do 70 i = 1,natom
        if (radii(i) .gt. radmax) radmax = radii(i)
70    continue

      bb = 4 * radmax + 4 * rp
      bb2 = bb * bb

c open output file
C      open (unit=7,file='dots',status='unknown',
C     :form='unformatted',err=9020)
!by debg 25Jul2008      open (unit=7,file='dots',err=9020) !by AWSS
!by debg 25Jul2008      write(7,*) !by AWSS
!by debg 25Jul2008      rewind(7) !by AWSS
c main loop:

      do 1000 i1 = 1, natom
        if (atten(i1) .le. 0) go to 1000
        ri = radii(i1)
        eri = ri + rp
        density = atmden(i1)
        nnbr = 0
        nbur = 0
        nbb = 0

      do 100 i2 = 1,natom
        if (i1 .eq. i2) go to 100
        if (atten(i2) .le. 0) go to 100

        if (mol(i2) .eq. mol(i1)) then
          d2 = dis2(atoms(1,i1),atoms(1,i2))
          if (d2 .le. 0.0) go to 9040
          bridge = ri + radii(i2) + 2 * rp
          if (d2 .ge. bridge * bridge) go to 100
          nnbr = nnbr + 1
          if (nnbr .gt. MAXNBR) go to 9060
          nbr(nnbr) = i2
        else
          if (atten(i1) .lt. 5) go to 100
          d2 = dis2(atoms(1,i1),atoms(1,i2))
          if (d2 .lt. bb2) nbb = nbb + 1
          bridge = ri + radii(i2) + 2 * rp
          if (d2 .ge. bridge * bridge) go to 100
          nbur = nbur + 1
          if (nbur .gt. MAXNBR) go to 9060
          do 90 k = 1,3
            burco (k, nbur) = atoms(k,i2)
90        continue
          burrad(nbur) = radii(i2)
        end if

100   continue

      if (atten(i1) .eq. 6 .and. nbb .le. 0) go to 1000
      if (nnbr .le. 0) then
        access(i1) = .true.
        go to 620
      end if

c sort neighbors by distance from atom i1
      do 110 n = 1,nnbr
        i2 = nbr(n)
        disnbr(n) = dis2(atoms(1,i1),atoms(1,i2))
        nbrusd(n) = .false.
110   continue

      do 120 n = 1,nnbr
        l = 0
        dmin = 1000000.0
        do 115 m = 1,nnbr
          if (nbrusd(m)) go to 115
          if (disnbr(m) .lt. dmin) then
            dmin = disnbr(m)
            l = m
          end if
115     continue
        if (l .le. 0) stop 'insertion sort fails'
        nbrstd(n) = nbr(l)
        nbrusd(l) = .true.
120   continue

c second loop:

      do 600 jnbr = 1,nnbr
        i2 = nbr(jnbr)
        if (i2 .le. i1) go to 600
        rj = radii(i2)
        erj = rj + rp
        density = (atmden(i1) + atmden(i2))/2
        dij = dis(atoms(1,i1),atoms(1,i2))
        do 140 k = 1,3
          uij(k) = (atoms(k,i2) - atoms(k,i1))/dij
140     continue
        asymm = (eri * eri - erj * erj) / dij
        between = (abs(asymm) .lt. dij)
        do 160 k = 1,3
          tij(k) = 0.5 * (atoms(k,i1) + atoms(k,i2)) + 
     &    0.5 * asymm * uij(k) ! dgomes Mon Nov 23 19:39:53 BRST 2015
160     continue
        far = (eri + erj) * (eri + erj) - dij * dij
        if (far .le. 0.0) go to 600
        far = sqrt (far)
        contain = dij * dij - (ri - rj) * (ri - rj)
        if (contain .le. 0.0) go to 600
        contain = sqrt (contain)
        rij = 0.5 * far * contain / dij

        if (nnbr .le. 1) then
          access(i1) = .true.
          access(i2) = .true.
          go to 320
        end if

c third loop:

      do 300 knbr = 1,nnbr
        i3 = nbr(knbr)
        if (i3 .le. i2) go to 300
        rk = radii (i3)
        erk = rk + rp
        djk = dis(atoms(1,i2),atoms(1,i3))
        if (djk .ge. erj + erk) go to 300
        dik = dis(atoms(1,i1), atoms(1,i3))
        if (dik .ge. eri + erk) go to 300
        if (atten(i1) .le. 1 .and. atten(i2) .le. 1 .and.
     &  atten(i3) .le. 1) go to 300

      do 220 k = 1,3
        uik(k) = (atoms(k,i3) - atoms(k,i1)) / dik
220   continue

      dt = dot(uij, uik)
      if (dt .ge. 1.0) go to 255
      if (dt .le. -1.0) go to 255
      wijk = acos(dt)
      if (wijk .le. 0.0) go to 255
      swijk = sin(wijk)
      if (swijk .le. 0.0) go to 255
      call cross (uij,uik,uijk)
      do 230 k = 1,3
        uijk(k) = uijk(k) / swijk
230   continue
      call cross (uijk,uij,utb)
      asymm = (eri * eri - erk * erk) / dik
      do 235 k = 1,3
      tik(k) = 0.5 * (atoms(k,i1) + atoms(k,i3)) + 0.5 * asymm * uik(k)
235   continue
      dt = 0.0
      do 240 k = 1,3
      dt = dt + uik(k) * (tik(k) - tij(k))
240   continue
      do 250 k = 1,3
      bijk(k) = tij(k) + utb(k) * dt / swijk
250   continue
      hijk = eri * eri - dis2 (bijk, atoms (1,i1))
      if (hijk .gt. 0.0) go to 257
c collinear and other
255   continue
      dtijk2 = dis2(tij,atoms(1,i3))
      rkp2 = erk * erk - rij * rij
      if (dtijk2 .lt. rkp2) go to 600
      go to 300
257   continue
      hijk = sqrt(hijk)
      do 280 is0 = 1,2
      isign = 3 - 2 * is0
      do 260 k = 1,3
      pijk(k) = bijk(k) + isign * hijk * uijk(k)
260   continue
c     check for collision
      do 270 lnbr = 1,nnbr
      i4 = nbrstd(lnbr)
      erl = radii(i4) + rp
      if (i4 .eq. i2) go to 270
      if (i4 .eq. i3) go to 270
      if (dis2(pijk,atoms(1,i4)) .le. erl * erl) go to 280
270   continue
c new probe position
      nprobe = nprobe + 1
      if (nprobe .gt. MAXPRB) go to 9100
      if (isign .gt. 0) then
      pi1(nprobe) = i1
      pi2(nprobe) = i2
      pi3(nprobe) = i3
      else
      pi1(nprobe) = i2
      pi2(nprobe) = i1
      pi3(nprobe) = i3
      end if
      heights(nprobe) = hijk
      do 275 k = 1,3
      probes(k, nprobe) = pijk(k)
      alts(k,nprobe) = isign * uijk(k)
275   continue
      access(i1) = .true.
      access(i2) = .true.
      access(i3) = .true.
280   continue
300   continue

320   continue

c return to second loop

c toroidal surface generation

      if (atten(i1) .le. 1 .and. atten(i2) .le. 1) go to 600
      if (rp .le. 0.0) go to 600

      density = (atmden(i1) + atmden(i2))/2
      rci = rij * ri / eri
      rcj = rij * rj / erj
      rb = rij - rp
      if (rb .le. 0.0) rb = 0.0
      rs = (rci + 2 * rb + rcj) / 4
      e = rs/rij
      edens = e * e * density

      call subcir (tij, rij, uij, edens, MAXSUB, subs, nsub, ts)
      if (nsub .le. 0) go to 600

      do 400 isub = 1, nsub
      do 325 k = 1,3
      pij(k) = subs(k, isub)
325   continue

c     check for collision
      do 330 lnbr = 1, nnbr
      i4 = nbrstd (lnbr)
      if (i4 .eq. i2) go to 330
      erl = radii(i4) + rp
      if (dis2 (pij, atoms(1,i4)) .le. erl * erl) go to 400
330   continue

c no collision, toroidal arc generation
      access(i1) = .true.
      access(i2) = .true.
      if (atten(i1) .eq. 6 .and. atten(i2) .eq. 6 .and. nbur .le. 0)
     :go to 400
      do 340 k = 1, 3
      pi(k) = (atoms(k, i1) - pij(k)) / eri
      pj(k) = (atoms(k, i2) - pij(k)) / erj
340   continue
      call cross (pi, pj, axis)
      call normal (axis)
      dtq = rp * rp - rij * rij
      pcusp = (dtq .gt. 0.0 .and. between)
      if (pcusp) then
c point cusp -- two shortened arcs
      dtq = sqrt (dtq)
      do 350 k = 1, 3
      qij(k) = tij(k) - dtq * uij(k)
      qji(k) = tij(k) + dtq * uij(k)
350   continue
      do 360 k = 1, 3
      pqi(k) = (qij(k) - pij(k))/rp
      pqj(k) = (qji(k) - pij(k))/rp
360   continue
      else
c no cusp
      do 370 k = 1, 3
      pqi(k) = pi(k) + pj(k)
370   continue
      call normal (pqi)
      do 375 k = 1, 3
      pqj(k) = pqi(k)
375   continue
      end if
      dt = dot (pi, pqi)
      if (dt .ge. 1.0) go to 400
      if (dt .le. -1.0) go to 400
      anglei = acos (dt)
      dt = dot (pqj, pj)
      if (dt .ge. 1.0) go to 400
      if (dt .le. -1.0) go to 400
      anglej = acos (dt)

c convert two arcs to points

      if (atten(i1) .ge. 2) then
      call subarc (pij, rp, axis, density, pi, pqi, MAXSUB, pnts, npnt,
     * ps)
      do 380 ipnt = 1, npnt
      area = ps * ts * disptl (tij, uij, pnts (1, ipnt)) / rij
!by debg 25Jul2008      call putpnt (2, i1,mol(i1), atten (i1), pnts (1, ipnt), area, pij,
!by debg 25Jul2008     * atoms (1, i1)) !by AWSS
      call putpnt (2, i1,mol(i1), atten (i1), pnts (1, ipnt), area, pij,
     * atoms (1, i1),natom,atmarea) !by debg 25Jul2008
380   continue
      end if

      if (atten(i2) .ge. 2) then
      call subarc (pij, rp, axis, density, pqj, pj, MAXSUB, pnts, npnt,
     * ps)
      do 390 ipnt = 1, npnt
      area = ps * ts * disptl (tij, uij, pnts (1, ipnt)) / rij
!by debg 25Jul2008      call putpnt (2, i2,mol(i2), atten (i2), pnts (1, ipnt) ,area, pij,
!by debg 25Jul2008     *atoms(1,i2)) !by AWSS
      call putpnt (2, i2,mol(i2), atten (i2), pnts (1, ipnt) ,area, pij,
     *atoms(1,i2),natom,atmarea) !by debg 25Jul2008
390   continue
      end if

400   continue
600   continue

c return to first loop
620   continue

      if (.not. access(i1)) go to 1000
      if (atten(i1) .le. 1) go to 1000
      if (atten(i1) .eq. 6 .and. nbur .le. 0) go to 1000
      density = atmden (i1)

c convex surface generation

      if (nnbr .le. 0) then
      north (1) = 0.0
      north(2) = 0.0
      north(3) = 1.0
      south(1) = 0.0
      south(2) = 0.0
      south(3) = -1.0
      eqvec(1) = 1.0
      eqvec(2) = 0.0
      eqvec(3) = 0.0

      else

      i2 = nbrstd(1)
      do 630 k = 1,3
      north(k) = atoms(k, i1) - atoms(k, i2)
630   continue
      call normal(north)
      vtemp(1) = north(2) * north(2) + north(3) * north(3)
      vtemp(2) = north(1) * north(1) + north(3) * north(3)
      vtemp(3) = north(1) * north(1) + north(2) * north(2)
      call normal(vtemp)
      dt = dot (vtemp, north)
      if (abs(dt) .gt. 0.99) then
      vtemp(1) = 1.0
      vtemp(2) = 0.0
      vtemp(3) = 0.0
      end if
      call cross (north, vtemp, eqvec)
      call normal (eqvec)
      call cross (eqvec, north, vql)
      rj = radii (i2)
      erj = rj + rp
      dij = dis (atoms(1, i1), atoms (1, i2))
      do 635 k = 1,3
      uij(k) = (atoms(k, i2) - atoms (k, i1)) / dij
635   continue
      asymm = (eri * eri - erj * erj) / dij
      do 640 k = 1, 3
      tij(k) = 0.5 * (atoms (k, i1) + atoms (k, i2)) + 
     *0.5 * asymm * uij (k)
640   continue
      far = (eri + erj) * (eri + erj) - dij * dij
      if (far .le. 0.0) stop 'imaginary far'
      far = sqrt (far)
      contain = dij * dij - (ri - rj) * (ri - rj)
      if (contain .le. 0.0) stop 'imaginary contain'
      contain = sqrt (contain)
      rij = 0.5 * far * contain / dij
      do 645 k = 1,3
      pij(k) = tij(k) + rij * vql(k)
      south(k) = (pij(k) - atoms(k, i1)) / eri
645   continue
      if (triple(north, south, eqvec) .le. 0.0) 
     *stop 'non-positive frame'
      end if

      call subarc (o, ri, eqvec, density, north, south, MAXSUB, 
     *lats, nlat, cs)

c debugging print statement:
C      write (6, 656) i1, nlat, nnbr, nbur, nbb !by AWSS
c656   format (1x, 'i1, nlat, nnbr, nbur, nbb:', 5i6)

      if (nlat .le. 0) go to 1000

      do 800 ilat = 1, nlat
c project onto north vector
      dt = dot (lats (1, ilat), north)
      do 660 k = 1, 3
      cen(k) = atoms(k, i1) + dt * north(k)
660   continue
      rad = ri * ri - dt * dt
      if (rad .le. 0.0) go to 800
      rad = sqrt (rad)
      call subcir (cen, rad, north, density, MAXSUB, pnts, npnt, ps)
      if (npnt .le. 0) go to 800
      area = cs * ps
      do 750 ipnt = 1, npnt
      do 680 k = 1, 3
      pcen(k) = atoms(k, i1) + (eri/ri) * (pnts(k,ipnt) - atoms(k,i1))
680   continue

c     check for collision
      do 690 lnbr = 2, nnbr
      i4 = nbrstd (lnbr)
      erl = radii (i4) + rp
      if (dis2 (pcen, atoms(1, i4)) .le. erl * erl) go to 750
690   continue

c no collision, put point
!by debg 25Jul2008      call putpnt (1, i1,mol(i1), atten(i1), pnts(1,ipnt), area, pcen,
!by debg 25Jul2008     *atoms(1,i1)) !by AWSS
      call putpnt (1, i1,mol(i1), atten(i1), pnts(1,ipnt), area, pcen,
     *atoms(1,i1),natom,atmarea) !by debg 25Jul2008

750   continue
800   continue
1000  continue

c end of first loop

!by debg 25Jul2008      write (16, 1010) nprobe
1010  format (1x, 'nprobe = ', i8)

      if (rp .le. 0.0) go to 1600

c concave surface generation

c collect low probes
      nlow = 0
      do 1050 iprb = 1, nprobe
        if (heights(iprb) .ge. rp) go to 1050
          nlow = nlow + 1
        if (nlow .gt. MAXLOW) stop 'low probe overflow'
          lowprbs (nlow)  = iprb
1050  continue
!by debg 25Jul2008      write (16, 1060) nlow
1060  format (1x, 'number of low probes = ', i4)

c probe loop:

      do 1500 iprb = 1, nprobe
        is(1) = pi1 (iprb)
        is(2) = pi2 (iprb)
        is(3) = pi3 (iprb)
      do 1120 k = 1, 3
        pijk(k) = probes (k, iprb)
        uijk(k) = alts (k, iprb)
1120  continue

      hijk = heights (iprb)

      i1 = is(1)
      i2 = is(2)
      i3 = is(3)
      if (atten(i1) .eq. 6 .and. atten(i2) .eq. 6 .and.
     :atten(i3) .eq. 6 .and. nbur .le. 0) go to 1500
      density = (atmden(i1) + atmden(i2) + atmden(i3)) / 3

c gather nearby low probes
      nnear = 0
      if (nlow .le. 0) go to 1135
      do 1130 l = 1, nlow
        iprb2 = lowprbs(l)
        if (iprb2 .eq. iprb) go to 1130
        d2 = dis2 (pijk, probes (1, iprb2))
        if (d2 .ge. 4 * rp * rp) go to 1130
        nnear = nnear + 1
        if (nnear .gt. MAXLOW) stop 'near low overflow'
        nears (nnear) = iprb2
1130  continue
1135  continue

c set up vectors from probe center to three atoms

      do 1160 m = 1, 3
        i = is (m)
        do 1140 k = 1,3
          vp(k,m) = atoms(k, i) - pijk(k)
1140    continue
        call normal (vp(1,m))
1160  continue

c set up vectors normal to three cutting planes
      call cross (vp(1,1), vp(1,2), vector (1,1))
      call cross (vp (1,2), vp (1,3), vector (1,2))
      call cross (vp(1,3), vp (1,1), vector (1,3))
      call normal (vector(1,1))
      call normal (vector(1,2))
      call normal (vector(1,3))

c find latitude of highest vertex of triangle

      dm = -1.0
      mm = 0
      do 1180 m = 1, 3
        dt = dot (uijk, vp (1,m))
        if (dt .gt. dm) then
          dm = dt
          mm = m
        end if
1180  continue

c create arc for selecting latitudes

      do 1200 k = 1,3
        south(k) = - uijk(k)
1200  continue
      call cross (vp (1, mm), south, axis)
      call normal (axis)
      call subarc (o, rp, axis, density, vp (1,mm), south, MAXSUB,
     * lats, nlat, cs)
      if (nlat .le. 0) go to 1500

c probe latitude loop:

      do 1400 ilat = 1, nlat
        dt = dot (lats(1,ilat),south)
        do 1250 k = 1,3
          cen(k) = dt * south(k)
1250    continue
        rad = rp * rp - dt * dt
        if (rad .le. 0.0) go to 1400
        rad = sqrt (rad)
        call subcir (cen, rad, south, density, MAXSUB, pnts, npnt, ps)
        if (npnt .le. 0) go to 1400
        area = cs * ps
        do 1350 ipnt = 1, npnt
c check against 3 planes
          do 1270 m = 1,3
            dt = dot (pnts (1, ipnt), vector (1,m))
            if (dt .ge. 0.0) go to 1350
1270      continue
        do 1280 k = 1,3
          pnts(k, ipnt) = pijk(k) + pnts(k, ipnt)
1280    continue

c if low probe, check for inside nearby low probe
        if (hijk .ge. rp) go to 1320
        if (nnear .le. 0) go to 1320


        do 1300 n = 1, nnear
          iprb2 = nears(n)
          d2 = dis2 (pnts (1, ipnt), probes (1, iprb2))
          if (d2 .lt. rp * rp) go to 1350
1300    continue
1320    continue

c determine which atom the surface point is closest to
      mc = 0
      dmin = 2 * rp
      do 1330 m = 1,3
        i = is(m)
        d = dis (pnts(1,ipnt), atoms (1,i)) - radii(i)
        if (d .lt. dmin) then
          dmin = d
          mc = m
        end if
1330  continue
      i = is (mc)

!by debg 25Jul2008      call putpnt (3, i,mol(i), atten(i), pnts (1, ipnt), area, pijk,
!by debg 25Jul2008     * atoms (1, i)) !by AWSS
      call putpnt (3, i,mol(i), atten(i), pnts (1, ipnt), area, pijk,
     * atoms (1, i),natom,atmarea) !by debg 25Jul2008

1350  continue
1400  continue
1500  continue

c end of probe loop

c branch for van der Waals surface:
1600  continue

c finished writing surface points

!by debg 25Jul2008      close (7)
      nspt=nsp(1)+nsp(2)+nsp(3) !by AWSS
!by debg 25Jul2008      write (16, 2050) nsp(1), nsp(2), nsp(3),nspt
2050      format (1x, 'number of surface points = ', 4i8)

      return


c error branches:

9020  write (6,9025)
9025  format (1x, 'mds: cannot open output file')
      stop
9040  write (6,9045)
9045  format (1x, 'mds: coincident atoms')
      stop
9060  write (6, 9065)
9065  format (1x, 'mds: neighbor overflow')
      stop
9100  write (6, 9105)
9105  format (1x, 'mds: probe overflow')
      stop

      end


*****************************************************
c subroutines

c put point to disk:

!      subroutine putpnt (itype, i, moln, atten, coor, area, pcen, acen) !by AWSS
      subroutine putpnt 
     &(itype, i, moln, atten, coor, area, pcen, acen, natom, atmarea) !by debg 25Jul2008
      real atmarea(natom) !by debg 25Jul2008


      integer itype, i, atten, moln !by AWSS
      real area
      real coor(3), pcen(3), acen(3)
  
      integer k, ibur, lbur, nbur
      real erl, pradius

      real outnml(3)
c MAXNBR should have the same value here and in the mds subroutine
      integer MAXNBR
      parameter (MAXNBR=20000) ! FIXED Mon Feb 22 18:58:44 BRT 2010 (devia ter changed from 10000 for big structures ! by debg 29Jul2009)

      integer nsp(3)
      real burco(3,MAXNBR),burrad(MAXNBR),pprev(3)
      logical bprev

      common /mdsblk/nsp, pradius, nbur, burco, burrad, pprev, bprev

      logical buried
      integer*2 i2, itype2, iflag,moll !by AWSS
  
      real dot
      real triple
      real dis2
      real dis
      real disptl

      buried = .false.
      i2 = i
      moll = moln !by AWSS
      itype2 = itype

      go to (100, 200, 300, 400, 400, 400) atten
      stop 'mds: invalid atom attention number in putpnt'

100   continue
      return

200   continue
c      write (7) i2, itype2, coor
      write (7,250) i2, moll, itype2, coor !by AWSS
250   format (1x,i5,i2,i2,3f15.8) !by AWSS
      go to 900

300   continue
c      write (7) i2, itype2, coor, area
      write (7,350) i2, moll, itype2, coor, area !by AWSS
350   format (1x, i5, i2, i2, 4f15.8) !by AWSS
      go to 900

400   continue

c calculate outward pointing unit normal vector
      if (pradius .le. 0.0) then
      do 410 k = 1, 3
      outnml(k) = coor(k) - acen(k)
410   continue
      call normal(outnml)
      else
      do 420 k = 1,3
      outnml(k) = (pcen(k) - coor(k))/pradius
420   continue
      end if

      if (atten .ge. 5) go to 500
c      write (7) i2, itype2, coor, area, outnml
      write (7,450) i2, moll, itype2, coor, area, outnml !by AWSS
450   format (1x, i5, i2, i2, 7f15.8) !by AWSS
      go to 900

500   continue

c determine whether buried
c first check whether probe changed
      if (dis2 (pcen, pprev) .le. 0.0) then
      buried = bprev
      else
c check for collisions with neighbors in other molecules
      do 530 lbur = 1, nbur
      erl = burrad (lbur) + pradius
      if (dis2 (pcen, burco (1, lbur)) .le. erl * erl) then
      buried = .true.
      go to 540
      end if
530   continue
540   continue
      do 545 k = 1, 3
      pprev(k) = pcen(k)
545   continue
      end if

      bprev = buried
      if (atten .eq. 6) go to 600
      if (buried) then
      iflag = 1
      else
      iflag = 0
      end if

c      write (7) i2, itype2, coor, area, outnml, iflag
      write (7,550) i2, moln, itype2, coor, area, outnml, iflag !by AWSS
550   format (1x, i5, i2, i2, 7f15.8, i3) !by AWSS

      go to 900

600   continue
      if (.not. buried) return
c      write (7) i2, itype2, coor, area, outnml
!by debg aqui ele escreve o dots
!by debg i2=numero do atomo
!by debg moln=numero da molecula (1 ou 2)
!by debg itype2= ainda nao sei
!by debg coor= xyz do ponto
!by debg area= area :) 
!by debg outnml = ainda nao sei
!by debg
!      write (7,550) i2, moln, itype2, coor, area, outnml !by AWSS 
!      write (7,*) i2,area !by debg 28jun2008
      atmarea(i2)=atmarea(i2)+area !by debg 25Jul2008

900   continue
      nsp(itype) = nsp(itype) + 1
      return
      end

********************************************
c elementary mathematical subroutines:

      real function dot (c, d)
      real c(3), d(3)
      real s
      integer k

      s = 0.0
      do 100 k = 1, 3
      s = s + c(k) * d(k)
100   continue
      dot = s
      return
      end


      subroutine cross (c, d, e)
      real c(3), d(3), e(3)

      e(1) = c(2) * d(3) - c(3) * d(2)
      e(2) = c(3) * d(1) - c(1) * d(3)
      e(3) = c(1) * d(2) - c(2) * d(1)
      return
      end

      real function triple (c, d, e)
      real c(3), d(3), e(3)
      real cd(3)
      real dot

      call cross (c, d, cd)
      triple = dot (cd, e)

      return
      end

      real function dis2 (c, d)
      real c(3), d(3)
      integer k
      real s, cd

      s = 0.0
      do 100 k = 1, 3
      cd = c(k) - d(k)
      s = s + cd * cd
100   continue
      dis2 = s
      return
      end

      real function dis (c, d)
      real c(3), d(3)
      real s
      real dis2
      real sqrt

      s = dis2 (c, d)
      if (s .lt. 0.0) s = 0.0
      dis = sqrt (s)
      return
      end

      subroutine normal (x)
      real x(3)
      integer k
      real s

      s = 0.0
      do 100 k = 1, 3
      s = s + x(k) * x(k)
100   continue
      if (s .le. 0.0) stop 'zero vec in normal'
      s = sqrt (s)
      do 200 k = 1, 3
      x(k) = x(k) / s
200   continue
      return
      end

c distance from point to line:

      real function disptl (cen, axis, pnt)
      real cen(3), axis(3), pnt(3)

      real vec(3)
      integer k
      real dt, d2
  
      real dot
      real sqrt

      do 100 k = 1, 3
      vec(k) = pnt(k) - cen(k)
100   continue

      dt = dot (vec, axis)

      d2 = vec(1) * vec(1) + vec(2) * vec(2) + vec(3) * vec(3) - 
     *dt * dt
      if (d2 .le. 0.0) d2 = 0.0
      disptl = sqrt (d2)

      return
      end

c subdivision routines:

      subroutine subdiv (cen, rad, x, y, angle, density, maxsub, pnts,
     * npnt, ps)

      integer maxsub, npnt
      real rad, angle, density, ps
      real cen(3)
      real x(3), y(3)
      real pnts (3, maxsub)

      real a, c, s, delta
      integer n, k, i
      real sqrt

      delta = 1.0 / (sqrt(density) * rad)

      a = - delta / 2
      n = 0
      do 100 i = 1, maxsub
      a = a + delta
      if (a .gt. angle) go to 150
      n = n + 1
      c = rad * cos (a)
      s = rad * sin (a)
      do 50 k = 1, 3
      pnts(k, i) = cen(k) + c * x(k) + s * y(k)
50    continue
100   continue
      if (a + delta .lt. angle) stop 'too many subdivisions'
150   continue
      npnt = n
      if (npnt .gt. 0) then
      ps = rad * angle / npnt
      else
      ps = 0.0
      end if
      return
      end

      subroutine subarc (cen, rad, axis, density, x, v, maxsub, pnts,
     * npnt, ps)

      integer maxsub, npnt
      real rad, density, ps
      real cen(3), axis(3), x(3), v(3)
      real pnts (3, maxsub)
      real y(3)
      real angle
      real dt1, dt2
  
      real dot
      real atan2

  
      call cross (axis, x, y)

      dt1 = dot (v, x)
      dt2 = dot (v, y)
      angle = atan2 (dt2, dt1)
      if (angle .lt. 0.0) angle = angle + 2 * 3.1415926535

      call subdiv (cen, rad, x, y, angle, density, maxsub, pnts, npnt,
     * ps)

      return
      end


      subroutine subcir (cen, rad, axis, density, maxsub, pnts, npnt,
     * ps)

      integer maxsub, npnt
      real rad, density, ps
      real cen(3), axis(3)
      real pnts(3, maxsub)
      real v1(3), v2(3), x(3), y(3)
      real angle, dt

      real dot

c arbitrary unit vector perpendicular to axis
      v1(1) = axis(2) * axis(2) + axis(3) * axis(3)
      v1(2) = axis(1) * axis(1) + axis(3) * axis(3)
      v1(3) = axis(1) * axis(1) + axis(2) * axis(2)
      call normal (v1)
      dt = dot(v1,axis)
      if (abs (dt) .gt. 0.99) then
      v1(1) = 1.0
      v1(2) = 0.0
      v1(3) = 0.0
      end if
      call cross (axis, v1, v2)
      call normal (v2)
      call cross (axis, v2, x)
      call normal (x)
      call cross (axis, x, y)

      angle = 2.0 * 3.1415926535

      call subdiv (cen, rad, x, y, angle, density, maxsub, pnts, npnt,
     * ps)

      return
      end

c
c Copyright 1986 by Michael L. Connollyc All rights reserved

c-----------------------------------------------------
