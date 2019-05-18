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
set t epslatex size @dissmarginwidth,5cm color colortext standalone header diss10pt.footnotesize
set output 'fig.tex'

# legend
unset key
# positioning
load 'positions.cfg'
SPACING_HORIZONTAL = 5
SPACING_VERTICAL = 2
OUTER_RATIO_L = 0.99
OUTER_RATIO_R = 0.5
OUTER_RATIO_T = 0.5
OUTER_RATIO_B = 0.99
# x-axis
set xrange [0.02:20]
set xtics 10 offset 0,0.5
set xlabel offset 0,1.25
set logscale x
LABEL_X = '$f$ / kHz'
# y-axis
set yrange [-10:20]
set ytics 10 offset 0.5,0
set ylabel offset 2,0
# grid
load 'grid.cfg'
# color scheme
load 'qualitative/Paired.plt'  # see gnuplot-colorbrewer
# axes
set format '$%g$'
set tics scale 0.75 out nomirror
# labels
load 'labels.cfg'
set label 1 at graph 0.0, 1.1 left front '\stepcounter{tmpcounter}(\alph{tmpcounter})'
set label 2 tc ls 2 'shelved'
set label 3 tc ls 8 'fullband'
set label 4 at graph 0.1, 1.1 left front
# variables
sx = 1.0
sy = 0.5
orix1 = 0.0
oriy1 = 0.5
oriy2 = 0

################################################################################
set multiplot layout 2,1

#### plot 1 ####
# y-axis
LABEL_Y = '$20 \log_{10} |\sffilter[subscript=pre]|$'
# labels
set label 2 at graph 0.95, 0.2 right front
set label 3 at graph 0.95, 0.4 right front
set label 4 'pre-filter'
# positioning
@pos_top_left
set size sx, sy
set origin orix1, oriy1
# plotting
plot 'Hfull.txt' u ($1/1000):2 w l ls 7 lw 3,\
  'Hopt.txt' u ($1/1000):2 w l ls 2 lw 2

#### plot 2 ####
# y-axis
LABEL_Y = '$20 \log_{10} |\sfpressure(\sforigin,\sfomega)|$'
# labels
set label 2 at graph 0.05, 0.6 left front
set label 3 at graph 0.05, 0.8 left front
set label 4 'synthesised sound field'
# positioning
@pos_bottom_left
set size sx, sy
set origin orix1, oriy2
# plotting
plot 'Pfull.txt' u ($1/1000):2 w l ls 7 lw 3,\
  'Popt.txt' u ($1/1000):2 w l ls 2 lw 2

################################################################################
unset multiplot

# output
call 'plot.plt' 'fig'
