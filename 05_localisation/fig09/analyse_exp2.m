% analyse results of second localisation experiment

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
% significance level aka. (1 - confidence level)
alpha = 0.01;
% listening positions
x = [0.00; 0.50; 1.00; 0.00; 0.50; 1.00; 1.25;  0.00;  0.50;  1.00]*(-1);
y = [0.75; 0.75; 0.75; 0.00; 0.00; 0.00; 0.00; -0.75; -0.75; -0.75];
% source position
xs = 0;
ys = 2.5;
% ground truth of localisation angle
gt = repmat(atan2d(x-xs,ys-y),9,1);
% loudspeaker array
phi0 = (0:55)*360/56;
x0 = 1.5*cosd(phi0);
y0 = 1.5*sind(phi0);

vecscale = 0.5;

results_dir = 'exp2/';

filenames = {
    'exp2_WFS_L56'
    'exp2_NFCHOA_L56_R027'
    'exp2_LWFS-SBL_L56_R027'
    'exp2_LWFS-SBL_L56_M027'
    'exp2_LWFS-SBL_L56_R003'
    'exp2_LWFS-SBL_L56_M003'
    'exp2_LWFS-VSS_L56_r15'
    'exp2_LWFS-VSS_L56_r30'
    'exp2_LWFS-VSS_L56_r45'  
};

%% parsing

filelist = dir([results_dir, '*_subject*_rating_main.csv']);
fdx = 0;

loc = zeros(90,1,size(filelist,1));
offsets = loc;
calib = zeros(10,1,size(filelist,1));
gt_calib = calib;
for file = filelist.'
    fdx = fdx+1;
    % parse the file for localisation azimuths
    data = dlmread([results_dir, file.name],',',1,0);    
    % select speaker condition for calibration (condition == 1)
    select = data(:,3) == 1;
    calib(:,1,fdx) = data(select, 9).*180./pi;
    gt_calib(:,1,fdx) = -data(select, 5);
    % select everything but speakers (condition ~= 1)
    data = data(data(:,3) ~= 1, :);
    % sort data after condition id
    [~,cdx] = sort(data(:,3));
    % 
    loc(:,1,fdx) = data(cdx, 9).*180./pi;
    offsets(:,1,fdx) = data(cdx, 5);
end   

%% data calibration
[loc_corrected, calib_corrected] = data_calibration(calib,gt_calib,loc);

%% corrected signed localisation error
err = loc_corrected + offsets - repmat(gt,1,size(loc,2),size(loc,3));

% localisation bias
err_stats = statistics(err, alpha, err_hist_bins);
err_bias = reshape(err_stats.mean_cond, 10, []);
err_bias_ci = reshape(err_stats.mean_conf_cond, 10, []);

nu1 = (10*size(err,2).*size(err,3));  % degrees of freedom
err_RMSE = sqrt(1./nu1.*sum(reshape(sum(sum(err.^2, 3), 2), 10, []), 1));
err_RMSE(9) = ...
    sqrt(1./nu1.*sum(sum(sum(err([81:82,84:90],:,:).^2, 3), 2), 1));  % outlier

% localisation angle
loc_avr = reshape(gt, 10, []) + err_bias;

%% comparison of method to calibration condition
err_binaural = calib_corrected(:) - gt_calib(:);

nu2 = length(err_binaural);  % degrees of freedom
err_binaural_RMSE = sqrt(sum(err_binaural.^2)./nu2);

% p-value from F-test comparing RMSEs of method and calibration
p_err_RMSE = fcdf(err_RMSE.^2./err_binaural_RMSE.^2,nu1,nu2,'upper');

% find critical value for F-test
Fcrit = fzero(@(x) ncfcdf(x/1.1,nu1,nu2,nu1) - fcdf(x,nu1,nu2,'upper'), [0 5])
% according type-I and type-II error probability
alpha_F = fcdf(Fcrit,nu1,nu2,'upper')

%% plotting and gnuplot

figure;
for idx=1:7
    subplot(3,3,idx);
    hold on;
    
    ciplot = [];
    for jdx=1:10
        r = vecscale.*0.75;
        phi = linspace(-err_bias_ci(jdx,idx),err_bias_ci(jdx,idx),360)+loc_avr(jdx,idx)+90;
        
        xci = [0, cosd(phi)];
        yci = [0, sind(phi)];
        
        fill(x(jdx)+r.*xci,y(jdx)+r.*yci,'r');
        
        ciplot = [ciplot,x(jdx,ones(1,361)).',y(jdx,ones(1,361)).',xci.',yci.'];
    end
    
    quiver(x,y,vecscale.*cosd(loc_avr(:,idx)+90),vecscale.*sind(loc_avr(:,idx)+90), 0);
    plot(x0,y0,'ko');
    hold off;
    axis equal
    
    % gnuplot
    errtmp = err((idx-1)*10+1:idx*10,:,:);    
    gp_save([filenames{idx} '_corrected.txt'], ...
        reshape(errtmp,size(errtmp,1),[]));
    gp_save([filenames{idx} '_ci.txt'], ciplot);
    gp_save([filenames{idx} '_loc.txt'], ...
        [x,y, loc_avr(:,idx), err_bias(:,idx)]);
    gp_save([filenames{idx} '_RMSE.txt'], ...
        [err_RMSE(idx), err_binaural_RMSE, p_err_RMSE(idx), alpha_F]);
end
%% save

gp_save('array.txt', [x0.',y0.']);
