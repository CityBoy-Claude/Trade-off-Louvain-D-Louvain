function Mod=computeMod(C,M,xita)
    m=sum(sum(M));
    Mod=0;
    newC=unique(C);
    intra=0;
    inter=0;
    for i=1:length(newC)
        node_comi=find(C==newC(i));
        sum1=sum(sum(M(node_comi,node_comi)));
        sum2=sum(sum(M(node_comi,:)));
        if sum2>0
            Mod=Mod+(1-xita)*sum1/m-xita*(sum2/m)^2;
        end
        intra=intra+sum1;
        inter=inter+sum2-sum1;
    end
    fprintf('Nc:%f,intra:%f,inter:%f \n',length(newC),intra,inter);
end