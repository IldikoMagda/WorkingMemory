%hyperparameters of nca
%split data into trainingset and predictionset 

data = new40up_alldata_TABLE;
[trainingdata, predictiondata, predictionclasses, permudata, permclasses] = firstsplit(data);
 
% we are going to use training data only, because it's bigger, and does the
% job
%split data into trainingset and predictionset 
%load('TABLEfeatures1_18.mat')
 

 %split data into trainingset and predictionset 
[trainingdata, predictiondata, predictionclasses, permudata, permclasses] = firstsplit110features(data);


traind = trainingdata(:, 1:108);
trainc = trainingdata(:,109); 

cvp           = cvpartition(trainc,'kfold',5);
numtestsets   = cvp.NumTestSets;
lambdavalues  = linspace(0,2,20)/length(trainc);
lossvalues    = zeros(length(lambdavalues),numtestsets);


%generalization error without fitting 
%nca = fscnca(traind,trainc,'FitMethod','none');
%L = loss(nca,Xtest,ytest)


for i = 1:length(lambdavalues)
    for k = 1:numtestsets
        X = traind(cvp.training(k),:);
        y = trainc(cvp.training(k),:);
        Xvalid = traind(cvp.test(k),:);
        yvalid = trainc(cvp.test(k),:);

        nca = fscnca(X,y,'FitMethod','exact', ...
             'Solver','sgd','Lambda',lambdavalues(i));
                  
        lossvalues(i,k) = loss(nca,Xvalid,yvalid,'LossFunction','quadratic');
    end
end

figure()
plot(lambdavalues,mean(lossvalues,2),'ro-');
xlabel('Lambda values');
ylabel('Loss values');
grid on;

[~,idx] = min(mean(lossvalues,2)); % Find the index
bestlambda = lambdavalues(idx) % Find the best lambda value which then can be usedfor NCA

