function [C,S]=reIndex(oldCom)
    C=zeros(1,length(oldCom));
    newCom=unique(oldCom);
    S=zeros(1,length(newCom));
    for i=1:length(newCom)
        S(i)=length(oldCom(oldCom==newCom(i)));
    end
    [S,ind]=sort(S,'descend');
    for i=1:length(newCom)
        C(oldCom==newCom(ind(i)))=i;
    end
end