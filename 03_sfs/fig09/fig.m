% effect for 2.5D WFS pre-filter on sound pressure in synthesised sound field

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
SOFAstart;

%% Parameters
conf = SFS_config;

% high-resolution delayline 
conf.delayline.filter = 'lagrange';
conf.delayline.filterorder = 9;
conf.delayline.resampling = 'pm';
conf.delayline.resamplingfactor = 8;
conf.delayline.resamplingorder = 64;

% secondary source distribution
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0 0 0];
conf.secondary_sources.number = 56;

conf.dimension = '2.5D';
conf.xref = [0 0 0]; 
conf.usetapwin = false;  % do not use tapering window
conf.t0 = 'source';

conf.N = 2^14;

xs = [0 -1 0];
src = 'pw';

x0 = secondary_source_positions(conf);
x0 = secondary_source_selection(x0,xs,src);

hirs = dummy_irs(2^10, conf);  % impulse responses

% driving signal without pre-filter
conf.wfs.usehpre = false;  % will be applied manually
d = driving_function_imp_wfs(x0,xs,src,conf);

% sound pressures at xref 
p = ir_generic(conf.xref, 0, x0, d, hirs, conf);  % without pre-filter

% spectrum of sound field without pre-filter
[A, ~, f] = spectrum_from_signal(p(:,1), conf);
A = A.*length(p(:,1))./2;

% spectrum of full bandwidth pre-filter
Hfull = sqrt(2*pi*f/conf.c);

% spectrum of optimised pre-filter
Hopt = Hfull;
flow = 60;
fhigh = 1500;
idxfhigh = max(find(f<fhigh));
idxflow = min(find(f>flow));
Hopt(1:idxflow) = Hfull(idxflow);
Hopt(idxfhigh:end) = Hfull(idxfhigh);

% plotting
semilogx(...
    f, db(Hfull.*A), ...
    f, db(Hopt.*A) ...
    );
ylim([-40,20]);

% gnuplot
gp_save('Hfull.txt', [f, db(Hfull)]);
gp_save( 'Hopt.txt', [f, db(Hopt)]);
gp_save('Pfull.txt', [f, db(Hfull.*A)]);
gp_save( 'Popt.txt', [f, db( Hopt.*A)]);

