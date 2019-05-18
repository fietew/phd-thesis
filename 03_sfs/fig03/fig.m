% effect of tapering in 2.5 LWFS-VSS

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
conf.delayline.filterorder = 3;
conf.delayline.resampling = 'pm';
conf.delayline.resamplingfactor = 4;
conf.delayline.resamplingorder = 64;
% secondary source distribution
conf.secondary_sources.geometry = 'sphere';
conf.secondary_sources.grid = 'gauss';
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0 0 0];
conf.secondary_sources.number = 2*60^2;
% WFS
conf.usetapwin = false;
conf.wfs.usehpre = false;
% MISC
conf.N = 2^14;
conf.dimension = '3D';
conf.t0 = 'source';

%% Variables
src = 'pw';
xs = [0,  -1, 0];

posvec = [%
    0, 0, 0;
    0.5, 0, 0;
    0,-0.5,0;
    0, 0.5,0].';


%% Computations

% dummy HIRS (dirac impulse)
hirs = dummy_irs(2^10, conf);

for pos = posvec    
    for tap = [0, 1]        
        % secondary sources
        x0 = secondary_source_positions(conf);
        x0 = secondary_source_selection(x0,xs,src);
        % custom tapering
        if tap
          x0(:,7) = x0(:,7).*sum(bsxfun(@times, x0(:,4:6), xs),2);
        end
        % driving signal
        d = driving_function_imp_wfs(x0,xs,src,conf);
        % sound pressures at xref
        p = ir_generic(pos.', 0, x0, d, hirs, conf);  % without pre-filter
        % spectrum of sound field without pre-filter
        [A, ~, f] = spectrum_from_signal(p(:,1), conf);
        A = A.*length(p(:,1))./2;
        % spectrum of full bandwidth 3D WFS pre-filter
        Hfull = 2*pi*f/conf.c;
        % sound pressure magnitude spectrum
        Pabs = Hfull.*A;  % squared because h_pre(n) * h_pre(-n)
        % plotting
        semilogx(f, db(Pabs))
        hold on;
        % gnuplot
        filename = sprintf('P_x%2.2f_y%2.2f_tap%d.txt', pos(1), pos(2), tap);
        gp_save(filename, [f, db(Pabs)]);
    end
end
