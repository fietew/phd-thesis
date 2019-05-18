#!/usr/bin/gnuplot

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

reset
set macros
set loadpath '../../gnuplot/'

load 'xyborder.cfg'
load 'standalone.cfg'

################################################################################
set t epslatex size @dissmarginwidth,4cm color colortext standalone header diss10pt.footnotesize
set output 'fig.tex'

unset key # deactivate legend

load 'qualitative/Set1.plt'
# x-axis
set xrange [0:pi]
set xtics (0, '$\frac{\pi}{2}$' pi/2.0, '$\pi$' pi) offset 0,0.5
set xlabel '$\alpha$ / rad ' offset 0,0.85
# y-axis
set yrange [-80:0]
set ytics 40 offset 0.75,0
set ylabel '$20 \lg |\sfwindow^M(\alpha)|$' offset 2.55,0
# margins
set bmargin 2.25
set tmargin 0.5
set lmargin 4.5
set rmargin 0.75
# grid
load 'grid.cfg'
# labels
set label 1 'rectangular' at graph 1.0,0.925 right tc ls 1
set label 2 'max-$\mathbf r_E$' at graph 1.0,0.8 right tc ls 2

################################################################################

# plotting
plot 'windows.txt' u 1:2 w lines ls 1 lw 2,\
  '' u 1:3 w lines ls 2 lw 2

# output
call 'plot.plt' 'fig'
