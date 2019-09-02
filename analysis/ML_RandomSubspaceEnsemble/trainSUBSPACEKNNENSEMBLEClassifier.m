function [trainedSUBSPACEKNNENSEMBLEClassifier, validationAccuracy] = trainSUBSPACEKNNENSEMBLEClassifier(trainingData)
% [trainedClassifier, validationAccuracy] = trainClassifier(trainingData)
% returns a trained classifier and its accuracy. This code recreates the
% classification model trained in Classification Learner app. Use the
% generated code to automate training the same model with new data, or to
% learn how to programmatically train models.
%
%  Input:
%      trainingData: a matrix with the same number of columns and data type
%       as imported into the app.
%
%  Output:
%      trainedClassifier: a struct containing the trained classifier. The
%       struct contains various fields with information about the trained
%       classifier.
%
%      trainedClassifier.predictFcn: a function to make predictions on new
%       data.
%
%      validationAccuracy: a double containing the accuracy in percent. In
%       the app, the History list displays this overall accuracy score for
%       each model.
%
% Use the code to train the model with new data. To retrain your
% classifier, call the function from the command line with your original
% data or new data as the input argument trainingData.
%
% For example, to retrain a classifier trained with the original data set
% T, enter:
%   [trainedClassifier, validationAccuracy] = trainClassifier(T)
%
% To make predictions with the returned 'trainedClassifier' on new data T2,
% use
%   yfit = trainedClassifier.predictFcn(T2)
%
% T2 must be a matrix containing only the predictor columns used for
% training.

% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
% Convert input to table
inputTable = array2table(trainingData, 'VariableNames', {'column_1', 'column_2', 'column_3', 'column_4', 'column_5', 'column_6', 'column_7', 'column_8', 'column_9', 'column_10', 'column_11', 'column_12', 'column_13', 'column_14', 'column_15', 'column_16', 'column_17', 'column_18', 'column_19'});

predictorNames = {'column_1', 'column_2', 'column_3', 'column_4', 'column_5', 'column_6', 'column_7', 'column_8', 'column_9', 'column_10', 'column_11', 'column_12', 'column_13', 'column_14', 'column_15', 'column_16', 'column_17', 'column_18'};
predictors = inputTable(:, predictorNames);
response = inputTable.column_19;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];


% Train a classifier
% This code specifies all the classifier options and trains the classifier.
 
learner = templateKNN('NumNeighbors',2); %2 gave the best results, but the 2 classes should be odd neighbours to not have 50-50 voting 
classificationEnsemble = fitcensemble(...
    predictors, ...
    response, ...
    'Method', 'Subspace', ...
    'NumLearningCycles', 32, ... % results of findingbestnumberoflearners
    'Learners', learner, ... %using knn as weak learners 
    'NPredToSample', 3, ... %number of predictors selected at random
    'ClassNames', [0; 1]);

% Create the result struct with predict function
predictorExtractionFcn = @(x) array2table(x, 'VariableNames', predictorNames);
ensemblePredictFcn = @(x) predict(classificationEnsemble, x);
trainedSUBSPACEKNNENSEMBLEClassifier.predictFcn = @(x) ensemblePredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedSUBSPACEKNNENSEMBLEClassifier.ClassificationEnsemble = classificationEnsemble;


% Compute resubstitution predictions
[validationPredictions, validationScores] = predict(trainedSUBSPACEKNNENSEMBLEClassifier.ClassificationEnsemble, predictors);

% Compute resubstitution accuracy
validationAccuracy = 1 - resubLoss(trainedSUBSPACEKNNENSEMBLEClassifier.ClassificationEnsemble, 'LossFun', 'ClassifError');
