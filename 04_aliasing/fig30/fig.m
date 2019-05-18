% sound field and error and aliasing freq. for virtual point source in LWFS-VSS

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
conf.localwfs_vss.method = 'wfs';
conf.localwfs_vss.number = 512;
conf.localwfs_vss.consider_secondary_sources = false;
conf.localwfs_vss.consider_target_field = false;

Lref = 512;
L = 56;
Mref = 70;
Rcvec = 0.2:0.2:1.0;
xc = [0.5, 0 ,0];
R = conf.secondary_sources.size/2;
xps = [0 2.5 0];
f = 2500;
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

%% Sound Fields
for Rc = Rcvec
    
    xref = xc;
    conf.localwfs_vss.center = xc;
    conf.localwfs_vss.size = 2*Rc;
    
    % aliasing frequency at x
    minmax_kSt_fun = @(x0t) minmax_kt_circle(x0t, xc, Rc);
    minmax_kGt_fun = @(x0t,xt) minmax_kt_circle(x0t, xt, 0);
    fS = aliasing_extended_control(x0gt, kSx0gt, xvec, minmax_kGt_fun, ...
        minmax_kSt_fun, conf);
    fS = reshape(fS, size(x));
    
    % normalisaton factor
    g = sound_field_mono(xref(1), xref(2), xref(3), [xps, 0, 1, 0, 1], 'ps', ...
        1, f, conf);
    
    % local region
    phiplot = (0:1:360).';
    xplot = [xc(1) + Rc.*cosd(phiplot), xc(2) + Rc.*sind(phiplot)];
    
    % ground truth sound field
    conf.secondary_sources.number = Lref;
    Pgt = sound_field_mono_localwfs_vss(X,Y,Z,xps,'ps',f,conf);
    Pgt = Pgt./abs(g);
    x0 = secondary_source_positions(conf);
    
    plot_sound_field(Pgt,X,Y,Z,x0,conf);
    hold on;
    plot(xref(1),xref(2),'kx');
    plot(xplot(:,1), xplot(:,2), 'k--');
    hold off;
    
    % monochromatic LWFS-VSS driving function
    conf.secondary_sources.number = L;
    [P,x,y] = sound_field_mono_localwfs_vss(X,Y,Z,xps,'ps',f,conf);
    P = P./abs(g);
    x0 = secondary_source_positions(conf);
    
    plot_sound_field(P,X,Y,Z,x0,conf);
    hold on;
    plot(xref(1),xref(2),'kx');
    plot(xplot(:,1), xplot(:,2), 'k--');
    hold off;
    
    % error
    eps = db((P-Pgt)./Pgt);
    
    % gnuplot
    filesuffix = sprintf('_Rc%2.2f', Rc);
    
    gp_save_matrix(['fS' filesuffix '.dat'],x,y,fS);
    gp_save_matrix(['P' filesuffix '.dat'], x, y, real(P));
    gp_save_matrix(['Pgt' filesuffix '.dat'], x, y, real(Pgt));
    gp_save_matrix(['eps' filesuffix '.dat'], x, y, eps);
    
    gp_save(['local_region' filesuffix '.txt'], xplot);
    gp_save(['xc' filesuffix '.txt'], xc);
end

%% SSD
conf.secondary_sources.number = L;
x0 = secondary_source_positions(conf);
gp_save_loudspeakers('array.txt',x0);
