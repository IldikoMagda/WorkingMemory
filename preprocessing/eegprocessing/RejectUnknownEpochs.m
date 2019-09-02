%%% This script's aim is to mark those events for rejection that we do not
%%% have actual accuracy data on. To keep only the first forgotten number's
%%% data.

clear; 
clc; 

%open and load eeglab in matlab
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% this tracks which version of EEGLAB is being used, you may ignore it
EEG.etc.eeglabvers = '14.1.2'; 

% EEG data directory 
datadir = '/home/ildiko/Desktop/PROCESSED_Data/TRIALFFT/';
cd(datadir)
myfiles = dir('*.set'); 
numberoffiles = length(myfiles);


%Loop through all files 

echo on
cd(datadir)

    for eachfile = 1:numberoffiles
    cd(datadir)
    filename = [datadir '/' myfiles(eachfile).name];
    EEG = pop_loadset('filename', filename);
    EEG = eeg_checkset( EEG );
    

%EEG set variables
numberofevents = length(EEG.epoch) -1; % -1 event last one doesn't break the code...
allevents = 1: numberofevents;          % as I compare two events 
markedforrejection = [];


%Loop through all events
for eachepoch = allevents
    
    %find the labels of two neighbouring event and convert them to numbers
    labelA = EEG.epoch(eachepoch).eventtype; %90010 per se or 80050 
    labelA = str2double(labelA);
    nextepoch = eachepoch +1;
        
    labelB = EEG.epoch(nextepoch).eventtype;
    %next is either 900* or 800* /remembered or not 
    
    labelB= str2double(labelB);
 
    
    if labelA <= 90000 % if forgotten
        if labelB <= 90000  % next forgotten too --> reject second
  
          markedforrejection(end +1) = nextepoch ; %save the number of the event into a variable thatI want to reject
        
        end
    end
    
    
 end

    EEG = pop_rejepoch( EEG, markedforrejection ,0);
    EEG = pop_saveset( EEG, 'filename', [filename 'removedlabels.set']);
    
    end
         
