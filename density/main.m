clc;
%email-EU,polbooks,TerrorAttack,TerroristRel,zachary
datasetName='email-EU';
load(['..\Dataset\',datasetName,'\',datasetName,'A.mat']);
load(['..\Dataset\',datasetName,'\',datasetName,'label.mat']);
result={}
for xita=0.1:0.1:0.9
[COMTY,~]=genlouvain1(A,1,xita)
r=size(COMTY.COM);
r=r(2);
NMI=[];
for i=1:r
    NMI=[NMI nmi(COMTY.COM{1,i},labels)];
end
result{int8(xita*10)}=max(NMI);
k=max(labels)
end
result