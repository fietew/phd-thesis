% sound field and local wavenumber vector of monochromatic point source

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
addpath('../../matlab');

%% Config
conf = SFS_config;

%% Variables
xs = [0, 1, 0];
f = 1000;
X = [-1.5, 1.5];
Y = [-1.5, 1.5];
Z = 0;

%% Sound Field
conf.resolution = 300;
% ground truth
[P,x,y,z] = sound_field_mono_point_source(X,Y,Z,xs,f,conf);
% normalise to coordinate origin
g = abs(sound_field_mono_point_source(0,0,0,xs,f,conf));
P = P./g;

%% Local Wavenumber Vector
conf.resolution = 12;
[xk,yk] = xyz_grid(X,Y,Z,conf);
xk = [xk(:),yk(:)];
xk(:,3) = Z;
k = local_wavenumber_vector(xk, xs, 'ps');

%% gnuplot
gp_save_matrix('P.dat',x,y,real(P));
gp_save('k.txt', [xk,k]);
