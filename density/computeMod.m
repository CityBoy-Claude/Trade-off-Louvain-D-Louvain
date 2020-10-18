function Mod=computeMod(C,M,S,xita)
    m=sum(sum(M));
    Mod=0;
    newC=unique(C);
    for i=1:length(newC)
        node_comi=find(C==newC(i));
        V_i=sum(S(node_comi));
        sum1=sum(sum(M(node_comi,node_comi)));
        sum2=sum(sum(M(node_comi,:)));
        if sum2>0
            %Mod=Mod+(2*sum1-sum2)/V_i;
            Mod=Mod+(sum1-xita*sum2)/V_i;
        end
    end
end