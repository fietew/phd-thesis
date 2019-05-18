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
set t epslatex size @disstextwidth,7.5cm color colortext standalone header diss10pt.footnotesize
set output 'fig.tex'

unset key

# some stats
stats 'rays.txt' skip 1 nooutput
colrays = STATS_columns/2
# labels
load 'labels.cfg'
set label 1 at graph 0.5, 1.075 center front
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
sx = 0.29
sy = 0.38
orix1 = 0.065
orix2 = 0.065 + 0.96*1*sx
orix3 = 0.065 + 0.96*2*sx
oriy1 = 0.56
oriy2 = 0.11

################################################################################

set multiplot

################################################################################
#### plot 1 #####
# labels
set label 1 '$\sfpressure[superscript=sampled]_{-1}(\sfx,\sfy,\sfomega)$'
# positioning
@pos_top_left
set size sx, sy
set origin orix1, oriy1
# c-axis
load 'diverging/RdBu.plt'  # see gnuplot-colorbrewer
set palette negative
set cbrange [-1:1]
set cbtics 1
# plotting
plot 'eta-1_P.dat' binary matrix with image,\
  'eta-1_array.txt' @array_continuous,\
  'eta-1_x0rays_active.txt' using 1:2 w p ls 101,\
  'eta-1_x0rays_inactive.txt' using 1:2 w p ls 103,\
  'eta-1_x0SPA.txt' using 1:2 w p ls 104,\
  'eta-1_raysSPA.txt' using 1:2 w l ls 104,\
  for [i=1:colrays] 'eta-1_rays.txt' using 2*i-1:2*i w l ls 101

#### plot 2 #####
# labels
set label 1 '$\sfpressure[superscript=sampled]_{-2}(\sfx,\sfy,\sfomega)$'
# positioning
@pos_bottom_left
set size sx, sy
set origin orix1, oriy2
# c-axis
load 'diverging/RdBu.plt'  # see gnuplot-colorbrewer
set palette negative
set cbrange [-1:1]
set cbtics 1
# plotting
plot 'eta-2_P.dat' binary matrix with image,\
  'eta-2_array.txt' @array_continuous,\
  'eta-2_x0rays_active.txt' using 1:2 w p ls 101,\
  'eta-2_x0rays_inactive.txt' using 1:2 w p ls 103,\
  'eta-2_x0SPA.txt' using 1:2 w p ls 104,\
  'eta-2_raysSPA.txt' using 1:2 w l ls 104,\
  for [i=1:colrays] 'eta-2_rays.txt' using 2*i-1:2*i w l ls 101

#### plot 3 #####
# labels
set label 1 '$\sfpressure[superscript=sampled]_{-1,\mathrm{SPA}}(\sfx,\sfy,\sfomega)$'
# positioning
@pos_top
set size sx, sy
set origin orix2, oriy1
# colorbar
set colorbox vert user origin screen 0.91, graph 0.0 size graph 0.05, graph 1.0
# plotting
plot 'eta-1_PSPA.dat' binary matrix with image,\
  'eta-1_array.txt' @array_continuous,\
  'eta-1_x0SPA.txt' using 1:2 w p ls 104,\
  'eta-1_raysSPA.txt' using 1:2 w l ls 104

#### plot 4 #####
# labels
set label 1 '$\sfpressure[superscript=sampled]_{-2,\mathrm{SPA}}(\sfx,\sfy,\sfomega)$'
# positioning
@pos_bottom
set size sx, sy
set origin orix2, oriy2
# colorbox
unset colorbox
# plotting
plot 'eta-2_PSPA.dat' binary matrix with image,\
  'eta-2_array.txt' @array_continuous,\
  'eta-2_x0SPA.txt' using 1:2 w p ls 104,\
  'eta-2_raysSPA.txt' using 1:2 w l ls 104

#### plot 5 #####
# labels
set label 1 ''
# positioning
@pos_top_right
set size sx, sy
set origin orix3, oriy1
# c-axis
load 'sequential/Reds.plt'  # see gnuplot-colorbrewer
set palette positive
set cbrange [-60:0]
set cbtics 20 add ('$0$ dB' 0)
# plotting
plot 'eta-1_error.dat' binary matrix with image,\
  'eta-1_array.txt' @array_continuous,\
  'eta-1_x0SPA.txt' using 1:2 w p ls 104,\
  'eta-1_raysSPA.txt' using 1:2 w l ls 104

#### plot 6 #####
# positioning
@pos_bottom_right
set size sx, sy
set origin orix3, oriy2
# colorbar
set colorbox vert user origin screen 0.91, graph 0.0 size graph 0.05, graph 1.0
# plotting
plot 'eta-2_error.dat' binary matrix with image,\
  'eta-2_array.txt' @array_continuous,\
  'eta-2_x0SPA.txt' using 1:2 w p ls 104,\
  'eta-2_raysSPA.txt' using 1:2 w l ls 104

################################################################################
unset multiplot

# output
call 'plot.plt' 'fig'
