%%% script to loop through the files, get power spectral density using Welch
%%% method 

%Should also get labels and accouracy at some point before obtaining the
%results 

%open and load eeglab in matlab
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% this tracks which version of EEGLAB is being used, you may ignore it
EEG.etc.eeglabvers = '14.1.2'; 

% EEG data directory 
datadir = '/home/ildiko/Desktop/PROCESSED_Data/batch6/readyPROCfiles';
cd(datadir)
myfiles = dir('*.set'); 
numberoffiles = length(myfiles);

%Loop through all files 

echo on
cd(datadir)

for eachfile = 1:numberoffiles
cd(datadir)
filename = [datadir '/' myfiles(eachfile).name];

%load eeg set
EEG = pop_loadset('filename', filename);
EEG = eeg_checkset( EEG );
      
results = full_welsch(EEG);
 
filename = [filename '.mat'];
save(filename, 'results')
 

end