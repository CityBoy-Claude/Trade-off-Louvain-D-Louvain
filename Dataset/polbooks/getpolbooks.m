clear;clc;
f=fopen('polbooks.mtx');
fgetl(f);
str=fgetl(f);
nums=str2num(str);
nodes_num=nums(1);
edges_num=nums(1);
for i=1:edges_num
    str=fgetl(f);
    edge{i}=str2num(str);
end
A=zeros(nodes_num,nodes_num);
for i=1:edges_num
    A(edge{i}(1),edge{i}(2))=1;
    A(edge{i}(2),edge{i}(1))=1;
end