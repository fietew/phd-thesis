% reproduced sound field for 2.5D NFCHOA of monochromatic plane wave with
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
addpath('../../matlab');
%% Parameters
conf = SFS_config;

conf.secondary_sources.geometry = 'circle';
conf.secondary_sources.size = 3;
conf.secondary_sources.center = [0 0 0];
conf.secondary_sources.number = 512;

conf.dimension = '2.5D';

%% Variables

N0 = conf.secondary_sources.number;

src = 'pw';
xs = [0,  -1, 0];

X = [-1.5, 1.5];
Y = [-1.5, 1.5];
Z = 0;

f = 1000;

%% Computation
% secondary sources
x0 = secondary_source_positions(conf);

for f = [500,1000]
    for M = [14, 7]
        conf.nfchoa.order = M;
        
        for window = {'rect', 'max-rE'}
            conf.modal_window = window{1};
            [win, Win, phi0] = modal_weighting(M, N0, conf);
            
            %% sound pressure
            conf.resolution = 300;
            % ground truth
            Ppw_gt = sound_field_mono_plane_wave(X,Y,Z,xs,f,conf);
            % reproduced sound field
            x0 = secondary_source_positions(conf);
            D = driving_function_mono_nfchoa(x0,xs,src,f,conf);
            DM = cconv(D.',Win,N0)./N0;
            [Ppw,x,y] = sound_field_mono(X,Y,Z,x0,'ps',DM,f,conf);
            % normalised absolute error
            Ppw_error = abs(1 - Ppw./Ppw_gt);
            % normalisation factor for gnuplot
            gpw = sound_field_mono_plane_wave(0,0,0,xs,f,conf);
            % gnuplot
            gp_save_matrix(sprintf('Ppw_f%d_M%d_%s.dat', f, M, window{1}), ...
                x,y,real(Ppw./gpw));
            gp_save_matrix(sprintf('Ppw_error_f%d_M%d_%s.dat', f, M, window{1}), ...
                x,y,db(Ppw_error));
            
            %% scalar product of local wavenumber vector and npw
            [gradPx, gradPy, gradPz] = sound_field_gradient_mono(X,Y,Z,x0,'ps',DM,f,conf);
            
            kvec = -imag([gradPx(:)./Ppw(:), gradPy(:)./Ppw(:) , gradPz(:)./Ppw(:)]);
            kvec = bsxfun(@rdivide, kvec, vector_norm(kvec,2));
            
            kscalar = zeros(size(x));
            kscalar(:) = xs(1).*kvec(:,1) + xs(2).*kvec(:,2) + xs(3).*kvec(:,3);
            alpha = acosd(kscalar);
            
            gp_save_matrix(sprintf('alpha_f%d_M%d_%s.dat', f, M, window{1}), ...
                x,y,alpha);
            
            %% local wave vector on subsampled grid
            conf.resolution = 12;
            [Ppw,x,y] = sound_field_mono(X,Y,Z,x0,'ps',DM,f,conf);
            [gradPx, gradPy, gradPz] = sound_field_gradient_mono(X,Y,Z,x0,'ps',DM,f,conf);
            
            xk = [x(:),y(:)];
            xk(:,3) = Z;
            kvec = -imag([gradPx(:)./Ppw(:), gradPy(:)./Ppw(:) , gradPz(:)./Ppw(:)]);
            kvec = bsxfun(@rdivide, kvec, vector_norm(kvec,2));
            gp_save(sprintf('k_f%d_M%d_%s.txt', f, M, window{1}), [xk,kvec]);
            
            %% region of correct synthesis
            phiM = (0:1:360).';
            rM = M.*conf.c/(2*pi*f);
            xM = rM.*[cosd(phiM), sind(phiM)];
            
            gp_save(sprintf('region_f%d_M%d_%s.txt', f, M, window{1}), xM);
            
        end
    end
end

% gnuplot
gp_save_loudspeakers('array.txt', [x0; x0(1,:)]);
