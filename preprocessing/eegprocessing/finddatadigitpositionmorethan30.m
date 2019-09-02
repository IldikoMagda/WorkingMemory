% This script will select only data after digitpos 4
%keep the remaining in a new variable 

digitdata = TABLE(:,110);
allofthem = length(digitdata); 
new40up_alldata_TABLE= [];


NEWdigitreduced = find(TABLE(:, 110)>30); % indeces that match the criteria

%choose those indeces for a new variable 

for each = 1:length(NEWdigitreduced)
    variablevalue = NEWdigitreduced(each);
    new40up_alldata_TABLE =[new40up_alldata_TABLE; TABLE(variablevalue,:)];
    
end



