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

clear all;
close all;
SFS_start;

%% Parameters
conf = SFS_config;

conf.secondary_sources.geometry = 'circle';
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0 0 0];
conf.secondary_sources.number = 512;
conf.dimension = '2.5D';
conf.driving_functions = 'reference_circle';

conf.usetapwin = 0;

conf.localwfs_vss.method = 'wfs';
conf.localwfs_vss.number = 512;
conf.localwfs_vss.geometry = 'circle';
conf.localwfs_vss.driving_functions = 'default';
conf.localwfs_vss.usetapwin = 0;
conf.localwfs_vss.consider_target_field = 0;
conf.localwfs_vss.consider_secondary_sources = 0;

%% Variables
src = 'pw';
xs = [0,  -1, 0];

X = [-1.5, 1.5];
Y = [-1.5, 1.5];
Z = 0;

%% Computation
% secondary sources
x0 = secondary_source_positions(conf);

for rl = [0.25, 0.5, 0.75]
    for f = [1000, 2000]
        conf.localwfs_vss.size = 2*rl;

        for xshift = linspace(0.25,0.75,2)
            xc = [xshift,0,0];
            conf.xref = xc;
            conf.localwfs_vss.center = xc;

            % ground truth
            Ppw_gt = sound_field_mono_plane_wave(X,Y,Z,xs,f,conf);
            % driving function
            [D, x0select] = driving_function_mono_localwfs_vss(x0,xs,src,f,conf);
            % reproduced sound field
            [P,x,y] = sound_field_mono(X,Y,Z,x0select,'ps',D,f,conf);
            % normalised absolute error
            P_error = abs(1 - P./Ppw_gt);

            %% gnuplot
            datastring =  sprintf('_f%4.0f_r%2.2f_posx%2.2f_posy%2.2f', f, rl, xc(1), xc(2));

            % virtual secondary sources
            tmpconf = conf;
            tmpconf.secondary_sources.size = conf.localwfs_vss.size;
            tmpconf.secondary_sources.center = conf.localwfs_vss.center;
            tmpconf.secondary_sources.number = conf.localwfs_vss.number;
            tmpconf.secondary_sources.geometry = conf.localwfs_vss.geometry;
            
            xv = secondary_source_positions(tmpconf);
            gp_save_loudspeakers(['virtual_array' datastring '.txt'], [xv; xv(1,:)]);
            
            gp_save_matrix(['P' datastring '.dat'], x,y,P);
            gp_save_matrix(['Perror' datastring '.dat'], x,y,db(P_error));
        end
    end
end
% gnuplot
gp_save_loudspeakers('array.txt', [x0; x0(1,:)]);
