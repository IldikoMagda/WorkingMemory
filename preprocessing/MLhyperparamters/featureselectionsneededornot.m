%see if we need feature selection 

data = TABLEfeatures1_18; 

 %split data into trainingset and predictionset 
[trainingdata, predictiondata, predictionclasses, permudata, permclasses] = firstsplit(data);


traind = trainingdata(:, 1:18);
trainc = trainingdata(:,19); 

cvp = cvpartition(trainc,'holdout',1000);

Xtrain = traind(cvp.training,:);
ytrain = trainc(cvp.training,:);
Xtest  = traind(cvp.test,:);
ytest  = trainc(cvp.test,:);

%generate loss without fitting method 
nca = fscnca(Xtrain,ytrain,'FitMethod','none');
L = loss(nca,Xtest,ytest)


%generate loss with fitting 
nca = fscnca(Xtrain,ytrain,'FitMethod','exact','Lambda',0,...
      'Solver','sgd','Standardize',true);
  
  % if this L is less than the previous one, good to go
  
  L = loss(nca,Xtest,ytest)
  %means that the loss is less, so it has a point to do 