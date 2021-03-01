
function single_channel_EEGdenoise(cfg)
% single_channle_EEGdenoise toolbox to denoise single channel EEG data
%
% Code author: Haoming Zhang  from Southern University of Science and Technology
%   
% Date: 2021/2/1
%
% Description: 
%   EMD_denoise_EEG is a Matlab software for denoising single channel EEG 
%   raw data. This software contain two methods: filter and Empirical Mode Decomposition(EMD)
%   This EMD method realize the paper: "HILBERT-HUANG TRANSFORM BASED HIERARCHICAL
%   CLUSTERING FOR EEG DENOISING" by author Ahmet Mert and Aydin Akan.
%
% Inputs:
%   The function accepts as data formats: epoched raw/preprocessed files in
%   Numpy format (.npy) or Fieldtrip format (.mat). The input files should
%   be a 2-D matrix(trials * EEG time series) or a 1-D matrix(1 * EEG time
%   series). An example could be find in 'Example_data' file. We also provide 
%   clean EEG data for people to observe it's denoise ability. The example
%   signals come from EEGdenoiseNet.
%   We use npy-matlab-master toolbox to load and write .npy c in Matlab.
%
% Outputs:
%   The shape of the output matrix is the same as inputs, and saved as
%   Numpy format (.npy) or Fieldtrip format (.mat).
%
% Usage:
%   GENERAL ANALYSIS CONFIGURATION SETTINGS
%   cfg = []; % clear the config variable
%   cfg.datadir = 'Example_data\EOG'; % this is where the data files are
%   the data files are
%   cfg.filenames = {'1' '2'  };
%   cfg.datafile_name = 'noiseEEG_test';
%   cfg.noise_type = 'eog'; % String; 'emg' or 'eog'
%   cfg.denoise_method = 'filter'; % String; 'filter' or 'emd'
%   if cfg.denoise_method == 'filter'
%       cfg.filtering_band = [12, 80]; % Double; cut-off frequency:[min, max], {max:[]/0 -> highpass, min:[]/0 -> lowpass}
%   elseif cfg.denoise_method == 'emd'
%       cfg.classify_method = '2IMF'; % String; 'threshold' or '2IMF'
%   cfg.fs = 256; % double; the frequency of the input noisysignal data.
%   cfg.save_type = 'mat'; % String; 'mat' or 'npy'.
%   cfg.outputdir = 'Example_data\\EOG'; % output location
%   single_channle_EEGdenoise(cfg); % run first level analysis
%
% See also: EMD_denoise_EEG_core

%% Check input variable

if isempty(cfg.datadir)
    error('The input datadir string is empty')
end
if isempty(cfg.datafile_name)
    error('The input datafile_name string is empty')
end
if isempty(cfg.filenames)
    error('The input filenames cell is empty')
end
if isempty(cfg.fs)
    error('The input fs is empty')
end
if strcmpi(cfg.noise_type,'emg') == 0 && strcmpi(cfg.noise_type,'eog') == 0
    error('char noise_type should be emg or eog')
end

if strcmpi(cfg.denoise_method,'emd') == 0 && strcmpi(cfg.denoise_method,'filter') == 0
    error('char denoise_method should be emd or filter')
end
if cfg.denoise_method == string('emd')
    if strcmpi(cfg.classify_method,'threshold') == 0 && strcmpi(cfg.classify_method,'2IMF') == 0
        error('char classify_method should be threshold or 2IMF')
    end
end

if strcmpi(cfg.save_type,'mat') == 0 && strcmpi(cfg.save_type,'npy') == 0
    error('char save_type should be mat or npy')
end
%% Running denoising code for each file
nfiles = length(cfg.filenames);
nsubjects = length(cfg.datafile_name);
for file_i = 1:nfiles
    for subject_i = 1:nsubjects
        try
        %% Load data from .npy or .mat
            disp(['Denoising file ' cfg.filenames{file_i},'/',cfg.datafile_name{subject_i} ]);
                % first try to load eeglab data in .set format
            if exist([cfg.datadir,filesep, cfg.filenames{file_i},filesep,cfg.datafile_name{subject_i}, '.npy'],'file')
                noisyeeg = readNPY([cfg.datadir,filesep, cfg.filenames{file_i},filesep,cfg.datafile_name{subject_i}, '.npy']);
                % next, attempt to load npy data in .npy format in case this fails
            elseif exist([cfg.datadir,filesep, cfg.filenames{file_i},filesep,cfg.datafile_name{subject_i}, '.mat'],'file')
                noisyeeg = load([cfg.datadir,filesep, cfg.filenames{file_i},filesep,cfg.datafile_name{subject_i}, '.mat']);
                % next, attempt to load mat data in .mat format in case this fails
            else
                wraptext('The data needs to be stored in matlab format (.mat extension) or in numpy format (.npy extension). The toolbox attempts to read your datafile using both extensions. If you are reading this message, both attempts have failed.');
                error(['Cannot load data, filename ''' cfg.datafile_name{subject_i} ''' cannot be found at ''' [cfg.outputdir,filesep, cfg.filenames{file_i}] '''']);
            end

        %% 
            Denoiseoutput_test = [];
            
            if cfg.denoise_method == string('emd')
                for nepoch = 1:size(noisyeeg,1)
                    Denoiseoutput_test = [Denoiseoutput_test; EMD_denoise_EEG_core(noisyeeg(nepoch,:), cfg.fs, cfg.noise_type, cfg.classify_method)];
                    cmd_progress_bar('EEG Denoising by EMD', nepoch, size(noisyeeg,1));
                end
            elseif cfg.denoise_method == string('filter')
                for nepoch = 1:size(noisyeeg,1)
                    Denoiseoutput_test = [Denoiseoutput_test; filter_data(noisyeeg(nepoch,:), cfg.fs, cfg.filtering_band(1), cfg.filtering_band(2), 512)];% The last parameter is the order of filter
                    cmd_progress_bar('EEG Denoising by filter', nepoch, size(noisyeeg,1));
                end
            end

        %% save the denoised output
            output_location = [cfg.outputdir,filesep, cfg.filenames{file_i}];
            if(~exist(output_location, 'dir'))
                mkdir(output_location);
            end
            if cfg.save_type == 'npy'
                writeNPY(Denoiseoutput_test, [output_location,'/',cfg.denoise_method,'_', cfg.datafile_name{subject_i},'_Denoiseoutput.npy']);
            elseif cfg.save_type == 'mat'
                save([output_location,'/',cfg.denoise_method,'_', cfg.datafile_name{subject_i},'_Denoiseoutput.mat'], 'Denoiseoutput_test');
            end
            disp('Done.');
            
        catch ME
            disp(ME.message);
            disp('************************************************************************************************************');
            disp(['ERROR: could not analyze data from file ' cfg.filenames{file_i} '. Skipping and continuing to next subject.']);
            disp('************************************************************************************************************');
        end
    end
end
