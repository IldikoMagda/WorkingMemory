function Out = pwelch_eeg(cfg,EEG)

% this function estimate the power spectrum based on the eeglab data
% structure (epoched or not)

% Please input:
% determine the parameters for pwelch
cfg.epochsize = 0.75; % this is how you want to break the data in seconds
cfg.pwindow = 1; % size of the window for Welch 
cfg.overlap = 0; % how much overlap (here half of the window, 0.5) as a proportion
cfg.freqrange = [1 80]; % the frequency range you want to analyse
cfg.freqbands = [1 4;4 8;8 12;12 30;30 45;55 80]; % define frequency bands
cfg.channels = 1:18; (vector with the channels to analyse)

pow_xx = [];results.freqbands=[];

    for ep_i = 1:EEG.trials
      
             
        for ch_i = 1:length(cfg.channels) 
            
        rawdata = [];
        rawdata = EEG.data(ch_i,:,ep_i);
        xx = [];freq = [];  
        [xx,freq]=pwelch(rawdata,cfg.pwindow*EEG.srate,cfg.overlap,[1:1:45],EEG.srate);
        pow_xx(ch_i,:,ep_i) = xx;
        
        end
       
               
    end

    
    % now average over frequency bands
    
   for freq_i = 1:length(cfg.freqbands(:,1)) 
   
    freqpoints = [];
    freqpoints = find(freq>=cfg.freqbands(freq_i,1) & freq<=cfg.freqbands(freq_i,2))';
    
    allfreqpoints = [];
    allfreqpoints = find(freq>=2 & freq<=45)';
    
    pow_xx2(:,freq_i,:) = sum(pow_xx(:,freqpoints,:),2)./sum(pow_xx(:,allfreqpoints,:),2);
      
    results.freqbands = [ results.freqbands;cfg.freqbands(freq_i,1) cfg.freqbands(freq_i,2)];
    

   end
   
   results.pow_xx = pow_xx;
   results.pow_xx2 = pow_xx2;
   results.freq = freq;
   

Out = results;
