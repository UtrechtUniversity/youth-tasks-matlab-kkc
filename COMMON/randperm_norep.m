function [S] = randperm_norep(n, m)

ind = 1 : n;

V = zeros(m, n);
V(1,:) = randperm(n);

for i = 2 : m-1
    T = randperm(n);
    
    D = (T == V(i-1,:));
    while (sum(D) > 1)
        u = Shuffle(T(D));
        k = 1;
        for j = 1 : n
            if (D(j) == 1)
                T(j) = u(k);
                k = k + 1;
            end
        end
        D = (T == V(i-1,:));
    end
    
    if (sum(D) == 1)
        j = ind(D);
        k = j;
        while (k == j)
            k = randi(n);
        end
        tmp = T(j);
        T(j) = T(k);
        T(k) = tmp;
    end
    
    V(i,:) = T;
end

T = randperm(n);
D = (T == V(m-1,:)) | (T == [V(1,2:n) 0]);
fail_cnt = 0;
while (sum(D) > 0)
    if (sum(D) == 1)
        j = ind(D);
        k = j;
        while (k == j)
            k = randi(n);
        end
        tmp = T(j);
        T(j) = T(k);
        T(k) = tmp;
    else
        u = Shuffle(T(D));
        k = 1;
        for j = 1 : n
            if (D(j) == 1)
                T(j) = u(k);
                k = k + 1;
            end
        end
    end
    D = (T == V(m-1,:)) | (T == [V(1,2:n) 0]);
    
    if (sum(D) > 0)
        fail_cnt = fail_cnt + 1;
        if (fail_cnt >= 20)
            T = randperm(n);
            D = (T == V(m-1,:)) | (T == [V(1,2:n) 0]);
            fail_cnt = 0;
        end
    end
end

V(m,:) =  T;

S = reshape(V, 1, n*m);



