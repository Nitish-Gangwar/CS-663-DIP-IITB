A = [8 2 6 2;6 4 1 2;2 5 4 8] ;
[U,S,V ,verify] =svd_manuel(A)


function [U,S,V ,check] = svd_manuel(A)
    [m,n] = size(A);
    Vdash = A'*A ;
    [Vvect , eV] = eig(Vdash) 

    [sigma , idx] = sort(diag(eV),"descend")
    S = zeros(size(A));
    V  = zeros([n,n]);
    for i = 1:n
        S(i,i) = sqrt(sigma(i));
        V(:,i) = Vvect(:,idx(i));
    end
    %c = norm(V(:,4))
    V
    S
    U = A*V;
    [s,t] = size(U);
    for i =1:t
        U(:,i) = U(:,i)/norm(U(:,i));
    end
    U
    %norm(U(:,2))
    check = U*S*V'
    
end

