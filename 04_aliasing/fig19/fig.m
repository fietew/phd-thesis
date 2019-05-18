% comparison of point source with its bandlimited version

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
conf.resolution = 300;
conf.plot.usenormalisation = false;

X = [-1.5, 1.5];
Y = [-1.5, 1.5];
Z = 0;
Npw = 1024;
f = 2000;
k = 2*pi*f./conf.c;
M = 27;
Mref = ceil(k*sqrt(X(2).^2 + Y(2).^2));
xs = [-1, 2.5, 0];
src = 'ps';
xref = conf.xref;

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

% reference sound field (M -> "Inf")
Smref = circexp_mono_ps(xs,Mref,f,xref,conf);
Spwref = pwd_mono_circexp(Smref, Npw);
S = sound_field_mono(X,Y,Z,xpw,'pw',Spwref.',f,conf);

% normalisation factor
g = abs(sound_field_mono(xref(1),xref(2),xref(3),[xs,0,0,1,1],src,1,f,conf));

% bandlimited sound field
Sm = circexp_mono_ps(xs,M,f,xref,conf);
Spw = pwd_mono_circexp(Sm, Npw);
SM = sound_field_mono(X,Y,Z,xpw,'pw',Spw.',f,conf);

% scalar product of local wavenumber vectors
[gradSMx, gradSMy, gradSMz] = sound_field_gradient_mono(X,Y,Z,xpw,'pw',Spw.',f,conf);

kSM = -imag([gradSMx(:)./SM(:), gradSMy(:)./SM(:) , gradSMz(:)./SM(:)]);
kSM = bsxfun(@rdivide, kSM, vector_norm(kSM,2));

kscalar = zeros(size(x));
kscalar(:) = sum(kS.*kSM,2);  
alpha = acosd(kscalar);

% local wavenumber vector on subsampled grid
conf.resolution = 12;

[SMsub,xsub,ysub] = sound_field_mono(X,Y,Z,xpw,'pw',Spw.',f,conf);
[gradSMxsub, gradSMysub, gradSMzsub] = sound_field_gradient_mono(X,Y,Z,xpw,'pw',Spw.',f,conf);

kSMsub = -imag([gradSMxsub(:)./SMsub(:), gradSMysub(:)./SMsub(:) , gradSMzsub(:)./SMsub(:)]);
kSMsub = bsxfun(@rdivide, kSMsub, vector_norm(kSMsub,2));

% local modal order
mu = k.*vector_norm(cross(xvec,kS,2),2);
mu = reshape(mu,size(x));

% modal radius
rM = M/k;
phiM = (0:360).';
xM = rM*cosd(phiM);
yM = rM*sind(phiM);
 
%% plotting
conf.plot.usedb = false;
plot_sound_field(S./g,X,Y,Z,[],conf);

plot_sound_field(SM./g,X,Y,Z,[],conf);

conf.plot.usedb = true;
plot_sound_field((S-SM)./S,X,Y,Z,[],conf);

figure;
imagesc(X,Y,alpha);
hold on;
quiver(xsub(:),ysub(:),kSMsub(:,1), kSMsub(:,2), 'y');
hold off;
set(gca, 'YDir', 'normal');
  
%% gnuplot
gp_save_matrix('S.dat',x,y,real(S./g));
gp_save_matrix('SM.dat',x,y,real(SM./g));
gp_save_matrix('eps.dat',x,y,db(SM./S-1));
gp_save_matrix('alpha.dat',x,y,alpha);
gp_save_matrix('mu.dat',x,y,mu);
gp_save('rM.txt',[xM,yM]);
gp_save('kvec.txt',[xsub(:),ysub(:),kSMsub(:,1:2)]);
