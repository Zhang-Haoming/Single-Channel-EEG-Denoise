
function [denoised_EEG] = EMD_denoise_EEG_core(noisysignal, fs, noise_type, classify_method)
% EMD_denoise_EEG_core is an core internal function of the single_channle_EEGdenoise
%   toolbox. 
%   
% Inputs:
%   noisysignal; matrix (1-D double array); which contain noisy component.
%   fs: double; the frequency of the input noisysignal data.
%   noise_type; String; 'emg' or 'eog'.
%   classify_method; String; 'threshold' or '2IMF'.
%
% Outputs:
%   noisysignal; matrix (1-D double array); which has been denoised.
%
% See also single_channel_EEGdenoise 

%% calculate EMD decompose and cluster them by frequency feature of hht

[IMF, residual, info] = emd(noisysignal, 'Display',0);

[hs,f,t,imfinsf,imfinse] = hht(IMF,fs);

distance = pdist(imfinsf','seuclidean');

min_limit=0.1;
max_limit= 1;

nordistance = Interval_normalization(distance, min_limit, max_limit);
tree = linkage(nordistance);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for test
% figure(2)
% dendrogram(tree);%显示系统聚类树
% figure(1)
% plot(IMF(:,2))
% figure(3)
% subplot(2,2,1)
% plot(noisysignal)
% title('input noisy signal')
% subplot(2,2,2)
% plot(noisysignal - IMF(:,1)'  )
% title('cleaned by EMD')
% subplot(2,2,3)
% plot(outputeeg(num,:))
% title('cleaned by EEGdenoiseNet')
% subplot(2,2,4)
% plot(eeg(num,:))
% title('clean EEG signal')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Automatic recognize artifact IMFs and reconstruct rest IMFs by cluster result
if noise_type == string('eog')
    if classify_method == string('threshold')
        IMF_EEG_list = [];
        for i = size(tree,1) : -1: 1
            if tree(i,3) > 0.3
                IMF_EEG_list = [ IMF_EEG_list tree(i,1)];
            end
        end
        IMF_EEG = IMF(:,IMF_EEG_list);
        denoised_EEG = sum(IMF_EEG,2)';

    elseif classify_method == string('2IMF')
        denoised_EEG = IMF(:,1)'+ IMF(:,2)';
    end
    
elseif noise_type == string('emg')
    if classify_method == string('threshold')
        IMF_EEG_list = [];
        for i = size(tree,1) : -1: 1
            if tree(i,3) > 0.3
                IMF_EEG_list = [ IMF_EEG_list tree(i,1)];
            end
        end
        IMF_EEG_list = setdiff(1:size(IMF,2), IMF_EEG_list);
        IMF_EEG = IMF(:,IMF_EEG_list);
        denoised_EEG = sum(IMF_EEG,2)';
    
    elseif classify_method == string('2IMF')
        denoised_EEG = noisysignal - IMF(:,1)'- IMF(:,2)';
    end
end
end


function [nordistance] = Interval_normalization(inputmatrix, a, b)
% Interval_normalization This method could normalize a inputmatrix to a
% range: from a to b

inputmatrixmax=max(inputmatrix);% calculate the max number
inputmatrixmin=min(inputmatrix);% calculate the min number

k=(b-a)/(inputmatrixmax - inputmatrixmin);
nordistance=a+k*(inputmatrix-inputmatrixmin);
end