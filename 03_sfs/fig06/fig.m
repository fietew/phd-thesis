% reproduced sound field for 2.5D WFS of monochromatic point source/plane wave

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
%% Parameters
conf = SFS_config;

conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0 0 0];
conf.secondary_sources.number = 1024;

conf.dimension = '2.5D';
conf.xref = [0 0 0]; 
conf.usetapwin = false;  % do not use tapering window

%% Variables
f = 1000;

X = [-3, 3];
Y = [-1.5, 1.5];
Z = 0;

xref = conf.xref;

%% Computation

x0 = secondary_source_positions(conf);

for srcv = {'ps', 'pw', 'fs'}
    
    src = srcv{1};
    
    switch src
        case 'ps'
            xs = [0 2.5 0];
            srcgt = 'ps';
            phis = cart2pol(-xs(1), -xs(2));
        case 'pw'
            xs = [0,-1,0];
            srcgt = 'pw';
            phis = cart2pol(xs(1), xs(2));
        case 'fs'
            xs = [0,0.5,0,0,-1,0];
            srcgt = 'ps';
            phis = cart2pol(-xs(1), -xs(2));
    end
    
    % ground truth
    Pgt = sound_field_mono(X,Y,Z,[xs(1:3), 0, 1, 0, 1], srcgt, 1, f, conf);
    % normalisation factor for gnuplot
    g = sound_field_mono(xref(1),xref(2),xref(3),[xs(1:3), 0, 1, 0, 1], srcgt, 1, f, conf);
    % selected secondary sources
    [~, xdx] = secondary_source_selection(x0,xs,src);
    % driving functions
    D = driving_function_mono_wfs(x0(xdx,:),xs,src,f,conf);
    % reproduced sound fields    
    [P,x,y] = sound_field_mono(X,Y,Z,x0(xdx,:),'ps',D,f,conf);
    % normalised absolute error
    Perror = abs(1 - P./Pgt);
    % gnuplot
    gp_save_matrix(sprintf('P%s.dat', src),x,y,real(P)./abs(g));
    gp_save_matrix(sprintf('P%s_error.dat', src),x,y,db(Perror));
    gp_save_loudspeakers(sprintf('array%s_active.txt', src), x0(xdx,:));
    
    x0_inactive = x0(~xdx,:);
    phi0_inactive = cart2pol(x0_inactive(:,1), x0_inactive(:,2));
    delta = wrapToPi(phi0_inactive-phis);
    [~,idx] = sort(delta);    
    gp_save_loudspeakers(sprintf('array%s_inactive.txt', src), x0_inactive(idx,:));
end
gp_save('xref.txt', conf.xref(1:2));
