
%%% Script to load and semi automate channel rejection 

clear; 
clc; 

%open and load eeglab in matlab
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% this tracks which version of EEGLAB is being used, you may ignore it
EEG.etc.eeglabvers = '14.1.2'; 

% EEG data directory 
datadir = '/home/ildiko/Desktop/EEG_Data/WM/working_memory/eegfilesonlyWM/icaddata/ICAPrightnames/ICAPdataRIGHTnames/readytointerpolate';
cd(datadir)
myfiles = dir('*.set'); 
numberoffiles = length(myfiles);



for eachfile = 1: numberoffiles
    cd(datadir)
    filename = [datadir '/' myfiles(eachfile).name];
    EEG = pop_loadset('filename', filename);
    EEG = eeg_checkset( EEG );
    

pop_rejchan(EEG);
      
    
pop_interp(EEG);
    
pop_saveset(EEG);
     
end
