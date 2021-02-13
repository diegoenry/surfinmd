# Filter 
echo -n "Surface area cut off: "
read cut
awk -v cut=$cut '$3 > $cut {print $1"_"$2,$3,$4}' rsurf.dat 
