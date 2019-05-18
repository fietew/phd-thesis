% Difference Composite Loudness Level (CLL) between Condition and Reference

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

bir_path = '../brs/';  % path to birs
sig_path = './';  % path to stimuli

% parameters for gammatone filterbank modelling human's frequency selectivity
fb_type       = 'gammatone';
fb_lowFreqHz  = 80;  %
fb_highFreqHz = 16000;
fb_nERBs      = 1.0;

% parameters of innerhaircell processor
ihc_method    = 'dau';

% parameters for gammatone filterbank modelling human's frequency selectivity
afeSettings = genParStruct(...
    'fb_type', fb_type, ...
    'fb_lowFreqHz', fb_lowFreqHz, ...
    'fb_highFreqHz', fb_highFreqHz, ...
    'fb_nERBs', fb_nERBs,  ...
    'ihc_method', ihc_method ...
    );
  
% brir files (order is important for gnuplot)
brir_list = {
    'brs_posx0.00_posy0.00_circular_nls0056_dls3.00_wfs'
    'brs_posx-0.50_posy0.75_circular_nls0056_dls3.00_wfs'
    'brs_posx0.00_posy0.00_circular_nls0056_dls3.00_nfchoa_M27_rect'
    'brs_posx-0.50_posy0.75_circular_nls0056_dls3.00_nfchoa_M27_rect'
    'brs_posx0.00_posy0.00_circular_nls0056_dls3.00_lwfs-sbl_M27_npw0064'
    'brs_posx-0.50_posy0.75_circular_nls0056_dls3.00_lwfs-sbl_M27_npw0064'
    'brs_posx0.00_posy0.00_circular_nls0056_dls3.00_lwfs-sbl_M27_npw1024'
    'brs_posx-0.50_posy0.75_circular_nls0056_dls3.00_lwfs-sbl_M27_npw1024'
    'brs_posx0.00_posy0.00_circular_nls0056_dls3.00_lwfs-sbl_M19_rect_npw1024'
    'brs_posx-0.50_posy0.75_circular_nls0056_dls3.00_lwfs-sbl_M19_rect_npw1024'
    'dummy'
    'brs_posx-0.50_posy0.75_circular_nls0056_dls3.00_lwfs-sbl_M03_npw1024'
    'brs_posx0.00_posy0.00_circular_nls0056_dls3.00_lwfs-sbl_M27_max-rE_npw1024'
    'brs_posx-0.50_posy0.75_circular_nls0056_dls3.00_lwfs-sbl_M27_max-rE_npw1024'
    'brs_posx0.00_posy0.00_circular_nls0056_dls3.00_lwfs-vss_circular_nvs1024_dvs0.30_wfs'
    'brs_posx-0.50_posy0.75_circular_nls0056_dls3.00_lwfs-vss_circular_nvs1024_dvs0.30_wfs'
    'brs_posx0.00_posy0.00_circular_nls0056_dls3.00_lwfs-vss_circular_nvs1024_dvs0.90_wfs'
    'brs_posx-0.50_posy0.75_circular_nls0056_dls3.00_lwfs-vss_circular_nvs1024_dvs0.90_wfs'
    };
 
%% Computations
  
% dry source signal
[sig, fs_sig] = audioread([sig_path 'pnoise_pulse_44100.wav']);

% reference impulse response
[bir_ref,fs_bir_ref] = audioread([bir_path 'brs_posx0.00_posy0.00_ref_corrected.wav']);
sig_ref = convolution(bir_ref, sig);

% Composite Loudness Level of Reference
[CLL_ref, fc] = perception_CLL(sig_ref,fs_sig,afeSettings);

% Difference in Composite Loudness Level
CLL_delta = zeros(length(brir_list), length(fc));

for bdx = 1:length(brir_list)
    
    if strcmp(brir_list{bdx}, 'dummy')
        %
        CLL_delta(bdx,:) = NaN;
    else
    
        [bir_tar, fs_bir_tar] = audioread([bir_path brir_list{bdx} '_corrected.wav']);

        if fs_bir_tar ~= fs_sig || fs_bir_ref ~= fs_bir_tar
            error('sampling rate mismatch');
        end

        % convolution
        sig_tar = convolution(bir_tar, sig);

        % Composite Loudness Level
        [CLL_tar, fc] = perception_CLL(sig_tar,fs_sig,afeSettings);

        %
        CLL_delta(bdx,:) = CLL_tar - CLL_ref;
    end
end

%% plotting    
figure;
plot(fc, CLL_delta);
ylim([-20,20]);
xlabel('Center Frequency / Hz');
ylabel('Loudness Difference / dB');    

%% gnuplot
gp_save('data.txt', [fc.', CLL_delta.'])

