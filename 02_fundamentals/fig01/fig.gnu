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
set t epslatex size @dissmarginwidth,4cm color colortext standalone header diss10pt.footnotesize
set output 'fig.tex'

# legend
unset key
# x-axis
set xrange [-1.5:1.5]
set xtics 1 offset 0,0.5
set xlabel '$x$ / m' offset 0,1
# y-axis
set yrange [-1.5:1.5]
set ytics 1 offset 0.5,0
set ylabel '$y$ / m' offset 2,0
# c-axis
load 'diverging/RdBu.plt'  # see gnuplot-colorbrewer
set palette negative
set cbrange [-1:1]
set cbtics 1
# colorbar
load 'colorbar.cfg'
# axes
set size ratio -1
set format '$%g$'
set tics scale 0.75 out nomirror
# margins
set bmargin 2
set tmargin 0.5
set lmargin 4
set rmargin 0

################################################################################

# plotting
plot 'fig.dat' binary matrix with image

# output
call 'plot.plt' 'fig'
