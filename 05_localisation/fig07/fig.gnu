#!/usr/bin/gnuplot

#*****************************************************************************
# Copyright (c) 2012      Hagen Wierstorf                                    *
#                         Centre for Vision, Speech and Signal Processing    *
#                         University of Surrey                               *
#                         Guildford, GU2 7XH, UK                             *
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

# latex
set terminal epslatex size @dissfullwidth,8cm color colortext standalone header diss10pt.footnotesize
set output 'fig.tex'

unset key # deactivate legend

# border
load 'xyborder.cfg'
set border back
# grid
load 'grid.cfg'
set grid mytics back ls 102
# colors definitions
set style line 1 lc rgb 'black' pt 12  ps 1.5 lt 1 lw 2 # --- black
set style line 2 lc rgb 'black' pt 9 ps 1.5
set style line 3 lc rgb '#d6d7d9' pt 13 ps 1.5
set style line 4 lc rgb 'black' dt 1 lw 2
set style line 5 lc rgb 'black' dt 2 lw 2
# x-axis
set xrange [-45:45]
set xtics 15 offset 0,0.5
set xlabel offset 0,1.0
# y-axis
set yrange [-20:20]
set ylabel offset 2.5,0
set ytics offset 1.0,0
set format y '$%g$'
# labels
set label 1 at graph 1.0, first 22 right front tc ls 1
# margins
set lmargin 4.5
set rmargin 1.0

set multiplot layout 2,2
################################################################################

#### plot 1 #####
# x-axis
set format x ''
# y-axis
set ytics 5
set ylabel '$\Delta_{ls}^b (\sfcylphi_c)$ / deg'
# margins
set tmargin 2.5
set bmargin 0.5
# labels
set label 1 'Wierstorf et al.'
# title
set title 'signed error'
# variables
prefix = '2012'

plot for [ii=1:10] prefix.'_err.txt' using 1:1+ii ls 3 ,\
  prefix.'_lme.txt' using 1:2 w l ls 4,\
  '' using 1:3 w l ls 5,\
  '' using 1:4 w l ls 5,\

#### plot 2 #####
# y-axis
set ylabel '$\tilde \Delta_{ls}^b (\sfcylphi_c)$ / deg'
# title
set title 'corrected signed error'

plot for [ii=1:10] prefix.'_err_corrected.txt' using 1:1+ii ls 3,\
  prefix.'_err_corrected_mean.txt' using 1:2:3 w yerrorbars ls 1,\

#### plot 3 #####
# x-axis
set format x '$%g$'
set xlabel '$\sfcylphi_c$ / deg'
# y-axis
set ylabel '$\Delta_{ls}^b (\sfcylphi_c)$ / deg'
# margins
set tmargin 0.5
set bmargin 2.5
# labels
set label 1 'current study'
# title
unset title
# variables
prefix = '2017'

plot for [ii=1:10] prefix.'_err.txt' using 1:1+ii ls 3 ,\
  prefix.'_lme.txt' using 1:2 w l ls 4,\
  '' using 1:3 w l ls 5,\
  '' using 1:4 w l ls 5

#### plot 4 #####
# y-axis
set ylabel '$\tilde \Delta_{ls}^b (\sfcylphi_c)$ / deg'

plot for [ii=1:10] prefix.'_err_corrected.txt' using 1:1+ii ls 3,\
  prefix.'_err_corrected_mean.txt' using 1:2:3 w yerrorbars ls 1,\

################################################################################
unset multiplot

call 'plot.plt' 'fig'
