% optimal radius for virtual SSD in LWFS-VSS

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

conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0,0,0];
conf.c = 343;
conf.resolution = 300;

xs = [0,2.5,0];
src = 'ps';

Lref = 2^16;
L = 56;
R = conf.secondary_sources.size/2;
Rl = 0.085;
Rcvec = linspace(0.001, 2*R, 200);  % consider maximum Rc
Reps = Rcvec(2) - Rcvec(1);

x = -1.0:0.5:0;
y = -0.75:0.75:0.75;
[y,x] = meshgrid(y,x);
x = x(:);
x = [x; 0];
y = y(:);
y = [y; 1.25];

%% Aliasing Frequency for different xl==xc and M
% x0 and local wavenumber kS(x0) of virtual sound field at x0
conf.secondary_sources.number = Lref;
x0 = secondary_source_positions(conf);
x0 = secondary_source_selection(x0,xs,src);  % a_S(x0) >= 0
x0(:,7) = 2.*pi.*R./L;  % sampling distance deltax0

% local wavenumber of virtual sound field at x0
kSx0 = local_wavenumber_vector(x0(:,1:3), xs, src);

% evaluation points x
xvec = [x(:), y(:)];
xvec(:,3) = 0;
xl = xvec;

% aliasing frequency at x for M
minmax_kGt_fun = @(x0p,xp) minmax_kt_circle(x0p,xp,Rl);
fS = nan(size(Rcvec,2), size(xvec,1));
fSRl = zeros(1,size(xvec,1));
fSWFS = zeros(1,size(xvec,1));

for xdx = 1:size(xvec,1)
    xl = xvec(xdx,:);
    xc = xvec(xdx,:);
    
    rdx = 0;
    for Rc = Rcvec;
        rdx = rdx + 1;
        minmax_kSt_fun = @(x0t) minmax_kt_circle(x0t, xc, Rc);
        minmax_kGt_fun = @(x0t,xt) minmax_kt_circle(x0t, xt, 0);
        fStmp = aliasing_extended_control(x0, kSx0, xl, minmax_kGt_fun, ...
           minmax_kSt_fun, conf);
        
        if Rc + norm(xc) <= R + 0.5*Reps
            fS(rdx,xdx) = fStmp;
        end
    end
    
    minmax_kSt_fun = @(x0t) minmax_kt_circle(x0t, xc, Rl);
    fSRl(xdx) = aliasing_extended_control(x0, kSx0, xl, minmax_kGt_fun, ...
        minmax_kSt_fun, conf);
    
    fSWFS(xdx) = aliasing_extended(x0, kSx0, xl, minmax_kGt_fun, conf);
end

% plotting
figure;
semilogy(Rcvec,fS.');
set(gca, 'ColorOrderIndex', 1);
xlim([Rcvec(1),Rcvec(end)]);
ylim([1000,20000]);
xlabel('M');
ylabel('f^S / Hz');

% gnuplot
gp_save('fS.txt',[Rcvec.',fS]);
gp_save('fSRl.txt',[Rl, fSRl]);
gp_save('fSWFS.txt',[[Rcvec(1); Rcvec(end)], [fSWFS; fSWFS]]);
gp_save('pos.txt', [x,y]);

%% Aliasing Frequency near Rl=Rc

% % RSr = M/kS
% RSr = bsxfun(@rdivide, Rcvec.', 2*pi*fS./conf.c);
% % find M for which RSr which is very close to Rl
% [~, rdx] = min(abs(RSr - Rl), [],1);
% MSr = Rcvec(rdx);
% % calculate frequency correspoding to kR == M
% fSr = MSr./(2*pi.*Rl)*conf.c;
% % gnuplot
% gp_save('fSr.txt', [MSr; fSr].');
% 
gS = fSRl./fSWFS;

%% Radius caused by Modal Bandwidth limitation
f = logspace(0,6,100);
Rl = 0.085*ones(size(f));

% Ml = 2.*pi.*f.*Rl/conf.c;
% 
gp_save('Rl.txt',[f; Rl].');

%% SSD
conf.secondary_sources.number = L;
x0 = secondary_source_positions(conf);
gp_save_loudspeakers('array.txt',x0);

