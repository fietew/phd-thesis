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
conf.secondary_sources.number = 1024;
% high-resolution delayline
conf.delayline.filter = 'lagrange';
conf.delayline.filterorder = 9;
conf.delayline.resampling = 'pm';
conf.delayline.resamplingfactor = 8;
conf.delayline.resamplingorder = 64;

conf.dimension = '2.5D';
conf.t0 = 'source';

conf.N = 2^14;

%% Variables
xs = [0 -1 0];
src = 'pw';
hirs = dummy_irs(2^10, conf);  % impulse responses
posvec = [
    0.5, 0.0, 0.0
    0.0, 0.5, 0.0
    ];
x0 = secondary_source_positions(conf);

%% Computation
for M = [14, 28]
    conf.nfchoa.order = M;
    
    for pos = posvec.'
        
        for maxre = [0 1]
            if maxre
                conf.modal_window = 'max-rE';
            else
                conf.modal_window = 'rect';
            end
            
            
            % driving signal
            d = driving_function_imp_nfchoa(x0,xs,src,conf);
            % sound pressures at xref
            p = ir_generic(pos.', 0, x0, d, hirs, conf);  % without pre-filter
            % spectrum of sound field
            [Pabs, ~, f] = spectrum_from_signal(p(:,1), conf);
            Pabs = Pabs.*length(p(:,1))./2;
            % plotting
            semilogx(f, db(Pabs))
            hold on;
            % gnuplot
            filename = sprintf('P_x%2.2f_y%2.2f_M%d_maxre%d.txt',pos(1),pos(2),M,maxre);
            gp_save(filename, [f, db(Pabs)]);
        end       
    end
    
    dbplot = (-100:10).';
    r = 0.5;
    fM = M.*conf.c/(2.*pi*r).*ones(size(dbplot));
    gp_save(sprintf('fM_M%d.txt', M), [fM, dbplot]);
end