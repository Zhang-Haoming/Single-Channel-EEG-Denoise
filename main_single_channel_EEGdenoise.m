% GENERAL ANALYSIS CONFIGURATION SETTINGS
cfg = []; % clear the config variable
%cfg.datadir = 'Example_data\EOG'; % this is where the data files are
cfg.datadir = 'E:\GAN_output\EMD_for_EEG_denoise\EMG';
cfg.filenames = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' };
cfg.datafile_name = {'noiseEEG_test'};
cfg.noise_type = 'emg'; % String; 'emg' or 'eog'
cfg.denoise_method = 'emd'; % String; 'filter' or 'emd'
cfg.filtering_band = [12, 0]; % Double; cut-off frequency:[min, max], {max:[]/0 -> highpass, min:[]/0 -> lowpass}
cfg.classify_method = '2IMF'; % String; 'threshold' or '2IMF'
cfg.fs = 512; % double; the frequency of the input noisysignal data.
cfg.save_type = 'npy'; % String; 'mat' or 'npy'
%cfg.outputdir = 'Example_data\\EOG'; % output location
cfg.outputdir = 'E:\GAN_output\EMD_for_EEG_denoise\EMG';
single_channle_EEGdenoise(cfg); % run first level analysis
