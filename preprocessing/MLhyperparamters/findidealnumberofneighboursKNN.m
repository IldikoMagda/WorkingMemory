% this script will evaluate how many neighbours should I be using 

data = TABLEfeatures91_108 ;
N= 100; 
[trainingData, x, y, z, q] = firstsplit(data); 
clear data 

inputTable = array2table(trainingData, 'VariableNames', {'column_1', 'column_2', 'column_3', 'column_4', 'column_5', 'column_6', 'column_7', 'column_8', 'column_9', 'column_10', 'column_11', 'column_12', 'column_13', 'column_14', 'column_15', 'column_16', 'column_17', 'column_18', 'column_19'});

predictorNames = {'column_1', 'column_2', 'column_3', 'column_4', 'column_5', 'column_6', 'column_7', 'column_8', 'column_9', 'column_10', 'column_11', 'column_12', 'column_13', 'column_14', 'column_15', 'column_16', 'column_17', 'column_18'};
predictors = inputTable(:, predictorNames);
response = inputTable.column_19;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];


rng(8000,'twister') % for reproducibility -random number generator that is remembered
K = round(logspace(0,log10(N),10)); % Choose the number of neighbors approximately evenly spaced on a logarithmic scale 
cvloss = zeros(numel(K),1);
for k=1:numel(K)
    knn = fitcknn(predictors,response,...
        'NumNeighbors',K(k),'CrossVal','On');
    cvloss(k) = kfoldLoss(knn);
end
figure; % Plot the accuracy versus k
semilogx(K,cvloss);
xlabel('Number of nearest neighbors');
ylabel('10 fold classification error');
title('k-NN classification');