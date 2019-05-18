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

load 'standalone.cfg'
load 'mathematics.cfg'

# latex
set terminal epslatex size @dissfullwidth,@dissfullwidth color colortext standalone header diss10pt.footnotesize
set output 'fig.tex'

unset key

# border
load 'xyborder.cfg'
# positioning
load 'positions.cfg'
# grid
load 'grid.cfg'
# x-axis
set xlabel offset 0,1.0
set logscale x
# y-axis
set ylabel offset 2.5,0
set logscale y
# c-axis
set cbrange [0.5:5.5]
unset colorbox
set palette defined (\
          0.5 '#FF7F00',\
          1.5 '#FF7F00',\
          1.5 '#FDBF6F',\
          2.5 '#FDBF6F',\
          2.5 '#1F78B4',\
          3.5 '#1F78B4',\
          3.5 '#33A02C',\
          4.5 '#33A02C',\
          4.5 '#E31A1C',\
          5.5 '#E31A1C')
# functions
point_size(x) = x < 1.0 ? 1.0 : 1.0 + 2*log10(x)
# variables
s_main = 0.605
ori_main = 0.065
ori_side = s_main + ori_main + 0.03
s_side = 1 - ori_side

################################################################################
set multiplot

#### main plot ####
set size s_main, s_main
set origin ori_main, ori_main
# x-axis
LABEL_X = 'aliasing frequency $\sffS(\sfpos)$ / kHz'
set xrange [0.2:70]
set xtics offset 0,0.5
set xtics add (0.2, 20)
# y-axis
LABEL_Y = 'SBL frequency $\sffB_M(\sfpos)$ / kHz'
set yrange [0.2:60]
set ytics 10 offset 0.5,0
set ytics add (0.2, 20, 50, '$\infty$' 60)
# labels
set label 1 at first 0.3, 6 tc rgb '#FF7F00' 'NFCHOA'
set label 2 at first 0.3, 45 tc rgb '#1F78B4' 'WFS'
set label 3 at first  15, 1.25 tc rgb '#33A02C' 'LWFS-SBL'
set label 4 at first  15, 45 tc rgb '#E31A1C' 'LWFS-VSS'
set label 5 at first  11, 0.8 front 'localisation bias $|\bar \Delta^\cdot_{\cdot m}(\sfpos)|$'
# positioning
@pos_bottom_left

plot 'data.txt' using ($1/1000.0):($2/1000.0):(point_size($3)):4 pt 6 ps variable lc palette,\
  '<printf "20 -0.625 1\n\
    20 -0.475 10\n\
    20 -0.275 100"' using 1:(pow(10,$2)):(point_size($3)) pt 6 ps variable lc rgb '#000000',\
  '' using 1:(pow(10,$2)):(sprintf('$%2.0f^\\circ$',$3)) with labels left offset 1.75,0

### right plot ####
set size s_side, s_main
set origin ori_side, ori_main
# labels
unset label
# x-axis
set xrange [0.1:160]
set xtics 10
LABEL_X = 'localisation bias $|\bar \Delta^\cdot_{\cdot m}(\sfpos)|$ / deg'
# y-axis
set ytics 10
# positioning
@pos_bottom_right
# plotting
plot 'data.txt' using 3:($2/1000.0):4 pt 2 lc palette

### top plot ####
set size s_main, s_side
set origin ori_main, ori_side
# labels
unset label
# x-axis
set xtics 10
set xrange [0.2:70]
# y-axis
set yrange [0.1:160]
set ytics 10
LABEL_Y = 'localisation bias $|\bar \Delta^\cdot_{\cdot m}(\sfpos)|$ / deg'
# positioning
@pos_top_left
# plotting
plot 'data.txt' using ($1/1000.0):3:4 pt 2 lc palette,\

unset multiplot
###############################################################################

unset output
call 'plot.plt' 'fig'
