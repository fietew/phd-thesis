function [CLL_phones, fc] = perception_CLL(sig, fs, afeSettings)
% get Composite Loudness Level after Pulkki 1999

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

% middle ear filtering
[b,a] = butter(1,[500, 2000]/(fs/2));
sig = filter(b,a,sig);

% instantiation of data and manager objects
dataObj = dataObject(sig,fs);  % empty data object with two channels;
managerObj = manager(dataObj, {'filterbank'}, afeSettings);

% start processing
managerObj.processSignal();
gammatone_left = dataObj.filterbank{1}.Data(:);
gammatone_right = dataObj.filterbank{2}.Data(:);
fc = dataObj.filterbank{1}.cfHz;  % centre frequencies of filters in Hz

% left/right loudness in sones (Pulkki 1999, eq. 2)
LL_sones = sqrt(rms(gammatone_left));
RL_sones = sqrt(rms(gammatone_right));

% composite loudness in sones (Pulkki 1999, eq. 2)
CL_sones = LL_sones + RL_sones;

% composite loudness level in phones (Pulkki 1999, eq. 3)
CLL_phones = 40 + 10*log2(CL_sones);

end

