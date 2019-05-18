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
load 'array.cfg'
load 'labels.cfg'
load 'colorbar.cfg'
load 'standalone.cfg'

################################################################################
set t epslatex size @disstextwidth,4.0cm color colortext standalone header diss10pt.footnotesize
set output 'fig.tex'

unset key

# labels
load 'labels.cfg'
set label 1 at graph 0.5, 1.06 center front
set label 2 at graph 0.0, 1.06 left front '\stepcounter{tmpcounter}(\alph{tmpcounter})'
# positioning
load 'positions.cfg'
# axes
set size ratio -1
set format '$%g$'
set tics scale 0.75 out nomirror
# x-axis
set xrange [-1.5:1.5]
set xtics 1 offset 0,0.5
set xlabel offset 0,1.3
LABEL_X = '$x$ / m'
# y-axis
set yrange [-1.5:1.5]
set ytics 1 offset 0.5,0
set ylabel offset 2.8,0
LABEL_Y = '$y$ / m'
# c-axis
set cbtics offset -0.5,0
# colorbar
load 'colorbar.cfg'
unset colorbox
# style
set style line 101 lc rgb 'black' pt 7 ps 1 linewidth 3
set style line 102 lc rgb 'white' pt 7 ps 1 linewidth 3
set style line 103 lc rgb 'yellow' pt 7 ps 1 linewidth 3
set style line 104 lc rgb '#00AA00' pt 7 ps 1 linewidth 3
# variables
sx = 0.29
sy = 0.720
dx = 0
orix1 = 0*sx + 1*dx + 0.06
orix2 = 1*sx + 2*dx + 0.06
orix3 = 2*sx + 3*dx + 0.06
oriy1 = 0.175
M = 27

################################################################################
set multiplot

set view map
unset surface
set contour base
set format x '%g'
set format y '%g'
M = 27
set cntrparam level incremental M,M,M
set table 'cont.txt'
splot 'mu.dat' u 1:2:3 binary matrix w l
unset table

#### plot 1 #####
# labels
set label 1 '$\sfvirtualsourceB_M(\sfpossec,\sfomega)$'
# positioning
@pos_bottom_left
set size sx, sy
set origin orix1, oriy1
# c-axis
load 'diverging/RdBu.plt'  # see gnuplot-colorbrewer
set palette negative
set cbrange [-1:1]
set cbtics 1
# plotting
plot 'SM.dat' binary matrix with image,\
  'cont.txt' w l ls 101

#### plot 3 #####
# labels
set label 1 '$\sfwindow[prefix=cht]^M(\sfcylmu)\,\sfvirtualsource(\sfpos,\sfomega)$'
# positioning
@pos_bottom
set size sx, sy
set origin orix2, oriy1
# plotting
plot 'SMapprox_wm.dat' binary matrix with image,\
  'cont.txt' w l ls 101

#### plot 5 #####
# labels
set label 1 '$\sfselect[prefix=cht]^M(\sfcylmu)\,\sfvirtualsource(\sfpos,\sfomega)$'
# positioning
@pos_bottom_right
set size sx, sy
set origin orix3, oriy1
# colorbar
set colorbox @colorbar_east
# plotting
plot 'SMapprox_am.dat' binary matrix with image,\
  'cont.txt' w l ls 101

################################################################################
unset multiplot

# output
call 'plot.plt' 'fig'
