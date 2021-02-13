#Average stuff, output single vector
#awk '{for (i=2;i<=NF;i++){a[i]+=$i;}} END {for (i=2;i<=NF;i++){printf "%.0f", a[i]/NR; printf "\t"};printf "\n"}' rsurf.csv

# When running parallel, after merging .csv files you may run the statistics like that

awk '{for(i=2;i<=NF;i++) {
   sum[i] += $i; sumsq[i] += ($i)^2}
   }
   END {
         for (i=2;i<=NF;i++) {
            print i-1, sum[i]/NR, sqrt((sumsq[i]-sum[i]^2/NR)/NR)
         }
       }' rsurf.csv > rsurf_from_csv.dat 
