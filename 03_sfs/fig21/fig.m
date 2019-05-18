% effect of size of local region in 2.5 LWFS-VSS

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
conf.secondary_sources.geometry = 'circle';
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0 0 0];
conf.secondary_sources.number = 1024;
conf.dimension = '2.5D';
conf.driving_functions = 'default';
% WFS
conf.tapwinlen = 1.0;
conf.wfs.usehpre = false;
% LWFS-VSS
conf.localwfs_vss.method = 'wfs';
conf.localwfs_vss.number = 1024;
conf.localwfs_vss.center = [0.25, 0, 0];
conf.localwfs_vss.geometry = 'circle';
conf.localwfs_vss.driving_functions = 'default';
conf.localwfs_vss.tapwinlen = 1;
conf.localwfs_vss.consider_target_field = 0;
conf.localwfs_vss.consider_secondary_sources = 0;
conf.localwfs_vss.wfs.usehpre = false;
% MISC
conf.N = 2^14;
conf.dimension = '2.5D';
conf.t0 = 'source';
conf.xref = conf.localwfs_vss.center;

%% Variables
src = 'pw';
xs = [0,  -1, 0];

%% Computations

% dummy HIRS (dirac impulse)
hirs = dummy_irs(2^10, conf);

for rl = [0.25, 0.5, 0.75, Inf]
    conf.localwfs_vss.size = 2*rl;
    
    for tapwin = [0, 1]
        conf.usetapwin = tapwin;  % use tapering for SSD
        conf.localwfs_vss.usetapwin = tapwin;  % use tapering for virtual SSD
        
        % secondary sources
        x0 = secondary_source_positions(conf);
        % driving signal
        if isinf(rl)  % WFS
            x0 = secondary_source_selection(x0,xs,src);
            x0 = secondary_source_tapering(x0, conf);
            d = driving_function_imp_wfs(x0,xs,src,conf);
        else  % LWFS-VSS
            [d,x0] = driving_function_imp_localwfs_vss(x0,xs,src,conf);
        end
        % sound pressures at xref
        p = ir_generic(conf.xref, 0, x0, d, hirs, conf);  % without pre-filter
        % spectrum of sound field without pre-filter
        [A, ~, f] = spectrum_from_signal(p(:,1), conf);
        A = A.*length(p(:,1))./2;
        % spectrum of full bandwidth WFS pre-filter
        Hfull = sqrt(2*pi*f/conf.c);
        % sound pressure magnitude spectrum
        if isinf(rl)  % WFS
            Pabs = Hfull.*A;  % squared because h_pre(n) * h_pre(-n)
        else  % LWFS-VSS
            Pabs = Hfull.^2.*A;  % squared because h_pre(n) * h_pre(-n)
        end        
        % plotting
        semilogx(f, db(Pabs))
        hold on;
        % gnuplot
        filename = sprintf('P_Rl%2.2f_tap%d.txt', rl, tapwin);
        gp_save(filename, [f, db(Pabs)]);
    end
end
