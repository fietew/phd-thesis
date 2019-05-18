function [err, gt] = parse_ratings_old(results_dir, idx)
% parse localisation results of Wierstorf
%
% return values
%   ratings:  localisation azimuths [Nc x Nr x Ns]
%   gt:       ground source azimuths [Nc x 1]
%   time:     time elapsed for trial [Nc x Nr x Ns]
%
% Nc: number of conditions
% Nr: number of repetitions
% Ns: number of subjects

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

% files containing localisation azimuths and timestamps
filelist = dir([results_dir, '*.csv']);
filelist = filelist(reshape([2*idx-1;2*idx], 1, [] ));

err = [];
gt = [];

fdx = 0;
for file = filelist.'
  fdx = fdx+1;
  % subject idx
  sdx = floor((fdx-1)/2.0) + 1;
  % select repetitions
  if mod(fdx,2) == 0
    rdx = 4:5;  % 2nd session
  else
    rdx = 1:3;  % 1st session
  end  
  % parse the file for localisation azimuths and timestamps
  data = dlmread([results_dir, file.name],',',10,0);  
  % select HRTF condition (2)
  data = data(data(:,2) == 2,:);
  % get unique conditions
  condition_ids = unique(data(:,3));
  % iterate over unique conditions
  for idx = 1:length(condition_ids)
    % ground truth azimuth (will be overwritten in each iteration w.r.t fdx)
    gt(idx,1) = data(condition_ids(idx), 9);
    % signed localisation error
    select = data(:,3) == condition_ids(idx);
    err(idx,rdx,sdx) = data(select, 8) - data(select, 9);
  end   
end
