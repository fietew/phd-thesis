#!/usr/bin/gnuplot

#*****************************************************************************
# Copyright (c) 2012      Hagen Wierstorf                                    *
#                         Centre for Vision, Speech and Signal Processing    *
#                         University of Surrey                               *
#                         Guildford, GU2 7XH, UK                             *
#                                                                            *
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

load 'localization.cfg'
load 'noborder.cfg'
load 'array.cfg'
load 'standalone.cfg'
load 'colorbar.cfg'

# latex
set terminal epslatex size 17cm,24cm color colortext standalone header diss10pt.scriptsize
set output 'fig.tex'

unset key
unset tics
unset colorbox

set tmargin 0
set bmargin 0
set lmargin 0
set rmargin 0

set size ratio -1

set style line 1 lc rgb 'orange' pt 2 ps 0.75 lw 1  # --- grey crosses
set style line 101 lc rgb '#808080' lt 1 lw 1

set xrange [-1.75:1.55]
set yrange [-1.55:2.65]

set cbrange [0:40]
set cbtics 10 nomirror out scale 0.75 offset -0.5

set palette defined (1 '#1F78B4', 2 '#1F78B4' )

set label 11 at -1.25,2.4 left front tc rgb 'black' '\stepcounter{tmpcounter}\ft(\alph{tmpcounter})'
set label 12 at  0.4,2.4 left front tc ls 101
set label 13 at  0.4,2.1 left front tc ls 101
set label 14 at  0.4,1.8 left front tc ls 101
set label 15 tc ls 101


print_error(x) = x < 10 ? sprintf('$%2.1f^{\\circ}$',x) : sprintf('$%2.0f^{\\circ}$',x)
print_p(x) = x < 0.0001 ? sprintf('$<10^{-5}$',x) : sprintf('$%0.5f$',x)

print_RMSE_helper(x,p,alpha) = p < alpha ? sprintf('$\\mathbf{%2.1f}^{\\circ}$',x) : sprintf('$%2.1f^{\\circ}$',x)

print_RMSE(x,p,alpha) = sprintf('\\shortstack[l]{RMSE:\\\\%s}', print_RMSE_helper(x, p, alpha))
print_test(x) = sprintf('\\shortstack[l]{$p$-value:\\\\%s}', print_p(x) )

r_spread = 0.5

sx = 1.0/4
sy = 1.0/5

orix1 = 0*sx*0.9
orix2 = 1*sx*0.85
orix3 = 2*sx*0.85
orix4 = 3*sx*0.85

oriy1 = 4*sy
oriy2 = 3*sy
oriy3 = 2*sy
oriy4 = 1*sy
oriy5 = 0*sy

################################################################################
set multiplot

##### 1ST ROW ######

#### plot 1 ####
set size sx,sy
set origin orix1, oriy1

set label 12 'NFCHOA $\dagger$'
set label 13 '$M = 6$'
set label 14 'rect.'
unset label 15

filename = 'exp1_NFCHOA_L56_R006'
load 'plot.gnu'

#### plot 2 ####
set size sx,sy
set origin orix2, oriy1

set label 14 'max-$\mathbf r_E$'

filename = 'exp1_NFCHOA_L56_M006'
load 'plot.gnu'

#### plot 3 ####
set label 13 '$M = 13$'
set label 14 'rect.'

set size sx,sy
set origin orix3, oriy1

filename = 'exp1_NFCHOA_L56_R013'
load 'plot.gnu'

#### plot 4 ####
set size sx,sy
set origin orix4, oriy1

set label 14 'max-$\mathbf r_E$'

filename = 'exp1_NFCHOA_L56_M013'
load 'plot.gnu'

##### 2ND ROW #####

#### plot 5 ####
set size sx,sy
set origin orix1, oriy2

set label 13 '$M = 27$'
set label 14 'rect.'

filename = 'exp1_NFCHOA_L56_R027'
load 'plot.gnu'

#### plot 6 ####
set size sx,sy
set origin orix2, oriy2

set label 12 'NFCHOA $\ddagger$'
set label 13 '$M = 27$'
set label 14 'rect.'

filename = 'exp2_NFCHOA_L56_R027'
load 'plot.gnu'

#### plot 7 ####
set size sx,sy
set origin orix3, oriy2

set label 12 'NFCHOA $\dagger$'
set label 13 '$M = 27$'
set label 14 'max-$\mathbf r_E$'

filename = 'exp1_NFCHOA_L56_M027'
load 'plot.gnu'

#### plot 8 ####
set size sx,sy
set origin orix4, oriy2

set label 12 'NFCHOA $*$'
set label 13 '$M = 28$'
set label 14 'rect.'

filename = 'wierstorf_NFCHOA_L56_R028'
load 'plot.gnu'

##### 3RD ROW #####

#### plot 9 ####
set size sx,sy
set origin orix1, oriy3

set label 12 'NFCHOA $\dagger$'
set label 13 '$M = 300$'

filename = 'exp1_NFCHOA_L56_R300'
load 'plot.gnu'

#### plot 10 ####
set size sx,sy
set origin orix2, oriy3

set label 12 'WFS $\ddagger$'
set label 13 ''
set label 14 ''

filename = 'exp2_WFS_L56'
load 'plot.gnu'

#### plot 11 ####
set size sx,sy
set origin orix3, oriy3

set label 12 'WFS $*$'

filename = 'wierstorf_WFS_L56'
load 'plot.gnu'

##### 4TH ROW #####

#### plot 12 ####
set size sx,sy
set origin orix1, oriy4

set label 12 'LWFS-VSS $\ddagger$'
set label 13 '$R_l = 15\,\mathrm{cm}$'
set label 14 ''

filename = 'exp2_LWFS-VSS_L56_r15'
load 'plot.gnu'

#### plot 13 ####
set size sx,sy
set origin orix2, oriy4

set label 13 '$R_l = 30\,\mathrm{cm}$'

filename = 'exp2_LWFS-VSS_L56_r30'
load 'plot.gnu'

#### plot 14 ####
set size sx,sy
set origin orix3, oriy4

set label 13 '$R_l = 45\,\mathrm{cm}$'

filename = 'exp2_LWFS-VSS_L56_r45'
load 'plot_artefact.gnu'

##### 5TH ROW #####

#### plot 15 ####
set size sx,sy
set origin orix1, oriy5

set label 12 'LWFS-SBL $\ddagger$'
set label 13 '$M = 3$'
set label 14 'rect.'

filename = 'exp2_LWFS-SBL_L56_R003'
load 'plot.gnu'

#### plot 16 ####
set size sx,sy
set origin orix2, oriy5

set label 14 'max-$\mathbf r_E$'

filename = 'exp2_LWFS-SBL_L56_M003'
load 'plot.gnu'

#### plot 17 ####
set size sx,sy
set origin orix3, oriy5

set label 13 '$M = 27$'
set label 14 'rect.'

filename = 'exp2_LWFS-SBL_L56_R027'
load 'plot.gnu'

#### plot 18 ####
set size sx,sy
set origin orix4, oriy5

set label 14 'max-$\mathbf r_E$'

filename = 'exp2_LWFS-SBL_L56_M027'
load 'plot.gnu'

unset multiplot
###############################################################################

call 'plot.plt' 'fig'
