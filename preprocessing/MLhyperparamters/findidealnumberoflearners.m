% Find the smallest number of learner for KNN ensemble. 

data = TABLEfeatures91_108;

[trainingData,x,y,z,w] = firstsplit(data);

inputTable = array2table(trainingData, 'VariableNames', {'column_1', 'column_2', 'column_3', 'column_4', 'column_5', 'column_6', 'column_7', 'column_8', 'column_9', 'column_10', 'column_11', 'column_12', 'column_13', 'column_14', 'column_15', 'column_16', 'column_17', 'column_18', 'column_19'});

predictorNames = {'column_1', 'column_2', 'column_3', 'column_4', 'column_5', 'column_6', 'column_7', 'column_8', 'column_9', 'column_10', 'column_11', 'column_12', 'column_13', 'column_14', 'column_15', 'column_16', 'column_17', 'column_18'};
predictors = inputTable(:, predictorNames);
response = inputTable.column_19;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];



learner = templateKNN('NumNeighbors',3); % 2 gave the best results, but the 2 classes should be odd neighbours to not have 50-50 voting 
classificationEnsemble = fitcensemble(...
    predictors, ...
    response, ...
    'Method', 'Subspace', ...
    'Learners', learner, ...
    'NPredToSample', 3, ... 
    'CrossVal','On', ...
    'ClassNames', [0; 1]);


figure; % Plot the accuracy versus number in ensemble
plot(kfoldLoss(classificationEnsemble,'Mode','Cumulative'))
xlabel('Number of learners in ensemble');
ylabel('10 fold classification error');
title('k-NN classification with Random Subspace');



