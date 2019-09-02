% Split data into TRAINING SET and UNSEEN DATASET , permutation dataset and
% classes
%This script is for datasets with 18 features 

function [TRAININGSET, UNSEENDATA, UNSEENCLASSES, PERMUDATA, PERMCLASS] = firstsplit(data)

classes = data(:,7); %choose the classes row

actualdata = data(:, 1:6); % choose all data only 

notremembered = actualdata(classes(:)==0,:); % all data is either remembered or not
remembered = actualdata(classes(:)==1,:);
%Let's first take out the unseen data from the whole, WITHOUT REPLACEMENT,
%RANDOM 

%removing 25% of total data for validation set. 25  % of not remembered,as
%minority class. 50-50 distribution
totalnotremembered = length(notremembered); 
Validationnumber = round(totalnotremembered *0.25);
Trainingnumber = round(totalnotremembered *0.75);
Permutationnumber = round(totalnotremembered *0.5);

%sample out 25% of total not remembered, without replacement
UNSEENDATAnotrem= datasample(notremembered,Validationnumber,'Replace',false);
UNSEENDATArem =datasample(remembered,Validationnumber,'Replace',false);

%these are their classes added to them for now.
UNSEENDATAnotrem(:,7) = 0; 
UNSEENDATArem(:, 7) = 1;

%concatenate the two array

concat = [UNSEENDATAnotrem; UNSEENDATArem];

%shuffle up the raws with classes 
shuffleddata = concat(randperm(size(concat, 1)), :);  %love this piece of code... genious 

%separate results column again and data 

UNSEENDATA = shuffleddata(:, 1:6); 
UNSEENCLASSES= shuffleddata(:, 7);


%now let's pick our training data from the remaining data
newdatasetA = datasample(notremembered, Trainingnumber);
newdatasetB = datasample(remembered, Trainingnumber);


%should concatenate the two... but... now I lost the classlabels
%so let's add them back 

newdatasetA(:,7) = 0; 
newdatasetB(:, 7) = 1; 

pickedtrainingset = [newdatasetA; newdatasetB];

% let's shuffle them anyway 

shufflethetrainingdata =pickedtrainingset(randperm(size(pickedtrainingset, 1)), :);

TRAININGSET= shufflethetrainingdata;

%now let's pick our permutation data from the data
permutationdataA = datasample(notremembered, Permutationnumber);
permutationdataB = datasample(remembered, Permutationnumber);
%attach their actual classes to them
permutationdataA(:,7) = 0; 
permutationdataB(:, 7) = 1;

%concatenate permutation data with true classes (to be shuffled) 

pickedpermutationdatawithclasses = [permutationdataA; permutationdataB]; 

%first shuffle the rows only 

randompermu = pickedpermutationdatawithclasses(randperm(size(pickedpermutationdatawithclasses, 1)),:);
PERMUDATA = randompermu(:, 1:6); 
%shuffle up their classses 

shuffledclasses = randompermu(randperm(size(randompermu,1)),:);

%return
PERMCLASS = shuffledclasses(:,7); 


%return TRAININGSET, UNSEENDATA, UNSEENCLASSES, ;
end 
