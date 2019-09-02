%%% Script to load and relabel events according whether it was remembered or not 

clear; 
clc; 

%open and load eeglab in matlab
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% this tracks which version of EEGLAB is being used, you may ignore it
EEG.etc.eeglabvers = '14.1.2'; 

% EEG data directory 
datadir = '/home/ildiko/Desktop/PROCESSED_Data/batch1';
cd(datadir)
myfiles = dir('*.set'); 
numberoffiles = length(myfiles);

% RESULTS directory

resultsdir = '/home/ildiko/Desktop/RESULTS/RESULTS_batch1';
filesinfolder = fullfile(resultsdir, '*.mat'); %all mat files in results dir
%cd(resultsdir)
%myresults = dir('*.mat')
eachresult = dir(filesinfolder); % name of them 
numberofresults = length(eachresult); %number of them 

echo on 

%trying to load results file (bdata variables) one by one
for resultvariables = 1:numberofresults
        name = fullfile(resultsdir, eachresult(resultvariables).name);
        %name = [resultsdir '/' myresults(resultsvariables).name];
        load(name);


% load the pairing EEG data set
    cd(datadir)
    for eachfile = 1:numberoffiles
    cd(datadir)
    filename = [datadir '/' myfiles(eachfile).name];
    EEG = pop_loadset('filename', filename);
    EEG = eeg_checkset( EEG );

    digitspan = bdata.digitspan;
    numberoftrials = bdata.ntrials;
    correctdigits = bdata.correctdigits;
    numberofeventsrecorded = length(EEG.event);
    
        % relabel events

        for eachtrial = 1:numberoftrials
             for eachdigit = 1:digitspan(eachtrial) % for each digit for each trial -span of numbers shown

                 % find the event in the EEG file that has 8 in the middle
                 % ( presented numbers) 
                 
                 eventofinterest = [num2str(eachtrial) '8' num2str(eachdigit)];
                 
                 if length(bdata.digitacc{eachtrial}) >= eachdigit % find if there is accuracy of that number recorded
                 digitaccuracy = bdata.digitacc{eachtrial}(eachdigit);
                 
                 elseif length(bdata.digitacc{eachtrial}) < eachdigit %if no accuracy, mean forgot before got to that point
                     digitaccuracy == 0 
                 end 
                 %find events matching criteria 
                 for eachevents = 1:numberofeventsrecorded %check all events 
                     
                     testeoi = strcmp(EEG.event(eachevents).type, eventofinterest); %match to events of interest
                     if testeoi == 1

                     % relabel the key triggers
                     % Digit accuracy for each event = 1 or 0 
                        if digitaccuracy==0 % not remembered 

                     EEG.event(eachevents).type = ['800' num2str(eachdigit) '0']; % change event name to 

                        elseif digitaccuracy==1 % remembered 

                     EEG.event(eachevents).type = ['900' num2str(eachdigit) '0']; %change event name to
                     
                        end
                     elseif testeoi ==0 
                     end
                 
                 end
                 
                 
                 
            end
        end
             
       
                 
% save set where events were relabelled 
            EEG = pop_saveset( EEG, 'filename', [filename '_relabeledevents.set']);
    end  
          
end