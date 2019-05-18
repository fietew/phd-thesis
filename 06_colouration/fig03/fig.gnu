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
set loadpath '../../gnuplot/

load 'xyborder.cfg'
load 'standalone.cfg'

################################################################################
set t epslatex size @disstextwidth,10.0cm color colortext standalone header diss10pt.scriptsize
set output 'fig.tex'

unset key # deactivate legend

load 'qualitative/Paired.plt'
# positioning
load 'positions.cfg'
SPACING_HORIZONTAL = 5.0
SPACING_VERTICAL = 4.0
OUTER_RATIO_L = 0.95
OUTER_RATIO_B = 0.45
# variables
Nspec = 9
offset_phon = 20 # shift in dB
# x-axis
set xrange [0.08:14.8]
set logscale x 10
set xtics offset 0,0.5
set xlabel offset 0,1.25
LABEL_X = 'Centre frequency of auditory bands $/$ kHz'
# y-axis
set yrange [-(Nspec-1)*offset_phon-5:10]
set ytics offset_phon offset 0.5,0
set mytics 2
set ylabel  offset 3.25,0
LABEL_Y = 'CLL difference to reference / dB'
# grid
load 'grid.cfg'
set grid xtics ytics mxtics mytics
# labels
load 'labels.cfg'
set label 1 at graph 0.0, 1.075 left front tc ls 2
set label 2 at graph 1.0, 1.075 right front tc ls 6
set label 3 at graph 0.0, 1.025 left front  tc ls 2
set label 4 at graph 1.0, 1.025 right front  tc ls 6
do for [ii=1:Nspec] {
  set label 10+ii at graph 0.06, first (-ii+1.35)*offset_phon left front
}
do for [ii=1:Nspec] {
  set label 20+ii at graph 0.01, first (-ii+1.35)*offset_phon left front\
    '\stepcounter{tmpcounter}\ft(\alph{tmpcounter})'
}

################################################################################

# labels
set label 1  'centre'
set label 2  'off-centre'
set label 3  '$\sfpos = [0,0,0]^\mathrm{T}$~m'
set label 4  '$\sfpos = [-0.5,0.75,0]^\mathrm{T}$~m'

set label 11 'WFS'
set label 12 'NFCHOA $M=27$, rect.'
set label 13 'LWFS-SBL $\sfNpw=64$, $M=27$, rect.'
set label 14 'LWFS-SBL $\sfNpw=1024$, $M=27$, rect.'
set label 15 'LWFS-SBL $\sfNpw=1024$, $M=19$, rect.'
set label 16 'LWFS-SBL $\sfNpw=1024$, $M=3$, rect.'
set label 17 'LWFS-SBL $\sfNpw=1024$, $M=27$, max-$\mathbf r_E$'
set label 18 'LWFS-VSS $N_{\mathrm{fs}}=1024$, $\sfRlocal = 15$~cm'
set label 19 'LWFS-VSS $N_{\mathrm{fs}}=1024$, $\sfRlocal = 45$~cm'

# positioning
@pos_bottom_left
# plotting
plot for[ii=1:Nspec] 'data.txt' u ($1/1000):(column(2*ii+1)-(ii-1)*offset_phon) w l ls 5 lw 4,\
    for[ii=1:Nspec] 'data.txt' u ($1/1000):(column(2*ii)-(ii-1)*offset_phon) w l ls 2 lw 2

unset multiplot
################################################################################

call 'plot.plt' 'fig'
