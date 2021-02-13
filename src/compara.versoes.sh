first=/home/dgomes/bk_2010_10reau/dgomes/surfinmd.v1.05/src/
#second=/DATA1/nwfs/msrc/Desktop/v1.05/src/
second=/DATA1/nwfs/brazos/2008/mysoftware/v1.04/src/


echo "***** botacadeia.f *****"
diff $first/botacadeia.f $second/botacadeia.f

echo "***** checkparam.f *****"
diff $first/checkparam.f $second/checkparam.f

echo "***** default.f *****"
diff $first/default.f $second/default.f

echo "***** getarea.f *****"
diff $first/getarea.f $second/getarea.f

echo "***** getatype.f *****"
diff $first/getatype.f $second/getatype.f

echo "***** help.f *****"
diff $first/help.f $second/help.f

echo "***** lmdm.mds.f *****"
diff $first/lmdm.mds.f $second/lmdm.mds.f

echo "***** parameters.f *****"
diff $first/parameters.f $second/parameters.f

echo "***** putchain.f *****"
diff $first/putchain.f $second/putchain.f

echo "***** readparam.f *****"
diff $first/readparam.f $second/readparam.f

echo "***** readref.f *****"
diff $first/readref.f $second/readref.f

echo "***** readtraj.f *****"
diff $first/readtraj.f $second/readtraj.f

echo "***** setradii.f *****"
diff $first/setradii.f $second/setradii.f

echo "***** surfinmd.f *****"
diff $first/surfinmd.f $second/surfinmd.f

echo "***** titulo.f *****"
diff $first/titulo.f $second/titulo.f
