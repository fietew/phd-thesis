% HF-Approximation of Bandlimited Sound Fields

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

%% Parameters
conf = SFS_config;

conf.plot.usenormalisation = false;

Npw = 1024;
f = 2000;
k = 2*pi*f./conf.c;
M = 27;
xs = [-1, 2.5, 0];
src = 'ps';
xref = conf.xref;
X = [-1.5, 1.5];
Y = [-1.5, 1.5];
Z = 0;

%% Computation

conf.xref = [0,1,0];

% local wavenumber vector
[x, y, z] = xyz_grid(X,Y,Z,conf);
xvec = [x(:),y(:)];
xvec(:,3) = z;
kS = local_wavenumber_vector(xvec,xs,src);

% PWD angles
phipw = (0:Npw-1).*2.*pi./Npw;
xpw = [cos(phipw.'),sin(phipw.')];
xpw(:,3) = 0;
xpw(:,4:6) = xpw(:,1:3);
xpw(:,7) = 1./Npw;

% virtual source
S = sound_field_mono(X,Y,Z,[xs,0,0,1,1],src,1,f,conf);

% normalisation factor
g = abs(sound_field_mono(xref(1),xref(2),xref(3),[xs,0,0,1,1],src,1,f,conf));

% bandlimited sound field
win = modal_weighting(M, Npw, conf);
win = [win(end:-1:2),win];
Sm = circexp_mono_ps(xs,M,f,xref,conf);
Spw = pwd_mono_circexp(Sm, Npw);

SM = sound_field_mono(X,Y,Z,xpw,'pw',Spw.',f,conf);

% hf-approximation of bandlimited sound field
mu = k.*vector_norm(cross(xvec,kS,2),2);
W = sinc(bsxfun(@minus,(-M:M),mu))*win.';
mu = reshape(mu, size(S));
W = reshape(W, size(S));
SMapprox_wm = S.*W;

% additional approximation of window function
select = mu > M;
SMapprox_am = SMapprox_wm;
SMapprox_am(select) = 0;

%% Plots
conf.plot.usedb = false;
plot_sound_field(S./g,X,Y,Z,[],conf);

plot_sound_field(SM./g,X,Y,Z,[],conf);
hold on;
contour(x,y,mu,[M,M],'g');
hold off;

plot_sound_field(SMapprox_wm./g,X,Y,Z,[],conf);
hold on;
contour(x,y,mu,[M,M],'g');
hold off;

plot_sound_field(SMapprox_am./g,X,Y,Z,[],conf);
hold on;
contour(x,y,mu,[M,M],'g');
hold off;

% conf.plot.usedb = true;
% plot_sound_field(SMapprox_wm./SM-1,X,Y,Z,[],conf);
% hold on;
% contour(x,y,mu,[M,M],'g');
% hold off;
%
% plot_sound_field(SMapprox_am./SM-1,X,Y,Z,[],conf);
% hold on;
% contour(x,y,mu,[M,M],'g');
% hold off;

%% gnuplot
gp_save_matrix('S.dat',x,y,real(S./g));
gp_save_matrix('SM.dat',x,y,real(SM./g));
gp_save_matrix('SMapprox_wm.dat',x,y,real(SMapprox_wm./g));
gp_save_matrix('SMapprox_am.dat',x,y,real(SMapprox_am./g));

gp_save_matrix('SM_dB.dat',x,y,db(SM./g));
gp_save_matrix('SMapprox_wm_dB.dat',x,y,db(SMapprox_wm./g));
gp_save_matrix('SMapprox_am_dB.dat',x,y,db(SMapprox_am./g));

gp_save_matrix('mu.dat',x,y,mu);
