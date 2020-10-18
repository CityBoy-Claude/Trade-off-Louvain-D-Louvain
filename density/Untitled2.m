dataset={'email-EU','polbooks','TerrorAttack','TerroristRel','zachary'};
for i=1:5
datasetName=char(dataset(2));
load(['..\Dataset\',datasetName,'\',datasetName,'A.mat']);
load(['..\Dataset\',datasetName,'\',datasetName,'label.mat']);
links=sum(sum(A))/2;
fprintf('dataset:%s,node:%i,edge:%i,rate:%f \n',datasetName,size(A,1),links,links/(size(A,1)^2));
end