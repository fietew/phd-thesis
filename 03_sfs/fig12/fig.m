% angular spectra as inverse CHT of different window types

%*****************************************************************************
% Copyright (c) 2019      Fiete Winter                                       *
%                         Institut fuer Nachrichtentechnik                   *
%                         Universitaet Rostock                               *
%                         Richard-Wagner-Strasse 31, 18119 Rostock, Germany  *
%                                                                            *
% This file is part of the supplementary material for Fiete Winter's         *
% PhD thesis                                                                 *
%                                                                            *
% You can redistribute the material and/or modify it  under the terms of the *
% GNU  General  Public  License as published by the Free Software Foundation *
% , either version 3 of the License,  or (at your option) any later version. *
%                                                                            *
% This Material is distributed in the hope that it will be useful, but       *
% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY *
% or FITNESS FOR A PARTICULAR PURPOSE.                                       *
% See the GNU General Public License for more details.                       *
%                                                                            *
% You should  have received a copy of the GNU General Public License along   *
% with this program. If not, see <http://www.gnu.org/licenses/>.             *
%                                                                            *
% http://github.com/fietew/phd-thesis                 fiete.winter@gmail.com *
%*****************************************************************************

SFS_start;

%% Parameters
conf = SFS_config;

%% Variables
Nphi = 1024;
M = 7;

%% Computation
conf.modal_window = 'rect';
[~,Win_rect,phi] = modal_weighting(M,Nphi,conf);

conf.modal_window = 'max-rE';
[~,Win_maxrE] = modal_weighting(M,Nphi,conf);

% normalize to value at phi = 0
[~, idx] = min(abs(phi));
Win_rect = Win_rect./abs(Win_rect(idx));
Win_maxrE = Win_maxrE./abs(Win_maxrE(idx));

%% gnuplot
gp_save('windows.txt',[phi.', db(Win_rect).', db(Win_maxrE).']);