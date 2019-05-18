% analyse results of Wierstorf's localisation experiments

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

%% parameters
% histogram bins
err_hist_bins = -20:2:20;  % bins for localisation error histogram
t_hist_bins = 0.5:1:35.5;  % bins for time-per-trial histogram
% significance level aka. (1 - confidence level)
alpha = 0.01;
% listening positions
x = [0.00; 0.25; 0.50; 0.75; 1.00; 0.00; 0.25; 0.50; 0.75; 1.00; 1.25;  0.00;  0.25;  0.50;  0.75;  1.00]*(-1);
y = [0.75; 0.75; 0.75; 0.75; 0.75; 0.00; 0.00; 0.00; 0.00; 0.00; 0.00; -0.75; -0.75; -0.75; -0.75; -0.75];
% loudspeaker array
phi0 = (0:55)*360/56;
x0 = 1.5*cosd(phi0);
y0 = 1.5*sind(phi0);

vecscale = 0.5;

results_dir = 'wierstorf/';

filenames = {
    'wierstorf_WFS_L56'
    'wierstorf_WFS_L28'
    'wierstorf_WFS_L14'
    'wierstorf_NFCHOA_L56_R028'
    'wierstorf_NFCHOA_L28_R014'
    'wierstorf_NFCHOA_L14_R007'
    'wierstorf_NFCHOA_L14_R028'
};

filemasks = {
    '_Y0.75m*.csv'
    '_Y0.00m*.csv'
    '_Y-0.75m*.csv'
    };

figure;
mdx = 0;
for method = {'wfs', 'hoa'}

    switch method{1}
        case 'wfs'
        	Nlsvec = [56, 28, 14];
        case 'hoa'
        	Nlsvec = [56, 28, 14, 1456];
    end
    
    for Nls = Nlsvec
        
        mdx = mdx+1;
    
        err = [];
        err_bias = [];
        err_bias_ci = [];
        err_binaural = [];

        for mask = filemasks.'
            filelist = dir([results_dir,  method{1}, '/*', method{1}, mask{1}]);

            fdx = 0;
            err_tmp = [];
            time = [];
            for file = filelist.'
              fdx = fdx+1;
              % subject idx
              sdx = fdx;
              % parse the file for localisation azimuths and timestamps
              data = dlmread(fullfile(results_dir,  method{1},  file.name),',',10,0);
              % select speaker condition for calibration
              calib = data(data(:,2) == 0, :);
              offset = mean(calib(:, 9) - calib(:, 8));
              % select loudspeaker condition
              data = data(data(:,2) == Nls, :);
              % get unique conditions
              condition_ids = unique(data(:,3));
              % iterate over unique conditions
              for idx = 1:length(condition_ids)
                % 
                select = data(:,3) == condition_ids(idx);
                % signed localisation error
                err_tmp(idx,:,sdx) = data(select, 8) - data(select, 9) + offset;
                % time for each trial
                time(idx,:,sdx) = data(select, 12);
              end
              % error of corrected binaural synthesis data
              err_binaural = [err_binaural; calib(:, 8) - calib(:, 9) + offset];
            end

            err_stats = statistics(err_tmp, alpha, err_hist_bins);
            
            err = [err; err_tmp];
            err_bias = [err_bias; err_stats.mean_cond];
            err_bias_ci = [err_bias_ci; err_stats.mean_conf_cond];
        end

        gt = atan2d(x,2.5-y);
        loc_avr = gt + err_bias;

        %% subsampling
        select = [1:2:5,6:2:10,11,12:2:16];
        
        
        %% comparison of method to calibration condition
        nu1 = numel(err(select,:,:));
        err_RMSE = sqrt(sum(sum(sum(err(select,:,:).^2,1),2),3)./nu1);
        
        nu2 = length(err_binaural);
        err_binaural_RMSE = sqrt(sum(err_binaural.^2)./nu2);
        
        p_err_RMSE = fcdf(err_RMSE.^2./err_binaural_RMSE.^2,nu1,nu2,'upper');
        
        Fcrit = fzero(@(x) ncfcdf(x/1.1,nu1,nu2,nu1) - fcdf(x,nu1,nu2,'upper'), [0 5])
        alpha_F = fcdf(Fcrit,nu1,nu2,'upper')
        nu1
        nu2
   
        %% plotting    
        subplot(3,3,mdx);
        hold on;

        ciplot = [];
        for jdx=select
            r = vecscale.*0.75;
            phi = linspace(-err_bias_ci(jdx),err_bias_ci(jdx),360)+loc_avr(jdx)+90;

            xci = [0, cosd(phi)];
            yci = [0, sind(phi)];

            fill(x(jdx)+r.*xci,y(jdx)+r.*yci,'r');

            ciplot = [ciplot,x(jdx,ones(1,361)).',y(jdx,ones(1,361)).',xci.',yci.'];
        end

        errtmp = err(select,:,:);
    
        gp_save([filenames{mdx} '_corrected.txt'], reshape(errtmp,size(errtmp,1),[]));
        gp_save([filenames{mdx} '_ci.txt'], ciplot);
        gp_save([filenames{mdx} '_loc.txt'], [x(select),y(select), loc_avr(select), err_bias(select)]);
        gp_save([filenames{mdx} '_RMSE.txt'], [err_RMSE, err_binaural_RMSE, p_err_RMSE, alpha_F]);
        
        quiver(x,y,vecscale.*cosd(loc_avr+90),vecscale.*sind(loc_avr+90), 0);
        plot(x0,y0,'ko');
        hold off;
        axis equal    
    end
end
