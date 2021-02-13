# Example to run parallel surfimd
# Parallel surfinmd
surfpath=/home/dgomes/software/surfinmd.v1.06p2_06Jun2016/bin/

for ((init=5000;init<=20000;init=init+1000)) ; do
  let end=${init}+999
  ${surfpath}/surfinmd.dcd -r refc.pdb -dcd /run/shm/complex.dcd -b ${init}  -e ${end} -o surf_${init}_${end}.dat -or rsurf_${init}_${end}.dat -csv rsurf_${init}_${end}.csv &> surf_${init}_${end}.job&
done

# Put all together with grep,awk, cat you choose.
