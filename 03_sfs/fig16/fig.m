% reproduced sound field for 2.5D LWFS-SBL of monochromatic plane wave with
% different modal bandwidths and modal windows

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
conf.secondary_sources.geometry = 'circle';
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0 0 0];
conf.secondary_sources.number = 512;
conf.dimension = '2.5D';
conf.localwfs_sbl.Npw = 512;
conf.usetapwin = 0;

%% Variables
src = 'pw';
xs = [0,  -1, 0];

X = [-1.5, 1.5];
Y = [-1.5, 1.5];
Z = 0;

f = 1000;

%% Computation
% secondary sources
x0 = secondary_source_positions(conf);

for M = [7, 14]    
    conf.localwfs_sbl.order = M;  
    for window = {'rect', 'max-rE'}
        conf.modal_window = window{1};   
    
        for xshift = linspace(0.25,0.75,2)
            xc = [xshift,0,0];
            conf.xref = xc;

            % ground truth
            Ppw_gt = sound_field_mono_plane_wave(X,Y,Z,xs,f,conf);
            % driving function
            D = driving_function_mono_localwfs_sbl(x0,xs,src,f,conf);
            % reproduced sound field
            [P,x,y] = sound_field_mono(X,Y,Z,x0,'ps',D,f,conf);
            % normalised absolute error
            P_error = abs(1 - P./Ppw_gt);

            
            %% local region of correct synthesis
            phiM = (0:1:360).';
            rM = M.*conf.c/(2*pi*f);
            xM = [xc(1)+rM.*cosd(phiM), xc(2)+rM.*sind(phiM)];
            
            %% gnuplot
            gp_save_matrix(sprintf('Ppw_f%d_M%d_%s_posx%2.2f_posy%2.2f.dat', ...
                f, M, window{1}, xc(1), xc(2)), x,y,P);
            gp_save_matrix(sprintf('Ppw_error_f%d_M%d_%s_posx%2.2f_posy%2.2f.dat', ...
                f, M, window{1}, xc(1), xc(2)), x,y, db(P_error));
            gp_save(sprintf('local_f%d_M%d_%s_posx%2.2f_posy%2.2f.txt', ...
                f, M, window{1}, xc(1), xc(2)), xM);
        end
    end
end
% gnuplot
gp_save_loudspeakers('array.txt', [x0; x0(1,:)]);
