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
load 'standalone.cfg'

################################################################################
set t epslatex size @dissfullwidth,12cm color colortext standalone header diss10pt.scriptsize
set output 'fig.tex'

unset key

# color palette
load 'sequential/Greys.plt'
# labels
set label 1 at graph 0.0, 1.125 front left '\stepcounter{tmpcounter}\ft(\alph{tmpcounter})'
set label 2 at graph 0.1, 1.125 front left
set label 3 at graph 0.0, 1.05 front left
set label 5 at graph 0.27, 0.8  front left tc ls 2
set label 6 at graph 0.27, 0.9  front left tc ls 6 'Listener at $[-0.5,0.75,0]^{\mathrm T}$ m'

set label 8 front center tc rgb '#808080'
set label 9 front center tc rgb '#808080'
# arrows
set arrow 1 from graph 0, first 0 to graph 1.0, first 0 nohead lc rgb '#00aa00' lw 3
set arrow 2 nohead lc rgb '#808080' lw 3
set arrow 3 nohead lc rgb '#808080' lw 3
# border
load 'xyborder.cfg'
# axes
set format '$%g$'
set tics scale 0.75 out nomirror
# x-axis
set xtics offset 0,-0.05
set xlabel offset 0,3
# y-axis
set yrange [-0.05:1]
set ylabel offset 3,0
set ytics 1 offset 0.5,-0.1 right
set mytics 2
LABEL_Y = 'perceived coloration'
# margins
set tmargin 2.5
set bmargin 2.5
set lmargin 0
set rmargin 0
# legend
set key autotitle columnhead
unset key
# grid
load 'grid.cfg'
set grid mytics ytics
# functions
col2xlabel(x) = sprintf('%s', strcol(x))
# style
load 'qualitative/Paired.plt'
set style fill transparent solid 1 # border -1
# variables
orix1 = 0.03
orix2 = 0.36
orix3 = 0.69
oriy1 = 0.52
oriy2 = 0.02
shift = 0.1

set style increment user
################################################################################
set multiplot

set size 0.31,0.5

#### Run 1 & 2 #####
LABEL_X = ''
# labels
set label 2 'Noise stimulus'
set label 3 'rect. window, $M=27$ (LWFS-SBL)'
set label 5 'Listener at $[0,0,0]^{\mathrm T}$ m'
set label 8 at first 7, graph -0.26 'LWFS-SBL with varying $N_{\mathrm{pw}}$'
# arrow
set arrow 2 from first 4.5, graph -0.2 to first 9.5, graph -0.2
# positioning
set origin orix1,oriy1
# x-axis
set xrange [1.5:9.5]
set xtics (\
  'WFS' 2,\
  '\shortstack{\scs NFC-\\\scs HOA}' 3,\
  'Stereo' 4,\
  '$1024$' 5,\
  '$512$' 6,\
  '$256$' 7,\
  '$128$' 8,\
  '$64$' 9,\
  )
# y-axis
set ylabel '$\tilde \Delta^{c_1,\mathrm{Ref}}$'
# plotting
plot '../results/exp1/diffvsRef_set1_LWFS-SBL_Npw_noise_center.txt' u ($0-shift):3:6:7 w yerrorbars ls 2 pt 7 lw 3,\
     '../results/exp1/diffvsRef_set3_LWFS-SBL_Npw_noise_off.txt' u ($0+shift):3:6:7 w yerrorbars ls 6 pt 7 lw 3

#### Run 5 #####
# labels
set label 3 'rect. window, $N_{\mathrm{pw}}=1024$ (LWFS-SBL)'
set label 5 ''
set label 8 at first 6, graph -0.26 'LWFS-SBL with varying $M$'
# arrow
set arrow 2 from first 2.5, graph -0.2 to first 9.5, graph -0.2
# x-axis
set xtics (\
  'WFS' 2,\
  '$27$' 3,\
  '$23$' 4,\
  '$19$' 5,\
  '$15$' 6,\
  '$11$' 7,\
  '$7$' 8,\
  '$3$' 9,\
  )
# y-axis
set ylabel ''
set format y ''
# positioning
set origin orix2,oriy1
# plotting
plot '../results/exp1/diffvsRef_set5_LWFS-SBL_M_off.txt' u 0:3:6:7 w yerrorbars ls 6 pt 7 lw 3

#### Run 6 #####
# labels
set label 3 '$N_{\mathrm{pw}}=1024$ (LWFS-SBL)'
set label 8 at first 5, graph -0.26 'LWFS-SBL with varying $M$ and $\sfwindow[prefix=cht,subscript=cylm]^M$'
# arrow
set arrow 2 from first 2.5, graph -0.2 to first 7.5, graph -0.2
# positioning
set origin orix3,oriy1
# x-axis
set xrange [1.5:7.5]
set xtics offset 0,-0.05
set xtics (\
  'WFS' 2,\
  '\shortstack{$27$\\rect.}' 3,\
  '\shortstack{$27$\\max-$\mathbf r_E$}' 4,\
  '\shortstack{$23$\\max-$\mathbf r_E$}' 5,\
  '\shortstack{$19$\\rect.}' 6,\
  '\shortstack{$19$\\max-$\mathbf r_E$}' 7\
  )
# plotting
plot '../results/exp2/diffvsRef_set5_LWFS-SBL_window_off.txt' u 0:3:6:7 w yerrorbars ls 6 pt 7 lw 3

#### Run 7 & 8 #####
# labels
set label 2
set label 3 '$N_{\mathrm{fs}}=1024$ (LWFS-VSS)'
set label 5 'Listener at $[0,0,0]^{\mathrm T}$ m'
set label 8 at first 5, graph -0.26 'LWFS-VSS with varying radius $\sfRlocal$ / cm'
# arrow
set arrow 2 from first 2.5, graph -0.2 to first 7.5, graph -0.2
# x-axis
set xtics (\
  'WFS' 2,\
  '$15$' 3,\
  '$22.5$' 4,\
  '$30$' 5,\
  '$37.5$' 6,\
  '$45$' 7\
  )
# y-axis
set ylabel '$\tilde \Delta^{c_1,\mathrm{Ref}}$'
set format y '$%g$'
# positioning
set origin orix1,oriy2
# plotting
plot '../results/exp2/diffvsRef_set1_LWFS-VSS_radius_center.txt' u ($0-shift):3:6:7 w yerrorbars ls 2 pt 7 lw 3,\
     '../results/exp2/diffvsRef_set2_LWFS-VSS_radius_off.txt' u ($0+shift):3:6:7 w yerrorbars ls 6 pt 7 lw 3

#### Run 3 & 4 #####
# labels
set label 2 'Speech Stimulus'
set label 3 'rect. window, $M=27$ (LWFS-SBL)'
set label 8 at first 7, graph -0.26 'LWFS-SBL with varying $N_{\mathrm{pw}}$'
# arrow
set arrow 2 from first 4.5, graph -0.2 to first 9.5, graph -0.2
# positioning
set origin orix2,oriy2
# y-axis
set ylabel ''
set format y ''
# x-axis
set xrange [1.5:9.5]
set xtics (\
  'WFS' 2,\
  '\shortstack{\scs NFC-\\\scs HOA}' 3,\
  'Stereo' 4,\
  '$1024$' 5,\
  '$512$' 6,\
  '$256$' 7,\
  '$128$' 8,\
  '$64$' 9,\
  )
# plotting
plot '../results/exp1/diffvsRef_set2_LWFS-SBL_Npw_speech_center.txt' u ($0-shift):3:6:7 w yerrorbars ls 2 pt 7 lw 3,\
     '../results/exp1/diffvsRef_set4_LWFS-SBL_Npw_speech_off.txt' u ($0+shift):3:6:7 w yerrorbars ls 6 pt 7 lw 3

#### Run 9 & 10 #####
# labels
set label 2 'Noise stimulus'
set label 3 '$N_{\mathrm{pw}} = N_{\mathrm{fs}} = 1024$ (LWFS-SBL, LWFS-VSS)'
set label 8 at first 4.5, graph -0.26 'LWFS-VSS'
set label 9 at first 6.5, graph -0.26 'LWFS-SBL'
# arrow
set arrow 2 from first 3.7, graph -0.2 to first 5.3, graph -0.2
set arrow 3 from first 5.5, graph -0.2 to first 7.5, graph -0.2
# x-axis
set xrange [1.5:7.5]
set xtics (\
  'WFS' 2,\
  '\shortstack{\scs NFC-\\\scs HOA}' 3,\
  '$30$' 4,\
  '$45$' 5,\
  '\shortstack{$27$\\max-$\mathbf r_E$}' 6,\
  '\shortstack{$19$\\rect.}' 7,\
  )
# positioning
set origin orix3,oriy2
# plotting
plot '../results/exp2/diffvsRef_set3_LSFS-comparison_center.txt' u ($0-shift):3:6:7 w yerrorbars ls 2 pt 7 lw 3,\
     '../results/exp2/diffvsRef_set4_LSFS-comparison_off.txt' u ($0+shift):3:6:7 w yerrorbars ls 6 pt 7 lw 3,\

unset multiplot
################################################################################

call 'plot.plt' 'fig'
