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
# positioning
load 'positions.cfg'
SPACING_HORIZONTAL = 3.5
SPACING_VERTICAL = 2.0
OUTER_RATIO_L = 1.0
OUTER_RATIO_B = 1.0
# x-axis
set xrange [0.01:1.4]
set logscale x 10
set xtics offset 0,0.5
set xlabel offset 0,1.25
LABEL_X = '$y_{\mathrm fs}$ / m'
# y-axis
set yrange [-25:25]
set ytics 20 offset 0.5,0
set mytics 2
set ylabel  offset 3.5,0
LABEL_Y = '$20 \lg |P(\mathbf 0, \omega)|$'
# grid
load 'grid.cfg'
set grid xtics ytics mxtics mytics
# labels
load 'labels.cfg'

do for [ii=1:3]{
  set label ii+10 at graph 0.95, 0.95-0.1*ii right front tc ls ii
}

################################################################################

# labels
set label 11  '\ft $0.2$ kHz'
set label 12  '\ft $2$ kHz'
set label 13  '\ft $20$ kHz'

# positioning
@pos_bottom_left
# plotting
plot for[ii=1:3] 'data.txt' u 1:1+ii w l ls ii lw 4,\
    'data.txt' u 1:5 w l lw 4 lc rgb 'black' dt 2

# output
call 'plot.plt' 'fig'
