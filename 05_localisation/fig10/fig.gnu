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

set loadpath '../../gnuplot/'

load 'standalone.cfg'

# latex
set terminal epslatex size @dissfullwidth,13cm color colortext standalone header diss10pt.footnotesize
set output 'fig.tex'

# variables
cfHz=''  # Gammatone Center Frequencies
stats 'fc.txt' u 1:(cfHz = cfHz.sprintf('%4.0f ',$1)) nooutput
itd_idx_min = 1
itd_idx_max = 16
ild_idx_min = itd_idx_max+1
ild_idx_max = words(cfHz)
# functions
kilo(x) = (x > 1000) ? sprintf("%.01fk", (int((x+0.0)/100+0.5)+0.0)/10) : x
# borders
load 'xyborder.cfg'
# legend
unset key
# y-axis
set yrange [0:46]
# x-axis (ITD)
scale = 0.5
itd_range_max = 2
set xrange [-itd_range_max*scale:itd_range_max*scale]
# x2-axis (ILD)
ild_range_max = 40
set x2range [-ild_range_max*scale:ild_range_max*scale]
unset x2label
unset x2tics
unset format x2
# colorbar
unset colorbox
set cbrange [0:1]
# general style
set style fill transparent solid 0.75 border
set clip two
# labels
load 'labels.cfg'
set label 1 center
set label 2 at graph 1.05, 0.0 left rotate by 90
set label 3 at graph 1.0, 0.86 right
set label 4 at graph 0.0, 0.86 left '\stepcounter{tmpcounter}\ft(\alph{tmpcounter})'
# arrow
set arrow from first 0, graph 0 to first 0, ild_idx_max+4 front nohead ls 101 dt 2 lw 2
# margins
set tmargin 0
set bmargin 0
set lmargin 0
set rmargin 0

lef = \
  "set ylabel '\\ft centre frequency / Hz' offset 6,-0.75; \
   set ytics offset 1,0 nomirror out scale 0.75 \
    ( '\\ft '.kilo(word(cfHz, itd_idx_min)) itd_idx_min\
    , '\\ft '.kilo(word(cfHz, itd_idx_max)) itd_idx_max\
    , '\\ft '.kilo(word(cfHz, ild_idx_max)) ild_idx_max\
    )"

rig = \
  "unset ytics; \
   unset ylabel"

sx = 0.228
sy = 0.27
xshift = 0.07
xscale = 1.02
yshift = 0.13
yscale = 1.09

orix1 = 0*sx*xscale + xshift
orix2 = 1*sx*xscale + xshift
orix3 = 2*sx*xscale + xshift
orix4 = 3*sx*xscale + xshift

oriy1 = 2*sy*yscale + yshift
oriy2 = 1*sy*yscale + yshift
oriy3 = 0*sy*yscale + yshift

################################################################################
set multiplot

##### 1ST ROW ######

#### plot 1 ####
set size sx,sy
set origin orix1, oriy1
@lef
# palette
load 'sequential/Greys.plt'
# labels
set label 1 at graph 0.5, 1.0 'calibration condition'
set label 3 'ground truth'
# borders
set border 0
# x-axis
unset xtics
unset xlabel

datafile = 'brs_posx0.00_posy0.00_ref_gt1'
load 'hist.gnu'

#### plot 2 ####
set size sx,sy
set origin orix2, oriy1
@rig
# labels
set label 1 'WFS'
# palette
load 'sequential/Blues.plt'
# plotting
datafile = 'brs_posx-1.25_posy0.00_circular_nls0056_dls3.00_wfs_gt1'
load 'hist.gnu'

#### plot 3 ####
set size sx,sy
set origin orix3, oriy1
# labels
set label 1 at graph 1.025, 1.0 'NFCHOA $M = 6$ rect.'
# palette
load 'sequential/Oranges.plt'
# plotting
datafile = 'brs_win-rect_ord-6_pos-7(-1.25x_0.00y)_gt1'
load 'hist.gnu'

#### plot 4 ####
set size sx,sy
set origin orix4, oriy1
# labels
set label 1 ''
set label 3 'perceived'
# plotting
datafile = 'brs_win-rect_ord-6_pos-7(-1.25x_0.00y)_gt0'
load 'hist.gnu'

##### 2ND ROW ######

#### plot 5 ####
set size sx,sy
set origin orix1, oriy2
@lef
# labels
set label 1 'LWFS-VSS $\sfRlocal=15$\,cm'
set label 3 'ground truth'
# palette
load 'sequential/Reds.plt'
# plotting
datafile = 'brs_posx-1.25_posy0.00_circular_nls0056_dls3.00_lwfs-vss_circular_nvs1024_dvs0.30_wfs_gt1'
load 'hist.gnu'

#### plot 6 ####
set size sx,sy
set origin orix2, oriy2
@rig
# labels
set label 1 ''
set label 3 'perceived'
# plotting
datafile = 'brs_posx-1.25_posy0.00_circular_nls0056_dls3.00_lwfs-vss_circular_nvs1024_dvs0.30_wfs_gt0'
load 'hist.gnu'

#### plot 7 ####
set size sx,sy
set origin orix3, oriy2
# labels
set label 1 'LWFS-VSS $\sfRlocal=45$\,cm'
set label 3 'ground truth'
# plotting
datafile = 'brs_posx-1.25_posy0.00_circular_nls0056_dls3.00_lwfs-vss_circular_nvs1024_dvs0.90_wfs_gt1'
load 'hist.gnu'

#### plot 8 ####
set size sx,sy
set origin orix4, oriy2
# labels
set label 1 ''
set label 3 'perceived'
# plotting
datafile = 'brs_posx-1.25_posy0.00_circular_nls0056_dls3.00_lwfs-vss_circular_nvs1024_dvs0.90_wfs_gt0'
load 'hist.gnu'

##### 3rd ROW ######

#### plot 9 ####
set size sx,sy
set origin orix1, oriy3
@lef
# palette
load 'sequential/Greens.plt'
# labels
set label 1 'LWFS-SBL $M = 3$ rect.'
set label 3 'ground truth'
# x-axis
set border 1
set xtics 0.75 offset 0,0.5 nomirror out scale 0.75
set xlabel 'ITD / ms' offset 0,1.25
set format x '$%g$'
# custom x2-axis
x2axis_pos = -0.225
set arrow nohead from graph 0, x2axis_pos rto graph 1, 0 ls 101
set label 'ILD / dB' at graph 0.5, x2axis_pos-0.2 center
set label 'left' at graph 0.0, x2axis_pos+0.05 front left tc ls 101
set label 'right' at graph 1.0, x2axis_pos+0.05 front right tc ls 101
do for [xpos=-15:15:10] {
  set arrow nohead from second xpos, graph x2axis_pos rto graph 0, -0.025 ls 101
  set label at second xpos, graph x2axis_pos-0.1 sprintf('$%d$',xpos) center tc ls 101
}
# plotting
datafile = 'brs_posx-1.25_posy0.00_circular_nls0056_dls3.00_lwfs-sbl_M03_rect_npw1024_gt1'
load 'hist.gnu'

#### plot 10 ####
set size sx,sy
set origin orix2, oriy3
@rig
# labels
set label 1 ''
set label 3 'perceived'
# plotting
datafile = 'brs_posx-1.25_posy0.00_circular_nls0056_dls3.00_lwfs-sbl_M03_rect_npw1024_gt0'
load 'hist.gnu'

#### plot 11 ####
set size sx,sy
set origin orix3, oriy3
@rig
# labels
set label 1 'LWFS-SBL $M = 27$ max-$\mathbf r_E$'
set label 3 'ground truth'
# plotting
datafile = 'brs_posx-1.25_posy0.00_circular_nls0056_dls3.00_lwfs-sbl_M27_max-rE_npw1024_gt1'
load 'hist.gnu'

#### plot 12 ####
set size sx,sy
set origin orix4, oriy3
# labels
set label 1 ''
set label 3 'perceived'
# plotting
datafile = 'brs_posx-1.25_posy0.00_circular_nls0056_dls3.00_lwfs-sbl_M27_max-rE_npw1024_gt0'
load 'hist.gnu'

unset multiplot
###############################################################################

unset output
call 'plot.plt' 'fig'
