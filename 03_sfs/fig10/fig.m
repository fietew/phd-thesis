% effect for delayline in 2.5 WFS on sound pressure in synthesised sound field

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

% secondary source distribution
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0 0 0];

conf.wfs.usehpre = false;  % will be applied manually
conf.usetapwin = false;  % do not use tapering window

conf.dimension = '2.5D';
conf.xref = [0 0 0]; 
conf.t0 = 'source';

conf.N = 2^14;

%% Variables
xs = [0 -1 0];
src = 'pw';
hirs = dummy_irs(2^10, conf);  % impulse responses

%% Computation

for highres = [0 1]
    
    if highres
        % high-resolution delayline 
        conf.delayline.filter = 'lagrange';
        conf.delayline.filterorder = 9;
        conf.delayline.resampling = 'pm';
        conf.delayline.resamplingfactor = 8;
        conf.delayline.resamplingorder = 64;
    else
        % low-resolution delayline 
        conf.delayline.filter = 'integer';
        conf.delayline.filterorder = NaN;
        conf.delayline.resampling = 'none';
        conf.delayline.resamplingfactor = NaN;
        conf.delayline.resamplingorder = NaN;
    end
    
    for N0 = [56, 1024]
        conf.secondary_sources.number = N0;    
        x0 = secondary_source_positions(conf);
        x0 = secondary_source_selection(x0,xs,src);
        % driving signal
        d = driving_function_imp_wfs(x0,xs,src,conf);
        % sound pressures at xref 
        p = ir_generic(conf.xref, 0, x0, d, hirs, conf);  % without pre-filter
        % spectrum of sound field without pre-filter
        [A, ~, f] = spectrum_from_signal(p(:,1), conf);
        A = A.*length(p(:,1))./2;
        % spectrum of full bandwidth 2.5D WFS pre-filter
        Hfull = sqrt(2*pi*f/conf.c);
        % sound pressure magnitude spectrum
        Pabs = Hfull.*A;  % squared because h_pre(n) * h_pre(-n)
        % plotting
        semilogx(f, db(Pabs))
        hold on;
        % gnuplot
        filename = sprintf('P_L%d_highres%d.txt', N0, highres);
        gp_save(filename, [f, db(Pabs)]);
    end
end