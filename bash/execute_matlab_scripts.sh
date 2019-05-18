#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Incorrect number of arguments ($# provided, 1 expected)"
    exit 1
fi

# find MATLAB files and run them
find $1 -iname "fig*.m" -type f | sort -n | while read -r mfile ; do
    # 
    directory=`dirname $mfile`
    mfilelocal=`basename $mfile`
    printf "Found $mfile, Executing ..."

    matlab -nodisplay -nosplash -nodesktop -r \
      "cd $directory; try, run('$mfilelocal'), catch, exit(1), end, exit(0);" \
      > /dev/null
    printf " , Matlab exit code: $?\n"
done
