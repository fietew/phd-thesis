#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Incorrect number of arguments ($# provided, 1 expected)"
    exit 1
fi

# find gnuplot files and run them
find $1 -iname "fig*.gnu" -type f | sort -n | while read -r gnufile ; do
    # 
    directory=`dirname $gnufile`
    gnufilelocal=`basename $gnufile`
    printf "Found $gnufile, Executing ..."
    
    ( cd $directory ; gnuplot $gnufilelocal &> /dev/null; printf ", gnuplot exit code: $?\n" )
done

