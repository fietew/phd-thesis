function [loc_corrected, calib_corrected] = data_calibration(calib,gt_calib,loc)
% calibrate data

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

[Ncond, Nrep, Nsub] = size(calib);

sub = [];
sub(1,1,:) = 1:Nsub;
sub = repmat(sub, [Ncond, Nrep]);

err_calib = calib - gt_calib;
tbl = table(err_calib(:),gt_calib(:), sub(:),'VariableNames',{'Error','GroundTruth','Subject'});
tbl.Subject = categorical(tbl.Subject);

lme = fitlme(tbl,'Error~ GroundTruth + (GroundTruth|Subject)');

% BLUEs of fixed effect
[~,~,FE] = fixedEffects(lme);
beta_0 = FE.Estimate(1);
beta_1 = FE.Estimate(2);

% BLUPs of random effects
[~,~,RE] = randomEffects(lme);
gamma_0 = RE.Estimate(1:2:end);
gamma_1 = RE.Estimate(2:2:end);

% correct localisation azimuth (per subject)
loc_corrected = loc;
calib_corrected = calib;
for edx = 1:Nsub
    loc_corrected(:,1,edx) = (loc(:,1,edx) - beta_0 - gamma_0(edx))./(1 + beta_1 + gamma_1(edx));
    calib_corrected(:,:,edx) = (calib(:,:,edx) - beta_0 - gamma_0(edx))./(1 + beta_1 + gamma_1(edx));
end
