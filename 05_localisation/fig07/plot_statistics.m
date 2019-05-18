function plot_statistics(stats, gt, label)
% plot statistics 

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

figure;
bar( stats.hist_bins, stats.hist_all )
hold on;
plot(stats.quantiles_all, zeros(size(stats.quantiles_all)), 'rdiamond')
hold off;
title( ['histograms and 5%-quantiles of ', label] );

figure;
plot(gt, stats.mean_sub_cond, 'diamond');
hold on;
errorbar( gt, stats.mean_cond, stats.mean_conf_cond, 'ksquare');
hold off;
ylim([-15,15])
title( ['arithmetic mean of ', label] );

figure;
plot(gt, stats.std_sub_cond, 'diamond');
hold on;
errorbar( gt, stats.std_cond, stats.std_cond - stats.std_conf_lower_cond, ...
  stats.std_conf_upper_cond - stats.std_cond, 'ksquare');
hold off;
ylim([0,15])
title( ['standard deviation from arithmetic mean of ', label] );