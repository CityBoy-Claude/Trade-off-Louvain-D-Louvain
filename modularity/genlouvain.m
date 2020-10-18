function [COMTY,ending]=genlouvain(A,s,xita)
    ending=0;
    M=A;
    if nnz(M-M')
        M=(M+M')/2;
    end
    shape = size(M);
    N = shape(1);
    M2 = M;
    M2((N+1).*[0:N-1]+1) = 0;
    m = sum(sum(M));
    niter=1;
    if m==0||N==1
        fprintf('FINISH!\n');
        ending=1;
        COMTY=0;
        return;
    end
    %main loop
    K = sum(M); 
    sumTot = sum(M);
    sumIn = diag(M); 
    com = 1:shape(1);
    for k=1:N
      Neighbor{k} = find(M2(k,:));
    end
    isGain=1;
    while(isGain==1)
        cost=zeros(1,N);
        isGain=0;
        for i=1:N
        %for i=randperm(N)
            com_i = com(i); 
            neighbor_i = Neighbor{i};
            gain = zeros(1,N); 
            best_gain = -1;
            newCom = com_i;
            com(i) = -1;
            sumTot(com_i) = sumTot(com_i) - K(i);
            node_ci = find(com==com_i);
            sumIn(com_i) = sumIn(com_i) - 2*sum(M(i,node_ci)) - M(i,i); 
            for j=1:length(neighbor_i)
            %for j=randperm(length(neighbor_i))
                com_j = com(neighbor_i(j));
                if(gain(com_j)==0)
                    node_cj = find(com==com_j);
                    Ki_in=2*sum(M(i,node_cj));
                    gain(com_j)=(1-xita)*Ki_in/m - xita*2*K(i)*sumTot(com_j)/(m*m);
                    %fprintf('community:%d,gain=%g\n',com_j-1,gain(com_j));
                    if (gain(com_j)>best_gain)
                        best_gain=gain(com_j);
                        new_t=com_j;
                    end
                end
            end
            if best_gain>0
                newCom=new_t;
                %fprintf('Move %d => %d\n',i-1,newCom-1);
                cost(i)=best_gain;
            end
            com_k=find(com==newCom);
            sumIn(newCom) = sumIn(newCom) + 2*sum(M(i,com_k));
            sumTot(newCom) = sumTot(newCom) + K(i);
            com(i) = newCom;
            if newCom~=com_i
                isGain=1;
            end
        end
        sCost=sum(cost);
        [C2 S2] = reIndex(com);
        comNum=length(unique(com));
        isoNum=length(S2(S2==1));
        Mod=computeMod(com,M,xita);
        %fprintf('niter %d:Mod=%f,community:%d(%d is isolated)\n',...
            %niter,Mod,comNum,isoNum);
        niter=niter+1;
        if(niter>1000)
            break;
        end
    end
    niter=niter-1;
    [com comSize] = reIndex(com);
    COMTY.COM{1} = com;
    COMTY.SIZE{1} = comSize;
    COMTY.MOD(1) = computeMod(com,M,xita);
    COMTY.Niter(1) = niter;
    %recursive
    if(s==1)
        newM=M;
        oldM=newM;
        curCom=com;%for current nodes/communities
        fullCom=com;%for origin nodes
        k=2;
        %fprintf('pass 1:niter=%d,community=%d',niter,length(comSize));
        while(1)
            oldM=newM;
            shape2=size(oldM);
            N2=shape2(1);
            uniqueCom=unique(curCom);
            comNum=length(uniqueCom);
            ind_curCom=zeros(comNum,N2);
            ind_fullCom=zeros(comNum,N);
            for i=1:comNum
                ind=find(curCom==i);
                ind_curCom(i,1:length(ind))=ind;
            end
            for i=1:comNum
                ind=find(fullCom==i);
                ind_fullCom(i,1:length(ind))=ind;
            end
            newM=zeros(comNum,comNum);
            for i=1:comNum
                for j=i:comNum
                    ind1=ind_curCom(i,:);
                    ind2=ind_curCom(j,:);
                    newM(i,j) = sum(sum(oldM(ind1(ind1>0),ind2(ind2>0))));
                    newM(j,i) = sum(sum(oldM(ind1(ind1>0),ind2(ind2>0))));
                end
            end
            [COMt e]=genlouvain(newM,0,xita);
            if(e~=1)
                fullCom=zeros(1,N);
                curCom=COMt.COM{1};%new community
                for i=1:comNum
                    ind=ind_fullCom(i,:);
                    fullCom(ind(ind>0))=curCom(i);
                end
                [COMfull,COMSIZE]=reIndex(fullCom);
                COMTY.COM{k} = COMfull;
                COMTY.SIZE{k} = COMSIZE;
                COMTY.MOD(k) = computeMod(COMfull,M,xita);
                COMTY.Niter(k) = COMt.Niter;
                %fprintf('pass %d:niter=%d,community=%d',...
                    %k,COMt.Niter,length(COMSIZE));
                ind=(COMfull==COMTY.COM{k-1});
                if(sum(ind)==length(ind))
                    %fprintf('communities dont change any more\n');
                    return
                end
            else
               %fprintf('matrix is empty\n');
               return;
            end
            k=k+1;
        end
    end
end