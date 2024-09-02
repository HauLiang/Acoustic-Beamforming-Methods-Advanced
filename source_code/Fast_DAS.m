function [X, Y, DAS_result] = Fast_DAS(CSM, w, frequencies, scan_limits, scan_resolution)
%
% This code implements the delay-and-sum (DAS) algorithm (fast version)
%    Van Veen, Barry D and Buckley, Kevin M,
%    "Beamforming: A versatile approach to spatial filtering",
%    IEEE assp magazine, 1988.
%
%
% Inputs:
%    CSM:  cross-spectrum matrix (CSM)
%    w:    weighted steering vector
%    frequencies:   scan-frequency band
%    scan_limits:   scanning plane
%    scan_resolution:   scan resolution
%
% Outputs:
%    X & Y:  Two-dimensional coordinates corresponding to the beamforming map
%    DAS_result:  beamforming map, obtained by DAS
%
% Author: Hao Liang
% Last modified by: 23/07/29
%

% Scanning plane setting
X = scan_limits(1):scan_resolution:scan_limits(2);
Y = scan_limits(3):scan_resolution:scan_limits(4);
N_X = length(X); N_Y = length(Y); N_mic = size(w,3);

% Parameter initialization
DAS_result = zeros(1,N_X*N_Y);
N_freqs = length(frequencies);


% Start scan-frequency beamforming
for K = 1:N_freqs

    % Calculate the weighted steering vector corresponding to the frequency K
    wk = w(:,:,:,K); wk_reshape = reshape(wk,[], N_mic).';

    % Matrix form: Calculate the DAS beamforming map corresponding the K frequency
    DAS_freqK = sum(conj(wk_reshape).*(CSM(:,:,K)*wk_reshape), 1)./N_mic^2;

    % Accumulate the frequency components
    DAS_result = DAS_result + DAS_freqK;

end

% Reshape the beamforming map
DAS_result = reshape(DAS_result, N_X, N_Y);

end