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
load 'standalone.cfg'

################################################################################
set t epslatex size 16.4cm,8.5cm color colortext standalone header diss10pt.footnotesize
set output 'fig.tex'

# legend
unset key
# positioning
load 'positions.cfg'
# axes
set size ratio 1
set format '$%g$'
set tics scale 0.75 out nomirror
# x-axis
set xtics offset 0,0.5
set xlabel offset 0,1
# y-axis
set ytics offset 0.5,0
# cb-axis
set cbtics offset -0.5,0
# colorbar
load 'colorbar.cfg'
unset colorbox
# linestyle
set style line 10 lc rgb 'green' lw 3 dt 6
set style line 11 lc rgb 'yellow' lw 3 dt 1
set style line 12 lc rgb 'magenta' lw 3 dt 1
# labels
load 'labels.cfg'
set label 1 at graph 0.0, 1.07 left front '\stepcounter{tmpcounter}(\alph{tmpcounter})'
set label 2 at graph 0.5, 1.07 center front
# variables
sx = 0.255
sy = 0.385
orix1 = 0.022
orix2 = 0.022 + 0.825*1*sx
orix3 = 0.022 + 0.825*2*sx
orix4 = 0.067 + 0.825*3*sx
oriy1 = 0.555
oriy2 = 0.105
# function
get_ls(x) = x == 0 ? 11 : 12

################################################################################
set view map
unset surface
set contour base
set format '%g'
set cntrparam level incremental 2.5, 2.5, 2.5

set table 'cont_M27.txt'
splot 'fS_M27.dat' u 1:2:($3/1000) binary matrix w l
set table 'cont_M300.txt'
splot 'fS_M300.dat' u 1:2:($3/1000) binary matrix w l
unset table

set multiplot

#### plot 1 ####
# labels
set label 2 '$\sfdriving[prefix=cht]_{\sfcylm}(\sfomega)$'
# x-axis
set xrange [-60:60]
set xtics 40
LABEL_X = '$\sfcylm$ / 1'
# y-axis
set yrange [0:3]
set ytics 1
set ylabel offset 1.75,0
LABEL_Y = '$\sff$ / kHz'
# c-axis
load 'sequential/Blues.plt'  # see gnuplot-colorbrewer
set palette positive
set cbrange [-40:10]
set cbtics 10
set cbtics add ('$0$ dB' 0)
# positioning
@pos_top_left
set size sx, sy
set origin orix1, oriy1
# plotting
plot 'Dhoa_spec_M300.dat' u 1:($2/1000):3 binary matrix with image,\
  'f.txt' u 1:($2/1000) w l ls 10,\
  for[eta=0:0] for[ii=1:2] sprintf('m_cutoff_eta%d_M300.txt', eta) u ii+1:($1/1000) w l ls get_ls(eta),\

#### plot 2 ####
# labels
set label 2 '$\sfdriving[prefix=cht,superscript=sampled]_{\sfcylm}(\sfomega)$'
# positioning
@pos_top
set size sx, sy
set origin orix2, oriy1
# plotting
plot 'Dsub_spec_M300.dat' u 1:($2/1000):3 binary matrix with image,\
  'f.txt' u 1:($2/1000) w l ls 10,\
  for[eta=-1:1] for[ii=1:2] sprintf('m_cutoff_eta%d_M300.txt', eta) u ii+1:($1/1000) w l ls get_ls(eta),\

#### plot 3 ####
# labels
set label 2 '$\sfpressure[prefix=cht,superscript=sampled]_{\sfcylm}(\sfcylr,\sfomega), \sfcylr = 1.0$ m'
# colorbar
set colorbox vert user origin screen 0.935, graph 0.0 size graph 0.05, graph 1.0
set cbtics format '$%g$'
# positioning
@pos_top
set size sx, sy
set origin orix3, oriy1
# plotting
plot 'Psub_spec_M300.dat' u 1:($2/1000):3 binary matrix with image,\
  'f.txt' u 1:($2/1000) w l ls 10,\
  for[eta=-1:1] for[ii=1:2] sprintf('m_cutoff_eta%d_M300.txt', eta) u ii+1:($1/1000) w l ls get_ls(eta),\

#### plot 4 ####
# labels
set label 2 '$\sfpressure[superscript=sampled](\sfpos,\sfomega)$'
# x-axis
set xrange [-1.5:1.5]
set xtics 1
set xlabel offset 0,1.0
LABEL_X = '$x$ / m'
# y-axis
set yrange [-1.5:1.5]
set ytics 1
set ylabel offset 2.25,0
LABEL_Y = '$y$ / m'
# c-axis
load 'diverging/RdBu.plt'  # see gnuplot-colorbrewer
set palette negative
set cbrange [-1:1]
set cbtics 1
# colorbar
unset colorbox
# positioning
@pos_top_left
set size sx, sy
set origin orix4, oriy1
# plotting
plot 'Psub_M300.dat' binary matrix with image,\
  'array.txt' @array_active,\
  'cont_M300.txt' w l ls 12,\

#### plot 5 ####
# labels
unset label 2
# x-axis
set xrange [-60:60]
set xtics 40
LABEL_X = '$\sfcylm$ / 1'
# y-axis
set yrange [0:3]
set ytics 1
set ylabel offset 1.75,0
LABEL_Y = '$\sff$ / kHz'
# c-axis
load 'sequential/Blues.plt'  # see gnuplot-colorbrewer
set palette positive
set cbrange [-40:10]
set cbtics 10
set cbtics add ('$0$ dB' 0)
# positioning
@pos_bottom_left
set size sx, sy
set origin orix1, oriy2
# plotting
plot 'Dhoa_spec_M27.dat' u 1:($2/1000):3 binary matrix with image,\
  'f.txt' u 1:($2/1000) w l ls 10,\
  for[eta=0:0] for[ii=1:2] sprintf('m_cutoff_eta%d_M27.txt', eta) u ii+1:($1/1000) w l ls get_ls(eta),\

#### plot 6 ####
# colorbar
unset colorbox
# positioning
@pos_bottom
set size sx, sy
set origin orix2, oriy2
# plotting
plot 'Dsub_spec_M27.dat' u 1:($2/1000):3 binary matrix with image,\
  'f.txt' u 1:($2/1000) w l ls 10,\
  for[eta=-1:1] for[ii=1:2] sprintf('m_cutoff_eta%d_M27.txt', eta) u ii+1:($1/1000) w l ls get_ls(eta),\

#### plot 7 ####
# positioning
@pos_bottom
set size sx, sy
set origin orix3, oriy2
# plotting
plot 'Psub_spec_M27.dat' u 1:($2/1000):3 binary matrix with image,\
  'f.txt' u 1:($2/1000) w l ls 10,\
  for[eta=-1:1] for[ii=1:2] sprintf('m_cutoff_eta%d_M27.txt', eta) u ii+1:($1/1000) w l ls get_ls(eta),\

#### plot 8 ####
# x-axis
set xrange [-1.5:1.5]
set xtics 1
set xlabel offset 0,1.0
LABEL_X = '$x$ / m'
# y-axis
set yrange [-1.5:1.5]
set ytics 1
set ylabel offset 2.25,0
LABEL_Y = '$y$ / m'
# c-axis
load 'diverging/RdBu.plt'  # see gnuplot-colorbrewer
set palette negative
set cbrange [-1:1]
set cbtics 1
# positioning
@pos_bottom_left
set size sx, sy
set origin orix4, oriy2
# colorbar
set colorbox vert user origin screen 0.935, graph 0.0 size graph 0.05, graph 1.0
set cbtics format '$%g$'
# plotting
plot 'Psub_M27.dat' binary matrix with image,\
  'R_M27.txt' w l ls 11,\
  'array.txt' @array_active,\
  'cont_M27.txt' w l ls 12,\

################################################################################
unset multiplot

# output
call 'plot.plt' 'fig'
