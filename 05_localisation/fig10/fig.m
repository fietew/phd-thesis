% IC-weighted ITD/ILD histograms

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
startTwoEars;
addpath('../../matlab');

%% Parameters

% parameters for gammatone filterbank modelling human's frequency selectivity
fb_type       = 'gammatone';
fb_lowFreqHz  = 80;  %
fb_highFreqHz = 16000;
fb_nERBs      = 1.0;  

% parameters of innerhaircell processor
ihc_method    = 'dau';

% parameters of crosscorrelation processor for ITD/IC and of ILD processor
wSizeSec      = 0.02;
hSizeSec      = 0.01;
wname         = 'hann';

% parameters for gammatone filterbank modelling human's frequency selectivity
afeSettings = genParStruct(...
    'fb_type', fb_type, ...
    'fb_lowFreqHz', fb_lowFreqHz, ...
    'fb_highFreqHz', fb_highFreqHz, ...
    'fb_nERBs', fb_nERBs,  ...
    'ihc_method', ihc_method, ...
    'cc_wSizeSec', wSizeSec, ...
    'cc_hSizeSec', hSizeSec, ...
    'cc_wname', wname, ...
    'ild_wSizeSec', wSizeSec, ...
    'ild_hSizeSec', hSizeSec, ...
    'ild_wname', wname ...
  );

% dry source signal
fs_sig = 44100;
rng(0);  % seed for random number generator
sig = randn(10*fs_sig,1);  % 10 seconds noise
% listening position
x = -1.25;
y = 0;
% source position
xs = 0;
ys = 2.5;
% ground truth of localisation angle
gt_angle = atan2d(x-xs,ys-y);
% localisation angles (from localisation experiments)
loc_angle = gt_angle + [
     0.0
    -0.1
   108.0
    21.0
    -0.9
     1.4
    -1.2
    -4.9
     1.3
  ];
% brir files
brir_list = {
  'brs_posx0.00_posy0.00_ref'
  'brs_posx-1.25_posy0.00_circular_nls0056_dls3.00_wfs'
  'brs_win-rect_ord-6_pos-7(-1.25x_0.00y)'
  'brs_posx-1.25_posy0.00_circular_nls0056_dls3.00_lwfs-sbl_M03_rect_npw1024'
  'brs_posx-1.25_posy0.00_circular_nls0056_dls3.00_lwfs-sbl_M27_max-rE_npw1024'
  'brs_posx-1.25_posy0.00_circular_nls0056_dls3.00_lwfs-vss_circular_nvs1024_dvs0.30_wfs'
  'brs_posx-1.25_posy0.00_circular_nls0056_dls3.00_lwfs-vss_circular_nvs1024_dvs0.90_wfs'
  };

%% 

for bdx = 1:length(brir_list)
  
  [birs, fs_birs] = audioread(['./brs/' brir_list{bdx} '_corrected.wav']);
  
  if fs_birs ~= fs_sig
    error('sampling rate mismatch');
  end
  
  for gt = [0, 1]
    
    if gt
      angle = gt_angle;
    else
      angle = loc_angle(bdx);
    end    
    
    % select impulse response
    if strcmp( brir_list{bdx}, 'brs_posx0.00_posy0.00_ref')
      adx = 1;
    else
      adx = mod(round(angle), 360)+1;
    end
    ir = birs(:,2*adx-1:2*adx);
    
    % convolution
    binsig = convolution(ir, sig);
    
    % ILD, ITD, IC
    [itd, ild, ic, fc] = perception_ITDILDIC(binsig, fs_sig, afeSettings);
    itd = itd*1000;  % itd in milliseconds
    nBlocks = size(ild,1);  % number of ITD/ILD estimates
    
    % === ITD histogram ===
    itd_bins_center = linspace(-2,2,81);  % centers of itd bins
    % edges of ild bins
    itd_bins_edges = [-inf, ...
      0.5*itd_bins_center(1:end-1) + 0.5*itd_bins_center(2:end), inf];
    % contains index of bin for each element in itd
    [~,hdx] = histc(itd, itd_bins_edges, 1);  % histogram along signal blocks
    
    hist_itd_ic = zeros(length(itd_bins_center), length(fc));
    % iterate over all gammatone channels
    for fdx = 1:length(fc)
      % iterate over all bins
      for idx = 1:length(itd_bins_center)
        % sum all IC-values which belong to an ITD value in the current bin
        hist_itd_ic(idx, fdx) = sum(ic(hdx(:,fdx) == idx, fdx));
      end
    end
    hist_itd_ic = hist_itd_ic./nBlocks;  % normalize histogram
    
    % === ILD histogram ===
    ild_bins_center = linspace(-40,40,81);  % centers of ild bins
    % edges of ild bins
    ild_bins_edges = [-inf, ...
      0.5*ild_bins_center(1:end-1) + 0.5*ild_bins_center(2:end), inf];
    % contains index of bin for each element in ild
    [~,hdx] = histc(ild, ild_bins_edges, 1);  % histogram along signal blocks
    
    hist_ild_ic = zeros(length(ild_bins_center), length(fc));
    % iterate over all gammatone channels
    for fdx = 1:length(fc)
      % iterate over all bins
      for idx = 1:length(ild_bins_center)
        % sum all IC-values which belong to an ILD value in the current bin
        hist_ild_ic(idx, fdx) = sum(ic(hdx(:,fdx) == idx, fdx));
      end
    end
    hist_ild_ic = hist_ild_ic./nBlocks;  % normalize histogram
    
    % === Gnuplot ===
    gp_save(['hist_itd_ic_' brir_list{bdx} sprintf('_gt%d.txt',gt)], [itd_bins_center(:), hist_itd_ic]);
    gp_save(['hist_ild_ic_' brir_list{bdx} sprintf('_gt%d.txt',gt)], [ild_bins_center(:), hist_ild_ic]);    
  end
end
gp_save('fc.txt', fc(:));
