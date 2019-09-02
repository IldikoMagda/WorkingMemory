%%% Script to load, epoch data that's events has been renamed 

clear; 
clc; 

%open and load eeglab in matlab
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% this tracks which version of EEGLAB is being used, you may ignore it
EEG.etc.eeglabvers = '14.1.2'; 

% EEG data directory 
datadir = '/home/ildiko/Desktop/kurvaanyadert';
cd(datadir)
myfiles = dir('*.set'); 
numberoffiles = length(myfiles);

for eachfile = 1:numberoffiles
    cd(datadir)
    filename = [datadir '/' myfiles(eachfile).name];
    EEG = pop_loadset('filename', filename);
    EEG = eeg_checkset( EEG );
    
    EEG = pop_epoch( EEG, {'80010' '80020' '80030' '80040' '80050' '80060' '80070' ...
'80080' '80090' '800100' '800110' '800120' '800130' '800140'...
'90010' '90020' '90030'  '90040' '90050' '90060' '90070' '90080' '90090'...
'900100' '900110' '900120' '900130' '900140'}, [0           1],'newname', [filename '_eventepoched'], 'epochinfo', 'yes');
    EEG.setname= [filename '_eventepoched.set'];
    EEG = pop_saveset(EEG, 'filename', [filename '_eventepoched.set']);
    %EEG = pop_saveset( EEG, 'filename', [filename '_numberepoched.set']);
        
end
