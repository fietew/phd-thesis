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

# reset
set macros
set loadpath '../../gnuplot/'

load 'xyborder.cfg'
load 'array.cfg'
load 'standalone.cfg'

################################################################################
set t epslatex size @dissfullwidth,4.4cm color colortext standalone header diss10pt.footnotesize
set output 'fig.tex'

# legend
unset key
# positioning
load 'positions.cfg'
# x-axis
set xrange [-1.5:1.5]
set xtics 1 offset 0,0.5
set xlabel offset 0,1.2
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
# axes
set size ratio -1
set tics scale 0.75 out nomirror
# styles
set style line 101 lc rgb 'black' lw 4
set style line 102 lc rgb 'black' pt 6 ps 3 linewidth 2
set style line 103 lc rgb 'black' lw 4 dt 3
# labels
load 'labels.cfg'
set label 1 at graph 0.5, 1.07 center front
set label 2 at graph 0.0, 1.07 left front '\stepcounter{tmpcounter}(\alph{tmpcounter})'
# variables
vlen = 0.2
sx = 0.19
sy = 0.720
dx = 0.01
orix1 = 0*sx + 1*dx + 0.035
orix2 = 1*sx + 2*dx + 0.035
orix3 = 2*sx + 3*dx + 0.035
orix4 = 3*sx + 4*dx + 0.035
oriy1 = 0.175
f = 2000

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

#### plot 1 ####
# positioning
set size sx, sy
set origin orix1, oriy1
@pos_bottom_left
# c-axis
set cbrange [-1:1]
set cbtics 1
# palette
set palette negative
set palette maxcolor 0
load 'diverging/RdBu.plt'  # see gnuplot-colorbrewer
# colorbar
unset colorbox
# labels
set label 1 '$\sfvirtualsource(\sfpos,\sfomega)$'
# plotting
plot 'S.dat' binary matrix with image

#### plot 2 ####
# positioning
set size sx, sy
set origin orix2, oriy1
@pos_bottom
# colorbar
set colorbox vert user origin screen 0.845, graph 0.0 size graph 0.05,1.0
# labels
set label 1 '$\sfvirtualsourceB_M(\sfpos,\sfomega)$'
# plotting
plot 'SM.dat' binary matrix with image,\
  'cont.txt' w l ls 101,\
  'rM.txt' w l ls 103

#### plot 3 ####
# positioning
set size sx, sy
set origin orix3, oriy1
@pos_bottom
# c-axis
set cbrange [-15:10]
set cbtics 5 add ('$0$ dB' 0)
# palette
load 'sequential/Reds.plt'  # see gnuplot-colorbrewer
set palette positive
set palette maxcolors 0
# colorbar
set colorbox vert user origin screen 0.895, graph 0.0 size graph 0.05,1.0
# labels
unset label 1
# plotting
plot 'eps.dat' binary matrix with image,\
  'cont.txt' w l ls 101,\
  'rM.txt' w l ls 103

#### plot 3 ####
# positioning
set size sx, sy
set origin orix4, oriy1
@pos_bottom_right
# c-axis
set cbrange [0:90]
set cbtics 45 format '$%g^\circ$'
# palette
load 'sequential/Blues.plt'  # see gnuplot-colorbrewer
# colorbar
set colorbox vert user origin screen 0.955, graph 0.0 size graph 0.05,1.0
# plotting
plot 'alpha.dat' binary matrix with image,\
  'kvec.txt' u ($1-$3*0.5*vlen):($2-$3*0.5*vlen):($3*vlen):($4*vlen) with vectors head size 0.1,20,60 ls 102,\
  'cont.txt' w l ls 101,\
  'rM.txt' w l ls 103

################################################################################
unset multiplot

# output
call 'plot.plt' 'fig'
