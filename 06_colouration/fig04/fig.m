% Regression with spatial aliasing freq. and SBL frequency on MUSHRA Data

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

SFS_start;  % start Sound Field Synthesis Toolbox
addpath('../../matlab');

%% Parameters
conf = SFS_config;  % default configuration SFS Toolbox
conf.c = 343;  % speed of sound
% config for loudspeaker array
conf.secondary_sources.size = 3;
conf.secondary_sources.geometry = 'circular';
conf.secondary_sources.number = 56;
conf.secondary_sources.logspread = 1.0;

% === custom parameters
conf.xs = [0, 2.5, 0];
conf.src = 'ps';
conf.Rc = NaN;
conf.xc = NaN;
conf.Rl = 0.085;  % head radius
conf.xl = NaN;
conf.M = NaN;
conf.useplot = true;
conf.falfile = 'fal.txt';
conf.fcsfile = 'fcs.txt';

%% Parameters which should be iterated

param_names = {
    'secondary_sources.number', ...
    'M', ...
    'Rc', ...
    'xc', ...
    'xl', ...
    };

%% Fitting

% Compute Spatial Aliasing Frequency
param_values = allcombs( ...
    { 56 }, ...
    { Inf, 27, 23, 19, 15, 11, 7, 3 }, ...
    { NaN }, ...
    { [-0.5, 0.75, 0] }, ...
    { [-0.5, 0.75, 0] }, ...
    [1, 2, 3, 4, 4] ...
    );

delete(conf.falfile)
delete(conf.fcsfile)
exhaustive_evaluation(@spatial_aliasing_frequency, param_names, param_values, conf, false);
exhaustive_evaluation(@correct_synthesis_frequency, param_names, param_values, conf, false);

% Frequencies
fal = dlmread('fal.txt', ',', 2, 0);
fcs = dlmread('fcs.txt', ',', 2, 0);
fcs = min(fcs, 20000);

% Ratings
scores = dlmread('../results/exp1/diffvsRef_set5_LWFS-SBL_M_off.txt', '\t', [5, 11, NaN, 30]);
% scores(:,end) = [];  % remove tabs
subject = 1:size(scores,2);

[~, fal] = meshgrid(subject, fal);
[subject, fcs] = meshgrid(subject, fcs);

% Modelling
tbl = table(scores(:),fal(:), fcs(:), subject(:), 'VariableNames', {'Scores','Fal','Fcs', 'Subject'});

lmecolin = fitlme(tbl,'Scores ~ 1 + Fal + Fcs + Fal*Fcs + (1|Subject)');

beta = lmecolin.fixedEffects;

(beta(3) - beta(2))./beta(4)

tblnew = table(fal(:,1), fcs(:,1), zeros(size(fal,1),1), 'VariableNames', {'Fal','Fcs', 'Subject'});

figure;
hold on;
[score_predict, score_predict_ci] = lmecolin.predict(tblnew);
gp_save_table('scorepredict_colin1.txt', '', {'Prediction', 'CI Low', 'CI High'}, '', score_predict, score_predict_ci); 
plot(score_predict);
plot(median(scores,2),'o');
ylim([0, 1]);
hold off;

%% Validation

% Compute Spatial Aliasing Frequency
param_values = allcombs( ...
    { 56 }, ...
    { Inf, 27, 27, 23, 19, 19 }, ...
    { NaN }, ...
    { [-0.5, 0.75, 0] }, ...
    { [-0.5, 0.75, 0] }, ...
    [1, 2, 3, 4, 4] ...
    );

delete(conf.falfile)
delete(conf.fcsfile)
exhaustive_evaluation(@spatial_aliasing_frequency, param_names, param_values, conf, false);
exhaustive_evaluation(@correct_synthesis_frequency, param_names, param_values, conf, false);

% Frequencies
fal = dlmread('fal.txt', ',', 2, 0);
fcs = dlmread('fcs.txt', ',', 2, 0);
fcs = min(fcs, 20000);

tblnew = table(fal(:), fcs(:), zeros(length(fal),1), 'VariableNames', {'Fal','Fcs', 'Subject'});

% Ratings
[scores] = dlmread('../results/exp2/diffvsRef_set5_LWFS-SBL_window_off.txt',...
  '\t', [5, 11, NaN, 31]);

figure;
hold on;
[score_predict, score_predict_ci] = lmecolin.predict(tblnew);
gp_save_table('scorepredict_colin2.txt', '', {'Prediction', 'CI Low', 'CI High'}, '', score_predict, score_predict_ci); 
plot(score_predict);
plot(median(scores,2),'o');
ylim([0, 1]);
hold off;