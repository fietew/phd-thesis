# Call this script together with a file base name to run pdflatex on it

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

unset output
!pdflatex --shell-escape @ARG1.tex
!rm @ARG1.tex \
    @ARG1.aux \
    @ARG1-inc.eps \
    @ARG1-inc-eps-converted-to.pdf \
    @ARG1.log \
