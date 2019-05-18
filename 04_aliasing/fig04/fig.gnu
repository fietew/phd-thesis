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
set t epslatex size @dissfullwidth,4.6cm color colortext standalone header diss10pt.footnotesize
set output 'fig.tex'

unset key

# some stats
stats 'rays.txt' skip 1 nooutput
colrays = STATS_columns/2
# labels
load 'labels.cfg'
set label 1 at graph 0.5, 1.075 center front
set label 2 at graph 0.0, 1.075 left front '\stepcounter{tmpcounter}(\alph{tmpcounter})'
# positioning
load 'positions.cfg'
# axes
set size ratio -1
set format '$%g$'
set tics scale 0.75 out nomirror
# x-axis
set xrange [-1.5:1.5]
set xtics 1 offset 0,0.5
set xlabel offset 0,1.0
LABEL_X = '$x$ / m'
# y-axis
set yrange [-0.5:2.5]
set ytics 1 offset 0.5,0
set ylabel offset 1.5,0
LABEL_Y = '$y$ / m'
# cb-axis
set cbtics offset -0.5,0
# colorbar
load 'colorbar.cfg'
unset colorbox
# style
set style line 101 lc rgb 'cyan' pt 7 ps 1 linewidth 3
set style line 102 lc rgb 'white' pt 7 ps 1 linewidth 3
set style line 103 lc rgb 'yellow' pt 7 ps 1 linewidth 3
set style line 104 lc rgb '#00AA00' pt 7 ps 1 linewidth 3
# variables
sx = 0.20
sy = 1.0
soff = 0.05
orix1 = soff
orix2 = soff + 1.05*1*sx
orix3 = soff + 1.05*2*sx
orix4 = soff + 1.05*3*sx
oriy1 = 0.05

################################################################################

set multiplot

################################################################################
#### plot 1 #####
# labels
set label 1 '$\sfvirtualsource(\sfx,\sfy,\sfomega)$'
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
plot 'S.dat' binary matrix with image

#### plot 2 #####
# labels
set label 1 '$\sfpressure(\sfx,\sfy,\sfomega)$'
# positioning
@pos_bottom
set size sx, sy
set origin orix2, oriy1
# plotting
plot 'P.dat' binary matrix with image,\
  'array.txt' @array_continuous,\
  'x0rays.txt' using 1:2 w p ls 101,\
  'x0SPA.txt' using 1:2 w p ls 104,\
  'raysSPA.txt' using 1:2 w l ls 104,\
  for [i=1:colrays] 'rays.txt' using 2*i-1:2*i w l ls 101

#### plot 3 #####
# labels
set label 1 '$\sfpressure_{\mathrm{SPA}}(\sfx,\sfy,\sfomega)$'
# positioning
@pos_bottom
set size sx, sy
set origin orix3, oriy1
# colorbar
set colorbox vert user origin graph 2.1, 0.0 size graph 0.05,1.0
# plotting
plot 'PSPA.dat' binary matrix with image,\
  'x0SPA.txt' using 1:2 w p ls 104,\
  'raysSPA.txt' using 1:2 w l ls 104,\
  'array.txt' @array_continuous

#### plot 4 #####
# labels
set label 1 ''
# positioning
@pos_bottom
set size sx, sy
set origin orix4, oriy1
# colorbar
set colorbox vert user origin graph 1.3, 0.0 size graph 0.05,1.0
# c-axis
load 'sequential/Reds.plt'  # see gnuplot-colorbrewer
set palette positive
set cbrange [-60:0]
set cbtics 20 add ('$0$ dB' 0)
# plotting
plot 'error.dat' binary matrix with image,\
  'x0SPA.txt' using 1:2 w p ls 104,\
  'raysSPA.txt' using 1:2 w l ls 104,\
  'array.txt' @array_continuous

################################################################################
unset multiplot

# output
call 'plot.plt' 'fig'
