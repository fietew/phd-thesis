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
set t epslatex size @dissfullwidth,3.8cm color colortext standalone header diss10pt.footnotesize
set output 'fig.tex'

unset key

# labels
load 'labels.cfg'
set label 1 @label_north
set label 2 @label_northwest '\stepcounter{tmpcounter}(\alph{tmpcounter})'
# positioning
load 'positions.cfg'
# axes
set size ratio -1
set format '$%g$'
set tics scale 0.75 out nomirror
# x-axis
set xrange [-1.55:1.55]
set xtics 1 offset 0,0.5
set xlabel offset 0,1.25
LABEL_X = '$x$ / m'
# y-axis
set yrange [-1.55:1.55]
set ytics 1 offset 0.5,0
set ylabel offset 2.25,0
LABEL_Y = '$y$ / m'
# c-axis
load 'sequential/Blues.plt'
set cbrange [-60:0]
set cbtics 20 offset -0.8,0 add ('$0$~dB' 0)
# colorbar
load 'colorbar.cfg'
unset colorbox
# variables
sx = 0.17
sy = 1.0
soff = 0.055
orix1 = soff
orix2 = soff + 1.05*1*sx
orix3 = soff + 1.05*2*sx
orix4 = soff + 1.05*3*sx
orix5 = soff + 1.05*4*sx
oriy1 = 0.05

################################################################################

set multiplot

################################################################################
#### plot 1 #####
# labels
set label 1 'WFS'
# positioning
@pos_bottom_left
set size sx, sy
set origin orix1, oriy1
# variables
xeval = '0.00'
yeval = '0.00'
src = 'pw'
# plotting
plot 'Pwfs.dat' binary matrix with image, \
  'array.txt' @array_active,\
  'front.txt' u 1:2 w l lw 3 lt 4 lc rgb'#00FF00', \
  'xref.txt' u 1:2 w p lw 2 ps 2 pt 2 lc rgb'#FF0000'

#### plot 2 #####
# labels
set label 1 'WFS LP'
# positioning
@pos_bottom
set size sx, sy
set origin orix2, oriy1
# plotting
plot 'Pwfslp.dat' binary matrix with image, \
  'array.txt' @array_active,\
  'front.txt' u 1:2 w l lw 3 lt 4 lc rgb'#00FF00', \
  'xref.txt' u 1:2 w p lw 2 ps 2 pt 2 lc rgb'#FF0000'

#### plot 3 #####
# labels
set label 1 'LWFS-SBL HP'
# positioning
@pos_bottom
set size sx, sy
set origin orix3, oriy1
# variables
src = 'ps'
# plotting
plot 'Plwfs.dat' binary matrix with image, \
  'array.txt' @array_active,\
  'front.txt' u 1:2 w l lw 3 lt 4 lc rgb'#00FF00', \
  'xref.txt' u 1:2 w p lw 2 ps 2 pt 2 lc rgb'#FF0000'

#### plot 4 #####
# labels
set label 1 'Crossover'
# positioning
@pos_bottom
set size sx, sy
set origin orix4, oriy1
# plotting
plot 'Pap.dat' binary matrix with image, \
  'array.txt' @array_active,\
  'front.txt' u 1:2 w l lw 3 lt 4 lc rgb'#00FF00', \
  'xref.txt' u 1:2 w p lw 2 ps 2 pt 2 lc rgb'#FF0000'

#### plot 5 ####
# labels
set label 1 'Crossover \& AP'
# colorbar
set colorbox @colorbar_east
# positioning
@pos_bottom_right
set size sx, sy
set origin orix5, oriy1
# plotting
plot 'P.dat' binary matrix with image, \
  'array.txt' @array_active,\
  'front.txt' u 1:2 w l lw 3 lt 4 lc rgb'#00FF00', \
  'xref.txt' u 1:2 w p lw 2 ps 2 pt 2 lc rgb'#FF0000'

################################################################################
unset multiplot

# output
call 'plot.plt' 'fig'
