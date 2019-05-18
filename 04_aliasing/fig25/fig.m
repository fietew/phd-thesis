% sound field and error and aliasing freq. for virtual point source in LWFS-SBL

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

addpath('../../matlab');
SFS_start;

%% Parameters
conf = SFS_config;

conf.plot.usenormalisation = false;
conf.plot.normalisation = 'center';
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0,0,0];
conf.c = 343;
conf.resolution = 300;
conf.xref = [-0.5,0.75,0];
conf.localwfs_sbl.Npw = 256;
conf.localwfs_sbl.fc = 1000;

Lref = 128;
L = 56;
Mref = 70;
Mvec = 7:5:27;
windowvec = {'max-rE'};
R = conf.secondary_sources.size/2;
xps = [0 2.5 0];
[phips, rps] = cart2pol(xps(1), xps(2));
f = 2000;
k = 2*pi*f/conf.c;
xref = conf.xref;

gp_save('xref.txt', xref)  % gnuplot

%% Aliasing Frequency
% x0 and local wavenumber kS(x0) of virtual sound field at x0
conf.secondary_sources.number = Lref;
x0gt = secondary_source_positions(conf);
x0gt = secondary_source_selection(x0gt,xps,'ps');  % a_S(x0) >= 0
x0gt(:,7) = 2.*pi.*R./L;  % sampling distance deltax0

% evaluation points x
X = [-1.55, 1.55];
Y = [-1.55, 1.55];
Z = 0;
[x,y,~] = xyz_grid(X,Y,Z,conf);
xvec = [x(:), y(:)];
xvec(:,3) = 0;

% local wavenumber of virtual sound field at x0gt
kSx0gt = local_wavenumber_vector(x0gt(:,1:3), xps, 'ps');

% local wavenumber of virtual sound field at x
kSx = local_wavenumber_vector(xvec, xps, 'ps');

%% Sound Fields
for M = Mvec
  for window = windowvec
    filesuffix = sprintf('_M%d_%s.dat', M, window{1});

    % aliasing frequency at x
    fS = aliasing_modal(x0gt, kSx0gt, xvec, xref, M, conf);
    fS = reshape(fS, size(x));

    % bandwidth limitation frequency at x
    fM = M*conf.c./(2*pi*vector_norm(cross(bsxfun(@minus,xvec,xref),kSx,2),2));
    fM = reshape(fM, size(x));

    % normalisaton factor
    g = sound_field_mono(xref(1), xref(2), xref(3), [xps, 0, 1, 0, 1], 'ps', 1, f, conf);

    % ground truth sound field
    conf.secondary_sources.number = Lref;
    conf.localwfs_sbl.order = Mref;
    conf.modal_window = window{1};
    Pgt = sound_field_mono_localwfs_sbl(X,Y,Z,xps,'ps',f,conf);
    Pgt = Pgt./abs(g);
    
    plot_sound_field(Pgt,X,Y,Z,[],conf);
    hold on;
    plot(xref(1),xref(2),'kx');
    hold off;
    
    % monochromatic NFCHOA driving function with modal windowing
    conf.secondary_sources.number = L;
    conf.localwfs_sbl.order = M;
    conf.modal_window = window{1};
    [P,x,y] = sound_field_mono_localwfs_sbl(X,Y,Z,xps,'ps',f,conf);
    P = P./abs(g);
    
    plot_sound_field(P,X,Y,Z,[],conf);
    hold on;
    plot(xref(1),xref(2),'kx');
    hold off;
    
    % error
    eps = db((P-Pgt)./Pgt);

    % gnuplot
    gp_save_matrix(['fS' filesuffix],x,y,fS);
    gp_save_matrix(['fM' filesuffix],x,y,fM);
    gp_save_matrix(['P' filesuffix], x, y, real(P));
    gp_save_matrix(['Pgt' filesuffix], x, y, real(Pgt));
    gp_save_matrix(['eps' filesuffix], x, y, eps);
  end
end

%% SSD
conf.secondary_sources.number = L;
x0 = secondary_source_positions(conf);
gp_save_loudspeakers('array.txt',x0);
