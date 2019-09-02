%%% Script to load, run clean rawdata fucntion and check channels after for
%%% interpolation 

clear; 
clc; 

%open and load eeglab in matlab
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% this tracks which version of EEGLAB is being used, you may ignore it
EEG.etc.eeglabvers = '14.1.2'; 

% EEG data directory 
datadir = '/home/ildiko/Desktop/EEG_Data/WM/working_memory/eegfilesonlyWM/icaddata/ICAPrightnames/ICAPdataRIGHTnames';
cd(datadir)
myfiles = dir('*.set'); 
numberoffiles = length(myfiles);


echo on 

for eachfile = 1:numberoffiles 

    cd(datadir)
    filename = [datadir '/' myfiles(eachfile).name];
    EEG = pop_loadset('filename', filename);
    EEG = eeg_checkset( EEG );
    
    
    EEG = clean_rawdata(EEG, 5, [0.25 0.75], 'off', 'off', 20, 0.5);
    
    
    EEG = pop_saveset( EEG, 'filename', [filename '_clean.set']);
    EEG = eeg_checkset( EEG );
    
    
end
