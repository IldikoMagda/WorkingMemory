function results = full_welsch(EEG) 

%%This function is to put together Welch method, average over frequency
%%bands, saving memory status and digitposition of a given pre-processed EEG
%%data

%Welch method


% determine the parameters for pwelch and save into config variable 

config.epochsize = 1; % this is how you want to break the data in seconds
config.pwindow = 1; % size of the window for Welch 
config.overlap = 0; % how much overlap (here half of the window, 0.5) as a proportion
config.freqrange = [1 80]; % the frequency range you want to analyse
config.freqbands = [1 4;4 8;8 12;12 30;30 45;55 80]; % define frequency bands
config.channels = 1:18; %(vector with the channels to analyse)

EEG = EEG
numberofepochs = length(EEG.epoch); 
allepochs = 1: numberofepochs;    

%create a two column structure with power and pairing frequency band

pow_xx = [];results.freqbands=[]; 

    %loop through each trial of the set 
    for eachepoch = 1:EEG.trials
      
        %loop through each channel  
        for eachchannel = 1:length(config.channels) 
        
        % Obtain raw data for each channel 
        rawdata = [];
        rawdata = EEG.data(eachchannel,:,eachepoch);
        
        % Carry out Welch-method for each channel 
        xx = [];freq = [];  
        [xx,freq]=pwelch(rawdata,config.pwindow*EEG.srate,config.overlap,[],EEG.srate);
        pow_xx(eachchannel,:,eachepoch) = xx;
            
        end
       
               
    end

    
    % now average over frequency bands
    %loop through every given frequency band to analyse
   for eachfreqband = 1:length(config.freqbands(:,1)) 
   
    freqpoints = find(freq>=config.freqbands(eachfreqband,1) & freq<=config.freqbands(eachfreqband,2))';
    
    allfreqpoints = find(freq>=2 & freq<=45)';
    
    pow_xx2(:,eachfreqband,:) = sum(pow_xx(:,freqpoints,:),2)./sum(pow_xx(:,allfreqpoints,:),2);
      
    results.freqbands = [ results.freqbands;config.freqbands(eachfreqband,1) config.freqbands(eachfreqband,2)];
    

   end
   
   results.pow_xx = pow_xx;
   results.pow_xx2 = pow_xx2;
   results.freq = freq;
   
 %add memory status to results variable ,whether the trial was remembered
 %or not. Also adding a variable with which digit was it. 
   
 memorystatus = [];
 digitposition = [];

 for eachevent = allepochs
     
     TRIALLABEL = EEG.epoch(eachevent).eventtype; % '90010' e.g
   
     vectortoadd= TRIALLABEL(4:5);
     digitposition = [digitposition; {vectortoadd}];
     TRIALLABEL= str2double(TRIALLABEL); 
     
     digit = 1 ;
     %check the value of the number to see if it was forgotten or not
     %then add it to memorystatus variable
     if TRIALLABEL <= 90000
         digit = 0  % assign 0 to forgotten
         memorystatus = [memorystatus; {digit}]; 
     else
         digit = 1  % assign 1 to remembered
         memorystatus = [memorystatus; {digit}];  
         
     end 
    
 end
    
%attach these to results variable 
 results.memorystatus= memorystatus;
 results.digitposition = digitposition;

return
results = results;