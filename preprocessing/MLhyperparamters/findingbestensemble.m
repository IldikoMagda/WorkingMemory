% trying to find the optimal tuning of the knn subspace ensemble 
%computationally heavy process that needs at least 16 gb RAM

data = TABLEfeatures73_90 ;

[trainingData ,x, y, q, z] = firstsplit(data); %from this function, we only need the first output 
clear data 

inputTable = array2table(trainingData, 'VariableNames', {'column_1', 'column_2', 'column_3', 'column_4', 'column_5', 'column_6', 'column_7', 'column_8', 'column_9', 'column_10', 'column_11', 'column_12', 'column_13', 'column_14', 'column_15', 'column_16', 'column_17', 'column_18', 'column_19'});

predictorNames = {'column_1', 'column_2', 'column_3', 'column_4', 'column_5', 'column_6', 'column_7', 'column_8', 'column_9', 'column_10', 'column_11', 'column_12', 'column_13', 'column_14', 'column_15', 'column_16', 'column_17', 'column_18'};
predictors = inputTable(:, predictorNames);
response = inputTable.column_19;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

% Train a classifier
% This code specifies all the classifier options and trains the classifier.
subspaceDimension = round(linspace(1,length(predictorNames) ,10));

cvloss = zeros(numel(subspaceDimension),1);
learner = templateKNN('NumNeighbors',3);
echo on
for npred=1:numel(subspaceDimension)
   subspace = fitcensemble(predictors,response,'Method','Subspace','Learners',learner, ...
       'NPredToSample',subspaceDimension(npred),'CrossVal','On');
   cvloss(npred) = kfoldLoss(subspace);
   fprintf('Random Subspace %i done.\n',npred);
end

figure; % plot the accuracy versus dimension
plot(subspaceDimension,cvloss);
xlabel('Number of predictors selected at random');
ylabel('10 fold classification error');
title('k-NN classification with Random Subspace');

