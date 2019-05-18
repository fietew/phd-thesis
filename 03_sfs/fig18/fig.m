% reproduced sound field for 2.5D LWFS-SBL for monochromatic point source
%

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
clear all;
close all;
%% Parameters
conf = SFS_config;

conf.plot.usedb = true;
conf.plot.useplot = true;

conf.N = 2^13;
conf.t0 = 'source';

conf.secondary_sources.geometry = 'circle';
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0 0 0];
conf.secondary_sources.number = 56;

conf.dimension = '2.5D';
conf.modal_window = 'max-rE';
conf.localwfs_sbl.fc = 1000;
conf.localwfs_sbl.Npw = 1024;
conf.localwfs_sbl.order = 28;

conf.xref = [-0.5,-0.75,0];

src = 'ps';
xs = [0, 2.5, 0];

X = [-1.5, 1.5];
Y = [-1.5, 1.5];
Z = 0;

%%
x0 = secondary_source_positions(conf);

N0 = size(x0,1);
Nfft = conf.N;
xref = conf.xref;
fs = conf.fs;

rs = vector_norm(xs-xref,2);
t = rs./conf.c;
factor = 1./(4*pi*rs);

fc = conf.localwfs_sbl.fc;
Nce = conf.localwfs_sbl.order;
Npw = conf.localwfs_sbl.Npw;

Nlr = ceil(Nce/2)*2;  % order of Linkwitz-Riley Coefficients
Wlr = fc/fs*2;  % normalised cut-off frequency of Linkwitz-Riley

%%

% === Local WFS for high frequencies ===
% Regular circular expansion of point source (highpass implicitly)
% Winter et al. (2017), eq. (14)
[pm,delay_circexp] = circexp_imp_ps(xs,Nce,xref,fc,conf);
% Modal window
wm = modal_weighting(Nce,conf);
pm = bsxfun(@times,wm,pm);
% Plane wave decomposition, Winter et al. (2017), eq. (10)
ppwd = pwd_imp_circexp(pm,Npw);
% Driving signal, Winter et al. (2017), eq. (9)
[dlwfs,delay_lwfs] = driving_function_imp_wfs_pwd(x0,ppwd,xref,conf);

[Plwfs,x,y] = sound_field_imp(X,Y,Z,x0,'ps',dlwfs,t+delay_lwfs+delay_circexp,conf);

% === WFS ===
% Secondary source selection
[~,xdx] = secondary_source_selection(x0,xs,'ps');
x0(xdx,:) = secondary_source_tapering(x0(xdx,:),conf);
% Driving signal
dwfs = zeros(Nfft,N0);
[dwfs(:,xdx),~,~,delay_lp] = driving_function_imp_wfs(x0(xdx,:),xs,'ps',conf);
% Coefficients for lowpass filtering of WFS driving function
[zlp,plp,klp] = linkwitz_riley(Nlr,Wlr,'low');  % LR Lowpass filter
% Lowpass filtering
[sos,g] = zp2sos(zlp,plp,klp,'down','none');  % generate sos
dwfslp = sosfilt(sos,dwfs)*g;

Pwfs = sound_field_imp(X,Y,Z,x0,'ps',dwfs,t+delay_lp ,conf);
Pwfslp = sound_field_imp(X,Y,Z,x0,'ps',dwfslp,t+delay_lp ,conf);
  
% === Crossover ===
% Winter et al. (2017), eq. (15)
% Get delay of delayline
[~,delay_delayline] = delayline(1,0,0,conf);
% Delay to compensate between lf-part and hf-part
delay_comp = delay_lp - (delay_lwfs+delay_circexp+delay_delayline);
% Combined driving signal
dap = dwfslp + delayline(dlwfs,delay_comp,1,conf);

Pap = sound_field_imp(X,Y,Z,x0,'ps',dap,t+delay_lp ,conf);

% === Compensate Phase-Distortions by Inverse Allpass ===
% Winter et al. (2017), eq. (17)
% TODO: ensure that the time-reserved filter is not truncated
[zap,pap,kap] = linkwitz_riley(Nlr,Wlr,'all');  % LR Allpass filter
[sos,g] = zp2sos(zap,pap,kap,'down','none');  % generate sos
% (time-reversed) allpass filtering
d = sosfilt(sos,dap(end:-1:1,:))*g;
d = d(end:-1:1,:);

P = sound_field_imp(X,Y,Z,x0,'ps',d,t+delay_lp ,conf);

%%
gp_save_matrix('Plwfs.dat', x,y, db(Plwfs./factor));
gp_save_matrix('Pwfslp.dat', x,y, db(Pwfslp./factor));
gp_save_matrix('Pwfs.dat', x,y, db(Pwfs./factor));
gp_save_matrix('Pap.dat', x,y, db(Pap./factor));
gp_save_matrix('P.dat', x,y, db(P./factor));

gp_save_loudspeakers('array.txt', x0);
gp_save('xref.txt', xref);

phi = (0:1:360).';
xfront = [xs(1)+rs*cosd(phi),xs(2)+rs*sind(phi)];
gp_save('front.txt', xfront);


