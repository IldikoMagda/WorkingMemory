
%%% This script will use a different approach to validate machine learning
%%% algorithms. The training will occur only once and bootstrap validation
%%% will be done using an unseen test data and then prediction data

%load('TABLEfeatures1_18.mat');  
data= TABLEfeatures91_108; 
tic
% how many times you want to repeat 
%let's say 100 for now  
samplingout = 300; 
accuracyovertimePREDICTION= [];
accuracyovertimePERMUTATION = []; 
ErrorRatePREDICTION =[]; 
ErrorRatePERMUTATION = []; 

FINALconfusionmatrix = zeros(2,2);


for i = 1:samplingout 
    
%split data into trainingset and predictionset 
[trainingdata, predictiondata, predictionclasses, permudata, permclasses] = firstsplit(data);

%train model and return it, with accuracy
[Trainedmodel, TrainingAccuracy] = ALLfeatureKNNtrainClassifier(trainingdata);


%test on unseen data and obtain accuracy 

%yfit = trainmodel.predictFcn(predictiondata); %just saves the predictions 
yfit = Trainedmodel.predictFcn(predictiondata);

%create numerical results
confusionmatrix1 = confusionmat(predictionclasses, yfit); 
a = confusionmatrix1(1,1)/  length(predictiondata(:,1))*100; %correctly predicted 0 in %
b = confusionmatrix1(2,2)/ length(predictiondata(:,1))* 100; %correctly classified 1 in %

overallclassifacc = a + b; 

%each class sensitivity and specificity and all this adding to a common
%confusion matrix 
matrix = confusionmatrix1; 

TP = matrix(2,2); %True positive 
TN = matrix(1,1); %True negative 

FN = matrix(2,1); %False negative 
FP = matrix(1,2);  %False positive 

% a bit forced but whatever, surely there is an easier way 

FINALconfusionmatrix(1,1)= FINALconfusionmatrix(1,1) +TN; 
FINALconfusionmatrix(1,2) = FINALconfusionmatrix(1,2) +FP; 
FINALconfusionmatrix(2,1) = FINALconfusionmatrix(2,1) +FN; 
FINALconfusionmatrix(2,2) = FINALconfusionmatrix(2,2) +TP; 

% save all accuracies
accuracyovertimePREDICTION= [accuracyovertimePREDICTION ; overallclassifacc]; %accuracy for each
cp = classperf(predictionclasses, yfit); %classificationperformance
ErrorRatePREDICTION =[ErrorRatePREDICTION ;[cp.ErrorRate]]; % error rate for each 
FeatureAndAcc(19, i)= accuracyovertimePREDICTION(i,:);

% let's do permutation test with our lovely trained model
%pretending is normal data, 
%repeat of previous steps 

permfit = Trainedmodel.predictFcn(permudata);
confusionmatrix2 = confusionmat(permclasses, permfit);
PERMa = confusionmatrix2(1,1)/  length(permudata(:,1))*100; %correctly predicted 0 in %
PERMb= confusionmatrix2(2,2)/ length(permudata(:,1))* 100;

overallPERMacc = PERMa + PERMb; 

accuracyovertimePERMUTATION =[accuracyovertimePERMUTATION ; overallPERMacc];
pp = classperf(permclasses, permfit); %classification performance 
ErrorRatePERMUTATION = [ErrorRatePERMUTATION ; [pp.ErrorRate]];



end
FinalAverageAccuracy = mean(accuracyovertimePREDICTION);
FinalAverageErrorrate = mean(ErrorRatePREDICTION);
FinalAveragePERMUacc = mean(accuracyovertimePERMUTATION);
FinalAveragePERMUErrorRate= mean(ErrorRatePERMUTATION);

toc

