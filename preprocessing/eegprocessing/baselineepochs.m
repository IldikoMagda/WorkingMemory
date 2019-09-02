%%% Script to load, epoch baseline data  

clear; 
clc; 

%open and load eeglab in matlab
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% this tracks which version of EEGLAB is being used, you may ignore it
EEG.etc.eeglabvers = '14.1.2'; 


% EEG data directory 
datadir = '/home/ildiko/Desktop/PROCESSED_Data/batch6/interp6';
cd(datadir)
myfiles = dir('*.set'); 
numberoffiles = length(myfiles);


% Loop through to get all baseline event 

for eachfile = 1:numberoffiles
    cd(datadir)
    filename = [datadir '/' myfiles(eachfile).name];
    EEG = pop_loadset('filename', filename);
    EEG = eeg_checkset( EEG );


% save set with new name baseline epochs
EEG = pop_epoch( EEG, {  '10'  }, [-1           0], 'newname', [filename 'baseline epochs'], 'epochinfo', 'yes');
EEG.setname=[filename 'baseline epochs'];
%Save ICA and data
EEG = pop_saveset(EEG, 'filename', [filename '_baselines.set']);

EEG = eeg_checkset( EEG );

end
