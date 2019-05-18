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
set t epslatex size @disstextwidth,7.0cm color colortext standalone header diss10pt.footnotesize
set output 'fig.tex'

# legend
unset key
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
# style
set style line 101 lc rgb 'black' lw 4
set style line 102 lc rgb 'red' lw 4
# labels
load 'labels.cfg'
set label 1 at graph 0.5, 1.06 left center
set label 3 center front tc rgb '#808080'
set label 5 at graph 0.0, 1.06 left front '\stepcounter{tmpcounter}(\alph{tmpcounter})'
# variables
sx = 0.33
sy = 0.40
orix1 = 0.035 + 0*0.85*sx
orix2 = 0.035 + 1*0.85*sx
orix3 = 0.035 + 2*0.85*sx
oriy1 = 0.55
oriy2 = 0.095

################################################################################
set multiplot layout 2,3

#### plot 1 ####
# labels
set label 1 'equidistant'
# positioning
set size sx, sy
set origin orix1, oriy1
@pos_top_left
# c-axis
set cbrange [-1:1]
set cbtics 1
# palette
set palette negative
set palette maxcolor 0
load 'diverging/RdBu.plt'  # see gnuplot-colorbrewer
# colorbar
unset colorbox
# variables
filename = 'ps_circular_none'
# plotting
load 'plotP.gnu'

#### plot 2 ####
# labels
set label 1 '$\sfRh = 0.25$~m'
# positioning
set size sx, sy
set origin orix2, oriy1
@pos_top
# variables
filename = 'ps_circular_both_xc-0.75_yc0.00_Rc0.25'
# plotting
load 'plotP.gnu'

#### plot 3 ####
# labels
set label 1 '$\sfRh = 0.50$~m'
# positioning
set size sx, sy
set origin orix3, oriy1
@pos_top_right
# colorbar
set colorbox @colorbar_east_tight
# variables
filename = 'ps_circular_both_xc-0.75_yc0.00_Rc0.50'
# plotting
load 'plotP.gnu'

#### plot 4 ####
# c-axis
set cbrange [1:3]
set cbtics 0.5 add ('$1$~kHz' 1)
set format cb '$%g$'
# palette
load 'sequential/Blues.plt'  # see gnuplot-colorbrewer
set palette maxcolors 4
# labels
unset label 1
# colorbar
unset colorbox
# positioning
set size sx, sy
set origin orix1, oriy2
@pos_bottom_left
# variables
filename = 'ps_circular_none'
# plotting
load 'plotfS.gnu'

#### plot 5 ####
# positioning
set size sx, sy
set origin orix2, oriy2
@pos_bottom
# variables
filename = 'ps_circular_both_xc-0.75_yc0.00_Rc0.25'
# plotting
load 'plotfS.gnu'

#### plot 6 ####
# positioning
set size sx, sy
set origin orix3, oriy2
@pos_bottom
# colorbar
set colorbox @colorbar_east_tight
# variables
filename = 'ps_circular_both_xc-0.75_yc0.00_Rc0.50'
# plotting
load 'plotfS.gnu'

################################################################################
unset multiplot

# output
call 'plot.plt' 'fig'
