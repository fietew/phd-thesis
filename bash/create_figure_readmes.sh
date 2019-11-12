#!/bin/bash

#*****************************************************************************
# Copyright (c) 2019      Fiete Winter                                       *
#                         Institut fuer Nachrichtentechnik                   *
#                         Universitaet Rostock                               *
#                         Richard-Wagner-Strasse 31, 18119 Rostock, Germany  *
#                                                                            *
# This file is part of the supplementary material for Fiete Winter's         *
# PhD thesis                                                                 *
#                                                                            *
# You can redistribute the material and/or modify it  under the terms of the *
# GNU  General  Public  License as published by the Free Software Foundation *
# , either version 3 of the License,  or (at your option) any later version. *
#                                                                            *
# This Material is distributed in the hope that it will be useful, but       *
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY *
# or FITNESS FOR A PARTICULAR PURPOSE.                                       *
# See the GNU General Public License for more details.                       *
#                                                                            *
# You should  have received a copy of the GNU General Public License along   *
# with this program. If not, see <http://www.gnu.org/licenses/>.             *
#                                                                            *
# http://github.com/fietew/phd-thesis                 fiete.winter@gmail.com *
#*****************************************************************************

if [ $# -ne 1 ]; then
    echo "Incorrect number of arguments ($# provided, 1 expected)"
    exit 1
fi

# find figure directories
find $1 -iname "fig*" -type d | sort -n | while read -r directory ; do
    # 
    echo "Processing $directory"

    printf "" > $directory/README.md

    # Convert pdf to png
    find $directory -iname "fig*.pdf" -type f | sort -n | while read -r pdffile ; do
        pngfile=${pdffile%.pdf}.png
        pngfilelocal=`basename $pngfile`
        pdffilelocal=`basename $pdffile`        
        echo "Converting $pdffilelocal to $pngfilelocal and creating README.md"
        convert -density 300 "$pdffile" -resize "800x800" -quality 100 "$pngfile"
        printf "![Fig]($pngfilelocal)\n" >> $directory/README.md
    done

    # MATLAB files
    find $directory -iname "fig*.m" -type f | sort -n | while read -r mfile ; do
        mfilelocal=`basename $mfile`
        echo "Found $mfile, adding to README.md"
        firstline=`head -1 $mfile`
        firstline=${firstline#"% "}
        printf "\n$firstline\n" >> $directory/README.md
        printf "\nMatlab:\n\`\`\`Matlab\n>> ${mfilelocal%.m}\n\`\`\`\n" >> $directory/README.md
    done
    
    # standalone LaTeX files
    find $directory -iname "fig*.tex" -type f | sort -n | while read -r texfile ; do
        texfilelocal=`basename $texfile`
        echo "Found $texfile, adding to README.md"
        firstline=`head -1 $texfile`
        firstline=${firstline#"% "}
        printf "\n$firstline\n" >> $directory/README.md
        if grep -q '\documentclass' $texfile
        then 
           printf "\nBash:\n\`\`\`Bash\n$ pdflatex $texfilelocal\n\`\`\`\n" >> $directory/README.md
        else
           printf '\nThis is an embedded LaTeX file. Please include it into your own document together with\n' >> $directory/README.md
           printf '```LaTeX\n' >> $directory/README.md
           printf '\\usepackage{soundfield}\n' >> $directory/README.md
           printf '\\usepackage{algpseudocode}\n' >> $directory/README.md
           printf '\\algnewcommand\\Continue{\\textbf{continue}}\n' >> $directory/README.md
           printf '```\n' >> $directory/README.md
        fi
    done

    # Gnuplot files
    find $directory -iname "fig*.gnu" -type f | sort -n | while read -r gnufile ; do
        echo "Found $gnufile, adding to README.md"
        gnufilelocal=`basename $gnufile`
        printf "\nBash:\n\`\`\`Bash\n$ gnuplot $gnufilelocal\n\`\`\`\n" >> $directory/README.md
    done
done

