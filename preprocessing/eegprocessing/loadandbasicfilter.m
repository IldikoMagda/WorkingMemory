% EEGLAB history file merged with my code 
% should import, load channel locs, rereference, filter, cleanline, ica, save
%-----------------------------------------------------------------------------

clear; 
clc; 

%open and load eeglab in matlab
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% this tracks which version of EEGLAB is being used, you may ignore it
EEG.etc.eeglabvers = '14.1.2'; 

%data directories 
datadir = '/home/ildiko/Desktop/EEG_Data/WM/working_memory/eegfilesonlyWM'
%filtereddatadir = '/home/ildiko/Desktop/EEG_Data/WM/working_memory/eegfilesonlyWM/filtereddatadir/ '

%get the files 
cd(datadir)
myfiles = dir('*.easy');

%save number of items in a variable 
numsubjects = length(myfiles); 

%counter variable
COUNTER = 0 

% do not save intermediate steps 
save_everything = 0;  

%import each file and
% store the set into eeglab 
%loop through and filter each subject 

tic  %time how long it runs 
for eachofthem = 1:numsubjects
    cd(datadir)
	fprintf('\n\n\n***Processing subject %deachofthem\n***\n', eachofthem);  % print which subject is being processed 
    
    filename = [datadir '/' myfiles(eachofthem).name]
    %import data
    EEG = pop_easy(filename,0,0,[]);
    [ALLEEG EEG CURRENTSET ] = eeg_store(ALLEEG, EEG);
    EEG.filename = EEG.setname
    EEG.setname = filename; 

    %channel locations
    EEG = pop_editset(EEG, 'chanlocs', '/home/ildiko/Desktop/EEG_Data/WM/locs_file_20_complete.locs')
    
    %rereference to average 
    EEG = pop_reref( EEG, [11 13]);

    %High pass filter at 0.5 Hz 
    EEG = pop_eegfiltnew(EEG, [],0.5,[],1,[],0);

    %Notch filter 45-55 Hz 
    %EEG = pop_eegfiltnew(EEG, 45,55,826,1,[],0);

    % CleanLine line automated line noise removal 
    EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:18] ,'computepower',1,'linefreqs',50,'normSpectrum',0,'p',0.01,'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels','tau',100,'verb',1,'winsize',4,'winstep',1);
    
    %save after filtering steps
    EEG = pop_saveset(EEG, 'filename', [filename '_filt.set']); 
    
    %Run ICA 
    EEG = pop_runica(EEG, 'extended', 1);

    %Save ICA and data
    EEG = pop_saveset(EEG, 'filename', [filename '_ica.set']); 
    % add to counter 
 
	COUNTER = COUNTER + 1;
end
toc
eeglab redraw;





