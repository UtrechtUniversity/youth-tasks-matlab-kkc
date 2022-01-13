function [seq, err] = randomseq(comb, repcnt)
%
%comb = [1 2 1 2 1 2 1 2 1 2 1 2;
%        1 1 2 2 1 1 2 2 1 1 2 2;
%        1 1 1 1 2 2 2 2 3 3 3 3];
%
%[seq err] = randomseq(comb, 1);
%
%[seq err] = randomseq(comb, [2 4 3 2 5 3 4 2 5 1 4 3]);
%

[n_comb m_comb] = size(comb);

Nstart = repcnt .* ones(1, m_comb);
N = Nstart;
Ntot = sum(N);

V = randi(length(N));
P = comb(:,V);
N(V) = N(V) - 1;
for i = 2 : Ntot
    
    vals = 1:length(N);
    vals(N<=0) = [];
    tN = N(N>0);
    index = zeros(1,sum(tN));
    index([1 cumsum(tN(1:end-1))+1]) = 1;
    choose = vals(cumsum(index));
    
    findcnt = 0;
    findpos = 1;
    while (findpos ~= 0)
        C = choose(randi(length(choose)));
        pos = randi(length(V));
        
        for j = 1 : n_comb
            R(j) = find([(P(j,pos:end)~=comb(j,C)) 1], 1) - 1;
            L(j) = pos - find([1 (P(j,1:pos-1)~=comb(j,C))], 1, 'last');
        end
        cnt = R + L;
        
        findpos = sum(cnt >= 3);
        
        findcnt = findcnt + 1;
        if ((findcnt > 2*m_comb) && (findpos ~= 0))
            err = 1;
            seq = 1:m_comb;
            return;
        end
    end
    
    V = [V(1:pos-1) C V(pos:end)];
    P = [P(:,1:pos-1) comb(:,C) P(:,pos:end)];
    N(C) = N(C) - 1;
end


%check if never repeated more than 3 times
rep_err = 0;
for (k = 1 : n_comb)
    for (i = 4 : length(V))
        repcnt = 0;
        for (j = 1 : 3)
            if (P(k,i) == P(k,i-j))
                repcnt = repcnt + 1;
            end
        end
        if (repcnt == 3)
            rep_err = rep_err + 1;
        end
    end
end

%check if number of occurences are correct
occ = hist(V,unique(V));
cnt_err = 0;
if (sum(occ == Nstart) ~= length(Nstart))
    cnt_err = 1;
end

seq = V;
err = (rep_err ~= 0) || cnt_err;


