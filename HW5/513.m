% data for censored fitting problem.
randn('state',0);
n = 20; % dimension of x's
M = 25; % number of non-censored data points
K = 100; % total number of points
c_true = randn(n,1);
X = randn(n,K);
y = X'*c_true + 0.1*(sqrt(n))*randn(K,1);
% Reorder measurements, then censor
[y, sort_ind] = sort(y);
sort_ind
X = X(:,sort_ind);
D = (y(M)+y(M+1))/2;
y = y(1:M);
X_uncen = X(:,1:M)
X_cen = X(:,M+1:K)
size(X_cen)
cvx_begin
    variable c(n)
    minimize(sum_square(y - X_uncen'*c))
    subject to
        X_cen'*c >= D
cvx_end
cvx_begin
    variable c_ls(n)
    minimize(sum_square(y - X_uncen'*c_ls))
cvx_end

norm(c - c_true, 2) / norm(c_true,2)

norm(c_ls - c_true, 2) / norm(c_true,2)

    
