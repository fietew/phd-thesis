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

################################################################################
set t epslatex size  @disstextwidth, 5.0cm color colortext standalone header diss10pt.footnotesize
set output 'fig.tex'

unset key # deactivate legend

load 'qualitative/Dark2.plt'
set style line 10 lc rgb 'black'
set style line 101
# positioning
load 'positions.cfg'
SPACING_VERTICAL = 3.0
OUTER_RATIO_B = 0.75
# labels
set label 2 at graph -0.15, screen 0.965 left front '\stepcounter{tmpcounter}(\alph{tmpcounter})'
# variables
Nspec = 10
offset = 40  # shift in dB
Mlabel = '17 30 50 34 40 80 17 16 34 10'

################################################################################
set multiplot

#### plot 1 #####
# labels
set label 1 '$\sfRh$' at first 0.09, graph 1.0 front left tc rgb 'red'
# x-axis
set xrange [0.05:1.5]
set xtics 0.1 offset 0,0.5
set xtics add (1.5)
set xlabel offset 0,1.0
set logscale x
LABEL_X = '$\sfRlocal\;/\;\mathrm{m}$'
# y-axis
set ylabel offset 3,0
set yrange [2:80]
set ytics 10 offset 1.0,0
set ytics add (80)
set logscale y
LABEL_Y = '$\sffS[superscript=LWFS-VSS]_{\sfcircleh}\;/\;\mathrm{kHz}$'
# positioning
SPACING_HORIZONTAL = 5.0
OUTER_RATIO_L = 0.9
set size 0.70, 1.0
set origin 0.0, 0.0
@pos_bottom_left
# border
load 'xyborder.cfg'
# arrows
set arrow 1 from 94.3, graph -0.025 to 95.3, graph 0.025 nohead ls 101 # Inf break
set arrow 2 from 95.3, graph -0.025 to 96.3, graph 0.025 nohead ls 101 #    "
# plotting
plot 'Rl.txt' u 2:($1/1000) with filledcurve y1 fc rgb '#FFCCCC',\
  'Rl.txt' u 2:($1/1000) with lines lc rgb 'red',\
  for[ii=1:Nspec] 'fS.txt' u 1:(column(ii+1)/1000) w l ls ii lw 2,\
  for[ii=1:Nspec] 'fSRl.txt' u 1:(column(ii+1)/1000) with points ls ii pt 6 ps 1.5,\
  for[ii=1:Nspec] 'fS.txt' every ::word(Mlabel,ii)-1::word(Mlabel,ii)-1 u 1:(column(ii+1)/1000):(sprintf('$%d$', ii-1)) with labels offset graph 0.01,graph 0.025 tc ls ii,\

#### plot 2 #####
# labels
unset label 1
# x-axis
set xrange [-1.5:1.5]
unset logscale
LABEL_X = ''
# y-axis
set yrange [-1.5:3.0]
LABEL_Y = ''
# positioning
SPACING_HORIZONTAL = 2.0
OUTER_RATIO_R = 0.5
set size 0.30, 1.0
set size ratio -1
set origin 0.70, 0.0
@pos_bottom_right
# border
load 'noborder.cfg'
# grid
unset grid
# plotting
load 'array.cfg' # for @array_active
load 'localization.cfg' # @point_source
plot 'array.txt' @array_active,\
  set_point_source(0,2.5) @point_source,\
  for[ii=0:Nspec-1] 'pos.txt' every ::ii::ii ls ii+1 lw 2 pt 2 ps 1.0,\
  for[ii=0:Nspec-1] 'pos.txt' every ::ii::ii using 1:2:(sprintf('$%d$',ii)) with labels offset graph 0.065,-0.035 tc ls ii+1

################################################################################
unset multiplot

# output
call 'plot.plt' 'fig'
