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
set t epslatex size @dissfullwidth,7.5cm color colortext standalone header diss10pt.footnotesize
set output 'fig.tex'

# legend
unset key
# positioning
load 'positions.cfg'
# x-axis
set xrange [-1.5:1.5]
set xtics 1 offset 0,0.5
set xlabel offset 0,1.25
LABEL_X = '$x$ / m'
# y-axis
set yrange [-1.5:1.5]
set ytics 1 offset 0.5,0
set ylabel offset 2.25,0
LABEL_Y = '$y$ / m'
# colorbar
load 'colorbar.cfg'
unset colorbox
# axes
set size ratio -1
set format '$%g$'
set tics scale 0.75 out nomirror
# labels
load 'labels.cfg'
set label 1 at graph 0.5,1.075 center front
set label 2 center front
set label 3 at graph 0.0, 1.075 left front '\stepcounter{tmpcounter}(\alph{tmpcounter})'
# styles
set style line 101 lc rgb 'black' pt 6 ps 3 linewidth 2
# variables
vlen = 0.2
sx = 0.18
sy = 0.36
soff = 0.0425
orix1 = soff
orix2 = soff + 1*1*sx
orix3 = soff + 1*2*sx
orix4 = soff + 1*3*sx
orix5 = soff + 1*4*sx
oriy1 = 0.525
oriy2 = 0.105

################################################################################
set multiplot

#### plot 1 ####
# positioning
@pos_top_left
set size sx, sy
set origin orix1, oriy1
# arrows
set arrow 1 from graph 0.0, 1.16 rto graph 2.1, 0 nohead lc rgb 'black'
# c-axis
load 'diverging/RdBu.plt'  # see gnuplot-colorbrewer
set palette negative
set cbrange [-1:1]
set cbtics 1
# labels
set label 1 '$f = 2$ kHz'
set label 2 at graph 1.1, 1.225 '$\sfposlocal = [0.75,0,0]^{\mathrm T}$ m'
# plotting
call 'plot_P.gnu' 'f2000_r0.75_posx0.75_posy0.00'

#### plot 2 ####
# labels
set label 1 '$f = 1$ kHz'
set label 2 ''
# positioning
@pos_top
set size sx, sy
set origin orix2, oriy1
# arrows
unset arrow 1
# plotting
call 'plot_P.gnu' 'f1000_r0.75_posx0.75_posy0.00'

#### plot 3 ####
# positioning
@pos_top
set size sx, sy
set origin orix3, oriy1
# arrows
set arrow 1 from graph 0.0, 1.16 rto graph 3.2, 0 nohead lc rgb 'black'
# plotting
call 'plot_P.gnu' 'f1000_r0.75_posx0.25_posy0.00'

#### plot 4 ####
# labels
set label 2 at graph 0.5, 1.225 '$\sfposlocal = [0.25,0,0]^{\mathrm T}$ m'
# arrows
unset arrow 1
# positioning
@pos_top
set size sx, sy
set origin orix4, oriy1
# plotting
call 'plot_P.gnu' 'f1000_r0.50_posx0.25_posy0.00'

#### plot 5 ####
# labels
set label 2 ''
# colorbar
set colorbox @colorbar_east
# positioning
@pos_top_right
set size sx, sy
set origin orix5, oriy1
# plotting
call 'plot_P.gnu' 'f1000_r0.25_posx0.25_posy0.00'

#### plot 6 ####
# positioning
@pos_bottom_left
set size sx, sy
set origin orix1, oriy2
# colorbar
unset colorbox
# labels
unset label 1
# c-axis
load 'sequential/Reds.plt'  # see gnuplot-colorbrewer
set palette positive
set cbrange [-40:0]
set cbtics 10 offset -0.5,0 add ('$0$ dB' 0)
# plotting
call 'plot_error.gnu' 'f2000_r0.75_posx0.75_posy0.00'

#### plot 7 ####
# positioning
@pos_bottom
set size sx, sy
set origin orix2, oriy2
# plotting
call 'plot_error.gnu' 'f1000_r0.75_posx0.75_posy0.00'

#### plot 8 ####
# positioning
@pos_bottom
set size sx, sy
set origin orix3, oriy2
# plotting
call 'plot_error.gnu' 'f1000_r0.75_posx0.25_posy0.00'

#### plot 9 ####
# positioning
@pos_bottom
set size sx, sy
set origin orix4, oriy2
# plotting
call 'plot_error.gnu' 'f1000_r0.50_posx0.25_posy0.00'

#### plot 10 ####
# colorbar
set colorbox @colorbar_east
# positioning
@pos_bottom_right
set size sx, sy
set origin orix5, oriy2
# plotting
call 'plot_error.gnu' 'f1000_r0.25_posx0.25_posy0.00'

################################################################################
unset multiplot

# output
call 'plot.plt' 'fig'
