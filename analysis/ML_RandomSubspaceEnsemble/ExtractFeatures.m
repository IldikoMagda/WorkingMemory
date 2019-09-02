%find features used to trainf machine learning
%assuming we have a trained subspace knn ensemble model 
%trying to access the predictors used for learner


%18 features were used with 39 cycles. random 5 features used. 
%which ones, are recorded here: 
%they are recorded as logical values of used/not used 

function featuresused = ExtractFeatures(Trainedmodel)

usedpredictors = Trainedmodel.ClassificationEnsemble.UsePredForLearner;

numberoffeatures = 18;
cycles = 39;
%how many times a feature was used ,empty array
featuresused = [];

%sum up learners for each features 
for each = 1:numberoffeatures
    
numberforone = sum(usedpredictors(each,:)); %sum of each row, how many times that channels was used
featuresused = [featuresused ; numberforone];


end 
end


