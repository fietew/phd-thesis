function [err, gt] = parse_ratings(results_dir, idx)
% parse localisation results
%
% return values
%   err:      signed azimuthal localisation error [Nc x Nr x Ns]
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

% files containing localisation azimuths
ratings_filelist = dir([results_dir, '*_subject*_rating_main.csv']);
ratings_filelist = ratings_filelist(idx);

% files containing ground truth
gt_angles = dlmread('loudspeaker_angles.txt', ',', 6, 0);

err = [];
gt = [];

fdx = 0;
for ratings_file = ratings_filelist.'
  fdx = fdx+1;
  
  %% localisation data
  % parse the file for localisation azimuths
  ratings_data = dlmread([results_dir, ratings_file.name],',',1,0);
  % get unique conditions (3rd column)
  condition_ids = unique(ratings_data(:,3));  
  % iterate over unique conditions
  for idx = 1:length(condition_ids)
    % ground truth azimuth (will be overwritten in each iteration w.r.t fdx)
    gt(idx,1) = gt_angles(condition_ids(idx), 2);
    % signed localisation error
    select = ratings_data(:,3) == condition_ids(idx);    
    err(idx,:,fdx) = ratings_data(select, 10)*180/pi - gt(idx);
  end
end
