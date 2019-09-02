%This script will add subject names to results variables and then attach
%all subject results to a common variable. This script uses specific
%frequency bands of interest instead of the all frequency bands


%load the dataset
datadir = '/home/ildiko/Desktop/PROCESSED_Data/FINALMATFILES';
filesinfolder = fullfile(datadir, '*.mat'); %all mat files in results dir
eachRESULTfile = dir(filesinfolder); % name of them 
numberofresults = length(eachRESULTfile); %number of them 
TABLE1 = [];

%loop through all files in the data directory 
for first = 1: numberofresults
    %load each .mat file 
    results = fullfile(datadir, eachRESULTfile(first).name);
    name = [eachRESULTfile(first).name];
    load(results);
    results.subjectID = name;
    allfrequencybands = 6;
    
    %loop through all freq band of interest and put together in one table
    EPOCH = [];
    EPOCH2 = [];
    
    for eachfrequency = 1:allfrequencybands
    As =results.pow_xx2(:, eachfrequency, :); % take a slice of freq 
    numberoftrials = length(results.pow_xx2(1, 1,:));
    
    Ar =reshape(As, [18, numberoftrials]); %reshape the variable ----->maybe need brackets
    At = num2cell(Ar); %convert to cell
    An = cell2mat(At); 
    Bt =results.memorystatus.'; %change the dimension from 176 x1 to 1x 176
    Bn = cell2mat(Bt);
    
    Ct = results.digitposition.';
    Cn = str2double(Ct); 
    
   % EPOCH = [EPOCH [Ar ; Bn ; Cn]];
    
   EPOCH = [Ar;EPOCH];
        
    end
    
    EPOCH2 = [EPOCH;Bn;Cn];
    
    TABLE1 = [TABLE1 [EPOCH2]];
    
end


TABLE = transpose(TABLE1); 
