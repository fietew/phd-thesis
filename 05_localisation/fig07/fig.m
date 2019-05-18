% results of localisation experiment to validate the evaluation method 

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
% histogram bins
err_hist_bins = -20:1:20;  % bins for localisation error histogram
year = {'2012', '2017'};
% 2012:
%   skip 7th participant: very large std (std_sub = 14.3284)
% 2017:
%   skip first participant:  myself
%   skip second participant: very large variance (std_sub = 10.8597)
subjects = { [1:6 8:11], 3:12};
% significance level aka. (1 - confidence level)
alpha = 0.01;

%% Computations
err_f_test = cell(2,1);
for idx = 1:length(year)
  
  prefix = year{idx};  
  switch prefix
    case '2012'
      [err, gt] = parse_ratings_old('2012/', subjects{idx});
    case '2017'
      [err, gt] = parse_ratings('2017/', subjects{idx});
  end
  
  [Ncond, Nrep, Nsub] = size(err);

  % === Localisation Error ===
  err_stats = statistics(err, alpha, err_hist_bins);
  gt_vec = gt;
  gt = repmat(gt, [1 Nrep Nsub]);
  
  sub = [];
  sub(1,1,:) = 1:Nsub;
  sub = repmat(sub, [Ncond, Nrep]);
  
  rep = [];
  rep(1,:,1) = 1:Nrep;
  rep = repmat(rep, [Ncond, 1, Nsub]);
  
  yr = repmat(year(idx), [numel(err), 1]);
  
  session = ones(numel(err),1);
  if idx == 1
      session(rep(:)>3) = 2;
  end
    
  % create table with data
  tbl = table(err(:),gt(:),sub(:),session(:),rep(:), yr(:), 'VariableNames',...
      {'Error','GroundTruth','Subject', 'Session', 'Rep', 'Year'});
  tbl.Subject = categorical(tbl.Subject);
  tbl.Session = categorical(tbl.Session);
  tbl.Year = categorical(tbl.Year);
  
  % fit model with and without random effects
  lfe = fitlme(tbl,'Error~ GroundTruth');
  lme = fitlme(tbl,'Error~ GroundTruth + (GroundTruth|Session:Subject)');
  
  % Likelihood-Ratio Test between models
  compare(lfe,lme)
  
  % BLUEs of fixed effect
  [~,~,FE] = fixedEffects(lme, 'Alpha', alpha);
  beta_0 = FE.Estimate(1);
  beta_1 = FE.Estimate(2);
  
  % BLUPs of random effects
  [~,~,RE] = randomEffects(lme, 'Alpha', alpha);
  gamma_0 = RE.Estimate(1:2:end);
  gamma_1 = RE.Estimate(2:2:end);

  % get localisation error predicted by linear mixed effects model  
  tblnew = tbl;
  tblnew.GroundTruth = linspace(-50,50, length(tblnew.GroundTruth)).';
  [err_predicted,err_predicted_ci] = predict(lme, tblnew, 'Conditional', false, 'Alpha', alpha);
  
  % correct localisation error using BLUEs and BLUPs
  err_corrected = err;
  edx = sub(:)+Nsub*(session(:)-1);
  err_corrected(:) = (err(:) + gt(:) - beta_0 - gamma_0(edx))./(1 + beta_1 + gamma_1(edx)) - gt(:);
  err_corrected_stats = statistics(err_corrected, alpha, err_hist_bins);
  err_f_test{idx} = err_corrected(:);

  % plotting  
  gt_plot = reshape(gt(:,:,1), [], 1);
  err_plot = reshape(err, [], Nsub);
  err_corrected_plot = reshape(err_corrected, [], Nsub);
  
  figure;
  plot(gt_plot, err_plot, 'o');
  hold on;
  plot(tblnew.GroundTruth, err_predicted, 'k', tblnew.GroundTruth, err_predicted_ci, 'k--');
  hold off;
  
  plot_statistics(err_stats, gt_vec, ['(uncorrected) corrected signed localisation error (', prefix, ')']);
  plot_statistics(err_corrected_stats, gt_vec, ...
      ['corrected signed localisation error (', prefix, ')']);
  
  % gnuplot  
  gp_save(['./', prefix, '_err.txt'], [gt_plot, err_plot]);  % loc. error
  gp_save(['./', prefix, '_lme.txt'], ...
      [tblnew.GroundTruth, err_predicted, err_predicted_ci]);  % prediction
  gp_save(['./', prefix, '_err_corrected.txt'], ...
      [gt_plot, err_corrected_plot]);  % corrected loc. error
  
  gp_save_statistics(['./', prefix, '_err'], err_stats, gt_vec);  % loc. error stats
  gp_save_statistics(['./', prefix, '_err_corrected'], ...
      err_corrected_stats, gt_vec);  % corrected loc. error stats  
end

% F-test comparing standard deviations of both experiments
std1 = std(err_f_test{1})
std2 = std(err_f_test{2})
[~,p,~,stats] = vartest2(err_f_test{:}, 'Tail','right') 
